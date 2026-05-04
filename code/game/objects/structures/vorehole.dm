// Vorehole.

// Vorehole States
#define HOLE_CLENCHING -1
#define HOLE_INACTIVE 0
#define HOLE_ACTIVE 1
#define HOLE_SWALLOW_HAZARD 2

/obj/structure/vorehole
	name = "Latex Hole"
	desc = "Watch your step. There's a shallow pit in the floor. Upon a closer look the bottom of that pit looks soft and rubbery, \
			and the center of it, puckering deeper down looks anything but shallow. Dangerously tempting too, and that puny hazard \
			striped warning frame looks more like a tripping hazard than anything useful. A warning sign on the surface of the rubber \
			reads \"WASTE ONLY\". Someone should put some railings in here..."
	icon = 'icons/mob/hole.dmi'
	icon_state = "hole"
	density = FALSE
	anchored = TRUE
	gender = NEUTER

	var/hole_state = HOLE_INACTIVE

	//Go check modules/mob/living/simplemob/subtypes/vore/vorehole.dm for the mob
	var/mob/living/simple_mob/vorehole/hole_mob
	/// The vorebelly that expels stuff from the vorebelly and into the connected disposal network.
	var/datum/weakref/hole_disposal_belly = null
	var/datum/weakref/hole_entrance_belly = null

/obj/structure/vorehole/Initialize(mapload)
	. = ..()
	hole_mob = new(src) // Creating the vorehole mob should set the weakrefs of it's vorgans on init.

	if(hole_mob) //...Just incase something went wrong.
		hole_state = HOLE_SWALLOW_HAZARD

	AddComponent(/datum/component/disposal_system_connection, FALSE)
	RegisterSignal(src, COMSIG_DISPOSAL_RECEIVE, PROC_REF(swallow_disposal_packet))

	var/obj/structure/disposalpipe/trunk/trunk = locate() in loc
	if(trunk)
		SEND_SIGNAL(src, COMSIG_DISPOSAL_LINK, trunk)

/obj/structure/vorehole/Destroy()
	. = ..()
	SEND_SIGNAL(src, COMSIG_DISPOSAL_UNLINK)
	if(hole_mob)
		qdel(hole_mob)
		hole_mob = null

/obj/structure/vorehole/Crossed(atom/movable/victim)
	if(!hole_mob) //Something is very, very wrong.
		return
	if(hole_state <= HOLE_INACTIVE)
		return
	if(hole_state == HOLE_SWALLOW_HAZARD)
		if(isliving(victim)) //Even if they cant be swallowed (due to prefs), it'll still fling them away when it tries to actually swallow.
			var/mob/living/cutie = victim
			cutie.visible_message("[cutie] slips into \the [src]!")
			cutie.Weaken(5)
			cutie.Stun(5)
			start_gulp(FALSE)
			return
		if(can_swallow(victim))
			start_gulp(FALSE)
			return

/obj/structure/vorehole/proc/start_gulp(manually_started = TRUE)
	if(hole_state <= HOLE_INACTIVE)
		return
	var/old_hole_state = hole_state
	hole_state = HOLE_CLENCHING
	flick("[icon_state]-swallow", src)
	addtimer(CALLBACK(src, PROC_REF(do_gulp)), 2) //Wait for the right time.
	VARSET_IN(src, hole_state, old_hole_state, 2.2 SECONDS) //Animation can be interupted here, but that's fine.

/obj/structure/vorehole/proc/do_gulp()
	var/obj/belly/hole_belly = hole_entrance_belly?.resolve()
	if(!hole_belly)
		return
	for(var/atom/movable/holefood in src.loc)
		if(istype(holefood, /obj/effect/decal/cleanable)) // Consume dirt, grime and blood. Yummers.
			hole_mob.adjust_nutrition(1)
			qdel(holefood)
			continue

		if(!hole_belly || !can_swallow(holefood)) //Weakref returned null or we cant eat them, !fling
			if(isliving(holefood)) //Inedible person on the hole, !fling
				holefood.throw_at_random(FALSE, 2, 1)
			continue
		hole_belly.nom_atom(holefood)

