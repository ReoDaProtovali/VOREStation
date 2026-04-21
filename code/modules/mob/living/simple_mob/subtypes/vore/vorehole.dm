// Vorehole mob.
// Generally, this should never be spawned on it's own, spawn the structure and it'll put one of these in it.

// Vorehole States (used by the structure.)
#define HOLE_CLENCHING -1
#define HOLE_INACTIVE 0
#define HOLE_ACTIVE 1
#define HOLE_SWALLOW_HAZARD 2

/mob/living/simple_mob/vorehole
	name = "Hole"	// These will be set based on whatever structure subtype it spawns in.
	desc = ""		// So copying the desc isnt important and saves copypasta
	anchored = TRUE
	gender = NEUTER

	var/obj/structure/vorehole/parent_hole = null

/mob/living/simple_mob/vorehole/Initialize(mapload)
	parent_hole = loc
	if(!istype(parent_hole, /obj/structure/vorehole)) //We're being created, but we're not in our parent object! Something has gone very wrong, or an admin spawned the wrong thing.
		return INITIALIZE_HINT_QDEL
	. = ..()
	//Realistically, only the name will be seen when speaking and in the vorepanel, but we're doing desc too for completion.
	name = parent_hole.name
	desc = parent_hole.desc



/mob/living/simple_mob/vorehole/Login()
	. = ..()
	remove_verb(src, /mob/living/simple_mob/proc/set_gender) //The hole does not have a gender
	add_verb(src, /mob/living/simple_mob/vorehole/proc/try_swallow)

/mob/living/simple_mob/vorehole/set_name()
	if(limit_renames && nameset)
		to_chat(src, span_userdanger("You've already set your name. Ask an admin to toggle \"nameset\" to 0 if you really must."))
		return
	var/newname
	newname = sanitizeSafe(tgui_input_text(src,"Set your name. You only get to do this once. Max 52 chars.", "Name set","", MAX_NAME_LEN, encode = FALSE), MAX_NAME_LEN)
	if (newname)
		name = newname
		voice_name = newname
		if(parent_hole)
			parent_hole.name = newname
		nameset = 1

/mob/living/simple_mob/vorehole/set_desc()
	var/newdesc
	newdesc = sanitizeSafe(tgui_input_text(src,"Set your description. Max 4096 chars.", "Description set","", prevent_enter = TRUE, encode = FALSE), MAX_MESSAGE_LEN)
	if(newdesc)
		desc = newdesc
		if(parent_hole)
			parent_hole.desc = .

/mob/living/simple_mob/vorehole/proc/try_swallow()


/datum/action/innate/vorehole_state_toggle
	name = "Toggle swallow mode."
	check_flags = AB_CHECK_RESTRAINED | AB_CHECK_STUNNED | AB_CHECK_CONSCIOUS

	var/obj/structure/vorehole/hole

/datum/action/innate/vorehole_state_toggle/Grant(mob/grant_to, obj/structure/_vorehole)
	. = ..()

	hole = _vorehole
	//active means it's in swallow hazard mode. If it's already in that state when we're granted, we should also start active.
	if(hole && hole.hole_state == HOLE_SWALLOW_HAZARD)
		active = TRUE

/datum/action/innate/vorehole_state_toggle/Trigger(trigger_flags)
	if(!hole || hole.hole_state <= HOLE_INACTIVE) // No changing state if you're in the middle of a swallow or otherwise inactive.
		to_chat(owner, span_warning("You cant change your state at the moment..."))
		return
	. = ..()

/datum/action/innate/vorehole_state_toggle/Activate()
	hole.hole_state = HOLE_SWALLOW_HAZARD
	to_chat(owner, span_notice("You prepare to readily swallow anything that gets too close."))

/datum/action/innate/vorehole_state_toggle/Deactivate()
	hole.hole_state = HOLE_ACTIVE
	to_chat(owner, span_notice("You will now hold shut until you manually try to swallow."))

/datum/action/vorehole_try_swallow
	name = "Swallow"

#undef HOLE_CLENCHING
#undef HOLE_INACTIVE
#undef HOLE_ACTIVE
#undef HOLE_SWALLOW_HAZARD
