/datum/admins/proc/Secrets()
	if(!check_rights(0))
		return

	var/list/dat = list("<B>The first rule of adminbuse is: you don't talk about the adminbuse.</B><HR>")

	dat +={"
			<B>General Secrets</B><BR>
			<BR>
			<A href='byond://?src=[REF(src)];[HrefToken()];secrets=admin_log'>Admin Log</A><BR>
			<A href='byond://?src=[REF(src)];[HrefToken()];secrets=show_admins'>Show Admin List</A><BR>
			<A href='byond://?src=[REF(src)];[HrefToken()];secrets=mentor_log'>Mentor Log</A><BR>
			<BR>
			"}

	if(check_rights(R_ADMIN,0))
		dat += {"
			<B>Admin Secrets</B><BR>
			<BR>
			<A href='byond://?src=[REF(src)];[HrefToken()];secrets=clear_virus'>Cure all diseases currently in existence</A><BR>
			<A href='byond://?src=[REF(src)];[HrefToken()];secrets=list_bombers'>Bombing List</A><BR>
			<A href='byond://?src=[REF(src)];[HrefToken()];secrets=check_antagonist'>Show current traitors and objectives</A><BR>
			<A href='byond://?src=[REF(src)];[HrefToken()];secrets=list_signalers'>Show last [length(GLOB.lastsignalers)] signalers</A><BR>
			<A href='byond://?src=[REF(src)];[HrefToken()];secrets=list_lawchanges'>Show last [length(GLOB.lawchanges)] law changes</A><BR>
			<A href='byond://?src=[REF(src)];[HrefToken()];secrets=showailaws'>Show AI Laws</A><BR>
			<A href='byond://?src=[REF(src)];[HrefToken()];secrets=showgm'>Show Game Mode</A><BR>
			<A href='byond://?src=[REF(src)];[HrefToken()];secrets=manifest'>Show Crew Manifest</A><BR>
			<A href='byond://?src=[REF(src)];[HrefToken()];secrets=DNA'>List DNA (Blood)</A><BR>
			<A href='byond://?src=[REF(src)];[HrefToken()];secrets=fingerprints'>List Fingerprints</A><BR>
			<A href='byond://?src=[REF(src)];[HrefToken()];secrets=ctfbutton'>Enable/Disable CTF</A><BR><BR>
			<A href='byond://?src=[REF(src)];[HrefToken()];secrets=tdomereset'>Reset Thunderdome to default state</A><BR>
			<A href='byond://?src=[REF(src)];[HrefToken()];secrets=set_name'>Rename Station Name</A><BR>
			<A href='byond://?src=[REF(src)];[HrefToken()];secrets=reset_name'>Reset Station Name</A><BR>
			<A href='byond://?src=[REF(src)];[HrefToken()];secrets=night_shift_set'>Set Night Shift Mode</A><BR>
			<BR>
			<B>Shuttles</B><BR>
			<BR>
			<A href='byond://?src=[REF(src)];[HrefToken()];secrets=moveferry'>Move Ferry</A><BR>
			<A href='byond://?src=[REF(src)];[HrefToken()];secrets=togglearrivals'>Toggle Arrivals Ferry</A><BR>
			<A href='byond://?src=[REF(src)];[HrefToken()];secrets=moveminingshuttle'>Move Mining Shuttle</A><BR>
			<A href='byond://?src=[REF(src)];[HrefToken()];secrets=movelaborshuttle'>Move Labor Shuttle</A><BR>
			<BR>
			"}

	if(check_rights(R_FUN,0))
		dat += {"
			<B>Fun Secrets</B><BR>
			<BR>
			<A href='byond://?src=[REF(src)];[HrefToken()];secrets=virus'>Trigger a Virus Outbreak</A><BR>
			<A href='byond://?src=[REF(src)];[HrefToken()];secrets=monkey'>Turn all humans into monkeys</A><BR>
			<A href='byond://?src=[REF(src)];[HrefToken()];secrets=anime'>Chinese Cartoons</A><BR>
			<A href='byond://?src=[REF(src)];[HrefToken()];secrets=allspecies'>Change the species of all humans</A><BR>
			<A href='byond://?src=[REF(src)];[HrefToken()];secrets=power'>Make all areas powered</A><BR>
			<A href='byond://?src=[REF(src)];[HrefToken()];secrets=unpower'>Make all areas unpowered</A><BR>
			<A href='byond://?src=[REF(src)];[HrefToken()];secrets=quickpower'>Power all SMES</A><BR>
			<A href='byond://?src=[REF(src)];[HrefToken()];secrets=tripleAI'>Triple AI mode (needs to be used in the lobby)</A><BR>
			<A href='byond://?src=[REF(src)];[HrefToken()];secrets=traitor_all'>Everyone is the traitor</A><BR>
			<A href='byond://?src=[REF(src)];[HrefToken()];secrets=ak47s'>AK-47s For Everyone!</A><BR>
			<A href='byond://?src=[REF(src)];[HrefToken()];secrets=guns'>Summon Guns</A><BR>
			<A href='byond://?src=[REF(src)];[HrefToken()];secrets=magic'>Summon Magic</A><BR>
			<A href='byond://?src=[REF(src)];[HrefToken()];secrets=events'>Summon Events (Toggle)</A><BR>
			<A href='byond://?src=[REF(src)];[HrefToken()];secrets=onlyone'>There can only be one!</A><BR>
			<A href='byond://?src=[REF(src)];[HrefToken()];secrets=delayed_onlyone'>There can only be one! (40-second delay)</A><BR>
			<A href='byond://?src=[REF(src)];[HrefToken()];secrets=stupify'>Make all players stupid</A><BR>
			<A href='byond://?src=[REF(src)];[HrefToken()];secrets=eagles'>Egalitarian Station Mode</A><BR>
			<A href='byond://?src=[REF(src)];[HrefToken()];secrets=ancap'>Anarcho-Capitalist Station Mode</A><BR>
			<A href='byond://?src=[REF(src)];[HrefToken()];secrets=blackout'>Break all lights</A><BR>
			<A href='byond://?src=[REF(src)];[HrefToken()];secrets=whiteout'>Fix all lights</A><BR>
			<A href='byond://?src=[REF(src)];[HrefToken()];secrets=floorlava'>The floor is lava! (DANGEROUS: extremely lame)</A><BR>
			<A href='byond://?src=[REF(src)];[HrefToken()];secrets=customportal'>Spawn a custom portal storm</A><BR>
			<BR>
			<A href='byond://?src=[REF(src)];[HrefToken()];secrets=changebombcap'>Change bomb cap</A><BR>
			<A href='byond://?src=[REF(src)];[HrefToken()];secrets=masspurrbation'>Mass Purrbation</A><BR>
			<A href='byond://?src=[REF(src)];[HrefToken()];secrets=massremovepurrbation'>Mass Remove Purrbation</A><BR>
			"}

	dat += "<BR>"

	if(check_rights(R_DEBUG,0))
		dat += {"
			<B>Security Level Elevated</B><BR>
			<BR>
			<A href='byond://?src=[REF(src)];[HrefToken()];secrets=maint_access_engiebrig'>Change all maintenance doors to engie/brig access only</A><BR>
			<A href='byond://?src=[REF(src)];[HrefToken()];secrets=maint_access_brig'>Change all maintenance doors to brig access only</A><BR>
			<A href='byond://?src=[REF(src)];[HrefToken()];secrets=infinite_sec'>Remove cap on security officers</A><BR>
			<BR>
			"}

	usr << browse(HTML_SKELETON(dat.Join()), "window=secrets")
	return





/datum/admins/proc/Secrets_topic(item,href_list)
	var/datum/round_event/E
	var/ok = 0
	switch(item)
		if("admin_log")
			var/dat = "<B>Admin Log<HR></B>"
			for(var/l in GLOB.admin_log)
				dat += "<li>[l]</li>"
			if(!GLOB.admin_log.len)
				dat += "No-one has done anything this round!"
			usr << browse(HTML_SKELETON(dat), "window=admin_log")

		if("mentor_log")
			CitadelMentorLogSecret()

		if("show_admins")
			var/dat = "<B>Current admins:</B><HR>"
			if(GLOB.admin_datums)
				for(var/ckey in GLOB.admin_datums)
					var/datum/admins/D = GLOB.admin_datums[ckey]
					dat += "[ckey] - [D.rank.name]<br>"
				usr << browse(HTML_SKELETON(dat), "window=showadmins;size=600x500")

		if("tdomereset")
			if(!check_rights(R_ADMIN))
				message_admins("[ADMIN_TPMONTY(usr)] tried to use Secrets_topic(), item: tdomereset, without admin perms.")
				log_admin("INVALID ADMIN PROC ACCESS: [key_name(usr)] tried to use Secrets_topic(), item: tdomereset, without admin perms.")
				return
			var/delete_mobs = alert("Clear all mobs?","Confirm","Yes","No","Cancel")
			if(delete_mobs == "Cancel")
				return

			log_admin("[key_name(usr)] reset the thunderdome to default with delete_mobs==[delete_mobs].", 1)
			message_admins(span_adminnotice("[key_name_admin(usr)] reset the thunderdome to default with delete_mobs==[delete_mobs]."))

			var/area/thunderdome = locate(/area/tdome/arena)
			if(delete_mobs == "Yes")
				for(var/mob/living/mob in thunderdome)
					qdel(mob) //Clear mobs
			for(var/obj/obj in thunderdome)
				if(!istype(obj, /obj/machinery/camera))
					qdel(obj) //Clear objects

			var/area/template = locate(/area/tdome/arena_source)
			template.copy_contents_to(thunderdome)

		if("clear_virus")

			var/choice = input("Are you sure you want to cure all disease?") in list("Yes", "Cancel")
			if(choice == "Yes")
				message_admins("[key_name_admin(usr)] has cured all diseases.")
				for(var/thing in SSdisease.active_diseases)
					var/datum/disease/D = thing
					D.cure(0)
		if("set_name")
			if(!check_rights(R_ADMIN))
				message_admins("[ADMIN_TPMONTY(usr)] tried to use Secrets_topic(), item: set_name, without admin perms.")
				log_admin("INVALID ADMIN PROC ACCESS: [key_name(usr)] tried to use Secrets_topic(), item: set_name, without admin perms.")
				return
			var/new_name = input(usr, "Please input a new name for the station.", "What?", "") as text|null
			if(!new_name)
				return
			set_station_name(new_name)
			log_admin("[key_name(usr)] renamed the station to \"[new_name]\".")
			message_admins(span_adminnotice("[key_name_admin(usr)] renamed the station to: [new_name]."))
			priority_announce("[command_name()] has renamed the station to \"[new_name]\".")
		if("night_shift_set")
			if(!check_rights(R_ADMIN))
				message_admins("[ADMIN_TPMONTY(usr)] tried to use Secrets_topic(), item: night_shift_set, without admin perms.")
				log_admin("INVALID ADMIN PROC ACCESS: [key_name(usr)] tried to use Secrets_topic(), item: night_shift_set, without admin perms.")
				return
			var/val = alert(usr, "What do you want to set night shift to? This will override the automatic system until set to automatic again.", "Night Shift", "On", "Off", "Automatic")
			switch(val)
				if("Automatic")
					if(CONFIG_GET(flag/enable_night_shifts))
						SSnightshift.can_fire = TRUE
						SSnightshift.fire()
					else
						SSnightshift.update_nightshift(FALSE, TRUE)
				if("On")
					SSnightshift.can_fire = FALSE
					SSnightshift.update_nightshift(TRUE, TRUE)
				if("Off")
					SSnightshift.can_fire = FALSE
					SSnightshift.update_nightshift(FALSE, TRUE)

		if("reset_name")
			if(!check_rights(R_ADMIN))
				message_admins("[ADMIN_TPMONTY(usr)] tried to use Secrets_topic(), item: reset_name, without admin perms.")
				log_admin("INVALID ADMIN PROC ACCESS: [key_name(usr)] tried to use Secrets_topic(), item: reset_name, without admin perms.")
				return
			var/new_name = new_station_name()
			set_station_name(new_name)
			log_admin("[key_name(usr)] reset the station name.")
			message_admins(span_adminnotice("[key_name_admin(usr)] reset the station name."))
			priority_announce("[command_name()] has renamed the station to \"[new_name]\".")

		if("list_bombers")
			if(!check_rights(R_ADMIN))
				message_admins("[ADMIN_TPMONTY(usr)] tried to use Secrets_topic(), item: list_bombers, without admin perms.")
				log_admin("INVALID ADMIN PROC ACCESS: [key_name(usr)] tried to use Secrets_topic(), item: list_bombers, without admin perms.")
				return
			var/dat = "<B>Bombing List</B><HR>"
			for(var/l in GLOB.bombers)
				dat += text("[l]<BR>")
			usr << browse(HTML_SKELETON(dat), "window=bombers")

		if("list_signalers")
			if(!check_rights(R_ADMIN))
				message_admins("[ADMIN_TPMONTY(usr)] tried to use Secrets_topic(), item: list_signalers, without admin perms.")
				log_admin("INVALID ADMIN PROC ACCESS: [key_name(usr)] tried to use Secrets_topic(), item: list_signalers, without admin perms.")
				return
			var/dat = "<B>Showing last [length(GLOB.lastsignalers)] signalers.</B><HR>"
			for(var/sig in GLOB.lastsignalers)
				dat += "[sig]<BR>"
			usr << browse(HTML_SKELETON(dat), "window=lastsignalers;size=800x500")

		if("list_lawchanges")
			if(!check_rights(R_ADMIN))
				message_admins("[ADMIN_TPMONTY(usr)] tried to use Secrets_topic(), item: list_lawchanges, without admin perms.")
				log_admin("INVALID ADMIN PROC ACCESS: [key_name(usr)] tried to use Secrets_topic(), item: list_lawchanges, without admin perms.")
				return
			var/dat = "<B>Showing last [length(GLOB.lawchanges)] law changes.</B><HR>"
			for(var/sig in GLOB.lawchanges)
				dat += "[sig]<BR>"
			usr << browse(HTML_SKELETON(dat), "window=lawchanges;size=800x500")

		if("moveminingshuttle")
			if(!check_rights(R_ADMIN))
				message_admins("[ADMIN_TPMONTY(usr)] tried to use Secrets_topic(), item: moveminingshuttle, without admin perms.")
				log_admin("INVALID ADMIN PROC ACCESS: [key_name(usr)] tried to use Secrets_topic(), item: moveminingshuttle, without admin perms.")
				return
			SSblackbox.record_feedback("nested tally", "admin_secrets_fun_used", 1, list("Send Mining Shuttle"))
			if(!SSshuttle.toggleShuttle("mining","mining_home","mining_away"))
				message_admins("[key_name_admin(usr)] moved mining shuttle")
				log_admin("[key_name(usr)] moved the mining shuttle")

		if("movelaborshuttle")
			if(!check_rights(R_ADMIN))
				message_admins("[ADMIN_TPMONTY(usr)] tried to use Secrets_topic(), item: movelaborshuttle, without admin perms.")
				log_admin("INVALID ADMIN PROC ACCESS: [key_name(usr)] tried to use Secrets_topic(), item: movelaborshuttle, without admin perms.")
				return
			SSblackbox.record_feedback("nested tally", "admin_secrets_fun_used", 1, list("Send Labor Shuttle"))
			if(!SSshuttle.toggleShuttle("laborcamp","laborcamp_home","laborcamp_away"))
				message_admins("[key_name_admin(usr)] moved labor shuttle")
				log_admin("[key_name(usr)] moved the labor shuttle")

		if("moveferry")
			if(!check_rights(R_ADMIN))
				message_admins("[ADMIN_TPMONTY(usr)] tried to use Secrets_topic(), item: moveferry, without admin perms.")
				log_admin("INVALID ADMIN PROC ACCESS: [key_name(usr)] tried to use Secrets_topic(), item: moveferry, without admin perms.")
				return
			SSblackbox.record_feedback("nested tally", "admin_secrets_fun_used", 1, list("Send CentCom Ferry"))
			if(!SSshuttle.toggleShuttle("ferry","ferry_home","ferry_away"))
				message_admins("[key_name_admin(usr)] moved the CentCom ferry")
				log_admin("[key_name(usr)] moved the CentCom ferry")

		if("togglearrivals")
			if(!check_rights(R_ADMIN))
				message_admins("[ADMIN_TPMONTY(usr)] tried to use Secrets_topic(), item: togglearrivals, without admin perms.")
				log_admin("INVALID ADMIN PROC ACCESS: [key_name(usr)] tried to use Secrets_topic(), item: togglearrivals, without admin perms.")
				return
			var/obj/docking_port/mobile/arrivals/A = SSshuttle.arrivals
			if(A)
				var/new_perma = !A.perma_docked
				A.perma_docked = new_perma
				SSblackbox.record_feedback("nested tally", "admin_toggle", 1, list("Permadock Arrivals Shuttle", "[new_perma ? "Enabled" : "Disabled"]"))
				message_admins("[key_name_admin(usr)] [new_perma ? "stopped" : "started"] the arrivals shuttle")
				log_admin("[key_name(usr)] [new_perma ? "stopped" : "started"] the arrivals shuttle")
			else
				to_chat(usr, span_admin("There is no arrivals shuttle"))
		if("showailaws")
			if(!check_rights(R_ADMIN))
				message_admins("[ADMIN_TPMONTY(usr)] tried to use Secrets_topic(), item: showailaws, without admin perms.")
				log_admin("INVALID ADMIN PROC ACCESS: [key_name(usr)] tried to use Secrets_topic(), item: showailaws, without admin perms.")
				return
			output_ai_laws()
		if("showgm")
			if(!check_rights(R_ADMIN))
				message_admins("[ADMIN_TPMONTY(usr)] tried to use Secrets_topic(), item: showgm, without admin perms.")
				log_admin("INVALID ADMIN PROC ACCESS: [key_name(usr)] tried to use Secrets_topic(), item: showgm, without admin perms.")
				return
			if(!SSticker.HasRoundStarted())
				alert("The game hasn't started yet!")
			else if (SSticker.mode)
				alert("The game mode is [SSticker.mode.name]")
			else alert("For some reason there's a SSticker, but not a game mode")
		if("manifest")
			if(!check_rights(R_ADMIN))
				message_admins("[ADMIN_TPMONTY(usr)] tried to use Secrets_topic(), item: manifest, without admin perms.")
				log_admin("INVALID ADMIN PROC ACCESS: [key_name(usr)] tried to use Secrets_topic(), item: manifest, without admin perms.")
				return
			var/dat = "<B>Showing Crew Manifest.</B><HR>"
			dat += "<table cellspacing=5><tr><th>Name</th><th>Position</th></tr>"
			for(var/datum/data/record/t in GLOB.data_core.general)
				dat += "<tr><td>[t.fields["name"]]</td><td>[t.fields["rank"]]</td></tr>"
			dat += "</table>"
			usr << browse(HTML_SKELETON(dat), "window=manifest;size=440x410")
		if("DNA")
			if(!check_rights(R_ADMIN))
				message_admins("[ADMIN_TPMONTY(usr)] tried to use Secrets_topic(), item: DNA, without admin perms.")
				log_admin("INVALID ADMIN PROC ACCESS: [key_name(usr)] tried to use Secrets_topic(), item: DNA, without admin perms.")
				return
			var/dat = "<B>Showing DNA from blood.</B><HR>"
			dat += "<table cellspacing=5><tr><th>Name</th><th>DNA</th><th>Blood Type</th></tr>"
			for(var/mob/living/carbon/human/H in GLOB.carbon_list)
				if(H.ckey)
					dat += "<tr><td>[H]</td><td>[H.dna.unique_enzymes]</td><td>[H.dna.blood_type]</td></tr>"
			dat += "</table>"
			usr << browse(HTML_SKELETON(dat), "window=DNA;size=440x410")
		if("fingerprints")
			if(!check_rights(R_ADMIN))
				message_admins("[ADMIN_TPMONTY(usr)] tried to use Secrets_topic(), item: fingerprints, without admin perms.")
				log_admin("INVALID ADMIN PROC ACCESS: [key_name(usr)] tried to use Secrets_topic(), item: fingerprints, without admin perms.")
				return
			var/dat = "<B>Showing Fingerprints.</B><HR>"
			dat += "<table cellspacing=5><tr><th>Name</th><th>Fingerprints</th></tr>"
			for(var/mob/living/carbon/human/H in GLOB.carbon_list)
				if(H.ckey)
					dat += "<tr><td>[H]</td><td>[md5(H.dna.uni_identity)]</td></tr>"
			dat += "</table>"
			usr << browse(HTML_SKELETON(dat), "window=fingerprints;size=440x410")

		if("monkey")
			if(!check_rights(R_FUN))
				return
			SSblackbox.record_feedback("nested tally", "admin_secrets_fun_used", 1, list("Monkeyize All Humans"))
			for(var/mob/living/carbon/human/H in GLOB.carbon_list)
				spawn(0)
					H.monkeyize()
			ok = 1

		if("allspecies")
			if(!check_rights(R_FUN))
				return
			var/result = input(usr, "Please choose a new species","Species") as null|anything in GLOB.species_list
			if(result)
				SSblackbox.record_feedback("nested tally", "admin_secrets_fun_used", 1, list("Mass Species Change", "[result]"))
				log_admin("[key_name(usr)] turned all humans into [result]", 1)
				message_admins(span_notice("[key_name_admin(usr)] turned all humans into [result]"))
				var/newtype = GLOB.species_list[result]
				for(var/mob/living/carbon/human/H in GLOB.carbon_list)
					H.set_species(newtype)

		if("tripleAI")
			if(!check_rights(R_FUN))
				return
			usr.client.triple_ai()
			SSblackbox.record_feedback("nested tally", "admin_secrets_fun_used", 1, list("Triple AI"))

		if("power")
			if(!check_rights(R_FUN))
				return
			SSblackbox.record_feedback("nested tally", "admin_secrets_fun_used", 1, list("Power All APCs"))
			log_admin("[key_name(usr)] made all areas powered", 1)
			message_admins(span_adminnotice("[key_name_admin(usr)] made all areas powered"))
			power_restore()

		if("unpower")
			if(!check_rights(R_FUN))
				return
			SSblackbox.record_feedback("nested tally", "admin_secrets_fun_used", 1, list("Depower All APCs"))
			log_admin("[key_name(usr)] made all areas unpowered", 1)
			message_admins(span_adminnotice("[key_name_admin(usr)] made all areas unpowered"))
			power_failure()

		if("quickpower")
			if(!check_rights(R_FUN))
				return
			SSblackbox.record_feedback("nested tally", "admin_secrets_fun_used", 1, list("Power All SMESs"))
			log_admin("[key_name(usr)] made all SMESs powered", 1)
			message_admins(span_adminnotice("[key_name_admin(usr)] made all SMESs powered"))
			power_restore_quick()

		if("traitor_all")
			if(!check_rights(R_FUN))
				return
			if(!SSticker.HasRoundStarted())
				alert("The game hasn't started yet!")
				return
			var/objective = stripped_input(usr, "Enter an objective")
			if(!objective)
				return
			SSblackbox.record_feedback("nested tally", "admin_secrets_fun_used", 1, list("Traitor All", "[objective]"))
			for(var/mob/living/H in GLOB.player_list)
				if(!(ishuman(H)||istype(H, /mob/living/silicon/)))
					continue
				if(H.stat == DEAD || !H.client || !H.mind || ispAI(H))
					continue
				if(is_special_character(H))
					continue
				var/datum/antagonist/traitor/T = new()
				T.give_objectives = FALSE
				var/datum/objective/new_objective = new
				new_objective.owner = H
				new_objective.explanation_text = objective
				T.add_objective(new_objective)
				H.mind.add_antag_datum(T)
			message_admins(span_adminnotice("[key_name_admin(usr)] used everyone is a traitor secret. Objective is [objective]"))
			log_admin("[key_name(usr)] used everyone is a traitor secret. Objective is [objective]")

		if("changebombcap")
			if(!check_rights(R_FUN))
				return
			SSblackbox.record_feedback("nested tally", "admin_secrets_fun_used", 1, list("Bomb Cap"))

			var/newBombCap = input(usr,"What would you like the new bomb cap to be. (entered as the light damage range (the 3rd number in common (1,2,3) notation)) Must be above 4)", "New Bomb Cap", GLOB.MAX_EX_LIGHT_RANGE) as num|null
			if (!CONFIG_SET(number/bombcap, newBombCap))
				return

			message_admins(span_boldannounce("[key_name_admin(usr)] changed the bomb cap to [GLOB.MAX_EX_DEVESTATION_RANGE], [GLOB.MAX_EX_HEAVY_RANGE], [GLOB.MAX_EX_LIGHT_RANGE]"))
			log_admin("[key_name(usr)] changed the bomb cap to [GLOB.MAX_EX_DEVESTATION_RANGE], [GLOB.MAX_EX_HEAVY_RANGE], [GLOB.MAX_EX_LIGHT_RANGE]")

		if("blackout")
			if(!check_rights(R_FUN))
				return
			SSblackbox.record_feedback("nested tally", "admin_secrets_fun_used", 1, list("Break All Lights"))
			message_admins("[key_name_admin(usr)] broke all lights")
			for(var/obj/machinery/light/L in GLOB.machines)
				L.break_light_tube()

		if("anime")
			if(!check_rights(R_FUN))
				return
			var/animetype = alert("Would you like to have the clothes be changed?",,"Yes","No","Cancel")

			var/droptype
			if(animetype =="Yes")
				droptype = alert("Make the uniforms Nodrop?",,"Yes","No","Cancel")

			if(animetype == "Cancel" || droptype == "Cancel")
				return
			SSblackbox.record_feedback("nested tally", "admin_secrets_fun_used", 1, list("Chinese Cartoons"))
			message_admins("[key_name_admin(usr)] made everything kawaii.")
			for(var/mob/living/carbon/human/H in GLOB.carbon_list)
				SEND_SOUND(H, sound(get_announcer_sound("animes")))

				if(H.dna.species.id == "human")
					if(H.dna.features["tail_human"] == "None" || H.dna.features["ears"] == "None")
						var/obj/item/organ/ears/cat/ears = new
						var/obj/item/organ/tail/cat/tail = new
						ears.Insert(H, drop_if_replaced=FALSE)
						tail.Insert(H, drop_if_replaced=FALSE)
					var/list/honorifics = list("[MALE]" = list("kun"), "[FEMALE]" = list("chan","tan"), "[NEUTER]" = list("san"), "[PLURAL]" = list("san")) //John Robust -> Robust-kun
					var/list/names = splittext(H.real_name," ")
					var/forename = names.len > 1 ? names[2] : names[1]
					var/newname = "[forename]-[pick(honorifics["[H.gender]"])]"
					H.fully_replace_character_name(H.real_name,newname)
					H.update_mutant_bodyparts()
					if(animetype == "Yes")
						var/seifuku = pick(typesof(/obj/item/clothing/under/costume/schoolgirl))
						var/obj/item/clothing/under/costume/schoolgirl/I = new seifuku
						var/olduniform = H.w_uniform
						H.temporarilyRemoveItemFromInventory(H.w_uniform, TRUE, FALSE)
						H.equip_to_slot_or_del(I, SLOT_W_UNIFORM)
						qdel(olduniform)
						if(droptype == "Yes")
							ADD_TRAIT(I, TRAIT_NODROP, ADMIN_TRAIT)
				else
					to_chat(H, "You're not kawaii enough for this.")

		if("whiteout")
			if(!check_rights(R_FUN))
				return
			SSblackbox.record_feedback("nested tally", "admin_secrets_fun_used", 1, list("Fix All Lights"))
			message_admins("[key_name_admin(usr)] fixed all lights")
			for(var/obj/machinery/light/L in GLOB.machines)
				L.fix()

		if("floorlava")
			SSweather.run_weather(/datum/weather/floor_is_lava)

		if("virus")
			if(!check_rights(R_FUN))
				return
			SSblackbox.record_feedback("nested tally", "admin_secrets_fun_used", 1, list("Virus Outbreak"))
			switch(alert("Do you want this to be a random disease or do you have something in mind?",,"Make Your Own","Random","Choose"))
				if("Make Your Own")
					AdminCreateVirus(usr.client)
				if("Random")
					E = new /datum/round_event/disease_outbreak()
				if("Choose")
					var/virus = input("Choose the virus to spread", "BIOHAZARD") as null|anything in typesof(/datum/disease)
					E = new /datum/round_event/disease_outbreak{}()
					var/datum/round_event/disease_outbreak/DO = E
					DO.virus_type = virus

		if("stupify")
			if(!check_rights(R_FUN))
				return
			SSblackbox.record_feedback("nested tally", "admin_secrets_fun_used", 1, list("Mass Braindamage"))
			for(var/mob/living/carbon/human/H in GLOB.player_list)
				to_chat(H, span_boldannounce("You suddenly feel stupid."))
				H.adjustOrganLoss(ORGAN_SLOT_BRAIN, 60, 80)
			message_admins("[key_name_admin(usr)] made everybody stupid")

		if("eagles")//SCRAW
			if(!check_rights(R_FUN))
				return
			SSblackbox.record_feedback("nested tally", "admin_secrets_fun_used", 1, list("Egalitarian Station"))
			for(var/obj/machinery/door/airlock/W in GLOB.machines)
				if(is_station_level(W.z) && !istype(get_area(W), /area/bridge) && !istype(get_area(W), /area/crew_quarters) && !istype(get_area(W), /area/security/prison))
					W.req_access = list()
			message_admins("[key_name_admin(usr)] activated Egalitarian Station mode")
			priority_announce("CentCom airlock control override activated. Please take this time to get acquainted with your coworkers.", null, "commandreport")

		if("ak47s")
			if(!check_rights(R_FUN))
				return
			message_admins("[key_name_admin(usr)] activated AK-47s for Everyone!")
			usr.client.ak47s()
			sound_to_playing_players('sound/misc/ak47s.ogg')

		if("ancap")
			if(!check_rights(R_FUN))
				return
			SSblackbox.record_feedback("nested tally", "admin_secrets_fun_used", 1, list("Anarcho-capitalist Station"))
			SSeconomy.full_ancap = !SSeconomy.full_ancap
			message_admins("[key_name_admin(usr)] toggled Anarcho-capitalist mode")
			if(SSeconomy.full_ancap)
				priority_announce("The NAP is now in full effect.", null, "commandreport")
			else
				priority_announce("The NAP has been revoked.", null, "commandreport")

		if("guns")
			if(!check_rights(R_FUN))
				return
			SSblackbox.record_feedback("nested tally", "admin_secrets_fun_used", 1, list("Summon Guns"))
			var/survivor_probability = 0
			switch(alert("Do you want this to create survivors antagonists?",,"No Antags","Some Antags","All Antags!"))
				if("Some Antags")
					survivor_probability = 25
				if("All Antags!")
					survivor_probability = 100

			rightandwrong(SUMMON_GUNS, usr, survivor_probability)

		if("magic")
			if(!check_rights(R_FUN))
				return
			SSblackbox.record_feedback("nested tally", "admin_secrets_fun_used", 1, list("Summon Magic"))
			var/survivor_probability = 0
			switch(alert("Do you want this to create survivors antagonists?",,"No Antags","Some Antags","All Antags!"))
				if("Some Antags")
					survivor_probability = 25
				if("All Antags!")
					survivor_probability = 100

			rightandwrong(SUMMON_MAGIC, usr, survivor_probability)

		if("events")
			if(!check_rights(R_FUN))
				return
			if(!SSevents.wizardmode)
				if(alert("Do you want to toggle summon events on?",,"Yes","No") == "Yes")
					summonevents()
					SSblackbox.record_feedback("nested tally", "admin_secrets_fun_used", 1, list("Summon Events", "Activate"))

			else
				switch(alert("What would you like to do?",,"Intensify Summon Events","Turn Off Summon Events","Nothing"))
					if("Intensify Summon Events")
						summonevents()
						SSblackbox.record_feedback("nested tally", "admin_secrets_fun_used", 1, list("Summon Events", "Intensify"))
					if("Turn Off Summon Events")
						SSevents.toggleWizardmode()
						SSevents.resetFrequency()
						SSblackbox.record_feedback("nested tally", "admin_secrets_fun_used", 1, list("Summon Events", "Disable"))

		if("dorf")
			if(!check_rights(R_FUN))
				return
			SSblackbox.record_feedback("nested tally", "admin_secrets_fun_used", 1, list("Dwarf Beards"))
			for(var/mob/living/carbon/human/B in GLOB.carbon_list)
				B.facial_hair_style = "Dward Beard"
				B.update_hair()
			message_admins("[key_name_admin(usr)] activated dorf mode")

		if("onlyone")
			if(!check_rights(R_FUN))
				return
			SSblackbox.record_feedback("nested tally", "admin_secrets_fun_used", 1, list("There Can Be Only One"))
			usr.client.only_one()
			sound_to_playing_players('sound/misc/highlander.ogg')

		if("delayed_onlyone")
			if(!check_rights(R_FUN))
				return
			SSblackbox.record_feedback("nested tally", "admin_secrets_fun_used", 1, list("There Can Be Only One"))
			usr.client.only_one_delayed()
			sound_to_playing_players('sound/misc/highlander_delayed.ogg')

		if("maint_access_brig")
			if(!check_rights(R_DEBUG))
				return
			for(var/obj/machinery/door/airlock/maintenance/M in GLOB.machines)
				M.check_access()
				if (ACCESS_MAINT_TUNNELS in M.req_access)
					M.req_access = list(ACCESS_BRIG)
			message_admins("[key_name_admin(usr)] made all maint doors brig access-only.")
		if("maint_access_engiebrig")
			if(!check_rights(R_DEBUG))
				return
			for(var/obj/machinery/door/airlock/maintenance/M in GLOB.machines)
				M.check_access()
				if (ACCESS_MAINT_TUNNELS in M.req_access)
					M.req_access = list()
					M.req_one_access = list(ACCESS_BRIG,ACCESS_ENGINE)
			message_admins("[key_name_admin(usr)] made all maint doors engineering and brig access-only.")
		if("infinite_sec")
			if(!check_rights(R_DEBUG))
				return
			var/datum/job/J = SSjob.GetJob("Security Officer")
			if(!J)
				return
			J.total_positions = -1
			J.spawn_positions = -1
			message_admins("[key_name_admin(usr)] has removed the cap on security officers.")

		if("ctfbutton")
			if(!check_rights(R_ADMIN))
				message_admins("[ADMIN_TPMONTY(usr)] tried to use Secrets_topic(), item: ctfbutton, without admin perms.")
				log_admin("INVALID ADMIN PROC ACCESS: [key_name(usr)] tried to use Secrets_topic(), item: ctfbutton, without admin perms.")
				return
			toggle_all_ctf(usr)
		if("masspurrbation")
			if(!check_rights(R_FUN))
				return
			mass_purrbation()
			message_admins("[key_name_admin(usr)] has put everyone on \
				purrbation!")
			log_admin("[key_name(usr)] has put everyone on purrbation.")
		if("massremovepurrbation")
			if(!check_rights(R_FUN))
				return
			mass_remove_purrbation()
			message_admins("[key_name_admin(usr)] has removed everyone from \
				purrbation.")
			log_admin("[key_name(usr)] has removed everyone from purrbation.")

		if("customportal")
			if(!check_rights(R_FUN))
				return

			var/list/settings = list(
				"mainsettings" = list(
					"typepath" = list("desc" = "Path to spawn", "type" = "datum", "path" = "/mob/living", "subtypesonly" = TRUE, "value" = /mob/living/simple_animal/hostile/poison/bees),
					"humanoutfit" = list("desc" = "Outfit if human", "type" = "datum", "path" = "/datum/outfit", "subtypesonly" = TRUE, "value" = /datum/outfit),
					"amount" = list("desc" = "Number per portal", "type" = "number", "value" = 1),
					"portalnum" = list("desc" = "Number of total portals", "type" = "number", "value" = 10),
					"offerghosts" = list("desc" = "Get ghosts to play mobs", "type" = "boolean", "value" = "No"),
					"minplayers" = list("desc" = "Minimum number of ghosts", "type" = "number", "value" = 1),
					"playersonly" = list("desc" = "Only spawn ghost-controlled mobs", "type" = "boolean", "value" = "No"),
					"ghostpoll" = list("desc" = "Ghost poll question", "type" = "string", "value" = "Do you want to play as %TYPE% portal invader?"),
					"delay" = list("desc" = "Time between portals, in deciseconds", "type" = "number", "value" = 50),
					"color" = list("desc" = "Portal color", "type" = "color", "value" = "#00FF00"),
					"playlightning" = list("desc" = "Play lightning sounds on announcement", "type" = "boolean", "value" = "Yes"),
					"announce_players" = list("desc" = "Make an announcement", "type" = "boolean", "value" = "Yes"),
					"announcement" = list("desc" = "Announcement", "type" = "string", "value" = "Massive bluespace anomaly detected en route to %STATION%. Brace for impact."),
				)
			)

			message_admins("[key_name(usr)] is creating a custom portal storm...")
			var/list/prefreturn = presentpreflikepicker(usr,"Customize Portal Storm", "Customize Portal Storm", Button1="Ok", width = 600, StealFocus = 1,Timeout = 0, settings=settings)

			if (prefreturn["button"] == 1)
				var/list/prefs = settings["mainsettings"]

				if (prefs["amount"]["value"] < 1 || prefs["portalnum"]["value"] < 1)
					to_chat(usr, "Number of portals and mobs to spawn must be at least 1")
					return

				var/mob/pathToSpawn = prefs["typepath"]["value"]
				if (!ispath(pathToSpawn))
					pathToSpawn = text2path(pathToSpawn)

				if (!ispath(pathToSpawn))
					to_chat(usr, "Invalid path [pathToSpawn]")
					return

				var/list/candidates = list()

				if (prefs["offerghosts"]["value"] == "Yes")
					candidates = pollGhostCandidates(replacetext(prefs["ghostpoll"]["value"], "%TYPE%", initial(pathToSpawn.name)), ROLE_TRAITOR)

				if (prefs["playersonly"]["value"] == "Yes" && length(candidates) < prefs["minplayers"]["value"])
					message_admins("Not enough players signed up to create a portal storm, the minimum was [prefs["minplayers"]["value"]] and the number of signups [length(candidates)]")
					return

				if (prefs["announce_players"]["value"] == "Yes")
					portalAnnounce(prefs["announcement"]["value"], (prefs["playlightning"]["value"] == "Yes" ? TRUE : FALSE))

				var/mutable_appearance/storm = mutable_appearance('icons/obj/tesla_engine/energy_ball.dmi', "energy_ball_fast", FLY_LAYER)
				storm.color = prefs["color"]["value"]

				message_admins("[key_name_admin(usr)] has created a customized portal storm that will spawn [prefs["portalnum"]["value"]] portals, each of them spawning [prefs["amount"]["value"]] of [pathToSpawn]")
				log_admin("[key_name(usr)] has created a customized portal storm that will spawn [prefs["portalnum"]["value"]] portals, each of them spawning [prefs["amount"]["value"]] of [pathToSpawn]")

				var/outfit = prefs["humanoutfit"]["value"]
				if (!ispath(outfit))
					outfit = text2path(outfit)

				for (var/i in 1 to prefs["portalnum"]["value"])
					if (length(candidates)) // if we're spawning players, gotta be a little tricky and also not spawn players on top of NPCs
						var/ghostcandidates = list()
						for (var/j in 1 to min(prefs["amount"]["value"], length(candidates)))
							ghostcandidates += pick_n_take(candidates)
							addtimer(CALLBACK(GLOBAL_PROC, GLOBAL_PROC_REF(doPortalSpawn), get_random_station_turf(), pathToSpawn, length(ghostcandidates), storm, ghostcandidates, outfit), i*prefs["delay"]["value"])
					else if (prefs["playersonly"]["value"] != "Yes")
						addtimer(CALLBACK(GLOBAL_PROC, GLOBAL_PROC_REF(doPortalSpawn), get_random_station_turf(), pathToSpawn, prefs["amount"]["value"], storm, null, outfit), i*prefs["delay"]["value"])

	if(E)
		E.processing = FALSE
		if(E.announceWhen>0)
			if(alert(usr, "Would you like to alert the crew?", "Alert", "Yes", "No") == "No")
				E.announceWhen = -1
		E.processing = TRUE
	if (usr)
		log_admin("[key_name(usr)] used secret [item]")
		if (ok)
			to_chat(world, text("<B>A secret has been activated by []!</B>", usr.key))

/proc/portalAnnounce(announcement, playlightning)
	set waitfor = 0
	if (playlightning)
		sound_to_playing_players('sound/magic/lightning_chargeup.ogg')
		sleep(80)
	priority_announce(replacetext(announcement, "%STATION%", station_name()))
	if (playlightning)
		sleep(20)
		sound_to_playing_players('sound/magic/lightningbolt.ogg')

/proc/doPortalSpawn(turf/loc, mobtype, numtospawn, portal_appearance, players, humanoutfit)
	for (var/i in 1 to numtospawn)
		var/mob/spawnedMob = new mobtype(loc)
		if (length(players))
			var/mob/chosen = players[1]
			if (chosen.client)
				chosen.client.prefs.copy_to(spawnedMob)
				chosen.transfer_ckey(spawnedMob)
			players -= chosen
		if (ishuman(spawnedMob) && ispath(humanoutfit, /datum/outfit))
			var/mob/living/carbon/human/H = spawnedMob
			H.equipOutfit(humanoutfit)
	var/turf/T = get_step(loc, SOUTHWEST)
	flick_overlay_static(portal_appearance, T, 15)
	playsound(T, 'sound/magic/lightningbolt.ogg', rand(80, 100), 1)
