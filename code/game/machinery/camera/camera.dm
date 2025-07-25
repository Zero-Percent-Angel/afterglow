#define CAMERA_UPGRADE_XRAY 1
#define CAMERA_UPGRADE_EMP_PROOF 2
#define CAMERA_UPGRADE_MOTION 4

/obj/machinery/camera
	name = "security camera"
	desc = "It's used to monitor rooms."
	icon = 'icons/obj/machines/camera.dmi'
	icon_state = "camera"
	light_color = "#CDDDFF"
	use_power = ACTIVE_POWER_USE
	idle_power_usage = 15
	active_power_usage = 30
	layer = WALL_OBJ_LAYER

	resistance_flags = FIRE_PROOF

	armor = ARMOR_VALUE_MEDIUM
	max_integrity = 100
	integrity_failure = 0.5
	var/list/network = list("ss13")
	var/c_tag = null
	var/status = TRUE
	var/start_active = FALSE //If it ignores the random chance to start broken on round start
	var/invuln = null
	var/obj/item/camera_bug/bug = null
	var/obj/structure/camera_assembly/assembly = null
	var/area/myarea = null

	//OTHER

	var/view_range = 7
	var/short_range = 2

	var/alarm_on = FALSE
	var/busy = FALSE
	var/emped = FALSE  //Number of consecutive EMP's on this camera
	var/in_use_lights = 0

	// Upgrades bitflag
	var/upgrades = 0

	var/internal_light = TRUE //Whether it can light up when an AI views it

/obj/machinery/camera/preset/toxins //Bomb test site in space
	name = "Hardened Bomb-Test Camera"
	desc = "A specially-reinforced camera with a long lasting battery, used to monitor the bomb testing site. An external light is attached to the top."
	c_tag = "Bomb Testing Site"
	network = list("rd","toxins")
	use_power = NO_POWER_USE //Test site is an unpowered area
	invuln = TRUE
	light_range = 10
	start_active = TRUE

/obj/machinery/camera/Initialize(mapload, obj/structure/camera_assembly/CA)
	. = ..()
	for(var/i in network)
		network -= i
		network += lowertext(i)
	if(CA)
		assembly = CA
	else
		assembly = new(src)
		assembly.state = 4
	GLOB.cameranet.cameras += src
	GLOB.cameranet.addCamera(src)
	if (isturf(loc))
		myarea = get_area(src)
		LAZYADD(myarea.cameras, src)
	proximity_monitor = new(src, 1)

	if(mapload && is_station_level(z) && prob(3) && !start_active)
		toggle_cam()

/obj/machinery/camera/connect_to_shuttle(obj/docking_port/mobile/port, obj/docking_port/stationary/dock, idnum, override=FALSE)
	for(var/i in network)
		network -= i
		network += "[idnum][i]"

/obj/machinery/camera/Destroy()
	if(can_use())
		toggle_cam(null, 0) //kick anyone viewing out and remove from the camera chunks
	GLOB.cameranet.cameras -= src
	if(isarea(myarea))
		LAZYREMOVE(myarea.cameras, src)
	QDEL_NULL(assembly)
	if(bug)
		bug.bugged_cameras -= src.c_tag
		if(bug.current == src)
			bug.current = null
		bug = null
	cancelCameraAlarm()
	return ..()

/obj/machinery/camera/emp_act(severity)
	. = ..()
	if(!status)
		return
	if(!(. & EMP_PROTECT_SELF))
		if(prob(severity/0.7))
			update_icon()
			var/list/previous_network = network
			network = list()
			GLOB.cameranet.removeCamera(src)
			stat |= EMPED
			set_light(0)
			emped = emped+1  //Increase the number of consecutive EMP's
			update_icon()
			var/thisemp = emped //Take note of which EMP this proc is for
			spawn(900)
				if(loc) //qdel limbo
					triggerCameraAlarm() //camera alarm triggers even if multiple EMPs are in effect.
					if(emped == thisemp) //Only fix it if the camera hasn't been EMP'd again
						network = previous_network
						stat &= ~EMPED
						update_icon()
						if(can_use())
							GLOB.cameranet.addCamera(src)
						emped = 0 //Resets the consecutive EMP count
						addtimer(CALLBACK(src, PROC_REF(cancelCameraAlarm)), 100)
			for(var/i in GLOB.player_list)
				var/mob/M = i
				if (M.client.eye == src)
					M.unset_machine()
					M.reset_perspective(null)
					to_chat(M, "The screen bursts into static.")

