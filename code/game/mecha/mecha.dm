#define MECHA_INT_FIRE			(1<<0)
#define MECHA_INT_TEMP_CONTROL	(1<<1)
#define MECHA_INT_SHORT_CIRCUIT	(1<<2)
#define MECHA_INT_TANK_BREACH	(1<<3)
#define MECHA_INT_CONTROL_LOST	(1<<4)

#define MELEE 1
#define RANGED 2

#define FRONT_ARMOUR 1
#define SIDE_ARMOUR 2
#define BACK_ARMOUR 3

// Defines for the durand's shield

// /obj/mecha signals
#define COMSIG_MECHA_ACTION_ACTIVATE "mecha_action_activate"	//sent from mecha action buttons to the mecha they're linked to

// End shield

/obj/mecha
	name = "mecha"
	desc = "Exosuit"
	icon = 'icons/mecha/mecha.dmi'
	density = TRUE //Dense. To raise the heat.
	opacity = 1 ///opaque. Menacing.
//	anchored = TRUE //no pulling around.
	resistance_flags = FIRE_PROOF | ACID_PROOF
	layer = BELOW_MOB_LAYER//icon draw layer
	infra_luminosity = 15 //byond implementation is bugged.
	force = 5
	flags_1 = HEAR_1|BLOCK_FACE_ATOM_1
	attack_hand_speed = CLICK_CD_MELEE
	attack_hand_is_action = TRUE
	var/can_move = 0 //time of next allowed movement
	var/mob/living/occupant = null
	var/step_in = 10 //make a step in step_in/10 sec.
	var/dir_in = SOUTH //What direction will the mech face when entered/powered on? Defaults to South.
	var/normal_step_energy_drain = 10 //How much energy the mech will consume each time it moves. This variable is a backup for when leg actuators affect the energy drain.
	var/step_energy_drain = 10
	var/melee_energy_drain = 15
	var/overload_step_energy_drain_min = 100
	max_integrity = 300 //max_integrity is base health
	move_force = MOVE_FORCE_VERY_STRONG
	move_resist = MOVE_FORCE_EXTREMELY_STRONG
	light_range = 9
	var/deflect_chance = 10 //chance to deflect the incoming projectiles, hits, or lesser the effect of ex_act.
	armor = ARMOR_VALUE_HEAVY
	var/list/facing_modifiers = list(FRONT_ARMOUR = 1.5, SIDE_ARMOUR = 1, BACK_ARMOUR = 0.5)
	var/obj/item/stock_parts/cell/cell
	var/state = 0
	var/list/log = new
	var/last_message = 0
	var/add_req_access = 1
	var/maint_access = 0
	var/equipment_disabled = 0 //disabled due to EMP
	var/dna_lock //dna-locking the mech
	var/list/proc_res = list() //stores proc owners, like proc_res["functionname"] = owner reference
	var/datum/effect_system/spark_spread/spark_system = new
	var/lights = FALSE
	var/lights_power = 8
	var/last_user_hud = 1 // used to show/hide the mecha hud while preserving previous preference
	var/completely_disabled = FALSE //stops the mech from doing anything
	var/breach_time = 0
	var/recharge_rate = 0
	var/can_be_locked = FALSE //Whether the mech can be DNA-locked or not.

	var/bumpsmash = 0 //Whether or not the mech destroys walls by running into it.
	//inner atmos
	var/use_internal_tank = 0
	var/internal_tank_valve = ONE_ATMOSPHERE
	var/obj/machinery/portable_atmospherics/canister/internal_tank
	var/datum/gas_mixture/cabin_air
	var/obj/machinery/atmospherics/components/unary/portables_connector/connected_port = null

	var/obj/item/radio/mech/radio
	var/list/trackers = list()

	var/max_temperature = 25000
	var/internal_damage_threshold = 50 //health percentage below which internal damage is possible
	var/internal_damage = 0 //contains bitflags

	var/list/operation_req_access = list()//required access level for mecha operation
	var/list/internals_req_access = list()//REQUIRED ACCESS LEVEL TO OPEN CELL COMPARTMENT

	var/wreckage

	var/list/equipment = new
	var/obj/item/mecha_parts/mecha_equipment/selected
	var/max_equip = 3
	var/datum/events/events

	var/stepsound = 'sound/mecha/mechstep.ogg'
	var/turnsound = 'sound/mecha/mechturn.ogg'
	var/attacksound = 'sound/weapons/punch4.ogg'

	var/melee_cooldown = 10
	var/melee_can_hit = 1
	var/attack_knockdown = 0 // For how much time it will knockdown a target in melee

	var/exit_delay = 40 //Time to exit mech
	var/destruction_sleep_duration = 50 //Time that mech pilot is put to sleep for if mech is destroyed
	var/enter_delay = 40 //Time taken to enter the mech

	var/is_currently_ejecting = FALSE //Mech cannot use equiptment when true, set to true if pilot is trying to exit mech

	//Action datums
	var/datum/action/innate/mecha/mech_eject/eject_action = new
	var/datum/action/innate/mecha/mech_toggle_internals/internals_action = new
	var/datum/action/innate/mecha/mech_cycle_equip/cycle_action = new
	var/datum/action/innate/mecha/mech_toggle_lights/lights_action = new
	var/datum/action/innate/mecha/mech_view_stats/stats_action = new
	var/datum/action/innate/mecha/mech_toggle_thrusters/thrusters_action = new
	var/datum/action/innate/mecha/mech_defense_mode/defense_action = new
	var/datum/action/innate/mecha/mech_overload_mode/overload_action = new
	var/datum/effect_system/smoke_spread/smoke_system = new //not an action, but trigged by one
	var/datum/action/innate/mecha/mech_smoke/smoke_action = new
	var/datum/action/innate/mecha/mech_zoom/zoom_action = new
	var/datum/action/innate/mecha/mech_switch_damtype/switch_damtype_action = new
	var/datum/action/innate/mecha/mech_toggle_phasing/phasing_action = new
	var/datum/action/innate/mecha/strafe/strafing_action = new

	//Action vars
	var/thrusters_active = FALSE
	var/leg_overload_mode = FALSE
	var/leg_overload_coeff = 100
	var/zoom_mode = FALSE
	var/smoke = 1
	var/smoke_ready = 1
	var/smoke_cooldown = 100
	var/phasing = FALSE
	var/phasing_energy_drain = 200
	var/phase_state = "" //icon_state when phasing
	var/strafe = FALSE //If we are strafing
	var/defense_mode = FALSE

	var/canstrafe = FALSE //if we can turn on strafing
	var/haslights = TRUE //if we can turn on lights

	var/nextsmash = 0
	var/smashcooldown = 3	//deciseconds

	var/occupant_sight_flags = 0 //sight flags to give to the occupant (e.g. mech mining scanner gives meson-like vision)
	var/mouse_pointer

	hud_possible = list (DIAG_STAT_HUD, DIAG_BATT_HUD, DIAG_MECH_HUD, DIAG_TRACK_HUD)

