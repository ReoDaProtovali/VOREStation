//formerly meat things
//I made these up. They aren't deliberately based on, or supposed to be anything in particular.
//They came out kind of goat-ish but that wasn't intentional. I was just going for some cute thing you could
//take care of and/or kill for meat.
//I made them to be a part of the 'low tech survival' part of the game. You can use them to obtain a relatively
//unlimited amount of meat, wool, hide, bone, and COMPANIONSHIP without the need for machines or power... hopefully.
//There's no real story behind them, they're semi-intelligent wild alien animals with a somewhat mild temperament.
//They'll beat you up if you're mean to them, they have preferences for food, affection, and the ability
//to form opinions of others. Or as close to those things as I could get with my tiny creature brain and byond.
//They're TOUGH, but pretty easy to exploit for your needs if you pay attention to them and use your head.
//They also come in a variety of colors and markings, and those factors can be kind of manipulated through controlled breeding.
//They basically do all their funny things based on nutrition, so, if you feed them and like, put them near eachother
//they do what they do when they feel like it.

//Also they eat you and all their vore related text is custom because I'm a shameless vore idiot
//And their stomach defaults to drain, so, dunking people into there will actually help them out without (immediately) killing people SO LIKE
//you know. Feed people to them or whatever, it's cool. People getting eaten has a tangible positive mechanical impact. So do it.

/////////////////TO DO (if I ever learn how/someone ever feels like it)//////////////////////////////
//>seek food nearby to eat, including players with the appropriate settings.
//>give baby teppi a holder thingy so you can pick them up and carry them around
//>give adult teppi the ability to be ridden at high affinity
//>give adult teppi the ability to be equipped with a bag or something, so they can carry things for you
//>baby teppi can ventcrawl when AI controlled (so they fade out, and then appear at a random vent on the Z level)
//>make it so that teppi size is a thing that can be influenced by breeding
//>make it so the teppi are better at following people they really like around without also disabling the other things that their AI does (like resting and speaking)
//>make it so that teppi gains affinity for feeding people to them WITHOUT ALSO introducing a way for people to game the system by spamclicking
//>make it so that when feeding people to the teppi you don't get a choice where to send them unless the teppi is controlled by the player (since they have a special interaction for choosing where to send people that they eat)

//stolen from chickens
GLOBAL_VAR_CONST(max_teppi, 50)	// How many teppi CAN we have?
GLOBAL_VAR_INIT(teppi_count, 0)	// How mant teppi DO we have?

//Tweakable defines
#define DEFAULT_TEPPI_SHEAR_TIME 3 SECONDS

/datum/category_item/catalogue/fauna/teppi
	name = "Alien Wildlife - Teppi"
	desc = "Teppi are large omnivorous quadrupeds with long fur.\
	Unlike many horned mammals, Teppi have developed paws with four toes rather than hooves.\
	This coupled with a thick, powerful tail makes them quite capable and balanced on many\
	kinds of terrain. A recently discovered species, their origins are something of a\
	mystery, but they have been discovered in more different regions of space with no apparent\
	connection to one another. Teppi are known to reproduce and grow rather quickly, which if\
	left unchecked can lead to serious problems for local ecology.\
	Teppi are very hardy, engaging them in combat is not recommended.\
	Teppi can be a good source of protein and materials for crafts and clothing in emergency\
	situations. They are not especially picky eaters, and have a rather mild temperament.\
	A pair of well fed Teppi can rather quickly become a small horde, so it is generally\
	advised to keep an eye on their numbers."
	value = CATALOGUER_REWARD_MEDIUM

/mob/living/simple_mob/vore/alienanimals/teppi
	name = "teppi"
	desc = "A large and furry creature, sporting two thick horns and a very sturdy tail. It has four toes on each paw."
	tt_desc = "Ipsumollis Velodigium" 	//I mashed some latin words together. This is nonsense, but it comes from 'very soft furred monster'
										//which I know is not how this kind of thing should honestly go but it's a weird future alien creature MANNNNNNN
	icon_state = "teppi"
	icon_living = "body_base"
	icon_dead = "body_dead"
	icon_rest = "body_rest"
	icon = 'icons/mob/alienanimals_x64.dmi'
	pixel_x = -16
	default_pixel_x = -16

	faction = FACTION_TEPPI
	maxHealth = 200
	health = 200
	movement_cooldown = -1
	meat_amount = 12
	meat_type = /obj/item/reagent_containers/food/snacks/meat

	response_help = "pets"
	response_disarm = "rudely paps"
	response_harm = "punches"

	harm_intent_damage = 2
	melee_damage_lower = 2
	melee_damage_upper = 10

	min_oxy = 2
	max_oxy = 0
	min_tox = 0
	max_tox = 15
	min_co2 = 0
	max_co2 = 50
	min_n2 = 0
	max_n2 = 0
	minbodytemp = 150
	maxbodytemp = 400
	unsuitable_atoms_damage = 0.5
	catalogue_data = list(/datum/category_item/catalogue/fauna/teppi)
	vis_height = 64

	var/affinity = list()
	var/datum/teppi_personality/personality //A bundle of our thoughts and feelings!
	var/body_color
	var/marking_color
	var/horn_color
	var/eye_color
	var/skin_color
	var/item_type
	var/item_color
	var/marking_type
	var/horn_type
	var/static/list/overlays_cache = list()
	var/inherit_allergen = FALSE
	var/inherit_colors = FALSE
	var/teppi_wool = FALSE
	var/amount_grown = 0
	var/teppi_adult = TRUE