/obj/structure/vorehole/proc/swallow_disposal_packet(datum/source, list/expelled_items, datum/gas_mixture/gas)
	SIGNAL_HANDLER
	var/obj/belly/special/disposal_connected/hole_belly = hole_disposal_belly?.resolve()
	if(hole_belly)
		//Weed out stuff we cant eat.
		for(var/atom/movable/AM in expelled_items)
			if(!can_swallow(AM) || !hole_belly) //Not allowed to be in belly, or we dont have a valid belly.
				AM.forceMove(src.loc) //Right out, Pleeeh!
				AM.throw_at_random(FALSE, 2, 1)
				expelled_items -= AM
				continue
		//Otherwise... Time to send it into the vorebelly!
		if(SEND_SIGNAL(hole_belly, COMSIG_DISPOSAL_RECEIVE, expelled_items, gas)) //Probably a really fucky way to do this, but it essentially emulates a disposal component send.
			return
	// If that didnt work or we didnt even have a target belly to begin with, handle everything that was supposed to get nommed.
	qdel(gas) //Bye Gas.
	for(var/atom/movable/AM in expelled_items)
		AM.forceMove(src.loc)
		AM.throw_at_random(FALSE, 2, 1)


/obj/structure/vorehole/proc/can_swallow(atom/movable/food)
	. = FALSE
	if(!food.CanEnterDisposals())
		return FALSE
	if(isliving(food))
		var/mob/living/M = food
		if(!M.devourable || !M.can_be_drop_prey)
			return FALSE
		return TRUE
	if(isobj(food))
		var/obj/O = food
		if(O.anchored || iseffect(O))
			return FALSE
		return TRUE

// Forwards drag-n-dropping ghosts on the hole to the internal mob, to mimic the hole being a mob itself. Mostly for convinience.
/obj/structure/vorehole/MouseDrop_T(atom/dropping, mob/user)
	if(isobserver(dropping) && isobserver(user) && user.client && check_rights_for(user.client, R_HOLDER))
		user.client.holder.cmd_ghost_drag(dropping, hole_mob)

/obj/structure/vorehole/proc/setup_mob_vorebellies(mob/living/simple_mob/vorehole/HM)
	//Entrance
	var/obj/belly/B = new /obj/belly(HM)
	B.name = "Pit"
	B.desc = "oh noes, you fell into the %pred!."
	B.mode_flags = DM_FLAG_THICKBELLY || DM_FLAG_JAMSENSORS || DM_FLAG_MUFFLEITEMS
	B.belly_fullscreen = "VBO_fleshs"
	B.digest_brute = 0
	B.digest_burn = 0

	B.autotransferwait = 3 SECONDS
	B.autotransferchance = 100

	// This is the vorebelly that thing fall into.
	hole_entrance_belly = WEAKREF(B)

	//Belly
	var/obj/belly/midbelly = new /obj/belly(HM)
	midbelly.name = "Passage"
	midbelly.desc = "Swallowed away now, lost to the depths of the %pred."
	midbelly.mode_flags = DM_FLAG_THICKBELLY || DM_FLAG_JAMSENSORS || DM_FLAG_MUFFLEITEMS
	midbelly.belly_fullscreen = "VBO_fleshs"
	//Autotransfer from the above belly to this one.
	B.autotransferlocation = midbelly.name

	//Disposals transfer belly
	B = new /obj/belly/special/disposal_connected(HM, src) //Try to flush on us, since we have the disposal component.
	B.name = "Outlet"
	B.desc = "Bye!"
	B.mode_flags = DM_FLAG_THICKBELLY || DM_FLAG_JAMSENSORS || DM_FLAG_MUFFLEITEMS
	B.belly_fullscreen = "VBO_fleshs"

	B.autotransferchance = 100
	B.autotransferlocation = midbelly.name //I hate that autotransfer locations are strings instead of refs.

	// This is the vorebelly that ejects things out.
	hole_disposal_belly = WEAKREF(B)

#undef HOLE_CLENCHING
#undef HOLE_INACTIVE
#undef HOLE_ACTIVE
#undef HOLE_SWALLOW_HAZARD