/obj/item/radio/mech //this has to go somewhere

/obj/mecha/Initialize()
	. = ..()
	events = new
	icon_state += "-open"
	add_radio()
	add_cabin()
	add_airtank()
	spark_system.set_up(2, 0, src)
	spark_system.attach(src)
	smoke_system.set_up(3, src)
	smoke_system.attach(src)
	add_cell()
	START_PROCESSING(SSobj, src)
	GLOB.poi_list |= src
	mecha_log_message("[src.name] created.")
	GLOB.mechas_list += src //global mech list
	prepare_huds()
	for(var/datum/atom_hud/data/diagnostic/diag_hud in GLOB.huds)
		diag_hud.add_to_hud(src)
	diag_hud_set_mechhealth()
	diag_hud_set_mechcell()
	diag_hud_set_mechstat()

/obj/mecha/get_cell()
	return cell

/obj/mecha/rust_heretic_act()
	take_damage(50,  BRUTE)

/obj/mecha/Destroy()
	if(occupant)
		occupant.SetSleeping(destruction_sleep_duration)
	go_out()
	var/mob/living/silicon/ai/AI
	for(var/mob/M in src) //Let's just be ultra sure
		if(isAI(M))
			occupant = null
			AI = M //AIs are loaded into the mech computer itself. When the mech dies, so does the AI. They can be recovered with an AI card from the wreck.
		else
			M.forceMove(loc)
	if(wreckage)
		if(prob(85))
			explosion(get_turf(src), 0, 1, 2, 3)
		var/obj/structure/mecha_wreckage/WR = new wreckage(loc, AI)
		for(var/obj/item/mecha_parts/mecha_equipment/E in equipment)
			if(E.salvageable && prob(30))
				WR.crowbar_salvage += E
				E.detach(WR) //detaches from src into WR
				E.equip_ready = 1
			else
				E.detach(loc)
				qdel(E)
		if(cell)
			WR.crowbar_salvage += cell
			cell.forceMove(WR)
			cell.charge = rand(0, cell.charge)
		if(internal_tank)
			WR.crowbar_salvage += internal_tank
			internal_tank.forceMove(WR)
	else
		for(var/obj/item/mecha_parts/mecha_equipment/E in equipment)
			E.detach(loc)
			qdel(E)
		if(cell)
			qdel(cell)
		if(internal_tank)
			qdel(internal_tank)
		if(AI)
			AI.gib() //No wreck, no AI to recover
	STOP_PROCESSING(SSobj, src)
	GLOB.poi_list.Remove(src)
	equipment.Cut()
	cell = null
	internal_tank = null
	assume_air(cabin_air)
	cabin_air = null
	qdel(spark_system)
	spark_system = null
	qdel(smoke_system)
	smoke_system = null

	GLOB.mechas_list -= src //global mech list
	return ..()

/obj/mecha/proc/restore_equipment()
	equipment_disabled = 0
	if(istype(src, /obj/mecha/combat))
		mouse_pointer = 'icons/mecha/mecha_mouse.dmi'
	if(occupant)
		SEND_SOUND(occupant, sound('sound/items/timer.ogg', volume=50))
		to_chat(occupant, "<span=notice>Equipment control unit has been rebooted successfuly.</span>")
		occupant.update_mouse_pointer()

/obj/mecha/CheckParts(list/parts_list)
	..()
	cell = locate(/obj/item/stock_parts/cell) in contents
	var/obj/item/stock_parts/scanning_module/SM = locate() in contents
	var/obj/item/stock_parts/capacitor/CP = locate() in contents
	if(SM)
		normal_step_energy_drain = 20 - (5 * SM.rating) //10 is normal, so on lowest part its worse, on second its ok and on higher its real good up to 0 on best
		step_energy_drain = normal_step_energy_drain
		qdel(SM)
	if(CP)
		armor = armor.modifyRating(energy = (CP.rating * 10)) //Each level of capacitor protects the mech against emp by 10%
		qdel(CP)

////////////////////////
////// Helpers /////////
////////////////////////

/obj/mecha/proc/add_airtank()
	internal_tank = new /obj/machinery/portable_atmospherics/canister/air(src)
	return internal_tank

/obj/mecha/proc/add_cell(obj/item/stock_parts/cell/C=null)
	if(C)
		C.forceMove(src)
		cell = C
		return
	cell = new /obj/item/stock_parts/cell/high/plus(src)