//	var/teppi_id //This is all for anti-incest business, which I might finish eventually, but am not sure if it's really deisrable right now.
//	var/mom_id
//	var/dad_id
	var/baby_countdown = 0
	var/breedable = FALSE
	var/prevent_breeding = FALSE
	var/petcount = 0
	var/wantpet = 0
	var/affection_factor = 1
	var/teppi_warned = FALSE
	var/teppi_mutate = FALSE	//Allows Teppi to get their children's colors scrambled, and possibly other things later on!

	attacktext = list("nipped", "chomped", "bonked", "stamped on")
	attack_sound = 'sound/voice/teppi/roar.ogg' // make a better one idiot
	friendly = list("snoofs", "nuzzles", "nibbles", "smooshes on")

	ai_holder_type = /datum/ai_holder/simple_mob/teppi

	mob_size = MOB_LARGE

	has_langs = list(LANGUAGE_TEPPI)
	say_list_type = /datum/say_list/teppi
	player_msg = "Teppi are large omnivorous quadrupeds. You have four toes on each paw, a long, strong tail, and are quite tough and powerful. You're a lot more intimidating than you are actually harmful though. Your kind are ordinarily rather passive, only really rising to violence when someone does violence to you or others like you. You're not stupid though, you can commiunicate with others of your kind, and form bonds with those who are kind to you, be they Teppi or otherwise. <br>- - - - -<br>" + span_notice("While you may have access to galactic common, this is purely meant for making it so you can understand people in an OOC manner, for facilitating roleplay. You almost certainly should not be speaking to people or roleplaying as though you understand everything everyone says perfectly, but it's not unreasonable to be able to intuit intent and such through people's tones when they speak. Teppi are kind of smart, but they are animals, and should be roleplayed as such.") + " " + span_warning("ADDITIONALLY, you have the ability to produce offspring if you're well fed enough every once in a while, and the ability to disable this from happening to you. These verbs exist for to preserve the mechanical functionality of the mob you are playing. You should be aware of your surroundings when you use this verb, and NEVER use it to prefbreak or be disruptive. If in doubt, don't use it.") + " " + span_notice("Also, to note, AI Teppi will never initiate breeding with player Teppi.")
	loot_list = list(/obj/item/bone/horn = 100)
	internal_organs = list(\
		/obj/item/organ/internal/brain,\
		/obj/item/organ/internal/heart,\
		/obj/item/organ/internal/liver,\
		/obj/item/organ/internal/stomach,\
		/obj/item/organ/internal/intestine,\
		/obj/item/organ/internal/lungs\
		)

	butchery_loot = list(\
		/obj/item/stack/animalhide = 3,\
		/obj/item/bone/horn = 1\
		)

/////////////////////////////////////// Vore stuff///////////////////////////////////////////

	swallowTime = 1 SECONDS
	vore_active = 1
	vore_capacity = 3
	vore_bump_chance = 1
	vore_bump_emote	= "greedily homms at"
	vore_ignores_undigestable = 0
	vore_default_mode = DM_DRAIN
	vore_icons = SA_ICON_LIVING
	vore_stomach_name = "Stomach"
	vore_default_contamination_flavor = "Wet"
	vore_default_contamination_color = "grey"
	vore_default_item_mode = IM_DIGEST
	vore_bump_chance = 5
	vore_pounce_chance = 35
	vore_pounce_falloff = 0
	vore_standing_too = TRUE
	can_be_drop_prey = FALSE

	var/obj/belly/friend_zone	//where friends go when we eat them
	var/obj/belly/food_zone		//where food goes when we eat it
	var/obj/belly/crossroads 	//where things are determined to be either a friend or a food.

///////////////////////////////////////Other stuff///////////////////////////////////////////

/mob/living/simple_mob/vore/alienanimals/teppi/Initialize(mapload, teppi1, teppi2)
	GLOB.teppi_count ++
	//Handles both growing up from a baby and also passing parent details to new babies.
	if(teppi1) //Parent? or just our younger self?
		if(teppi2) //Parents.
			inherit_from_parents(teppi1, teppi2)
		else //Younger Self.
			inherit_from_baby(teppi1)

	. = ..()

	if(name == initial(name))
		name = "[name] ([rand(1, 1000)])"
		real_name = name
	else
		add_verb(src, /mob/living/simple_mob/vore/alienanimals/teppi/proc/produce_offspring)
		add_verb(src, /mob/living/simple_mob/vore/alienanimals/teppi/proc/toggle_producing_offspring)


//	teppi_id = rand(1,100000)
//	if(!dad_id || !mom_id)
//		dad_id = rand(1,100000)
//		mom_id = rand(1,100000)
	teppi_setup()

