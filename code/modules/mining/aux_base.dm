///Mining Base////

#define ZONE_SET	0
#define BAD_ZLEVEL	1
#define BAD_AREA	2
#define BAD_COORDS	3
#define BAD_TURF	4

/area/shuttle/auxillary_base
	name = "Auxillary Base"
	luminosity = 0 //Lighting gets lost when it lands anyway


/obj/machinery/computer/auxillary_base
	name = "auxillary base management console"
	icon = 'icons/obj/terminals.dmi'
	icon_state = "dorm_available"
	var/shuttleId = "colony_drop"
	desc = "Allows a deployable expedition base to be dropped from the station to a designated mining location. It can also \
interface with the mining shuttle at the landing site if a mobile beacon is also deployed."
	var/launch_warning = TRUE
	var/list/turrets = list() //List of connected turrets

	req_one_access = list(ACCESS_CARGO, ACCESS_CONSTRUCTION, ACCESS_HEADS, ACCESS_RESEARCH)
	var/possible_destinations
	clockwork = TRUE
	var/obj/item/gps/internal/base/locator
	circuit = /obj/item/circuitboard/computer/auxillary_base
	connectable = FALSE

/obj/machinery/computer/auxillary_base/Initialize()
	. = ..()
	locator = new(src)

/obj/machinery/computer/auxillary_base/ui_interact(mob/user)
	. = ..()
	var/list/options = params2list(possible_destinations)
	var/obj/docking_port/mobile/M = SSshuttle.getShuttle(shuttleId)
	var/dat = "[is_station_level(z) ? "Docking clamps engaged. Standing by." : "Mining Shuttle Uplink: [M ? M.getStatusText() : "*OFFLINE*"]"]<br>"
	if(M)
		var/destination_found
		for(var/obj/docking_port/stationary/S in SSshuttle.stationary)
			if(!options.Find(S.id))
				continue
			if(!M.check_dock(S, silent=TRUE))
				continue
			destination_found = 1
			dat += "<A href='byond://?src=[REF(src)];move=[S.id]'>Send to [S.name]</A><br>"
		if(!destination_found && is_station_level(z)) //Only available if miners are lazy and did not set an LZ using the remote.
			dat += "<A href='byond://?src=[REF(src)];random=1'>Prepare for blind drop? (Dangerous)</A><br>"
	if(LAZYLEN(turrets))
		dat += "<br><b>Perimeter Defense System:</b> <A href='byond://?src=[REF(src)];turrets_power=on'>Enable All</A> / <A href='byond://?src=[REF(src)];turrets_power=off'>Disable All</A><br> \
		Units connected: [LAZYLEN(turrets)]<br>\
		Unit | Condition | Status | Direction | Distance<br>"
		for(var/PDT in turrets)
			var/obj/machinery/porta_turret/aux_base/T = PDT
			var/integrity = max((T.obj_integrity-T.integrity_failure * T.max_integrity)/(T.max_integrity-T.integrity_failure * max_integrity)*100, 0)
			var/status
			if(T.stat & BROKEN)
				status = span_bad("ERROR")
			else if(!T.on)
				status = "Disabled"
			else if(T.raised)
				status = "<span class='average'><b>Firing</b></span>"
			else
				status = span_good("All Clear")
			dat += "[T.name] | [integrity]% | [status] | [dir2text(get_dir(src, T))] | [get_dist(src, T)]m <A href='byond://?src=[REF(src)];single_turret_power=[REF(T)]'>Toggle Power</A><br>"


	dat += "<a href='byond://?src=[REF(user)];mach_close=computer'>Close</a>"

	var/datum/browser/popup = new(user, "computer", "base management", 550, 300) //width, height
	popup.set_content("<center>[dat]</center>")
	popup.open()