/obj/mecha/proc/add_cabin()
	cabin_air = new
	cabin_air.set_temperature(T20C)

	cabin_air.set_moles(GAS_O2,O2STANDARD*cabin_air.return_volume()/(R_IDEAL_GAS_EQUATION*cabin_air.return_temperature()))
	cabin_air.set_moles(GAS_N2,N2STANDARD*cabin_air.return_volume()/(R_IDEAL_GAS_EQUATION*cabin_air.return_temperature()))

	return cabin_air

/obj/mecha/proc/add_radio()
	radio = new(src)
	radio.name = "[src] radio"
	radio.icon = icon
	radio.icon_state = icon_state
	radio.subspace_transmission = TRUE

/obj/mecha/proc/can_use(mob/user)
	if(user != occupant)
		return 0
	if(user && ismob(user))
		if(!user.incapacitated())
			return 1
	return 0

////////////////////////////////////////////////////////////////////////////////

/obj/mecha/examine(mob/user)
	. = ..()
	var/integrity = obj_integrity*100/max_integrity
	switch(integrity)
		if(85 to 100)
			. += "It's fully intact."
		if(65 to 85)
			. += "It's slightly damaged."
		if(45 to 65)
			. += "It's badly damaged."
		if(25 to 45)
			. += "It's heavily damaged."
		else
			. += "It's falling apart."
	if(equipment && equipment.len)
		. += "It's equipped with:"
		for(var/obj/item/mecha_parts/mecha_equipment/ME in equipment)
			. += "[icon2html(ME, user)] \A [ME]."

//processing internal damage, temperature, air regulation, alert updates, lights power use.
/obj/mecha/process()
	var/internal_temp_regulation = 1

	if(internal_damage)
		if(internal_damage & MECHA_INT_FIRE)
			if(!(internal_damage & MECHA_INT_TEMP_CONTROL) && prob(5))
				clearInternalDamage(MECHA_INT_FIRE)
			if(internal_tank)
				var/datum/gas_mixture/int_tank_air = internal_tank.return_air()
				if(int_tank_air.return_pressure() > internal_tank.maximum_pressure && !(internal_damage & MECHA_INT_TANK_BREACH))
					setInternalDamage(MECHA_INT_TANK_BREACH)
				if(int_tank_air && int_tank_air.return_volume() > 0) //heat the air_contents
					int_tank_air.set_temperature(min(6000+T0C, int_tank_air.return_temperature()+rand(10,15)))
			if(cabin_air && cabin_air.return_volume()>0)
				cabin_air.set_temperature(min(6000+T0C, cabin_air.return_temperature()+rand(10,15)))
				if(cabin_air.return_temperature() > max_temperature/2)
					take_damage(4/round(max_temperature/cabin_air.return_temperature(),0.1), BURN, 0, 0)

		if(internal_damage & MECHA_INT_TEMP_CONTROL)
			internal_temp_regulation = 0

		if(internal_damage & MECHA_INT_TANK_BREACH) //remove some air from internal tank
			if(internal_tank)
				assume_air_ratio(internal_tank.return_air(), 0.1)

		if(internal_damage & MECHA_INT_SHORT_CIRCUIT)
			if(get_charge())
				spark_system.start()
				cell.charge -= min(20,cell.charge)
				cell.maxcharge -= min(20,cell.maxcharge)

	if(internal_temp_regulation)
		if(cabin_air && cabin_air.return_volume() > 0)
			var/delta = cabin_air.return_temperature() - T20C
			cabin_air.set_temperature(cabin_air.return_temperature() - max(-10, min(10, round(delta/4,0.1))))

	if(internal_tank)
		var/datum/gas_mixture/tank_air = internal_tank.return_air()

		var/release_pressure = internal_tank_valve
		var/cabin_pressure = cabin_air.return_pressure()
		var/pressure_delta = min(release_pressure - cabin_pressure, (tank_air.return_pressure() - cabin_pressure)/2)
		var/transfer_moles = 0
		if(pressure_delta > 0) //cabin pressure lower than release pressure
			if(tank_air.return_temperature() > 0)
				transfer_moles = pressure_delta*cabin_air.return_volume()/(cabin_air.return_temperature() * R_IDEAL_GAS_EQUATION)
				tank_air.transfer_to(cabin_air,transfer_moles)
		else if(pressure_delta < 0) //cabin pressure higher than release pressure
			var/datum/gas_mixture/t_air = return_air()
			pressure_delta = cabin_pressure - release_pressure
			if(t_air)
				pressure_delta = min(cabin_pressure - t_air.return_pressure(), pressure_delta)
			if(pressure_delta > 0) //if location pressure is lower than cabin pressure
				transfer_moles = pressure_delta*cabin_air.return_volume()/(cabin_air.return_temperature() * R_IDEAL_GAS_EQUATION)
				cabin_air.transfer_to(t_air, transfer_moles)

	if(occupant)
		if(cell)
			var/cellcharge = cell.charge/cell.maxcharge
			switch(cellcharge)
				if(0.75 to INFINITY)
					occupant.clear_alert("charge")
				if(0.5 to 0.75)
					occupant.throw_alert("charge", /obj/screen/alert/lowcell, 1)
				if(0.25 to 0.5)
					occupant.throw_alert("charge", /obj/screen/alert/lowcell, 2)
				if(0.01 to 0.25)
					occupant.throw_alert("charge", /obj/screen/alert/lowcell, 3)
				else
					occupant.throw_alert("charge", /obj/screen/alert/emptycell)

		var/integrity = obj_integrity/max_integrity*100
		switch(integrity)
			if(30 to 45)
				occupant.throw_alert("mech damage", /obj/screen/alert/low_mech_integrity, 1)
			if(15 to 35)
				occupant.throw_alert("mech damage", /obj/screen/alert/low_mech_integrity, 2)
			if(-INFINITY to 15)
				occupant.throw_alert("mech damage", /obj/screen/alert/low_mech_integrity, 3)
			else
				occupant.clear_alert("mech damage")
		var/atom/checking = occupant.loc
		// recursive check to handle all cases regarding very nested occupants,
		// such as brainmob inside brainitem inside MMI inside mecha
		while (!isnull(checking))
			if (isturf(checking))
				// hit a turf before hitting the mecha, seems like they have
				// been moved out
				occupant.clear_alert("charge")
				occupant.clear_alert("mech damage")
				RemoveActions(occupant, human_occupant=1)
				occupant = null
				break
			else if (checking == src)
				break  // all good
			checking = checking.loc

	if(lights)
		var/lights_energy_drain = 2
		use_power(lights_energy_drain)