//Picks colors and allergens for teppi that don't have them set
/mob/living/simple_mob/vore/alienanimals/teppi/proc/teppi_setup()
	var/static/list/possibleallergens = list(
		ALLERGEN_MEAT,
		ALLERGEN_FISH,
		ALLERGEN_FRUIT,
		ALLERGEN_VEGETABLE,
		ALLERGEN_GRAINS,
		ALLERGEN_BEANS,
		ALLERGEN_SEEDS,
		ALLERGEN_DAIRY,
		ALLERGEN_FUNGI,
		ALLERGEN_COFFEE,
		ALLERGEN_SUGARS,
		ALLERGEN_EGGS
		)

	var/static/list/possiblebody = list("#fff2d3" = 100, "#ffffc0" = 25, "#c69c85" = 25, "#9b7758" = 25, "#3f4a60" = 10, "#121f24" = 10, "#420824" = 1)
	var/static/list/possiblemarking = list("#fff2d3" = 100, "#ffffc0" = 50, "#c69c85" = 25, "#9b7758" = 5, "#3f4a60" = 5, "#121f24" = 5, "#6300db" = 1)
	var/static/list/possiblehorns = list("#454238" = 100, "#a3d5d7" = 10, "#763851" = 10, "#0d0c2f" = 5, "#ffc965" = 1)
	var/static/list/possibleeyes = list("#4848a7" = 100, "#f346ff" = 25, "#b20005" = 5, "#ff9a06" = 1, "#0cb600" = 50, "#32ffff" = 5, "#272523" = 50, "#ffffff" = 1)
	var/static/list/possibleskin = list("#584060" = 100, "#272523" = 50, "#ff8a8e" = 25, "#35658d" = 10, "#ffbb00" = 1)

	if(!inherit_allergen)	//For new teppi
		allergen_preference = pick(possibleallergens) //the food we like
		allergen_unpreference = pick(possibleallergens - allergen_preference) //can't dislike the thing we like, we're not THAT picky
	if(!inherit_colors)
		color = pickweight(possiblebody)
		marking_color = pickweight(possiblemarking)
		horn_color = pickweight(possiblehorns)
		eye_color = pickweight(possibleeyes)
		skin_color = pickweight(possibleskin)
	if(!marking_type)
		marking_type = "[rand(0,13)]" //the babies don't have this set up by default, but they might pick it from their parents
	if(teppi_adult)
		if(!horn_type)
			horn_type = "[rand(0,1)]"
	else if(teppi_mutate)
		var/list/possiblecolorlists = list(possiblebody, possiblemarking, possiblehorns, possibleeyes, possibleskin)
		var/mutant_color = pick(possiblecolorlists)
		switch(rand(0,5))
			if(0)
				color = pickweight(mutant_color)
			if(1)
				marking_color = pickweight(mutant_color)
			if(2)
				horn_color = pickweight(mutant_color)
			if(3)
				eye_color = pickweight(mutant_color)
			if(4)
				skin_color = pickweight(mutant_color)
			if(5)
				color = pickweight(mutant_color)
				marking_color = pickweight(mutant_color)
				horn_color = pickweight(mutant_color)
				eye_color = pickweight(mutant_color)
				skin_color = pickweight(mutant_color)
		teppi_mutate = FALSE

	update_icon()

//This builds, caches, and recalls parts of the teppi as it needs them, and shares them across all teppi,
//so ideally they only have to make it once as they need it since most of them will be using many of the same colored parts
/mob/living/simple_mob/vore/alienanimals/teppi/proc/teppi_icon()
	var/marking_key = "marking-[marking_color]"
	var/horn_key = "horn-[horn_color]"
	var/eye_key = "eye-[eye_color]"
	var/skin_key = "skin-[skin_color]"
	var/wool_key = "wool-[marking_color]"

	var/our_state = "base"	//For helping the images know what icon state they should be grabbing
	if(icon_state == icon_living)
		our_state = "base"
	if(icon_state == icon_rest)
		our_state = "rest"
	if(icon_state == icon_dead)
		our_state = "dead"
	var/life_stage = "adult"
	if(!teppi_adult)
		life_stage = "baby"
	/////LOWEST LAYER/////
	if(teppi_adult)		//Only adults get markings or wool. The marking color is a secret until they grow bigger!
		var/combine_key = marking_key+our_state+marking_type		//Markings first, the lowest layer, down with the base color
		var/image/marking_image = overlays_cache[combine_key]
		if(!marking_image)
			marking_image = image(icon,null,"marking_[our_state][marking_type]")
			marking_image.color = marking_color
			marking_image.appearance_flags = RESET_COLOR|KEEP_APART|PIXEL_SCALE
			overlays_cache[combine_key] = marking_image
		add_overlay(marking_image)

		if(item_type)
			var/item_key = "[item_type]-[item_color]"
			var/image/item_image = overlays_cache[item_key+our_state]	//Items! Like collar. Goes under everything but markings because I'll go crazy otherwise
			if(!item_image)
				item_image = image(icon,null,"[item_type]_[our_state]")
				item_image.color = item_color
				item_image.appearance_flags = RESET_COLOR|KEEP_APART|PIXEL_SCALE
				overlays_cache[item_key+our_state] = item_image
			add_overlay(item_image)

		if(teppi_wool)
			var/image/wool_image = overlays_cache[wool_key+our_state+life_stage]	//Wool comes next, goes over top of the markings, is the same color too
			if(!wool_image)
				wool_image = image(icon,null,"wool_[our_state]")
				wool_image.color = marking_color
				wool_image.appearance_flags = RESET_COLOR|KEEP_APART|PIXEL_SCALE
				overlays_cache[wool_key+our_state+life_stage] = wool_image
			add_overlay(wool_image)

	var/image/horn_image = overlays_cache[horn_key+our_state+life_stage+horn_type]		//Horns MUST come after marking and wool for layering purposes.
	if(!horn_image)
		if(!teppi_adult)
			horn_image = image(icon,null,"horn_[our_state]")	//Babies only have one kind of horns
		else
			horn_image = image(icon,null,"horn_[our_state][horn_type]")
		horn_image.color = horn_color
		horn_image.appearance_flags = RESET_COLOR|KEEP_APART|PIXEL_SCALE
		overlays_cache[horn_key+our_state+life_stage+horn_type] = horn_image
	add_overlay(horn_image)

	var/image/eye_image = overlays_cache[eye_key+our_state+life_stage]			//Eyes and skin should be above markings too, but their order doesn't matter
	if(!eye_image)																//they won't intersect with eachother or the horns, but might intersect with some markings.
		eye_image = image(icon,null,"eye_[our_state]")							//If we ever add horns or wool fluff that might cover them, remember to move these down as appropriate.
		eye_image.color = eye_color												//Otherwise they will just always be on top of them.
		eye_image.appearance_flags = RESET_COLOR|KEEP_APART|PIXEL_SCALE
		overlays_cache[eye_key+our_state+life_stage] = eye_image
	add_overlay(eye_image)

	var/image/skin_image = overlays_cache[skin_key+our_state+life_stage]
	if(!skin_image)
		skin_image = image(icon,null,"skin_[our_state]")
		skin_image.color = skin_color
		skin_image.appearance_flags = RESET_COLOR|KEEP_APART|PIXEL_SCALE
		overlays_cache[skin_key+our_state+life_stage] = skin_image
	add_overlay(skin_image)
	/////HIGHEST LAYER/////