/obj/machinery/computer/auxillary_base/Topic(href, href_list)
	if(..())
		return
	usr.set_machine(src)
	add_fingerprint(usr)
	if(!allowed(usr))
		to_chat(usr, span_danger("Access denied."))
		return

	if(href_list["move"])
		if(!is_station_level(z) && shuttleId == "colony_drop")
			to_chat(usr, span_warning("You can't move the base again!"))
			return
		var/shuttle_error = SSshuttle.moveShuttle(shuttleId, href_list["move"], 1)
		if(launch_warning)
			say(span_danger("Launch sequence activated! Prepare for drop!!"))
			playsound(loc, 'sound/machines/warning-buzzer.ogg', 70, 0)
			launch_warning = FALSE
			log_shuttle("[key_name(usr)] has launched the auxillary base.")
		else if(!shuttle_error)
			say("Shuttle request uploaded. Please stand away from the doors.")
		else
			say("Shuttle interface failed.")

	if(href_list["random"] && !possible_destinations)
		var/list/all_mining_turfs = list()
		for (var/z_level in SSmapping.levels_by_trait(ZTRAIT_MINING))
			all_mining_turfs += Z_TURFS(z_level)
		var/turf/LZ = safepick(all_mining_turfs) //Pick a random mining Z-level turf
		if(!ismineralturf(LZ) && !istype(LZ, /turf/open/floor/plating/asteroid))
		//Find a suitable mining turf. Reduces chance of landing in a bad area
			to_chat(usr, span_warning("Landing zone scan failed. Please try again."))
			updateUsrDialog()
			return
		if(set_landing_zone(LZ, usr) != ZONE_SET)
			to_chat(usr, span_warning("Landing zone unsuitable. Please recalculate."))
			updateUsrDialog()
			return


	if(LAZYLEN(turrets))
		if(href_list["turrets_power"])
			for(var/obj/machinery/porta_turret/aux_base/T in turrets)
				if(href_list["turrets_power"] == "on")
					T.on = TRUE
				else
					T.on = FALSE
		if(href_list["single_turret_power"])
			var/obj/machinery/porta_turret/aux_base/T = locate(href_list["single_turret_power"]) in turrets
			if(istype(T))
				T.on = !T.on

	updateUsrDialog()

/obj/machinery/computer/auxillary_base/proc/set_mining_mode()
	if(is_mining_level(z)) //The console switches to controlling the mining shuttle once landed.
		req_one_access = list()
		shuttleId = "mining" //The base can only be dropped once, so this gives the console a new purpose.
		possible_destinations = "mining_home;mining_away;landing_zone_dock;mining_public"

/obj/machinery/computer/auxillary_base/proc/set_landing_zone(turf/T, mob/user, no_restrictions)
	var/obj/docking_port/mobile/auxillary_base/base_dock = locate(/obj/docking_port/mobile/auxillary_base) in SSshuttle.mobile
	if(!base_dock) //Not all maps have an Aux base. This object is useless in that case.
		to_chat(user, span_warning("This station is not equipped with an auxillary base. Please contact your Nanotrasen contractor."))
		return
	if(!no_restrictions)
		var/static/list/disallowed_turf_types = typecacheof(list(
			/turf/closed,
			/turf/open/lava,
			/turf/open/indestructible,
			)) - typecacheof(list(
			/turf/closed/mineral,
			))

		if(!is_mining_level(T.z))
			return BAD_ZLEVEL


		var/list/colony_turfs = base_dock.return_ordered_turfs(T.x,T.y,T.z,base_dock.dir)
		for(var/i in 1 to colony_turfs.len)
			CHECK_TICK
			var/turf/place = colony_turfs[i]
			if(!place)
				return BAD_COORDS
			if(!istype(place.loc, /area/lavaland/surface))
				return BAD_AREA
			if(disallowed_turf_types[place.type])
				return BAD_TURF


	var/area/A = get_area(T)

	var/obj/docking_port/stationary/landing_zone = new /obj/docking_port/stationary(T)
	landing_zone.id = "colony_drop([REF(src)])"
	landing_zone.name = "Landing Zone ([T.x], [T.y])"
	landing_zone.dwidth = base_dock.dwidth
	landing_zone.dheight = base_dock.dheight
	landing_zone.width = base_dock.width
	landing_zone.height = base_dock.height
	landing_zone.setDir(base_dock.dir)
	landing_zone.area_type = A.type

	possible_destinations += "[landing_zone.id];"