/obj/machinery/camera/ex_act(severity, target)
	if(invuln)
		return
	..()

/obj/machinery/camera/proc/setViewRange(num = 7)
	src.view_range = num
	GLOB.cameranet.updateVisibility(src, 0)

/obj/machinery/camera/proc/shock(mob/living/user)
	if(!istype(user))
		return
	user.electrocute_act(10, src)

/obj/machinery/camera/singularity_pull(S, current_size)
	if (status && current_size >= STAGE_FIVE) // If the singulo is strong enough to pull anchored objects and the camera is still active, turn off the camera as it gets ripped off the wall.
		toggle_cam(null, 0)
	..()

// Construction/Deconstruction
/obj/machinery/camera/screwdriver_act(mob/living/user, obj/item/I)
	if(..())
		return TRUE
	panel_open = !panel_open
	to_chat(user, span_notice("You screw the camera's panel [panel_open ? "open" : "closed"]."))
	I.play_tool_sound(src)
	return TRUE

/obj/machinery/camera/wirecutter_act(mob/living/user, obj/item/I)
	if(!panel_open)
		return FALSE
	toggle_cam(user, 1)
	obj_integrity = max_integrity //this is a pretty simplistic way to heal the camera, but there's no reason for this to be complex.
	I.play_tool_sound(src)
	return TRUE

/obj/machinery/camera/multitool_act(mob/living/user, obj/item/I)
	if(!panel_open)
		return FALSE

	setViewRange((view_range == initial(view_range)) ? short_range : initial(view_range))
	to_chat(user, span_notice("You [(view_range == initial(view_range)) ? "restore" : "mess up"] the camera's focus."))
	return

/obj/machinery/camera/welder_act(mob/living/user, obj/item/I)
	if(!panel_open)
		return FALSE

	if(!I.tool_start_check(user, amount=0))
		return TRUE

	to_chat(user, span_notice("You start to weld [src]..."))
	if(I.use_tool(src, user, 100, volume=50))
		user.visible_message(span_warning("[user] unwelds [src], leaving it as just a frame bolted to the wall."),
			span_warning("You unweld [src], leaving it as just a frame bolted to the wall"))
		deconstruct(TRUE)

	return TRUE

