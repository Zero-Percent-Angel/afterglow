//DO NOT ADD MECHA PARTS TO THE GAME WITH THE DEFAULT "SPRITE ME" SPRITE!
//I'm annoyed I even have to tell you this! SPRITE FIRST, then commit.

/obj/item/mecha_parts/mecha_equipment
	name = "mecha equipment"
	icon = 'icons/mecha/mecha_equipment.dmi'
	icon_state = "mecha_equip"
	force = 5
	max_integrity = 300
	var/equip_cooldown = 0 // cooldown after use
	var/equip_ready = 1 //whether the equipment is ready for use. (or deactivated/activated for static stuff)
	var/energy_drain = 0
	var/obj/mecha/chassis = null
	/// Bitflag. Determines the range of the equipment.
	var/range = MELEE
	/// Bitflag. Used by exosuit fabricator to assign sub-categories based on which exosuits can equip this.
	var/mech_flags = NONE
	var/salvageable = 1
	//var/detachable = TRUE // Set to FALSE for built-in equipment that cannot be removed
	var/selectable = 1	// Set to 0 for passive equipment such as mining scanner or armor plates
	var/harmful = FALSE //Controls if equipment can be used to attack by a pacifist.
	//var/destroy_sound = 'sound/mecha/critdestr.ogg'

/obj/item/mecha_parts/mecha_equipment/proc/update_chassis_page()
	if(chassis)
		send_byjax(chassis.occupant,"exosuit.browser","eq_list",chassis.get_equipment_list())
		send_byjax(chassis.occupant,"exosuit.browser","equipment_menu",chassis.get_equipment_menu(),"dropdowns")
		return 1
	return

/obj/item/mecha_parts/mecha_equipment/proc/update_equip_info()
	if(chassis)
		send_byjax(chassis.occupant,"exosuit.browser","[REF(src)]",get_equip_info())
		return 1
	return

/obj/item/mecha_parts/mecha_equipment/Destroy()
	if(chassis)
		chassis.equipment -= src
		if(chassis.selected == src)
			chassis.selected = null
		src.update_chassis_page()
		//log_message("[src] is destroyed.", LOG_MECHA)
		chassis.log_append_to_last("[src] is destroyed.",1)
		if(chassis.occupant)
			chassis.occupant_message(span_danger("[src] is destroyed!"))
			SEND_SOUND(chassis.occupant, sound(istype(src, /obj/item/mecha_parts/mecha_equipment/weapon) ? 'sound/mecha/weapdestr.ogg' : 'sound/mecha/critdestr.ogg', volume=50))
			//chassis.occupant.playsound_local(chassis, destroy_sound, 50)
		//if(!detachable) //If we're a built-in nondetachable equipment, let's lock up the slot that we were in.
		//	chassis.max_equip--
		chassis = null
	return ..()

/obj/item/mecha_parts/mecha_equipment/proc/critfail()
	if(chassis)
		mecha_log_message("Critical failure", color="red")

/obj/item/mecha_parts/mecha_equipment/proc/get_equip_info()
	if(!chassis)
		return
	var/txt = "<span style=\"color:[equip_ready?"#0f0":"#f00"];\">*</span>&nbsp;"
	if(chassis.selected == src)
		txt += "<b>[src.name]</b>"
	else if(selectable)
		txt += "<a href='byond://?src=[REF(chassis)];select_equip=[REF(src)]'>[src.name]</a>"
	else
		txt += "[src.name]"

	return txt

/obj/item/mecha_parts/mecha_equipment/proc/is_ranged()//add a distance restricted equipment. Why not?
	return range&RANGED //rename to MECHA_RANGE and MECHA_MELEE

/obj/item/mecha_parts/mecha_equipment/proc/is_melee()
	return range&MELEE


/obj/item/mecha_parts/mecha_equipment/proc/action_checks(atom/target)
	if(!target)
		return 0
	if(!chassis)
		return 0
	if(!equip_ready)
		return 0
	if(energy_drain && !chassis.has_charge(energy_drain))
		return 0
	if(crit_fail)
		return 0
	if(chassis.equipment_disabled)
		to_chat(chassis.occupant, "<span=warn>Error -- Equipment control unit is unresponsive.</span>")
		return 0
	return 1

/obj/item/mecha_parts/mecha_equipment/proc/action(atom/target)
	return 0

/obj/item/mecha_parts/mecha_equipment/proc/start_cooldown()
	set_ready_state(0)
	chassis.use_power(energy_drain)
	addtimer(CALLBACK(src, PROC_REF(set_ready_state), 1), equip_cooldown)

/obj/item/mecha_parts/mecha_equipment/proc/do_after_cooldown(atom/target)
	if(!chassis)
		return
	var/C = chassis.loc
	set_ready_state(0)
	chassis.use_power(energy_drain)
	. = do_after(chassis.occupant, equip_cooldown, target=target)
	set_ready_state(1)
	if(!chassis || 	chassis.loc != C || src != chassis.selected || !(get_dir(chassis, target)&chassis.dir))
		return 0

/obj/item/mecha_parts/mecha_equipment/proc/do_after_mecha(atom/target, delay)
	if(!chassis)
		return
	var/C = chassis.loc
	. = do_after(chassis.occupant, delay, target=target)
	if(!chassis || 	chassis.loc != C || src != chassis.selected || !(get_dir(chassis, target)&chassis.dir))
		return 0

/obj/item/mecha_parts/mecha_equipment/proc/can_attach(obj/mecha/M)
	if(M.equipment.len<M.max_equip)
		return 1

/obj/item/mecha_parts/mecha_equipment/proc/attach(obj/mecha/M)
	M.equipment += src
	chassis = M
	forceMove(M)
	M.mecha_log_message("[src] initialized.")
	src.update_chassis_page()
	return

/obj/item/mecha_parts/mecha_equipment/proc/detach(atom/moveto=null)
	moveto = moveto || get_turf(chassis)
	if(src.Move(moveto))
		chassis.equipment -= src
		if(chassis.selected == src)
			chassis.selected = null
		update_chassis_page()
		chassis.mecha_log_message("[src] removed from equipment.")
		chassis = null
		set_ready_state(1)
	return


/obj/item/mecha_parts/mecha_equipment/Topic(href,href_list)
	if(href_list["detach"])
		detach()

/obj/item/mecha_parts/mecha_equipment/proc/set_ready_state(state)
	equip_ready = state
	if(chassis)
		send_byjax(chassis.occupant,"exosuit.browser","[REF(src)]",src.get_equip_info())
	return

/obj/item/mecha_parts/mecha_equipment/proc/occupant_message(message)
	if(chassis)
		chassis.occupant_message("[icon2html(src, chassis.occupant)] [message]")
	return

/obj/item/mecha_parts/mecha_equipment/proc/mecha_log_message(message, color) //on tg this just overrides log_message
	log_message(message, LOG_GAME, color)			//pass to default admin logging too
	if(chassis)
		chassis.mecha_log_message(message, color)		//and pass to our chassis

//Used for reloading weapons/tools etc. that use some form of resource
/obj/item/mecha_parts/mecha_equipment/proc/rearm()
	return 0

/obj/item/mecha_parts/mecha_equipment/proc/needs_rearm()
	return 0