//Diagnostic HUD updates
	diag_hud_set_mechhealth()
	diag_hud_set_mechcell()
	diag_hud_set_mechstat()

/obj/mecha/proc/drop_item()//Derpfix, but may be useful in future for engineering exosuits.
	return

/obj/mecha/Hear(message, atom/movable/speaker, message_language, raw_message, radio_freq, list/spans, message_mode, atom/movable/source)
	. = ..()
	if(speaker == occupant)
		if(radio.broadcasting)
			radio.talk_into(speaker, text, , spans, message_language)
		//flick speech bubble
		var/list/speech_bubble_recipients = list()
		for(var/mob/M in get_hearers_in_view(7,src))
			if(M.client)
				speech_bubble_recipients.Add(M.client)
		INVOKE_ASYNC(GLOBAL_PROC, GLOBAL_PROC_REF(flick_overlay), image('icons/mob/talk.dmi', src, "machine[say_test(raw_message)]",MOB_LAYER+1), speech_bubble_recipients, 30)

////////////////////////////
///// Action processing ////
////////////////////////////


/obj/mecha/proc/click_action(atom/target,mob/user,params)
	if(!occupant || occupant != user )
		return
	if(!locate(/turf) in list(target,target.loc)) // Prevents inventory from being drilled
		return
	if(completely_disabled)
		return
	if(is_currently_ejecting)
		return
	if(phasing)
		occupant_message("Unable to interact with objects while phasing")
		return
	if(user.incapacitated())
		return
	if(state)
		occupant_message(span_warning("Maintenance protocols in effect."))
		return
	if(!get_charge())
		return
	if(src == target)
		return
	var/dir_to_target = get_dir(src,target)
	if(dir_to_target && !(dir_to_target & dir))//wrong direction
		return
	if(internal_damage & MECHA_INT_CONTROL_LOST)
		target = safepick(view(3,target))
		if(!target)
			return

	var/mob/living/L = user
	if(!Adjacent(target))
		if(selected && selected.is_ranged())
			if(HAS_TRAIT(L, TRAIT_PACIFISM) && selected.harmful)
				to_chat(user, span_warning("You don't want to harm other living beings!"))
				return
			if(selected.action(target,params))
				selected.start_cooldown()
	else if(selected && selected.is_melee())
		if(isliving(target) && selected.harmful && HAS_TRAIT(L, TRAIT_PACIFISM))
			to_chat(user, span_warning("You don't want to harm other living beings!"))
			return
		if(selected.action(target,params))
			selected.start_cooldown()
	else
		if(internal_damage & MECHA_INT_CONTROL_LOST)
			target = safepick(oview(1,src))
		if(!melee_can_hit || !istype(target, /atom))
			return
		target.mech_melee_attack(src)
		melee_can_hit = 0
		spawn(melee_cooldown)
			melee_can_hit = 1


/obj/mecha/proc/range_action(atom/target)
	return


//////////////////////////////////
////////  Movement procs  ////////
//////////////////////////////////

/obj/mecha/Move(atom/newloc, direct)
	. = ..()
	if(.)
		events.fireEvent("onMove",get_turf(src))
	if (internal_tank.disconnect()) // Something moved us and broke connection
		occupant_message(span_warning("Air port connection teared off!"))
		mecha_log_message("Lost connection to gas port.")

/obj/mecha/setDir(newdir)
	. = ..()
	occupant?.setDir(newdir)

/obj/mecha/Process_Spacemove(movement_dir = 0, continuous_move)
	. = ..()
	if(.)
		return 1
	if(thrusters_active && movement_dir && use_power(step_energy_drain))
		return 1

	var/atom/movable/backup = get_spacemove_backup()
	if(backup)
		if(istype(backup) && movement_dir && !backup.anchored)
			if(backup.newtonian_move(turn(movement_dir, 180)))
				if(occupant)
					to_chat(occupant, span_info("You push off of [backup] to propel yourself."))
		return 1

/obj/mecha/relaymove(mob/user,direction)
	if(completely_disabled)
		return
	if(!direction)
		return
	if(user != occupant) //While not "realistic", this piece is player friendly.
		user.forceMove(get_turf(src))
		to_chat(user, span_notice("You climb out from [src]."))
		return 0
	if(internal_tank.connected_port)
		if(world.time - last_message > 20)
			occupant_message(span_warning("Unable to move while connected to the air system port!"))
			last_message = world.time
		return 0
	if(state)
		occupant_message(span_danger("Maintenance protocols in effect."))
		return
	return domove(direction)

/obj/mecha/proc/domove(direction)
	if(can_move >= world.time)
		return 0
	if(!Process_Spacemove(direction))
		return 0
	if(!has_charge(step_energy_drain))
		return 0
	if(zoom_mode)
		if(world.time - last_message > 20)
			occupant_message("Unable to move while in zoom mode.")
			last_message = world.time
		return 0

	var/move_result = 0
	var/oldloc = loc
	if(internal_damage & MECHA_INT_CONTROL_LOST)
		set_glide_size(DELAY_TO_GLIDE_SIZE(step_in))
		move_result = mechsteprand()
	else if(dir != direction && (!strafe || occupant.client.keys_held["Alt"]))
		move_result = mechturn(direction)
	else
		set_glide_size(DELAY_TO_GLIDE_SIZE(step_in))
		move_result = mechstep(direction)
	if(move_result || loc != oldloc)// halfway done diagonal move still returns false
		use_power(step_energy_drain)
		can_move = world.time + step_in
		return 1
	return 0

