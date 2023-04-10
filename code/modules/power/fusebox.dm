#define UPSTATE_ALLGOOD		(1<<7)

#define APC_NOT_CHARGING 0
#define APC_CHARGING 1
#define APC_FULLY_CHARGED 2
#define APC_ELECTRONICS_SECURED 2
#define APC_COVER_CLOSED 0


/obj/machinery/power/apc/fusebox
	name = "fusebox"
	icon_state = "fusebox"
	cell_type = /obj/item/stock_parts/cell/potato


/obj/machinery/power/apc/fusebox/ui_interact()
	//do nothing it's a fuse box....

//Icon
/obj/machinery/power/apc/fusebox/update_icon()
	var/update = check_updates() 		//returns 0 if no need to update icons.
						// 1 if we need to update the icon_state
						// 2 if we need to update the overlays
	if(!update)
		icon_update_needed = FALSE
		return

	if(update & 1) // Updating the icon state
		if(update_state & UPSTATE_ALLGOOD)
			icon_state = "fusebox"
		else
			icon_state = "fusebox-tripped"

	if(update_state & UPSTATE_ALLGOOD)
		switch(charging)
			if(APC_NOT_CHARGING)
				icon_state = "fusebox-tripped"
			if(APC_CHARGING)
				icon_state = "fusebox"
			if(APC_FULLY_CHARGED)
				icon_state = "fusebox"

/obj/machinery/power/apc/fusebox/north //Pixel offsets get overwritten on New()
	dir = NORTH
	pixel_y = 23

/obj/machinery/power/apc/fusebox/south
	dir = SOUTH
	pixel_y = -23

/obj/machinery/power/apc/fusebox/east
	dir = EAST
	pixel_x = 24

/obj/machinery/power/apc/fusebox/west
	dir = WEST
	pixel_x = -25

/obj/machinery/power/apc/fusebox/screwdriver_act(mob/living/user, obj/item/W)
	return FALSE;

/obj/machinery/power/apc/fusebox/crowbar_act(mob/user, obj/item/W)
	new /obj/item/stack/sheet/metal(loc)
	new /obj/item/stack/cable_coil/ten(loc)
	qdel(src)
	return TRUE


/obj/machinery/power/apc/fusebox/on_attack_hand(mob/user, act_intent, unarmed_attack_flags)
	playsound(src, 'sound/machines/click.ogg', 50, 1)
	operating = !operating
	to_chat(user, span_notice("You turn the fusebox [operating ? "on" : "off"]."))


/obj/machinery/power/apc/fusebox/Initialize(mapload, ndir, building = FALSE)
	. = ..()
	if (building)
		make_terminal()
		terminal.connect_to_network()
		has_electronics = APC_ELECTRONICS_SECURED
		opened = APC_COVER_CLOSED
		// is starting with a power cell installed, create it and set its charge level
		if(cell_type)
			cell = new cell_type
			cell.charge = start_charge * cell.maxcharge / 100
		stat = initial(stat)
		operating = TRUE
		update_icon()


#undef APC_NOT_CHARGING
#undef APC_CHARGING
#undef APC_FULLY_CHARGED
#undef UPSTATE_ALLGOOD
#undef APC_ELECTRONICS_SECURED
#undef APC_COVER_CLOSED


/obj/item/wallframe/apc/fusebox
	name = "\improper Fusebox"
	desc = "Used for repairing or building fuseboxes."
	icon_state = "fusebox"
	icon = 'icons/obj/power.dmi'
	result_path = /obj/machinery/power/apc/fusebox
	inverse = 1