/mob/living/simple_mob/vore/alienanimals/teppi/attackby(var/obj/item/O as obj, var/mob/user as mob)
	if(stat == DEAD)
		return ..()
	/////GRABS AND HOLDERS/////
	if(istype(O, /obj/item/grab))
		return ..()
	if(istype(O, /obj/item/holder))
		return ..()

	if(user.a_intent != I_HELP) //be gentle
		if(resting)
			lay_down()
		personality.adjust_affinity(user, -5)
		user.visible_message(user, span_notice("\The [user] hits \the [src] with \the [O]. \The [src] grumbles at \the [user]."),span_notice("You hits \the [src] with \the [O]. \The [src] grumbles at you."))
		playsound(src, 'sound/weapons/tap.ogg', 50, 1, -1)
		//Bypass the AI retaliation call. We dont need to call every other nearby teppi to murderfuck someone for a minor whack.
		if(personality.get_affinity(user) > -100)
			return O.attack(src, user, user.zone_sel.selecting)
		else
			return ..() //You dun fucked up here, though.

	if(teppi_wool)
		if(try_teppi_shear(user, O))
			return
	/////FOOD/////
	if(istype(O, /obj/item/reagent_containers/food))
		if(resting)
			to_chat(user, span_notice("\The [src] is napping, and doesn't respond to \the [O]."))
			return
		if(nutrition >= 5000)
			user.visible_message(span_notice("\The [user] tries to feed \the [O] to \the [src]. It snoofs but does not eat."),span_notice("You try to feed \the [O] to \the [src], but it only snoofts at it."))
			return
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
	/////WEAPONS/////
	if(istype(O, /obj/item/material/knife))
		if(client)
			return ..()
		if(resting)
			user.visible_message(span_attack("\The [user] approaches \the [src]'s neck with \the [O]."),span_attack("You approach \the [src]'s neck with \the [O]."))
			if(do_after(user, 5 SECONDS, target = src))
				if(resting)
					death()
					return
				else
					to_chat(user, span_notice("\The [src] woke up! You think better of slaughtering it while it is awake."))
					return
		else
			return ..()
	if(istype(O, /obj/item/clothing/accessory/collar/craftable))
		var/obj/item/clothing/accessory/collar/craftable/C = O
		if(item_type == "collar")
			to_chat(user, span_notice("[src] is already wearing a collar."))
			return
		if(!C.given_name)
			to_chat(user, span_notice("You didn't put a name on the collar. You can use it in your hand to do that!"))
			return
		item_type = "collar"
		item_color = C.color
		name = C.given_name
		real_name = C.given_name
		update_icon()
		qdel(C)
		fully_replace_character_name(real_name, C.given_name)
		log_admin("[key_name_admin(user)] renamed a teppi to [name] - [COORD(src)]")
		return
	/////EVERYTHING ELSE/////
	return ..()

