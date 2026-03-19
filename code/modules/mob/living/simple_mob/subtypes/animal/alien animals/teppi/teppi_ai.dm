////////////////
/// TEPPI AI ///
////////////////

// Contains /datum/ai_holder/simple_mob/teppi
//
// Which are both used by AI-controlled Teppi to give them "advanced" interactions, atleast compared to other mobs.

///////////////////AI Things////////////////////////
//Thank you very much Aronai <3

/datum/ai_holder/simple_mob/teppi
	hostile = FALSE
	cooperative = TRUE
	retaliate = TRUE
	speak_chance = 0.5
	wander = TRUE

	var/datum/teppi_personality/personality //Our Teppi's personality


/datum/ai_holder/simple_mob/teppi/react_to_attack(atom/movable/attacker, ignore_timers)
	if(holder.stat)
		return ..()
	if(!istype(holder, /mob/living/simple_mob/vore/alienanimals/teppi))
		return
	if(!isliving(attacker))
		return ..()
	var/mob/living/simple_mob/vore/alienanimals/teppi/gyoh = holder
	var/mob/living/L = attacker
	if(gyoh.IIsAlly(attacker) || personality.get_affinity(attacker) > 100) //Are we an ally, or a good friend?
		if(target && !holder.IIsAlly(target)) //If we have an active target, it probably wasnt an intentional hit, and we're not messing with a friend.

			if(personality.affinity[attacker.real_name] >= 250)
				//Someone we really like hurt us! But it's okay, we'll brush it off, just for them. :)
				ai_log("react_to_attack() : Was attacked by [attacker], but they are a good friend (we are a teppi).", AI_LOG_TRACE)
				return
			ai_log("react_to_attack() : Was attacked by [attacker], but they were an ally.", AI_LOG_TRACE)
			personality.adjust_affinity(attacker, -5) //Otherwise we'll still be a bit annoyed at you.
			return
		else //We got attacked, and we dont have an immediate concern. They're still a friend though.
			personality.annoyance++



	. = ..()

/mob/living/simple_mob/vore/alienanimals/teppi/proc/do_I_know_you()
	// Get list of everyone who can see us (which is everyone we can see, typically)
	var/list/people_nearby = oviewers(world.view, src)
	// Use the hidden . var to avoid needing to create a new local var (saves CPU)
	. = list()
	// Add everyone nearby to the list if they're in affinity, with key of the mob and value of the affinity
	// . becomes list(jane = 1, tim = -3) etc
	for(var/mob/living/M in people_nearby)
		var/their_affinity = affinity[M.real_name]
		if(their_affinity)
			if(their_affinity >= 25 || their_affinity <= -10)
				.[M] = affinity[M.real_name]
	// Sort the list (timsort default sort comperator is numeric ascending, so highest affinity will be last in the list)
	sortTim(., associative = TRUE)

/datum/ai_holder/simple_mob/teppi/handle_special_strategical()
	if(holder.nutrition <= 500)



/datum/ai_holder/simple_mob/teppi/handle_wander_movement()
	var/mob/living/simple_mob/vore/alienanimals/teppi/tepholder = holder
	if(tepholder.resting)
		if(prob(5))
			tepholder.lay_down()
		return
	// Copypasta from parent handle_wander_movement
	if(isturf(holder.loc) && can_act())
		if(--wander_delay > 0)
			return
		if(!wander_when_pulled && (holder.pulledby || holder.grabbed_by.len))
			ai_log("handle_wander_movement() : Being pulled and cannot wander. Exiting.", AI_LOG_DEBUG)
			return
	// We're having our chance NOW
	wander_delay = base_wander_delay
	// Typecast the ai_holder 'holder' var as a teppi so we can call do_I_know_you()
	var/list/affinity_nearby = tepholder.do_I_know_you()
	var/turf/T // Turf we might eventually move to
	// If we found any affinity people nearby
	if(affinity_nearby.len)
		// Extract the highest affinity person from the list, by taking the last item (the item at
		// position 6 in a list that's 6 length is the last item eg)
		var/mob/living/L = affinity_nearby[affinity_nearby.len]
		// If >= 0, wander towards
		if(affinity_nearby[L] >= 0)
			T = get_step_to(holder, L, 1)
		// Else wander away
		else
			T = get_step_away(holder, L)
	// Didn't find affinity people nearby, copypasta from normal wandering.
	// We don't call ..() because it'll perform some of the same work again and want to avoid that
	if(!T)
		if(prob(5))
			tepholder.lay_down()
			return
		var/moving_to = 0 // Apparently this is required or it always picks 4, according to the previous developer for simplemob AI.
		moving_to = pick(GLOB.cardinal)
		holder.set_dir(moving_to)
		T = get_step(holder,moving_to)
	// Finally do move if we actually found somewhere we'd like to go
	if(T)
		holder.IMove(T)

