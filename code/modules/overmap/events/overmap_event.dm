/*
** /obj/effect/overmap/event - Actual instances of event hazards on the overmap map
*/

// We don't subtype /obj/effect/overmap/visitable because that'll create sections one can travel to
//  And with them "existing" on the overmap Z-level things quickly get odd.
/obj/effect/overmap/event
	name = "event"
	icon = 'icons/obj/overmap.dmi'
	icon_state = "event"
	opacity = 1
	var/list/events							// List of event datum paths
	var/list/event_icon_states				// Randomly picked from
	var/difficulty = EVENT_LEVEL_MODERATE
	var/weaknesses //if the BSA can destroy them and with what
	var/edible = FALSE //If the stardog can eat this.

/obj/effect/overmap/event/Initialize(mapload)
	. = ..()
	icon_state = pick(event_icon_states)
	GLOB.overmap_event_handler.update_hazards(loc)

/obj/effect/overmap/event/Moved(atom/old_loc, direction, forced = FALSE)
	. = ..()
	GLOB.overmap_event_handler.update_hazards(old_loc)
	GLOB.overmap_event_handler.update_hazards(loc)

/obj/effect/overmap/event/Destroy()//takes a look at this one as well, make sure everything is A-OK
	var/turf/T = loc
	. = ..()
	GLOB.overmap_event_handler.update_hazards(T)

/obj/effect/overmap/event/proc/consume(mob/living/simple_mob/vore/overmap/stardog/dog) //stardog noms.
	return

//
// Definitions for specific types!
//

/obj/effect/overmap/event/meteor
	name = "asteroid field"
	events = list(/datum/event/meteor_wave/overmap)
	event_icon_states = list("meteor1", "meteor2", "meteor3", "meteor4")
	difficulty = EVENT_LEVEL_MAJOR
	weaknesses = OVERMAP_WEAKNESS_MINING | OVERMAP_WEAKNESS_EXPLOSIVE
	edible = TRUE

/obj/effect/overmap/event/meteor/consume(mob/living/simple_mob/vore/overmap/stardog/dog)
	if(!dog)
		return
	var/msg = pick(list(
		"You lap up \the [src]. The rocks roll down your gullet haphazardly. Some of them knock together and clatter their way down, while others turn to powder. Some of them even have some pretty sharp edges that don't feel very nice! They certainly don't taste very nice, and they weight heavily inside of your belly...",
		"You lap up \the [src]. When they land inside you can feel the weight of them settle in. They make your insides kind of queasy...",
		"You lap up \the [src]. They taste like rocks, and make you think of all the better things you could be eating..."
	))
	to_chat(dog, span_notice("[msg]"))
	dog.adjust_affinity(-200)
	dog.spawn_treasure(5)
	dog.spawn_ore(100)
	qdel(src)

/obj/effect/overmap/event/electric
	name = "electrical storm"
	events = list(/datum/event/electrical_storm/overmap)
	opacity = 0
	event_icon_states = list("electrical1", "electrical2", "electrical3", "electrical4")
	difficulty = EVENT_LEVEL_MAJOR
	weaknesses = OVERMAP_WEAKNESS_EMP
	edible = TRUE

/obj/effect/overmap/event/electric/consume(mob/living/simple_mob/vore/overmap/stardog/dog)
	if(!dog)
		return
	var/msg = pick(list(
		"You try to eat \the [src], but you find that no matter how much of it you lick or homn upon, yet more remains! It makes your mouth tingle, and your fur stand on end! It's kind of fun, but it doesn't taste like anything, and you definitely don't feel any more full."
	))
	to_chat(dog, span_notice("[msg]"))
	dog.adjust_affinity(15)
	//Electric doesnt delete

/obj/effect/overmap/event/dust
	name = "dust cloud"
	events = list(/datum/event/dust/overmap)
	event_icon_states = list("dust1", "dust2", "dust3", "dust4")
	weaknesses = OVERMAP_WEAKNESS_MINING | OVERMAP_WEAKNESS_EXPLOSIVE | OVERMAP_WEAKNESS_FIRE
	edible = TRUE