//Wake up the teppi if it is resting, which they like to do sometimes.
/mob/living/simple_mob/vore/alienanimals/teppi/attack_hand(mob/living/carbon/human/M as mob)
	if(stat == DEAD)
		return ..()
	/*
	if(M.a_intent == I_GRAB && item_type)
		if(affinity[M.real_name] >= 30)
			M.visible_message(span_notice("\The [M.name] removes \the [src]'s [item_type]."),span_notice("You remove \the [src]'s [item_type]."))
			item_type = null
			update_icon()
			return
	*/

	if(M.a_intent != I_HELP) //be gentle
		personality.handle_affinity(M, -5)
		to_chat(M, span_notice("\The [src] fusses at your rough treatment!!"))
		if(resting)
			lay_down()
		return ..()
	if(resting)
		M.visible_message(span_notice("\The [M.name] shakes \the [src] awake from their nap."),span_notice("You shake \the [src] awake!"))
		playsound(src, 'sound/weapons/thudswoosh.ogg', 50, 1, -1)
		lay_down()
		return
	else if(!client)
		..()
		playsound(src, 'sound/weapons/thudswoosh.ogg', 50, 1, -1)
		if(wantpet >= 100) //We want pets sometimes
			handle_affinity(M, 1)
			if(teppi_adult)
				if(prob(25))
					M.visible_message(span_notice("\The [src] rumbles happily at \the [M]"),span_notice("\The [src] rumbles happily at you!"))
					playsound(src, 'sound/voice/teppi/rumble.ogg', 75, 1)
				if(food_zone)
					food_zone.digest_mode = DM_DRAIN //People outside can help calm the tumby if you squirm too much
			else if(prob(25))
				M.visible_message(span_notice("\The [src] rumbles happily at \the [M]"),span_notice("\The [src] rumbles happily at you!"))
				playsound(src, 'sound/voice/teppi/cute_rumble.ogg', 75, 1)
			if(prob(25))
				wantpet = rand(0,25) * affection_factor //We stopped wanting pets
			to_chat(M, span_notice("\The [src] leans into your touch."))
			petcount = 0
		else if(petcount < 20)
			wantpet = 0
			petcount += 1
			if(prob(20))
				to_chat(M, span_notice("\The [src] grumbles at your touch."))
		else if(lets_eat(M) && prob(50))
			to_chat(M, span_notice("\The [src] grumbles a bit... and then bowls you over, pressing their weight into yours to knock you off of your feet! In a rush of chaotic presses and schlorps, the gooey touch of Teppi flesh grinds over you as you're guzzled away! Casually swallowed down in retaliation for all of the pettings. Pumped down deep into the grumbling depths of \the [src]."))
			visible_message(span_danger("\The [src] scromfs \the [M], before chuffing and settling down again."))
			playsound(src, pick(GLOB.bodyfall_sound), 75, 1)
			teppi_pounce(M)
			wantpet = 100
	else
		return ..()

/mob/living/simple_mob/vore/alienanimals/teppi/examine()
	. = ..()
	if(item_type)
		. += span_notice("They are wearing a [item_type] with [name] written on it.")
	if(nutrition >= 1000)
		. += span_notice("They look well fed.")
	if(nutrition <= 500)
		. += span_notice("They look hungry.")
	if(health < maxHealth && health / maxHealth * 100 <= 75)
		. += span_notice("They look beat up.")


/mob/living/simple_mob/vore/alienanimals/teppi/update_icon()
	..()
	teppi_icon()
	if(ghostjoin)
		ghostjoin_icon()


/mob/living/simple_mob/vore/alienanimals/teppi/Life()
	. =..()
	if(!. || QDELETED(src))
		return

	amount_grown += rand(1,5)
	var/not_hungy = FALSE
	if(nutrition >= 500)
		not_hungy = TRUE
	if(amount_grown >= 1000)
		if(teppi_adult)
			if(not_hungy && !teppi_wool)
				nutrition -= rand(250,500)
				teppi_wool = TRUE
				breedable = TRUE
				meat_amount += rand(0,2)
				update_icon()
		else if (not_hungy)
			var/nutrition_cost = 500 + (nutrition / 2)
			adjust_nutrition(-nutrition_cost)
			new /mob/living/simple_mob/vore/alienanimals/teppi(loc, store_teppi_data(src))
			qdel(src)
			return
		else
			visible_message("\The [src] whines pathetically...", runemessage = "whines")
			if(prob(50))
				playsound(src, 'sound/voice/teppi/whine1.ogg', 75, 1)
			else
				playsound(src, 'sound/voice/teppi/whine2.ogg', 75, 1)
			amount_grown -= rand(100,250)
	if(not_hungy)
		do_breeding()
	if(!client && prob(0.5))
		teppi_sound()

/mob/living/simple_mob/vore/alienanimals/teppi/proc/do_breeding()
	if(!breedable || prevent_breeding)
		return
	if(client)	//Player controlled teppi get a verb, so just do the countdown
		if(baby_countdown > 0)
			baby_countdown --
		return
	if(baby_countdown > 0)
		baby_countdown --
		return
	else if(GLOB.teppi_count >= GLOB.max_teppi) //if we can't make more then we shouldn't look for partners, but we can be ready in case a slot opens
		return
	if(prob(1))
		for(var/mob/living/simple_mob/vore/alienanimals/teppi/alltep in oview(1,src))
			if(!teppi_adult || !alltep.teppi_adult || alltep.prevent_breeding) //Don't have babies if you or your partner is babies
				continue
			if(alltep.client || alltep.stat == DEAD) //Don't have babies if your partner is inhabited by a player, or dead.
				continue
			if(alltep)
				new /mob/living/simple_mob/vore/alienanimals/teppi/baby(loc, src, alltep)
				baby_countdown = 200
				if(affinity[alltep.real_name])
					return
				personality.handle_affinity(alltep, 30) //Mom and dad should like eachother when they do their business
				alltep.handle_affinity(src, 30)
				return

/mob/living/simple_mob/vore/alienanimals/teppi/proc/teppi_sound()
	if(!teppi_adult || client)
		return
	if(resting)
		return
	playsound(src, pick(GLOB.teppi_sound), 75, 1)