/obj/mecha/proc/mechturn(direction)
	setDir(direction)
	if(turnsound)
		playsound(src,turnsound,40,1)
	return 1

/obj/mecha/proc/mechstep(direction)
	var/current_dir = dir
	var/result = step(src,direction)
	if(strafe)
		setDir(current_dir)
	if(result && stepsound)
		playsound(src,stepsound,40,1)
	return result

/obj/mecha/proc/mechsteprand()
	var/result = step_rand(src)
	if(result && stepsound)
		playsound(src,stepsound,40,1)
	return result

/obj/mecha/Bump(atom/obstacle)
	if(phasing && get_charge() >= phasing_energy_drain && !throwing)
		spawn()
			if(can_move)
				can_move = 0
				if(phase_state)
					flick(phase_state, src)
				forceMove(get_step(src,dir))
				use_power(phasing_energy_drain)
				sleep(step_in*3)
				can_move = 1
	else
		if(..()) //mech was thrown
			return
		if(bumpsmash && occupant) //Need a pilot to push the PUNCH button.
			if(nextsmash < world.time)
				obstacle.mech_melee_attack(src)
				nextsmash = world.time + smashcooldown
				if(!obstacle || obstacle.CanPass(src, dir))
					step(src,dir)
		if(isobj(obstacle))
			var/obj/O = obstacle
			if(!O.anchored)
				step(obstacle, dir)
		else if(ismob(obstacle))
			var/mob/M = obstacle
			if(!M.anchored)
				step(obstacle, dir)





///////////////////////////////////
////////  Internal damage  ////////
///////////////////////////////////

/obj/mecha/proc/check_for_internal_damage(list/possible_int_damage,ignore_threshold=null)
	if(!islist(possible_int_damage) || isemptylist(possible_int_damage))
		return
	if(prob(20))
		if(ignore_threshold || obj_integrity*100/max_integrity < internal_damage_threshold)
			for(var/T in possible_int_damage)
				if(internal_damage & T)
					possible_int_damage -= T
			var/int_dam_flag = safepick(possible_int_damage)
			if(int_dam_flag)
				setInternalDamage(int_dam_flag)
	if(prob(5))
		if(ignore_threshold || obj_integrity*100/max_integrity < internal_damage_threshold)
			var/obj/item/mecha_parts/mecha_equipment/ME = safepick(equipment)
			if(ME)
				qdel(ME)
	return

/obj/mecha/proc/setInternalDamage(int_dam_flag)
	internal_damage |= int_dam_flag
	log_append_to_last("Internal damage of type [int_dam_flag].",1)
	SEND_SOUND(occupant, sound('sound/machines/warning-buzzer.ogg',wait=0))
	diag_hud_set_mechstat()
	return

/obj/mecha/proc/clearInternalDamage(int_dam_flag)
	if(internal_damage & int_dam_flag)
		switch(int_dam_flag)
			if(MECHA_INT_TEMP_CONTROL)
				occupant_message(span_boldnotice("Life support system reactivated."))
			if(MECHA_INT_FIRE)
				occupant_message(span_boldnotice("Internal fire extinquished."))
			if(MECHA_INT_TANK_BREACH)
				occupant_message(span_boldnotice("Damaged internal tank has been sealed."))
	internal_damage &= ~int_dam_flag
	diag_hud_set_mechstat()

/////////////////////////////////////
//////////// AI piloting ////////////
/////////////////////////////////////

/obj/mecha/attack_ai(mob/living/silicon/ai/user)
	if(!isAI(user))
		return
	//Allows the Malf to scan a mech's status and loadout, helping it to decide if it is a worthy chariot.
	if(user.can_dominate_mechs)
		examine(user) //Get diagnostic information!
		for(var/obj/item/mecha_parts/mecha_tracking/B in trackers)
			to_chat(user, span_danger("Warning: Tracking Beacon detected. Enter at your own risk. Beacon Data:"))
			to_chat(user, "[B.get_mecha_info()]")
			break
		//Nothing like a big, red link to make the player feel powerful!
		to_chat(user, "<a href='byond://?src=[REF(user)];ai_take_control=[REF(src)]'><span class='userdanger'>ASSUME DIRECT CONTROL?</span></a><br>")
	else
		examine(user)
		if(occupant)
			to_chat(user, span_warning("This exosuit has a pilot and cannot be controlled."))
			return
		var/can_control_mech = 0
		for(var/obj/item/mecha_parts/mecha_tracking/ai_control/A in trackers)
			can_control_mech = 1
			to_chat(user, "<span class='notice'>[icon2html(src, user)] Status of [name]:</span>\n[A.get_mecha_info()]")
			break
		if(!can_control_mech)
			to_chat(user, span_warning("You cannot control exosuits without AI control beacons installed."))
			return
		to_chat(user, "<a href='byond://?src=[REF(user)];ai_take_control=[REF(src)]'><span class='boldnotice'>Take control of exosuit?</span></a><br>")

/obj/mecha/transfer_ai(interaction, mob/user, mob/living/silicon/ai/AI, obj/item/aicard/card)
	if(!..())
		return