//Serves as a nice mechanic to people get ready for the launch.
	minor_announce("Auxiliary base landing zone coordinates locked in for [A]. Launch command now available!")
	to_chat(user, span_notice("Landing zone set."))
	return ZONE_SET


/obj/item/assault_pod/mining
	name = "Landing Field Designator"
	icon_state = "gangtool-purple"
	item_state = "electronic"
	lefthand_file = 'icons/mob/inhands/misc/devices_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/misc/devices_righthand.dmi'
	desc = "Deploy to designate the landing zone of the auxillary base."
	w_class = WEIGHT_CLASS_SMALL
	shuttle_id = "colony_drop"
	var/setting = FALSE
	var/no_restrictions = FALSE //Badmin variable to let you drop the colony ANYWHERE.

/obj/item/assault_pod/mining/attack_self(mob/living/user)
	if(setting)
		return

	to_chat(user, span_notice("You begin setting the landing zone parameters..."))
	setting = TRUE
	if(!do_after(user, 50, target = user)) //You get a few seconds to cancel if you do not want to drop there.
		setting = FALSE
		return
	setting = FALSE

	var/turf/T = get_turf(user)
	var/obj/machinery/computer/auxillary_base/AB

	for (var/obj/machinery/computer/auxillary_base/A in GLOB.machines)
		if(is_station_level(A.z))
			AB = A
			break
	if(!AB)
		to_chat(user, span_warning("No auxillary base console detected."))
		return

	switch(AB.set_landing_zone(T, user, no_restrictions))
		if(ZONE_SET)
			qdel(src)
		if(BAD_ZLEVEL)
			to_chat(user, span_warning("This uplink can only be used in a designed mining zone."))
		if(BAD_AREA)
			to_chat(user, span_warning("Unable to acquire a targeting lock. Find an area clear of structures or entirely within one."))
		if(BAD_COORDS)
			to_chat(user, span_warning("Location is too close to the edge of the station's scanning range. Move several paces away and try again."))
		if(BAD_TURF)
			to_chat(user, span_warning("The landing zone contains turfs unsuitable for a base. Make sure you've removed all walls and dangerous terrain from the landing zone."))

/obj/item/assault_pod/mining/unrestricted
	name = "omni-locational landing field designator"
	desc = "Allows the deployment of the mining base ANYWHERE. Use with caution."
	no_restrictions = TRUE


/obj/docking_port/mobile/auxillary_base
	name = "auxillary base"
	id = "colony_drop"
	//Reminder to map-makers to set these values equal to the size of your base.
	dheight = 4
	dwidth = 4
	width = 9
	height = 9

/obj/docking_port/mobile/auxillary_base/takeoff(list/old_turfs, list/new_turfs, list/moved_atoms, rotation, movement_direction, old_dock, area/underlying_old_area)
	for(var/i in new_turfs)
		var/turf/place = i
		if(istype(place, /turf/closed/mineral))
			place.ScrapeAway()
	return ..()

/obj/docking_port/stationary/public_mining_dock
	name = "public mining base dock"
	id = "disabled" //The Aux Base has to leave before this can be used as a dock.
	//Should be checked on the map to ensure it matchs the mining shuttle dimensions.
	dwidth = 3
	width = 7
	height = 5
	area_type = /area/construction/mining/aux_base

/obj/structure/mining_shuttle_beacon
	name = "mining shuttle beacon"
	desc = "A bluespace beacon calibrated to mark a landing spot for the mining shuttle when deployed near the auxillary mining base."
	anchored = FALSE
	density = FALSE
	var/shuttle_ID = "landing_zone_dock"
	icon = 'icons/obj/objects.dmi'
	icon_state = "miningbeacon"
	var/obj/docking_port/stationary/Mport //Linked docking port for the mining shuttle
	pressure_resistance = 200 //So it does not get blown into lava.
	var/anti_spam_cd = 0 //The linking process might be a bit intensive, so this here to prevent over use.
	var/console_range = 15 //Wifi range of the beacon to find the aux base console

