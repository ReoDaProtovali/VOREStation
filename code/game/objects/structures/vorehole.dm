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
	icon_state = "slickhole"
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

/obj/structure/vorehole/Destroy()
	. = ..()
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
	flick("[icon_state]-1")
	addtimer(CALLBACK(src, PROC_REF(do_gulp)), 2) //Wait for the right time.
	VARSET_IN(src, hole_state, old_hole_state, 2.2 SECONDS) //Animation can be interupted here, but that's fine.

/obj/structure/vorehole/proc/do_gulp()
	var/obj/belly/hole_belly = hole_entrance_belly?.resolve()
	if(!hole_belly) //Weakref returned null. Abort!
		return
	for(var/atom/movable/holefood in src.loc)

		if(!can_swallow(holefood))
			if(istype(holefood, /obj/effect/decal/cleanable)) // Consume dirt, grime and blood. Yummers.
				hole_mob.adjust_nutrition(1)
				qdel(holefood)
			else if(isliving(holefood)) //Inedible person on the hole, !fling
				holefood.throw_at_random(FALSE, 2, 1)
			continue
		hole_belly.nom_atom(holefood)

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
		if (user.client.holder.cmd_ghost_drag(dropping, hole_mob))
			return


#undef HOLE_CLENCHING
#undef HOLE_INACTIVE
#undef HOLE_ACTIVE
#undef HOLE_SWALLOW_HAZARD
