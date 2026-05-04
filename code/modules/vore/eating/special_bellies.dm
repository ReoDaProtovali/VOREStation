// Special Vorebelly types. For general use bellies that have abnormal functionality.
// Also ones that probably shouldn't be savable.
// PS: I'm adding this file in the middle of a toilet overhaul PR.
// If that's not the definition of scope increase, I dont know what is. -Reo

/obj/belly/special //parant type for bellies you dont want to be treated like normal bellies to use
	prevent_saving = TRUE

/obj/belly/special/teleporter
	var/atom/movable/target = null
	var/target_turf = TRUE
	var/teleport_delay = 3 SECONDS

/obj/belly/special/teleporter/Entered(atom/movable/thing, atom/OldLoc)
	. = ..()
	if(teleport_delay <= 0) //just try to teleport immediately.
		try_tele(thing)
		return
	addtimer(CALLBACK(src, PROC_REF(try_tele), thing), teleport_delay, TIMER_DELETE_ME)

/obj/belly/special/teleporter/process(wait)
	if(istype(target))
		return ..()
	for(var/atom/movable/AM in contents)
		try_tele(AM)
	. = ..()

/obj/belly/special/teleporter/proc/try_tele(atom/movable/thing)
	if(!istype(target))
		return
	if(isturf(target)) // if it's a turf, we dont need to do anything else, just teleport to it
		thing.forceMove(target)
	else
		thing.forceMove(target_turf ? get_turf(target) : target )

// Handles autotransfer in a unique way.
// Target destination is used to transfer "incoming" disposal packets.
// Transfer chance is used to determine chance of flushing every process().
// Autotransfer message is used for the transfer out of the belly into the linked network.
// Additionally, on account of the mechanical intent of this vorebelly, preference for autotransfer will be disregarded.
// Generally, I cant imagine these being used outside of very niche situations, like the one im making this for.
/obj/belly/special/disposal_connected

	var/atom/flush_target //Incase we arnt being connected ourselves.

/obj/belly/special/disposal_connected/Initialize(mapload, target)
	flush_target = target
	RegisterSignal(src, COMSIG_DISPOSAL_RECEIVE, PROC_REF(receive_packet))
	. = ..()

/obj/belly/special/disposal_connected/Destroy()
	. = ..()
	flush_target = null

/obj/belly/special/disposal_connected/process(wait) //Doesnt run
	. = ..()

/obj/belly/special/disposal_connected/check_autotransfer(atom/movable/prey, list/transfer_locations)
	if(prob(autotransferchance))
		try_flush()
		return
	prey.belly_cycles = 0

/obj/belly/special/disposal_connected/proc/try_flush()
	var/datum/gas_mixture/air_contents = new(1)
	//Flush on our flush target, or ourselves if that doesnt exist.
	//Contents are the things we try to send. if this fails, nothing happens, and this is fine, we can try again.
	if(SEND_SIGNAL((istype(flush_target) ? flush_target : src), COMSIG_DISPOSAL_FLUSH, contents, air_contents))
		for(var/atom/movable/AM in contents)
			if(isliving(AM))
				var/mob/living/L = AM
				to_chat(L, span_vwarning(belly_format_string(primary_autotransfer_messages_owner, L, dest = "The disposals network")))

	else
		//Didnt send, delete the gas datum.
		qdel(air_contents)

//"Recieve" stuff from a disposal network, and instantly forward it to our autotransfer belly if it's set, to prevent it just getting transfered again.
/obj/belly/special/disposal_connected/proc/receive_packet(datum/source, list/recieved_items, datum/gas_mixture/gas)
	SIGNAL_HANDLER
	qdel(gas) //Nowhere for it to go.
	for(var/atom/movable/AM in recieved_items)
		nom_atom(AM)