/mob/living/simple_mob/vore/alienanimals/teppi/proc/try_teppi_shear(var/mob/user as mob, tool)
	var/sheartime = DEFAULT_TEPPI_SHEAR_TIME
	if(istype(tool, /obj/item/material/knife))
		var/obj/item/material/knife/K = tool
		if(K.default_material == MAT_PLASTIC || K.default_material == MAT_FLINT)
			sheartime *= 2
		if(K.dulled)
			sheartime *= 3
		if(!K.sharp)
			sheartime *= 2
		if(K.edge)
			sheartime *= 0.5
	else if(istype(tool, /obj/item/tool/wirecutters))
		sheartime *= 2
	else
		return FALSE
	if(do_after(user, sheartime, target = src))
		user.visible_message(span_notice("\The [user] shears \the [src] with \the [tool]."),span_notice("You shear \the [src] with \the [tool]."))
		amount_grown = rand(0,250)
		var/obj/item/stack/material/fur/F = new(get_turf(user), rand(10,15))
		F.color = marking_color
		teppi_wool = FALSE
		update_icon()
		handle_affinity(user, 5)
		teppi_sound()
		return TRUE

/mob/living/simple_mob/vore/alienanimals/teppi/Destroy()
	GLOB.teppi_count --
	friend_zone = null
	food_zone = null
	crossroads = null
	GLOB.active_ghost_pods -= src
	ai_holder.leader = null
	return ..()

/mob/living/simple_mob/vore/alienanimals/teppi/lay_down()
	..()
	if(!teppi_adult)
		return
	var/digest_mult = 2
	if(!client)				// AI teppi get a better multiplier
		digest_mult = 120 	// it has to be so large, because the default stats are So Low,
	else					// and as fun as it'd be to let players have big funny numbers, 120 on a multiplier is way too high.
	if(resting)
		if(!client)
			food_zone.digestchance = 60
		food_zone.digest_brute *= digest_mult // ~6 from default settings
		food_zone.digest_burn *= digest_mult // ~6 from default settings
		if(food_zone.contents && food_zone.digest_mode == DM_DIGEST) //Let everyone inside know that the teppi's tummy is getting to work...
			for(var/mob/living/snack in food_zone)
				to_chat(snack, span_warning("You feel the [food_zone] let out a deep rumble all around you..."))
	else
		if(!client)
			food_zone.digestchance = 5
		food_zone.digest_brute = max(0, food_zone.digest_brute / digest_mult) //Sanity.
		food_zone.digest_burn = max(0, food_zone.digest_burn / digest_mult)

/mob/living/simple_mob/vore/alienanimals/teppi/animal_nom(mob/living/T in living_mobs(1))
	if(vore_active && !voremob_loaded)
		init_vore(TRUE)
	if(client)
		return ..()
	var/current_affinity = personality.get_affinity(T)
	ai_holder.set_busy(TRUE)
	T.stop_pulling()
	if(current_affinity >= 50)
		var/tumby = vore_selected
		vore_selected = friend_zone
		ai_holder.set_busy(FALSE)
		..()
		vore_selected = tumby
		return
	else if(current_affinity <= -50)
		vore_selected.digest_mode = DM_DIGEST
	else
		vore_selected.digest_mode = DM_DRAIN
	..()
	ai_holder.set_busy(FALSE)


/mob/living/simple_mob/vore/alienanimals/teppi/perform_the_nom(mob/living/user, mob/living/prey, mob/living/pred, obj/belly/belly, delay_time)
	if(!client)
		var/teppi_checks = teppi_checks(user, prey, pred, belly)
		if(teppi_checks)
			belly = teppi_checks
		ai_holder.set_busy(TRUE)
		prey.stop_pulling()
	..()
	if(!client)
		ai_holder.set_busy(FALSE)

/mob/living/simple_mob/vore/alienanimals/teppi/begin_instant_nom(mob/living/user, mob/living/prey, mob/living/pred, obj/belly/belly)
	if(!client)
		var/teppi_checks = teppi_checks(user, prey, pred, belly)
		if(teppi_checks)
			belly = teppi_checks
		ai_holder.set_busy(TRUE)
		prey.stop_pulling()
	..()
	if(!client)
		ai_holder.set_busy(FALSE)

///Retrns the belly we'll be using if we are friends.
/mob/living/simple_mob/vore/alienanimals/teppi/proc/teppi_checks(mob/living/user, mob/living/prey, mob/living/pred)
	if(!pred)
		pred = user
	var/current_affinity = affinity[prey.real_name]
	if(current_affinity >= 50)
		return friend_zone
	if(current_affinity <= -50)
		vore_selected.digest_mode = DM_DIGEST
	else
		vore_selected.digest_mode = DM_DRAIN

//Instead of copying this everywhere let's just make a proc
/mob/living/simple_mob/vore/alienanimals/teppi/proc/lets_eat(person)
	if(teppi_adult && will_eat(person))
		return 1
	else
		return 0

/mob/living/simple_mob/vore/alienanimals/teppi/proc/teppi_pounce(mob/living/carbon/human/M as mob)
	M.Weaken(5)
	animal_nom(M)
	M.stop_pulling()


/datum/say_list/teppi
	speak = list("Gyooh~", "Gyuuuh!", "Gyuh?", "Gyaah...", "Iuuuuhh.", "Uoounh!", "GyoooOOOOoooh!", "Gyoh~", "Gyouh~","Gyuuuuh...", "Rrrr...", "Uuah~", "Groh!")
	emote_hear = list("puffs", "huffs", "rumbles", "gyoohs","pants", "snoofs")
	emote_see = list("sways its tail", "stretches", "yawns", "turns their head")
	say_maybe_target = list("Gyuuh?", "Rrrr!")
	say_got_target = list("GYOOOHHHH!!!")

