/obj/machinery/computer/shuttle/bos
	name = "Brotherhood Base Lockdown override."
	desc = "Can be used to disable the lockdown on the Brotherhood of Steel base."
	req_access = null //because of how this works only bos should be able to get to it.
	shuttleId = "Brotherhood_of_Steel"
	circuit = /obj/item/circuitboard/computer/bos
	possible_destinations = "Brotherhood_Home;Bos1;Bos2;Bos3;Bos4;Bos5;Bos6;Bos7;Bos8;Bos9;Bos10;Bos11;Bos12;Bos home"
	flags_1 = NODECONSTRUCT_1
	var/has_moved = FALSE
	var/base_ladder_id = ""
	resistance_flags = INDESTRUCTIBLE | LAVA_PROOF | FIRE_PROOF | UNACIDABLE | ACID_PROOF

/obj/machinery/computer/shuttle/bos/ui_act(action, params)
	if(action == "move")
		if(!has_moved)
			var/list/options = params2list(possible_destinations)
			if(!(params["shuttle_id"] in options))
				var/attempted = params["shuttle_id"]
				var/sanitized = url_encode(attempted)
				log_admin("[usr] attempted to href dock exploit on [src] with target location \"[attempted]\"")
				message_admins("[usr] just attempted to href dock exploit on [src] with target location \"[sanitized]\"")
				return
			else
				activate_ladder(params["shuttle_id"], base_ladder_id)
				has_moved = TRUE
		else
			to_chat(usr, span_warning("The controls have malfunctioned, and you cannot seem to lock the base down!"))
			return 0
	. = ..()

proc/activate_ladder(activation_id, new_id)
	for(var/obj/structure/ladder/unbreakable/lad in GLOB.ladders)
		if (lad.id == activation_id)
			lad.id = new_id
			lad.LateInitialize()


/obj/docking_port/mobile/elevator/bos
	name = "Brotherhood of Steel Foyer"
	width = 6
	height = 9
	dwidth = 1
	dheight = 0
	dir = EAST
	id = "Brotherhood_of_Steel"
	preferred_direction = EAST

/obj/docking_port/stationary/bos/
	name = "Brotherhood_of_Steel"
	id = "Brotherhood_Home"
	dwidth = 1
	dheight = 0
	width = 6
	height = 9
	dir = EAST
	roundstart_template = /datum/map_template/shuttle/bosbase/base

/obj/docking_port/stationary/bosaway/
	name = "Bos Base 1"
	id = "Bos1"
	dwidth = 1
	dheight = 0
	width = 6
	height = 9
	dir = EAST

/obj/docking_port/stationary/bosaway/two
	name = "Bos Base 2"
	id = "Bos2"

/obj/docking_port/stationary/bosaway/three
	name = "Bos Base 3"
	id = "Bos3"

/obj/docking_port/stationary/bosaway/four
	name = "Bos Base 4"
	id = "Bos4"

/obj/docking_port/stationary/bosaway/five
	name = "Bos Base 5"
	id = "Bos5"

/obj/docking_port/stationary/bosaway/six
	name = "Bos Base 6"
	id = "Bos6"

/obj/docking_port/stationary/bosaway/seven
	name = "Bos Base 7"
	id = "Bos7"

/obj/docking_port/stationary/bosaway/eight
	name = "Bos Base 8"
	id = "Bos8"

/obj/docking_port/stationary/bosaway/nine
	name = "Bos Base 9"
	id = "Bos9"

/obj/docking_port/stationary/bosaway/ten
	name = "Bos Base 10"
	id = "Bos10"

/obj/docking_port/stationary/bosaway/eleven
	name = "Bos Base 11"
	id = "Bos11"

/obj/docking_port/stationary/bosaway/twelve
	name = "Bos Base 12"
	id = "Bos12"
