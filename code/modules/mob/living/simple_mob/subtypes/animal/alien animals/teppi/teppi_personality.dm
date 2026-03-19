/////////////////////////
/// TEPPI PERSONALITY ///
/////////////////////////

/**
 * Contains Teppi personality datum, which is meant to be a mostly self-contained data holder for Teppi personality stuff.
 * Kind of like a component, but not really because it has procs and stuff the parent needs to call
 *
 */

/datum/teppi_personality
	var/mob/living/simple_mob/vore/alienanimals/teppi/holder
	/// Associative list of people's names and our opinion of them. (mob.real_name = affinity)
	var/affinity = list()
	/// Some Teppi are more happy to be loved on than others.
	var/affection_factor = 1
	/// Accumulated annoyance. Teppi may retaliate even against people they like if annoyed too much. Goes away over time, or sometimes when retaliating.
	var/annoyance = 0
	var/want_pets = 0
	/// "Player Effort" experience points used to level up the beast
	var/care_points

/datum/teppi_personality/initialize(mob/living/simple_mob/vore/alienanimals/teppi/new_teppi)
	if(!new_teppi)
		return INITIALIZE_HINT_QDEL
	affection_factor = rand(1,3)
	RegisterSignal(new_teppi, COMSIG_LIVING_LIFE, PROC_REF(life_process))

/datum/teppi_personality/proc/life_process()
	SIGNAL_HANDLER

	want_pets += rand(0,2) * affection_factor
	if(annoyance > 0 && prob(25)) //25% chance to decrement annoyance every life tick if we're annoyed.
		annoyance--


/// Affinity and basic relation stuff

/datum/teppi_personality/proc/adjust_affinity(mob/living/person, amount)

	affinity[person.real_name] += amount * affection_factor
	var/current_affinity = affinity[person.real_name]
	/*
	if(current_affinity >= 250)	//At this point the Teppi has joined your team
		holder.faction = person.faction
	if(current_affinity <= -500 && !client)	//You're doing this on purpose or really not paying attention and I'm going to kick your ass.

		ai_holder.track_target_position()
		ai_holder.set_stance(STANCE_FIGHT)
		affinity[person.real_name] = -100	//Don't hold a grudge though.
	*/

/datum/teppi_personality/proc/get_affinity(mob/living/person)
	return affinity[person.real_name]

/datum/teppi_personality/proc/get_known_people()
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

/// How much would we enjoy eating the given atom? Ranging from actual foodthings, to people and machines, do we want to eat it??
/datum/teppi_personality/proc/calculate_food_preference(atom/movable/tep_food)
	// Our opinion of this food item
	var/yum = 0
	// Roughly how much it'd be worth to eat.
	var/nutriment_value = 0
	if(istype(tep_food, /obj/item/reagent_containers/food)) //Normal foodthing!
		var/obj/item/reagent_containers/food/O = tep_food
		if(O.reagents)
			for(var/datum/reagent/R in O.reagents.reagent_list)
				if(R.allergen_type & allergen_preference)
					yum += ceil(R.volume)
				if(R.allergen_type & allergen_unpreference)
					yum -= ceil(R.volume)
				if(istype(R, /datum/reagent/nutriment))
					var/datum/reagent/nutriment/food_juice = R
					nutriment_value += R.nutriment_factor


		var/nutriment_amount = O.reagents?.get_reagent_amount(REAGENT_ID_NUTRIMENT) //does it have nutriment, if so how much?
		var/protein_amount = O.reagents?.get_reagent_amount(REAGENT_ID_PROTEIN) //does it have protein, if so how much?
		var/glucose_amount = O.reagents?.get_reagent_amount(REAGENT_ID_GLUCOSE) //does it have glucose, if so how much?
		var/yum = nutriment_amount + protein_amount + glucose_amount
		if(yum)
			if(!teppi_adult)
				yum *= 20
			else
				yum *= 10
			var/liked = FALSE
			var/disliked = FALSE
			for(var/datum/reagent/R as anything in O.reagents?.reagent_list)
				if(R.allergen_type & allergen_preference)
					liked = TRUE
				if(R.allergen_type & allergen_unpreference)
					disliked = TRUE
			if(liked && disliked) //in case a food has both the thing they like and also the thing they don't like in it
				user.visible_message(span_notice("\The [user] feeds \the [O] to \the [src]. It nibbles \the [O] and looks confused."),span_notice("You feed \the [O] to \the [src]. It nibbles \the [O] and looks confused."))
			else if(liked && !disliked)
				user.visible_message(span_notice("\The [user] feeds \the [O] to \the [src]. It nibbles \the [O] excitedly."),span_notice("You feed \the [O] to \the [src]. It nibbles \the [O] excitedly."))
				yum *= 2
				handle_affinity(user, 5)
			else if(!liked && disliked)
				user.visible_message(span_notice("\The [user] feeds \the [O] to \the [src]. It nibbles \the [O] slowly."),span_notice("You feed \the [O] to \the [src]. It nibbles \the [O] slowly."))
				yum *= 0.5
				handle_affinity(user, -5)
			else
				user.visible_message(span_notice("\The [user] feeds \the [O] to \the [src]. It nibbles \the [O]."),span_notice("You feed \the [O] to \the [src]. It nibbles \the [O]."))
				handle_affinity(user, 1)
		else
			user.visible_message(span_notice("\The [user] feeds \the [O] to \the [src]. It nibbles \the [O] casually."),span_notice("You feed \the [O] to \the [src]. It nibbles \the [O] casually."))
		adjust_nutrition(yum) //add the nutriment!
		user.drop_from_inventory(O)
		qdel(O)
		playsound(src, 'sound/items/eatfood.ogg', 75, 1)
		if(!client && lets_eat(user) && prob(1))
			visible_message(span_danger("\The [src] scromfs \the [user] along with the food!"))
			to_chat(user, span_notice("\The [src] leans in close, spreading its jaws in front of you. A hot, humid gust of breath blows over you as the weight of \the [src]'s presses you over, knocking you off of your feet as the warm gooey tough of jaws scromf over your figure, rapidly guzzling you away with the [O], leaving you to tumble down into the depths of its body..."))
			playsound(src, pick(GLOB.bodyfall_sound), 75, 1)
			teppi_pounce(user)
		if(yum && nutrition >= 500)
			to_chat(user, span_notice("\The [src] seems satisfied."))
		return