/obj/structure/mining_shuttle_beacon/on_attack_hand(mob/user, act_intent = user.a_intent, unarmed_attack_flags)
	if(anchored)
		to_chat(user, span_warning("Landing zone already set."))
		return

	if(anti_spam_cd)
		to_chat(user, span_warning("[src] is currently recalibrating. Please wait."))
		return

	anti_spam_cd = 1
	addtimer(CALLBACK(src, PROC_REF(clear_cooldown)), 50)

	var/turf/landing_spot = get_turf(src)

	if(!is_mining_level(landing_spot.z))
		to_chat(user, span_warning("This device is only to be used in a mining zone."))
		return
	var/obj/machinery/computer/auxillary_base/aux_base_console
	for(var/obj/machinery/computer/auxillary_base/ABC in GLOB.machines)
		if(get_dist(landing_spot, ABC) <= console_range)
			aux_base_console = ABC
			break
	if(!aux_base_console) //Needs to be near the base to serve as its dock and configure it to control the mining shuttle.
		to_chat(user, span_warning("The auxillary base's console must be within [console_range] meters in order to interface."))
		return

//Mining shuttles may not be created equal, so we find the map's shuttle dock and size accordingly.
	for(var/S in SSshuttle.stationary)
		var/obj/docking_port/stationary/SM = S //SM is declared outside so it can be checked for null
		if(SM.id == "mining_home" || SM.id == "mining_away")

			var/area/A = get_area(landing_spot)

			Mport = new(landing_spot)
			Mport.id = "landing_zone_dock"
			Mport.name = "auxillary base landing site"
			Mport.dwidth = SM.dwidth
			Mport.dheight = SM.dheight
			Mport.width = SM.width
			Mport.height = SM.height
			Mport.setDir(dir)
			Mport.area_type = A.type

			break
	if(!Mport)
		to_chat(user, span_warning("This station is not equipped with an appropriate mining shuttle. Please contact Nanotrasen Support."))
		return

	var/obj/docking_port/mobile/mining_shuttle
	var/list/landing_turfs = list() //List of turfs where the mining shuttle may land.
	for(var/S in SSshuttle.mobile)
		var/obj/docking_port/mobile/MS = S
		if(MS.id != "mining")
			continue
		mining_shuttle = MS
		landing_turfs = mining_shuttle.return_ordered_turfs(x,y,z,dir)
		break

	if(!mining_shuttle) //Not having a mining shuttle is a map issue
		to_chat(user, span_warning("No mining shuttle signal detected. Please contact Nanotrasen Support."))
		SSshuttle.stationary.Remove(Mport)
		qdel(Mport)
		return

	for(var/i in 1 to landing_turfs.len) //You land NEAR the base, not IN it.
		var/turf/L = landing_turfs[i]
		if(!L) //This happens at map edges
			to_chat(user, span_warning("Unable to secure a valid docking zone. Please try again in an open area near, but not within the aux. mining base."))
			SSshuttle.stationary.Remove(Mport)
			qdel(Mport)
			return
		if(istype(get_area(L), /area/shuttle/auxillary_base))
			to_chat(user, span_warning("The mining shuttle must not land within the mining base itself."))
			SSshuttle.stationary.Remove(Mport)
			qdel(Mport)
			return

	if(mining_shuttle.canDock(Mport) != SHUTTLE_CAN_DOCK)
		to_chat(user, span_warning("Unable to secure a valid docking zone. Please try again in an open area near, but not within the aux. mining base."))
		SSshuttle.stationary.Remove(Mport)
		qdel(Mport)
		return

	aux_base_console.set_mining_mode() //Lets the colony park the shuttle there, now that it has a dock.
	to_chat(user, span_notice("Mining shuttle calibration successful! Shuttle interface available at base console."))
	anchored = TRUE //Locks in place to mark the landing zone.
	playsound(loc, 'sound/machines/ping.ogg', 50, 0)

/obj/structure/mining_shuttle_beacon/proc/clear_cooldown()
	anti_spam_cd = 0

/obj/structure/mining_shuttle_beacon/attack_robot(mob/user)
	return attack_hand(user) //So borgies can help

#undef ZONE_SET
#undef BAD_ZLEVEL
#undef BAD_AREA
#undef BAD_COORDS
#undef BAD_TURF