//Transfer from core or card to mech. Proc is called by mech.
	switch(interaction)
		if(AI_TRANS_TO_CARD) //Upload AI from mech to AI card.
			if(!state) //Mech must be in maint mode to allow carding.
				to_chat(user, span_warning("[name] must have maintenance protocols active in order to allow a transfer."))
				return
			AI = occupant
			if(!AI || !isAI(occupant)) //Mech does not have an AI for a pilot
				to_chat(user, span_warning("No AI detected in the [name] onboard computer."))
				return
			AI.ai_restore_power()//So the AI initially has power.
			AI.control_disabled = 1
			AI.radio_enabled = 0
			AI.disconnect_shell()
			RemoveActions(AI, TRUE)
			occupant = null
			AI.forceMove(card)
			card.AI = AI
			AI.controlled_mech = null
			AI.remote_control = null
			icon_state = initial(icon_state)+"-open"
			to_chat(AI, "You have been downloaded to a mobile storage device. Wireless connection offline.")
			to_chat(user, "<span class='boldnotice'>Transfer successful</span>: [AI.name] ([rand(1000,9999)].exe) removed from [name] and stored within local memory.")

		if(AI_MECH_HACK) //Called by AIs on the mech
			AI.linked_core = new /obj/structure/AIcore/deactivated(AI.loc)
			if(AI.can_dominate_mechs)
				if(occupant) //Oh, I am sorry, were you using that?
					to_chat(AI, span_warning("Pilot detected! Forced ejection initiated!"))
					to_chat(occupant, span_danger("You have been forcibly ejected!"))
					go_out(1) //IT IS MINE, NOW. SUCK IT, RD!
			ai_enter_mech(AI, interaction)

		if(AI_TRANS_FROM_CARD) //Using an AI card to upload to a mech.
			AI = card.AI
			if(!AI)
				to_chat(user, span_warning("There is no AI currently installed on this device."))
				return
			if(AI.deployed_shell) //Recall AI if shelled so it can be checked for a client
				AI.disconnect_shell()
			if(AI.stat || !AI.client)
				to_chat(user, span_warning("[AI.name] is currently unresponsive, and cannot be uploaded."))
				return
			if(occupant || dna_lock) //Normal AIs cannot steal mechs!
				to_chat(user, span_warning("Access denied. [name] is [occupant ? "currently occupied" : "secured with a DNA lock"]."))
				return
			AI.control_disabled = 0
			AI.radio_enabled = 1
			to_chat(user, "<span class='boldnotice'>Transfer successful</span>: [AI.name] ([rand(1000,9999)].exe) installed and executed successfully. Local copy has been removed.")
			card.AI = null
			ai_enter_mech(AI, interaction)

//Hack and From Card interactions share some code, so leave that here for both to use.
/obj/mecha/proc/ai_enter_mech(mob/living/silicon/ai/AI, interaction)
	AI.ai_restore_power()
	AI.forceMove(src)
	occupant = AI
	icon_state = initial(icon_state)
	playsound(src, 'sound/machines/windowdoor.ogg', 50, 1)
	if(!internal_damage)
		SEND_SOUND(occupant, sound('sound/mecha/nominal.ogg',volume=50))
	AI.cancel_camera()
	AI.controlled_mech = src
	AI.remote_control = src
	AI.mobility_flags = MOBILITY_FLAGS_DEFAULT //Much easier than adding AI checks! Be sure to set this back to 0 if you decide to allow an AI to leave a mech somehow.
	AI.can_shunt = 0 //ONE AI ENTERS. NO AI LEAVES.
	to_chat(AI, AI.can_dominate_mechs ? span_announce("Takeover of [name] complete! You are now loaded onto the onboard computer. Do not attempt to leave the station sector!") :\
		span_notice("You have been uploaded to a mech's onboard computer."))
	to_chat(AI, "<span class='reallybig boldnotice'>Use Middle-Mouse to activate mech functions and equipment. Click normally for AI interactions.</span>")
	if(interaction == AI_TRANS_FROM_CARD)
		GrantActions(AI, FALSE) //No eject/return to core action for AI uploaded by card
	else
		GrantActions(AI, !AI.can_dominate_mechs)


//An actual AI (simple_animal mecha pilot) entering the mech
/obj/mecha/proc/aimob_enter_mech(mob/living/simple_animal/hostile/syndicate/mecha_pilot/pilot_mob)
	if(pilot_mob && pilot_mob.Adjacent(src))
		if(occupant)
			return
		icon_state = initial(icon_state)
		occupant = pilot_mob
		pilot_mob.mecha = src
		pilot_mob.forceMove(src)
		GrantActions(pilot_mob)//needed for checks, and incase a badmin puts somebody in the mob

/obj/mecha/proc/aimob_exit_mech(mob/living/simple_animal/hostile/syndicate/mecha_pilot/pilot_mob)
	if(occupant == pilot_mob)
		occupant = null
	if(pilot_mob.mecha == src)
		pilot_mob.mecha = null
	icon_state = "[initial(icon_state)]-open"
	pilot_mob.forceMove(get_turf(src))
	RemoveActions(pilot_mob)


/////////////////////////////////////
////////  Atmospheric stuff  ////////
/////////////////////////////////////

/obj/mecha/remove_air(amount)
	if(use_internal_tank)
		return cabin_air.remove(amount)
	return ..()

/obj/mecha/remove_air_ratio(ratio)
	if(use_internal_tank)
		return cabin_air.remove_ratio(ratio)
	return ..()

/obj/mecha/return_air()
	if(use_internal_tank)
		return cabin_air
	return ..()

/obj/mecha/proc/return_pressure()
	var/datum/gas_mixture/t_air = return_air()
	if(t_air)
		. = t_air.return_pressure()
	return

/obj/mecha/return_temperature()
	var/datum/gas_mixture/t_air = return_air()
	if(t_air)
		. = t_air.return_temperature()
	return

/obj/mecha/portableConnectorReturnAir()
	return internal_tank.return_air()