/obj/machinery/camera/attackby(obj/item/I, mob/living/user, params)
	// UPGRADES
	if(panel_open)
		if(istype(I, /obj/item/analyzer))
			if(!isXRay())
				if(!user.temporarilyRemoveItemFromInventory(I))
					return
				qdel(I)
				upgradeXRay()
				to_chat(user, span_notice("You attach [I] into the assembly's inner circuits."))
			else
				to_chat(user, span_notice("[src] already has that upgrade!"))
			return

		else if(istype(I, /obj/item/stack/sheet/mineral/plasma))
			if(!isEmpProof())
				if(I.use_tool(src, user, 0, amount=1))
					upgradeEmpProof()
					to_chat(user, span_notice("You attach [I] into the assembly's inner circuits."))
			else
				to_chat(user, span_notice("[src] already has that upgrade!"))
			return

		else if(istype(I, /obj/item/assembly/prox_sensor))
			if(!isMotion())
				if(!user.temporarilyRemoveItemFromInventory(I))
					return
				upgradeMotion()
				to_chat(user, span_notice("You attach [I] into the assembly's inner circuits."))
				qdel(I)
			else
				to_chat(user, span_notice("[src] already has that upgrade!"))
			return

	// OTHER
	if((istype(I, /obj/item/paper) || istype(I, /obj/item/pda)) && isliving(user))
		var/mob/living/U = user
		var/obj/item/paper/X = null
		var/obj/item/pda/P = null

		var/itemname = ""
		var/info = ""
		if(istype(I, /obj/item/paper))
			X = I
			itemname = X.name
			info = X.info
		else
			P = I
			itemname = P.name
			info = P.notehtml
		to_chat(U, span_notice("You hold \the [itemname] up to the camera..."))
		U.DelayNextAction(CLICK_CD_MELEE)
		for(var/mob/O in GLOB.player_list)
			if(isAI(O))
				var/mob/living/silicon/ai/AI = O
				if(AI.control_disabled || (AI.stat == DEAD))
					return
				if(U.name == "Unknown")
					to_chat(AI, "<b>[U]</b> holds <a href='byond://?_src_=usr;show_paper=1;'>\a [itemname]</a> up to one of your cameras ...")
				else
					to_chat(AI, "<b><a href='byond://?src=[REF(AI)];track=[html_encode(U.name)]'>[U]</a></b> holds <a href='byond://?_src_=usr;show_paper=1;'>\a [itemname]</a> up to one of your cameras ...")
				AI.last_paper_seen = "<HTML><HEAD><meta http-equiv='Content-Type' content='text/html; charset=UTF-8'><TITLE>[itemname]</TITLE></HEAD><BODY><TT>[info]</TT></BODY></HTML>"
			else if (O.client && O.client.eye == src)
				to_chat(O, "[U] holds \a [itemname] up to one of the cameras ...")
				O << browse(text("<HTML><HEAD<meta http-equiv='Content-Type' content='text/html; charset=UTF-8'>><TITLE>[]</TITLE></HEAD><BODY><TT>[]</TT></BODY></HTML>", itemname, info), text("window=[]", itemname))
		return

	else if(istype(I, /obj/item/camera_bug))
		if(!can_use())
			to_chat(user, span_notice("Camera non-functional."))
			return
		if(bug)
			to_chat(user, span_notice("Camera bug removed."))
			bug.bugged_cameras -= src.c_tag
			bug = null
		else
			to_chat(user, span_notice("Camera bugged."))
			bug = I
			bug.bugged_cameras[src.c_tag] = src
		return

	else if(istype(I, /obj/item/pai_cable))
		var/obj/item/pai_cable/cable = I
		cable.plugin(src, user)
		return

	return ..()

/obj/machinery/camera/run_obj_armor(damage_amount, damage_type, damage_flag = 0, attack_dir)
	if(damage_flag == "melee" && damage_amount < 12 && !(stat & BROKEN))
		return 0
	. = ..()

/obj/machinery/camera/obj_break(damage_flag)
	if(status && !(flags_1 & NODECONSTRUCT_1))
		triggerCameraAlarm()
		toggle_cam(null, 0)

/obj/machinery/camera/deconstruct(disassembled = TRUE)
	if(!(flags_1 & NODECONSTRUCT_1))
		if(disassembled)
			if(!assembly)
				assembly = new()
			assembly.forceMove(drop_location())
			assembly.state = 1
			assembly.setDir(dir)
			assembly = null
		else
			var/obj/item/I = new /obj/item/wallframe/camera (loc)
			I.obj_integrity = I.max_integrity * 0.5
			new /obj/item/stack/cable_coil(loc, 2)
	qdel(src)

/obj/machinery/camera/update_icon_state()
	if(!status)
		icon_state = "[initial(icon_state)]1"
	else if (stat & EMPED)
		icon_state = "[initial(icon_state)]emp"
	else
		icon_state = "[initial(icon_state)][in_use_lights ? "_in_use" : ""]"

