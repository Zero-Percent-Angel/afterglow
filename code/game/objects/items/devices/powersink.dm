// Powersink - used to drain station power

GLOBAL_LIST_EMPTY(power_sinks)

/obj/item/powersink
	desc = "A nulling power sink which drains energy from electrical systems."
	name = "power sink"
	icon = 'icons/obj/device.dmi'
	icon_state = "powersink0"
	item_state = "electronic"
	lefthand_file = 'icons/mob/inhands/misc/devices_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/misc/devices_righthand.dmi'
	w_class = WEIGHT_CLASS_BULKY
	flags_1 = CONDUCT_1
	throwforce = 5
	throw_speed = 1
	throw_range = 2
	custom_materials = list(/datum/material/iron=750)
	var/drain_rate = 1600000	// amount of power to drain per tick
	var/power_drained = 0 		// has drained this much power
	var/max_power = 1e10		// maximum power that can be drained before exploding
	var/mode = 0		// 0 = off, 1=clamped (off), 2=operating
	var/admins_warned = FALSE // stop spam, only warn the admins once that we are about to boom

	var/const/DISCONNECTED = 0
	var/const/CLAMPED_OFF = 1
	var/const/OPERATING = 2

	var/obj/structure/cable/attached		// the attached cable

/obj/item/powersink/Initialize()
	. = ..()
	GLOB.power_sinks += src

/obj/item/powersink/Destroy()
	GLOB.power_sinks -= src
	. = ..()

/obj/item/powersink/update_icon_state()
	icon_state = "powersink[mode == OPERATING]"

/obj/item/powersink/proc/set_mode(value)
	if(value == mode)
		return
	switch(value)
		if(DISCONNECTED)
			attached = null
			if(mode == OPERATING)
				STOP_PROCESSING(SSobj, src)
			anchored = FALSE

		if(CLAMPED_OFF)
			if(!attached)
				return
			if(mode == OPERATING)
				STOP_PROCESSING(SSobj, src)
			anchored = TRUE

		if(OPERATING)
			if(!attached)
				return
			START_PROCESSING(SSobj, src)
			anchored = TRUE

	mode = value
	update_icon()
	set_light(0)

/obj/item/powersink/attackby(obj/item/I, mob/user, params)
	if(istype(I, /obj/item/screwdriver))
		if(mode == DISCONNECTED)
			var/turf/T = loc
			if(isturf(T) && !T.intact)
				attached = locate() in T
				if(!attached)
					to_chat(user, span_warning("This device must be placed over an exposed, powered cable node!"))
				else
					set_mode(CLAMPED_OFF)
					user.visible_message( \
						"[user] attaches \the [src] to the cable.", \
						span_notice("You attach \the [src] to the cable."),
						span_italic("You hear some wires being connected to something."))
			else
				to_chat(user, span_warning("This device must be placed over an exposed, powered cable node!"))
		else
			set_mode(DISCONNECTED)
			user.visible_message( \
				"[user] detaches \the [src] from the cable.", \
				span_notice("You detach \the [src] from the cable."),
				span_italic("You hear some wires being disconnected from something."))
	else
		return ..()

/obj/item/powersink/attack_paw()
	return

/obj/item/powersink/attack_ai()
	return

/obj/item/powersink/on_attack_hand(mob/user, act_intent = user.a_intent, unarmed_attack_flags)
	switch(mode)
		if(DISCONNECTED)
			..()

		if(CLAMPED_OFF)
			user.visible_message( \
				"[user] activates \the [src]!", \
				span_notice("You activate \the [src]."),
				span_italic("You hear a click."))
			message_admins("Power sink activated by [ADMIN_LOOKUPFLW(user)] at [ADMIN_VERBOSEJMP(src)]")
			log_game("Power sink activated by [key_name(user)] at [AREACOORD(src)]")
			set_mode(OPERATING)

		if(OPERATING)
			user.visible_message( \
				"[user] deactivates \the [src]!", \
				span_notice("You deactivate \the [src]."),
				span_italic("You hear a click."))
			set_mode(CLAMPED_OFF)

/obj/item/powersink/process()
	if(!attached)
		set_mode(DISCONNECTED)
		return

	var/datum/powernet/PN = attached.powernet
	if(PN)
		set_light(5)

		// found a powernet, so drain up to max power from it

		var/drained = min ( drain_rate, attached.newavail() )
		attached.add_delayedload(drained)
		power_drained += drained

		// if tried to drain more than available on powernet
		// now look for APCs and drain their cells
		if(drained < drain_rate)
			for(var/obj/machinery/power/terminal/T in PN.nodes)
				if(istype(T.master, /obj/machinery/power/apc))
					var/obj/machinery/power/apc/A = T.master
					if(A.operating && A.cell)
						A.cell.charge = max(0, A.cell.charge - 50)
						power_drained += 50
						if(A.charging == 2) // If the cell was full
							A.charging = 1 // It's no longer full
				if(drained >= drain_rate)
					break

	if(power_drained > max_power * 0.98)
		if (!admins_warned)
			admins_warned = TRUE
			message_admins("Power sink at ([x],[y],[z] - <A href='byond://?_src_=holder;[HrefToken()];adminplayerobservecoodjump=1;X=[x];Y=[y];Z=[z]'>JMP</a>) is 95% full. Explosion imminent.")
		playsound(src, 'sound/effects/screech.ogg', 100, 1, 1)

	if(power_drained >= max_power)
		STOP_PROCESSING(SSobj, src)
		explosion(src.loc, 4,8,16,32)
		qdel(src)