/obj/effect/overmap/event/dust/consume(mob/living/simple_mob/vore/overmap/stardog/dog)
	if(!dog)
		return
	var/msg = pick(list(
		"You lap up \the [src]. The dust clings to your mouth and throat!!! You cough and splutter unhappily! It is literally space dirt, and it tastes like it!",
		"You lap up \the [src]. The bitter taste of the dust sticks to your tongue and takes a lot of work to get off! It's really frustrating!",
		"You lap up \the [src]. Not only does it taste horrible and feel worse going down, some of it gets in your eyes!"
	))
	to_chat(dog, span_notice("[msg]"))
	dog.adjust_affinity(-100)
	dog.spawn_treasure(15)
	dog.spawn_ore(25)
	qdel(src)

/obj/effect/overmap/event/ion
	name = "ion cloud"
	events = list(/datum/event/ionstorm/overmap)
	opacity = 0
	event_icon_states = list("ion1", "ion2", "ion3", "ion4")
	difficulty = EVENT_LEVEL_MAJOR
	weaknesses = OVERMAP_WEAKNESS_EMP
	edible = TRUE

/obj/effect/overmap/event/ion/consume(mob/living/simple_mob/vore/overmap/stardog/dog)
	if(!dog)
		return
	var/msg = pick(list(
		"When you approach \the [src], you find that the dog's will pulls away from your own a little bit. It seems to really like the shimmering clouds, and it feels really good to nestle up among them. Like taking a relaxing dip into a regenerative spring. Any aches and pains that the dog was experiencing seem to fade away, leaving it feeling refreshed!"
	))
	to_chat(dog, span_notice("[msg]"))
	dog.adjust_affinity(20)
	dog.adjustFireLoss(-999)
	dog.adjustBruteLoss(-999)
	//Ion doesnt delete

/obj/effect/overmap/event/carp
	name = "carp shoal"
	events = list(/datum/event/carp_migration/overmap)
	opacity = 0
	difficulty = EVENT_LEVEL_MODERATE
	event_icon_states = list("carp1", "carp2")
	weaknesses = OVERMAP_WEAKNESS_EXPLOSIVE | OVERMAP_WEAKNESS_FIRE
	edible = TRUE

/obj/effect/overmap/event/carp/consume(mob/living/simple_mob/vore/overmap/stardog/dog)
	if(!dog)
		return
	var/msg = pick(list(
				"You lap up \the [src]. They're pretty filling, but you don't really like the taste...",
				"You lap up \the [src]. You can feel them wiggle all the way down... They don't taste very good, but you feel energized afterward.",
				"You lap up \the [src]. They flee away from you, attempting to scatter in all directions, but you're faster! They leave an unpleasant taste on your tongue, but your belly doesn't seem to mind them."
	))
	to_chat(dog, span_notice("[msg]"))
	dog.adjust_nutrition(200)
	dog.adjust_affinity(-50)
	dog.spawn_mob()
	to_chat(dog, span_notice("You can feel something moving inside of you..."))
	qdel(src)

/obj/effect/overmap/event/carp/major
	name = "carp school"
	difficulty = EVENT_LEVEL_MAJOR
	event_icon_states = list("carp3", "carp4")

/obj/effect/overmap/event/carp/major/consume(mob/living/simple_mob/vore/overmap/stardog/dog)
	if(!dog)
		return
	var/msg = pick(list(
				"You lap up \the [src]. They're pretty filling, but you don't really like the taste...",
				"You lap up \the [src]. You can feel them wiggle all the way down... They don't taste very good, but you feel energized afterward.",
				"You lap up \the [src]. They flee away from you, attempting to scatter in all directions, but you're faster! They leave an unpleasant taste on your tongue, but your belly doesn't seem to mind them."
	))
	to_chat(dog, span_notice("[msg]"))
	dog.adjust_nutrition(300) //More carp, more nutrition
	dog.adjust_affinity(-50)
	dog.spawn_mob()
	to_chat(dog, span_notice("You can feel something moving inside of you..."))
	qdel(src)