/datum/say_list/teppibaby
	speak = list("Gyooh~", "Gyuuuh!", "Gyuh?", "Gyaah...", "Iuuuuhh.", "Uoounh!", "GyoooOOOOoooh!", "Gyoh~", "Gyouh~","Gyuuuuh...", "Rrrr...", "Uuah~", "Groh!", "Yip!")
	emote_hear = list("puffs", "huffs", "rumbles", "gyoohs","pants", "snoofs", "yips")
	emote_see = list("sways its tail", "stretches", "yawns", "turns their head")
	say_maybe_target = list("Gyuuh?", "Rrrr!")
	say_got_target = list("GYOOOHHHH!!!")

////////////////// Da babby //////////////

/mob/living/simple_mob/vore/alienanimals/teppi/baby
	name = "teppi"
	desc = "A smallish furry creature, sporting two nubby horns and a very sturdy tail. It has four toes on each paw."
	tt_desc = "Ipsumollis Velodigium"

	icon_state = "teppi"
	icon_living = "body_base"
	icon_dead = "body_dead"
	icon_rest = "body_rest"
	icon = 'icons/mob/alienanimals_x32.dmi'
	pixel_x = 0
	default_pixel_x = 0
	teppi_adult = FALSE
	maxHealth = 50
	health = 50
	movement_cooldown = 1
	harm_intent_damage = 5
	melee_damage_lower = 1
	melee_damage_upper = 5
	vore_active = FALSE		//it's a tiny baby :O
	devourable = FALSE
	digestable = FALSE
	vore_bump_chance = 0
	vore_pounce_chance = 0
	vis_height = 32
	meat_amount = 2
	loot_list = list()
	say_list_type = /datum/say_list/teppibaby

/mob/living/simple_mob/vore/alienanimals/teppi/baby/Initialize(mapload, teppi1, teppi2)
	. = ..()

	//Baby powers
	nutrition = 0
	add_verb(src, /mob/living/proc/ventcrawl)
	add_verb(src, /mob/living/proc/hide)


/mob/living/simple_mob/vore/alienanimals/teppi/baby/init_vore(force) //shouldn't need all the vore bidness if they aren't using it as babbies. They get their tummies when they grow up.
	return

/mob/living/simple_mob/vore/alienanimals/teppi/proc/store_teppi_data(mob/living/simple_mob/vore/alienanimals/teppi/teppi)
	var/list/teppi_data = list(
		"dir" = teppi.dir,
		"name" = teppi.name,
		"real_name" = teppi.real_name,
		"faction" = teppi.faction,
		"affinity" = teppi.affinity,
		"affection_factor" = teppi.affection_factor,
		"nutrition" = teppi.nutrition,
		"allergen_preference" = teppi.allergen_preference,
		"allergen_unpreference" = teppi.allergen_unpreference,
		"color" = teppi.color,
		"marking_color" = teppi.marking_color,
		"horn_color" = teppi.horn_color,
		"eye_color" = teppi.eye_color,
		"skin_color" = teppi.skin_color,
	)

	return teppi_data

//This sets all the things on adult teppi when they grow from a baby
/mob/living/simple_mob/vore/alienanimals/teppi/proc/inherit_from_baby(list/teppi_data)
	inherit_colors = TRUE
	inherit_allergen = TRUE
	dir = teppi_data["dir"]
	name = teppi_data["name"]
	real_name = teppi_data["real_name"]
	faction = teppi_data["faction"]
	affinity = teppi_data["affinity"]
	affection_factor = teppi_data["affection_factor"]
	nutrition = teppi_data["nutrition"]
	allergen_preference = teppi_data["allergen_preference"]
	allergen_unpreference = teppi_data["allergen_unpreference"]
	color = teppi_data["color"]
	marking_color = teppi_data["marking_color"]
	horn_color = teppi_data["horn_color"]
	eye_color = teppi_data["eye_color"]
	skin_color = teppi_data["skin_color"]
	ghostjoin = 1
	GLOB.active_ghost_pods += src
	update_icon()

//This sets all the things on baby teppi when they are bred from adult teppi
/mob/living/simple_mob/vore/alienanimals/teppi/proc/inherit_from_parents(mob/living/simple_mob/vore/alienanimals/teppi/mom, mob/living/simple_mob/vore/alienanimals/teppi/dad)
	inherit_colors = TRUE
//	mom_id = mom.teppi_id
//	dad_id = dad.teppi_id
	faction = mom.faction
	color = pick(list(mom.color, dad.color, BlendRGB(mom.color, dad.color, 0.5)))
	marking_color = pick(list(mom.marking_color, dad.marking_color, BlendRGB(mom.marking_color, dad.marking_color, 0.5)))
	horn_color = pick(list(mom.horn_color, dad.horn_color, BlendRGB(mom.horn_color, dad.horn_color, 0.5)))
	eye_color =  pick(list(mom.eye_color, dad.eye_color, BlendRGB(mom.eye_color, dad.eye_color, 0.5)))
	skin_color =  pick(list(mom.skin_color, dad.skin_color, BlendRGB(mom.skin_color, dad.skin_color, 0.5)))
	marking_type =  pick(list(mom.marking_type, dad.marking_type, null))
	horn_type =  pick(list(mom.horn_type, dad.horn_type, null))


	if(mom.teppi_mutate || dad.teppi_mutate)
		teppi_mutate = TRUE
	else if(prob(1))
		teppi_mutate = TRUE
	mom.nutrition -= 500
	dad.nutrition -= 250
	mom.visible_message("\The [src] is born from [mom]... It's the miracle of life!", runemessage = "grunts")
	handle_affinity(mom, 26)	//this way the babies will follow their parents around (and keep track of them)
	handle_affinity(dad, 25)

