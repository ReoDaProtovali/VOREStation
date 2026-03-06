/obj/item/pirate_garbage
	name = "Gloop"

/obj/item/pirate_garbage/gunpowder_keg
	name = "gunpowder barrel"
	desc = ""
	icon = 'icons/obj/pirate_garbage/keg.dmi'
	icon_state = "keg"
	var/fuseTimerID			// The ID of the timer used to control the fuse, so we can extinguish it an defuse it.

/obj/item/pirate_garbage/gunpowder_keg/CanPass(atom/movable/mover, turf/target)
	if(istype(mover, obj/item/projectile))
		return FALSE
	return !density

/obj/item/pirate_garbage/gunpowder_keg/bullet_act(obj/item/projectile/P, def_zone)
	if(P.get_structure_damage())
		boom()

/obj/item/pirate_garbage/gunpowder_keg/proc/light_da_fuse()
	fuseTimerID = addtimer(PROC_REF(boom), 5 SECONDS, )

/obj/item/pirate_garbage/gunpowder_keg/proc/boom()
	explosion(get_turf(src), 1, 3, 5, 5)

/obj/item/pirate_garbage/gunpowder_keg/proc/boom()

/obj/item/pirate_garbage/gunpowder_keg/mega //BOOOOOOOOM!!!
	name = "stronghold gunpowder barrel"

/obj/item/pirate_garbage/gunpowder_keg/mega/boom()
	explosion(get_turf(src, 3, 6, 12, 12))