/datum/ai_holder/simple_mob/teppi/handle_idle_speaking()
	if(holder.resting)
		return
	..()

// We'll eat food if it's available, we're hungry, and there's nothing else we're busy with!
/*
/datum/ai_holder/simple_mob/teppi/list_targets()
	. = ..()

	var/static/food_targets = typecacheof(list(/obj/item/reagent_containers/food/snacks))

	for(var/obj/O as anything in typecache_filter_list(range(vision_range, holder), alternative_targets))
		if(can_see(holder, O, vision_range) && !O.anchored)
			. += O
*/

// Select an obj if no mobs are around.
/datum/ai_holder/simple_mob/teppi/pick_target(list/targets)
	var/mobs_only = locate(/mob/living) in targets // If a mob is in the list of targets, then ignore objects.
	if(mobs_only)
		for(var/A in targets)
			if(!isliving(A))
				targets -= A

	return ..(targets)

/datum/ai_holder/simple_mob/teppi/can_attack(atom/movable/the_target, var/vision_required = TRUE)
	. = ..()
	if(!.) // Parent returned FALSE.
		if (istype(the_target, /mob/living/simple_mob/animal/giant_spider))
			var/mob/living/L = the_target
			if (L.stat)
				return FALSE
		if(istype(the_target, /obj) && (!vision_required || can_see_target(the_target)))
			var/obj/O = the_target
			if(!O.anchored)
				return TRUE



/datum/ai_holder/simple_mob/teppi/on_hear_say(mob/living/speaker, message)
	var/mob/living/simple_mob/vore/alienanimals/teppi/T = holder
	if(holder.client)
		return
	if(!speaker.client)
		return
	if(!T.teppi_adult)
		return
	var/speaker_affinity = T.affinity[speaker.real_name]
	message = html_decode(message)
	if(findtext(message, "lets go") || findtext(message, "let's go") || findtext(message, "come teppi") || findtext(message, "come [holder.name]"))
		if(speaker == leader)
			return
		if(!leader)
			if(speaker_affinity >= 100)
				set_follow(speaker, follow_for = 10 MINUTES)
				holder.visible_message(span_notice("\The [holder] starts following \the [speaker]"),span_notice("\The [holder] starts following you."))
				return
		else
			var/mob/living/L = leader
			if(!can_see_target(L))
				lose_follow()
				if(speaker_affinity >= 100)
					set_follow(speaker, follow_for = 10 MINUTES)
					holder.visible_message(span_notice("\The [holder] starts following \the [speaker]"),span_notice("\The [holder] starts following you."))
					return
			else if(speaker_affinity > T.affinity[L.real_name])
				holder.visible_message(span_notice("\The [holder] starts following \the [speaker]"),span_notice("\The [holder] starts following you."))
				set_follow(speaker, follow_for = 10 MINUTES)
				return
			if(speaker_affinity == T.affinity[L.real_name])
				lose_follow()
				holder.visible_message(span_notice("\The [holder] gives off an anxious whine."))
	if(findtext(message, "stop teppi") || findtext(message, "stay here") || findtext(message, "stop [holder.name]"))
		if(leader == speaker)
			lose_follow()
			holder.visible_message(span_notice("\The [holder] stops following \the [speaker]"),span_notice("\The [holder] stops following you."))
			return

/datum/ai_holder/simple_mob/teppi/give_target(new_target, urgent)
	. = ..()