/obj/mecha/MouseDrop_T(mob/M, mob/user)
	if (!user.canUseTopic(src) || (user != M))
		return
	if(!ishuman(user)) // no silicons or drones in mechas.
		return
	mecha_log_message("[user] tries to move in.")
	if (occupant)
		to_chat(usr, span_warning("The [name] is already occupied!"))
		log_append_to_last("Permission denied.")
		return
	if(dna_lock)
		var/passed = FALSE
		if(user.has_dna())
			var/mob/living/carbon/C = user
			if(C.dna.unique_enzymes==dna_lock)
				passed = TRUE
		if (!passed)
			to_chat(user, span_warning("Access denied. [name] is secured with a DNA lock."))
			log_append_to_last("Permission denied.")
			return
	if(!operation_allowed(user))
		to_chat(user, span_warning("Access denied. Insufficient operation keycodes."))
		log_append_to_last("Permission denied.")
		return
	if(user.buckled)
		to_chat(user, span_warning("You are currently buckled and cannot move."))
		log_append_to_last("Permission denied.")
		return
	if(user.has_buckled_mobs()) //mob attached to us
		to_chat(user, span_warning("You can't enter the exosuit with other creatures attached to you!"))
		return

	visible_message("[user] starts to climb into [name].")

	if(do_after(user, enter_delay, target = src))
		if(obj_integrity <= 0)
			to_chat(user, span_warning("You cannot get in the [name], it has been destroyed!"))
		else if(occupant)
			to_chat(user, span_danger("[occupant] was faster! Try better next time, loser."))
		else if(user.buckled)
			to_chat(user, span_warning("You can't enter the exosuit while buckled."))
		else if(user.has_buckled_mobs())
			to_chat(user, span_warning("You can't enter the exosuit with other creatures attached to you!"))
		else
			moved_inside(user)
	else
		to_chat(user, span_warning("You stop entering the exosuit!"))
	return

/obj/mecha/proc/moved_inside(mob/living/carbon/human/H)
	if(H?.client && (H in range(1)))
		occupant = H
		H.forceMove(src)
		H.update_mouse_pointer()
		add_fingerprint(H)
		GrantActions(H, human_occupant=1)
		forceMove(loc)
		log_append_to_last("[H] moved in as pilot.")
		icon_state = initial(icon_state)
		setDir(dir_in)
		playsound(src, 'sound/machines/windowdoor.ogg', 50, 1)
		if(!internal_damage)
			SEND_SOUND(occupant, sound('sound/mecha/nominal.ogg',volume=50))
		return 1
	else
		return 0

/obj/mecha/proc/mmi_move_inside(obj/item/mmi/mmi_as_oc, mob/user)
	if(!mmi_as_oc.brainmob || !mmi_as_oc.brainmob.client)
		to_chat(user, span_warning("Consciousness matrix not detected!"))
		return FALSE
	else if(mmi_as_oc.brainmob.stat)
		to_chat(user, span_warning("Beta-rhythm below acceptable level!"))
		return FALSE
	else if(occupant)
		to_chat(user, span_warning("Occupant detected!"))
		return FALSE
	else if(dna_lock && (!mmi_as_oc.brainmob.stored_dna || (dna_lock != mmi_as_oc.brainmob.stored_dna.unique_enzymes)))
		to_chat(user, span_warning("Access denied. [name] is secured with a DNA lock."))
		return FALSE

	visible_message(span_notice("[user] starts to insert an MMI into [name]."))

	if(do_after(user, exit_delay, target = src))
		if(!occupant)
			return mmi_moved_inside(mmi_as_oc, user)
		else
			to_chat(user, span_warning("Occupant detected!"))
	else
		to_chat(user, span_notice("You stop inserting the MMI."))
	return FALSE

/obj/mecha/proc/mmi_moved_inside(obj/item/mmi/mmi_as_oc, mob/user)
	if(!(Adjacent(mmi_as_oc) && Adjacent(user)))
		return FALSE
	if(!mmi_as_oc.brainmob || !mmi_as_oc.brainmob.client)
		to_chat(user, span_notice("Consciousness matrix not detected!"))
		return FALSE
	else if(mmi_as_oc.brainmob.stat)
		to_chat(user, span_warning("Beta-rhythm below acceptable level!"))
		return FALSE
	if(!user.transferItemToLoc(mmi_as_oc, src))
		to_chat(user, span_warning("\the [mmi_as_oc] is stuck to your hand, you cannot put it in \the [src]!"))
		return FALSE
	var/mob/living/brainmob = mmi_as_oc.brainmob
	mmi_as_oc.mecha = src
	occupant = brainmob
	brainmob.forceMove(src) //should allow relaymove
	brainmob.reset_perspective(src)
	brainmob.remote_control = src
	brainmob.update_mobility()
	brainmob.update_mouse_pointer()
	icon_state = initial(icon_state)
	update_icon()
	setDir(dir_in)
	mecha_log_message("[mmi_as_oc] moved in as pilot.")
	if(!internal_damage)
		SEND_SOUND(occupant, sound('sound/mecha/nominal.ogg',volume=50))
	GrantActions(brainmob)
	return TRUE

/obj/mecha/container_resist(mob/living/user)
	if(occupant)
		occupant.SetSleeping(destruction_sleep_duration*2)
	go_out()

/obj/mecha/Exited(atom/movable/M, atom/newloc)
	if(occupant && occupant == M) // The occupant exited the mech without calling go_out()
		go_out(TRUE, newloc)