//I ran a vote with the headmins, and this option won out considering the restrictions.
//I don't think this is a GOOD idea, but in pursuit of preserving Teppi's mechanical functionality while player controlled, there is a verb!
//This gives a strongly worded warning the first time you push the button, and has similar restrictons to AI controlled Teppi for use which will prevent spamming.
//
/mob/living/simple_mob/vore/alienanimals/teppi/proc/produce_offspring()
	set name = "Produce Offspring"
	set category = "Abilities.Teppi"
	set desc = "You can have babies if the conditions are right."
	if(prevent_breeding)
		to_chat(src, span_notice("You have elected to not participate in breeding mechanics, and so cannot complete that action."))
		return
	if(!teppi_warned)
		to_chat(src, span_danger("Be aware of your surroundings when using this verb. If you use this to be disruptive or prefbreak people, you are likely to eat a ban. If whoever's tending the teppi is trying to make more babies, or you're alone, or playing with other people who you know are into it, then sure. You should not however, for example, drag another teppi to the bar (or any public place) and drop a baby in the middle of the floor. If you're not sure if it's okay to do where you are, with whoever's around, it probably isn't. This is intended to preserve the mechanical utility of the mob you are playing as, not as a scene tool."))
		teppi_warned = TRUE
		return
	if(stat != CONSCIOUS)
		to_chat(src, span_notice("I can't do that right now..."))
		return
	if(!teppi_adult)
		to_chat(src, span_notice("I'm not old enough to make babies."))
		return
	if(baby_countdown > 0)
		to_chat(src, span_notice("It is not time yet..."))
		return
	if(!breedable || nutrition < 500)
		to_chat(src, span_notice("The conditions are not right to produce offspring."))
		return
	if(GLOB.teppi_count >= GLOB.max_teppi) //if we can't make more then we shouldn't look for partners
		to_chat(src, span_notice("I cannot produce more offspring at the moment, there are too many of us!"))
		return
	. = FALSE
	for(var/mob/living/simple_mob/vore/alienanimals/teppi/alltep in oview(1,src))
		if(!alltep.teppi_adult || alltep.nutrition < 250 || alltep.prevent_breeding || alltep.stat == DEAD)
			continue
		if(alltep)
			log_admin("[key_name_admin(src)] produced a baby teppi at [get_area(src)] - [COORD(src)]") //Won't show up in the chat, but makes a log of who's having babies where, for investigative purposes.
			new /mob/living/simple_mob/vore/alienanimals/teppi/baby(loc, src, alltep)
			baby_countdown = 400 //You don't have a random chance to deal with so the cooldown is twice as long.
			if(affinity[alltep.real_name])
				return
			handle_affinity(alltep, 30) //Mom and dad should like eachother when they do their business
			alltep.handle_affinity(src, 30)
			return
	if(. == FALSE)
		to_chat(src, span_notice("There are no suitable partners nearby."))

/mob/living/simple_mob/vore/alienanimals/teppi/proc/toggle_producing_offspring()
	set name = "Toggle Producing Offspring"
	set category = "Abilities.Teppi"
	set desc = "You can toggle whether or not you can produce offspring."
	if(!prevent_breeding)
		to_chat(src, span_notice("You disable breeding."))
		prevent_breeding = TRUE
	else
		to_chat(src, span_notice("You enable breeding."))
		prevent_breeding = FALSE

//This a teppi with funny colors will spawn!
/mob/living/simple_mob/vore/alienanimals/teppi/mutant/Initialize(mapload)
	teppi_mutate = TRUE
	. = ..()

//Custom teppi colors! For funzies.

/mob/living/simple_mob/vore/alienanimals/teppi/cass/Initialize(mapload)
	inherit_colors = TRUE
	color = "#c69c85"
	marking_color = "#eeb698"
	horn_color = "#272523"
	eye_color = "#612c08"
	skin_color = "#272523"
	marking_type = "2"
	horn_type =  "0"
	. = ..()

/mob/living/simple_mob/vore/alienanimals/teppi/baby/cass/Initialize(mapload)
	inherit_colors = TRUE
	color = "#c69c85"
	marking_color = "#eeb698"
	horn_color = "#272523"
	eye_color = "#612c08"
	skin_color = "#272523"
	marking_type = "2"
	horn_type =  "0"
	. = ..()

/mob/living/simple_mob/vore/alienanimals/teppi/aronai/Initialize(mapload)
	inherit_colors = TRUE
	color = "#404040"
	marking_color = "#222222"
	horn_color = "#141414"
	eye_color = "#9f522c"
	skin_color = "#e16f2d"
	marking_type = "13"
	horn_type = "1"
	. = ..()

/mob/living/simple_mob/vore/alienanimals/teppi/lira/Initialize(mapload)
	inherit_colors = TRUE
	color = "#fdfae9"
	marking_color = "#ffffc0"
	horn_color = "#ffc965"
	eye_color = "#1d7fb7"
	skin_color = "#f09ca9"
	marking_type = "13"
	horn_type = "0"
	. = ..()

#undef DEFAULT_TEPPI_SHEAR_TIME