/obj/machinery/camera/proc/toggle_cam(mob/user, displaymessage = 1)
	status = !status
	if(can_use())
		GLOB.cameranet.addCamera(src)
		if (isturf(loc))
			myarea = get_area(src)
			LAZYADD(myarea.cameras, src)
		else
			myarea = null
	else
		set_light(0)
		GLOB.cameranet.removeCamera(src)
		if (isarea(myarea))
			LAZYREMOVE(myarea.cameras, src)
	GLOB.cameranet.updateChunk(x, y, z)
	var/change_msg = "deactivates"
	if(status)
		change_msg = "reactivates"
		triggerCameraAlarm()
		if(!QDELETED(src)) //We'll be doing it anyway in destroy
			addtimer(CALLBACK(src, PROC_REF(cancelCameraAlarm)), 100)
	if(displaymessage)
		if(user)
			visible_message(span_danger("[user] [change_msg] [src]!"))
			add_hiddenprint(user)
		else
			visible_message(span_danger("\The [src] [change_msg]!"))

		playsound(src.loc, 'sound/items/wirecutter.ogg', 100, 1)
	update_icon()

	// now disconnect anyone using the camera
	//Apparently, this will disconnect anyone even if the camera was re-activated.
	//I guess that doesn't matter since they can't use it anyway?
	for(var/mob/O in GLOB.player_list)
		if (O.client && O.client.eye == src)
			O.unset_machine()
			O.reset_perspective(null)
			to_chat(O, "The screen bursts into static.")

/obj/machinery/camera/proc/triggerCameraAlarm()
	alarm_on = TRUE
	for(var/mob/living/silicon/S in GLOB.silicon_mobs)
		S.triggerAlarm("Camera", get_area(src), list(src), src)

/obj/machinery/camera/proc/cancelCameraAlarm()
	alarm_on = FALSE
	for(var/mob/living/silicon/S in GLOB.silicon_mobs)
		S.cancelAlarm("Camera", get_area(src), src)

/obj/machinery/camera/proc/can_use()
	if(!status)
		return FALSE
	if(stat & EMPED)
		return FALSE
	return TRUE

/obj/machinery/camera/proc/can_see()
	var/list/see = null
	var/turf/pos = get_turf(src)
	if(isXRay())
		see = range(view_range, pos)
	else
		see = get_hear(view_range, pos)
	return see

/atom/proc/auto_turn()
	//Automatically turns based on nearby walls.
	var/turf/closed/wall/T = null
	for(var/i in GLOB.cardinals)
		T = get_ranged_target_turf(src, i, 1)
		if(istype(T))
			setDir(turn(i, 180))
			break

//Return a working camera that can see a given mob
//or null if none
/proc/seen_by_camera(mob/M)
	for(var/obj/machinery/camera/C in oview(4, M))
		if(C.can_use())	// check if camera disabled
			return C
	return null

/proc/near_range_camera(mob/M)
	for(var/obj/machinery/camera/C in range(4, M))
		if(C.can_use())	// check if camera disabled
			return C

	return null

/obj/machinery/camera/proc/Togglelight(on=0)
	for(var/mob/living/silicon/ai/A in GLOB.ai_list)
		for(var/obj/machinery/camera/cam in A.lit_cameras)
			if(cam == src)
				return
	if(on)
		set_light(AI_CAMERA_LUMINOSITY, 0.8)
	else
		set_light(0)

/obj/machinery/camera/get_remote_view_fullscreens(mob/user)
	if(view_range == short_range) //unfocused
		user.overlay_fullscreen("remote_view", /obj/screen/fullscreen/impaired, 2)

/obj/machinery/camera/update_remote_sight(mob/living/user)
	user.see_invisible = SEE_INVISIBLE_LIVING //can't see ghosts through cameras
	if(isXRay())
		user.sight |= (SEE_TURFS|SEE_MOBS|SEE_OBJS)
		user.see_in_dark = max(user.see_in_dark, 8)
	else
		user.sight = 0
		user.see_in_dark = 2
	return 1