/obj/mecha/proc/go_out(forced, atom/newloc = loc)
	if(!occupant)
		return
	var/atom/movable/mob_container
	occupant.clear_alert("charge")
	occupant.clear_alert("mech damage")
	if(ishuman(occupant))
		mob_container = occupant
		RemoveActions(occupant, human_occupant=1)
	else if(isbrain(occupant))
		var/mob/living/brain/brain = occupant
		RemoveActions(brain)
		mob_container = brain.container
	else if(isAI(occupant))
		var/mob/living/silicon/ai/AI = occupant
		if(forced)//This should only happen if there are multiple AIs in a round, and at least one is Malf.
			RemoveActions(occupant)
			occupant.gib()  //If one Malf decides to steal a mech from another AI (even other Malfs!), they are destroyed, as they have nowhere to go when replaced.
			occupant = null
			return
		else
			if(!AI.linked_core)
				to_chat(AI, span_userdanger("Inactive core destroyed. Unable to return."))
				AI.linked_core = null
				return
			to_chat(AI, span_notice("Returning to core..."))
			AI.controlled_mech = null
			AI.remote_control = null
			RemoveActions(occupant, 1)
			mob_container = AI
			newloc = get_turf(AI.linked_core)
			qdel(AI.linked_core)
	else
		return
	var/mob/living/L = occupant
	occupant = null //we need it null when forceMove calls Exited().
	if(mob_container.forceMove(newloc))//ejecting mob container
		mecha_log_message("[mob_container] moved out.")
		L << browse(null, "window=exosuit")

		if(istype(mob_container, /obj/item/mmi))
			var/obj/item/mmi/mmi = mob_container
			if(mmi.brainmob)
				L.forceMove(mmi)
				L.reset_perspective()
			mmi.mecha = null
			mmi.update_icon()
			L.mobility_flags = NONE
		icon_state = initial(icon_state)+"-open"
		setDir(dir_in)

	if(L && L.client)
		L.update_mouse_pointer()
		L.client.change_view(CONFIG_GET(string/default_view))
		zoom_mode = 0

/////////////////////////
////// Access stuff /////
/////////////////////////

/obj/mecha/proc/operation_allowed(mob/M)
	req_access = operation_req_access
	req_one_access = list()
	return allowed(M)

/obj/mecha/proc/internals_access_allowed(mob/M)
	req_one_access = internals_req_access
	req_access = list()
	return allowed(M)



////////////////////////////////
/////// Messages and Log ///////
////////////////////////////////

/obj/mecha/proc/occupant_message(message as text)
	if(message)
		if(occupant && occupant.client)
			to_chat(occupant, "[icon2html(src, occupant)] [message]")
	return

/obj/mecha/proc/mecha_log_message(message, color)
	log.len++
	log[log.len] = list("time"="[STATION_TIME_TIMESTAMP("hh:mm:ss", world.time)]","date","year"="[GLOB.year_integer]","message"="[color?"<font color='[color]'>":null][message][color?"</font>":null]")
	log_message(message, LOG_GAME, color)			//also do the normal admin logs I guess.
	return log.len

/obj/mecha/proc/log_append_to_last(message as text,red=null)
	var/list/last_entry = log[log.len]
	last_entry["message"] += "<br>[red?"<font color='red'>":null][message][red?"</font>":null]"
	return

///////////////////////
///// Power stuff /////
///////////////////////

/obj/mecha/proc/has_charge(amount)
	return (get_charge()>=amount)

/obj/mecha/proc/get_charge()
	for(var/obj/item/mecha_parts/mecha_equipment/tesla_energy_relay/R in equipment)
		var/relay_charge = R.get_charge()
		if(relay_charge)
			return relay_charge
	if(cell)
		return max(0, cell.charge)

/obj/mecha/proc/use_power(amount)
	if(get_charge() && cell.use(amount))
		return 1
	return 0

/obj/mecha/proc/give_power(amount)
	if(!isnull(get_charge()))
		cell.give(amount)
		return 1
	return 0

/obj/mecha/update_remote_sight(mob/living/user)
	if(occupant_sight_flags)
		if(user == occupant)
			user.sight |= occupant_sight_flags

///////////////////////
////// Ammo stuff /////
///////////////////////

/obj/mecha/proc/ammo_resupply(obj/item/mecha_ammo/A, mob/user,fail_chat_override = FALSE)
	if(!A.rounds)
		if(!fail_chat_override)
			to_chat(user, span_warning("This box of ammo is empty!"))
		return FALSE
	var/ammo_needed
	var/found_gun
	for(var/obj/item/mecha_parts/mecha_equipment/weapon/ballistic/gun in equipment)
		ammo_needed = 0

		if(istype(gun, /obj/item/mecha_parts/mecha_equipment/weapon/ballistic) && gun.ammo_type == A.ammo_type)
			found_gun = TRUE
			if(A.direct_load)
				ammo_needed = initial(gun.projectiles) - gun.projectiles
			else
				ammo_needed = gun.projectiles_cache_max - gun.projectiles_cache

			if(ammo_needed)
				if(ammo_needed < A.rounds)
					if(A.direct_load)
						gun.projectiles = gun.projectiles + ammo_needed
					else
						gun.projectiles_cache = gun.projectiles_cache + ammo_needed
					playsound(get_turf(user),A.load_audio,50,1)
					to_chat(user, span_notice("You add [ammo_needed] [A.round_term][ammo_needed > 1?"s":""] to the [gun.name]"))
					A.rounds = A.rounds - ammo_needed
					A.update_name()
					return TRUE

				else
					if(A.direct_load)
						gun.projectiles = gun.projectiles + A.rounds
					else
						gun.projectiles_cache = gun.projectiles_cache + A.rounds
					playsound(get_turf(user),A.load_audio,50,1)
					to_chat(user, span_notice("You add [A.rounds] [A.round_term][A.rounds > 1?"s":""] to the [gun.name]"))
					A.rounds = 0
					A.update_name()
					return TRUE
	if(!fail_chat_override)
		if(found_gun)
			to_chat(user, span_notice("You can't fit any more ammo of this type!"))
		else
			to_chat(user, span_notice("None of the equipment on this exosuit can use this ammo!"))
	return FALSE
