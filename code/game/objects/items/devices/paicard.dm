/obj/item/paicard
	name = "personal AI device"
	icon = 'icons/obj/aicards.dmi'
	icon_state = "pai"
	item_state = "electronic"
	lefthand_file = 'icons/mob/inhands/misc/devices_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/misc/devices_righthand.dmi'
	w_class = WEIGHT_CLASS_SMALL
	slot_flags = ITEM_SLOT_BELT
	var/mob/living/silicon/pai/pai
	resistance_flags = FIRE_PROOF | ACID_PROOF
	max_integrity = 200

/obj/item/paicard/suicide_act(mob/living/user)
	user.visible_message(span_suicide("[user] is staring sadly at [src]! [user.p_they()] can't keep living without real human intimacy!"))
	return OXYLOSS

/obj/item/paicard/Initialize()
	SSpai.pai_card_list += src
	add_overlay("pai-off")
	return ..()

/obj/item/paicard/Destroy()
	//Will stop people throwing friend pAIs into the singularity so they can respawn
	SSpai.pai_card_list -= src
	if (!QDELETED(pai))
		QDEL_NULL(pai)
	return ..()

/obj/item/paicard/attack_self(mob/user)
	if (!in_range(src, user))
		return
	user.set_machine(src)
	var/dat = "<TT><B>Personal AI Device</B><BR>"
	if(pai)
		if(!pai.master_dna || !pai.master)
			dat += "<a href='byond://?src=[REF(src)];setdna=1'>Imprint Master DNA</a><br>"
		dat += "Installed Personality: [pai.name]<br>"
		dat += "Prime directive: <br>[pai.laws.zeroth]<br>"
		for(var/slaws in pai.laws.supplied)
			dat += "Additional directives: <br>[slaws]<br>"
		dat += "<a href='byond://?src=[REF(src)];setlaws=1'>Configure Directives</a><br>"
		dat += "<br>"
		dat += "<h3>Device Settings</h3><br>"
		if(pai.radio)
			dat += "<b>Radio Uplink</b><br>"
			dat += "Transmit: <A href='byond://?src=[REF(src)];wires=[WIRE_TX]'>[(pai.radio.wires.is_cut(WIRE_TX)) ? "Disabled" : "Enabled"]</A><br>"
			dat += "Receive: <A href='byond://?src=[REF(src)];wires=[WIRE_RX]'>[(pai.radio.wires.is_cut(WIRE_RX)) ? "Disabled" : "Enabled"]</A><br>"
			if(pai.radio_short)
				dat += "<font color='red'>Reset radio short: <a href='byond://?src=[REF(src)];reset_radio_short=1'>\[RESET\]</a><br>"
		else
			dat += "<b>Radio Uplink</b><br>"
			dat += "<font color=red><i>Radio firmware not loaded. Please install a pAI personality to load firmware.</i></font><br>"
		if(ishuman(user))
			var/mob/living/carbon/human/H = user
			if(H.real_name == pai.master || H.dna.unique_enzymes == pai.master_dna)
				dat += "<A href='byond://?src=[REF(src)];toggle_holo=1'>\[[pai.canholo? "Disable" : "Enable"] holomatrix projectors\]</a><br>"
		dat += "<A href='byond://?src=[REF(src)];wipe=1'>\[Wipe current pAI personality\]</a><br>"
	else
		dat += "No personality installed.<br>"
		dat += "Searching for a personality... Press view available personalities to notify potential candidates."
		dat += "<A href='byond://?src=[REF(src)];request=1'>\[View available personalities\]</a><br>"
	user << browse(HTML_SKELETON(dat), "window=paicard")
	onclose(user, "paicard")
	return

/obj/item/paicard/Topic(href, href_list)

	if(!usr || usr.stat)
		return

	if(href_list["request"])
		SSpai.findPAI(src, usr)

	if(pai)
		if(!(loc == usr))
			return
		if(href_list["setdna"])
			if(pai.master_dna)
				return
			if(!iscarbon(usr))
				to_chat(usr, span_warning("You don't have any DNA, or your DNA is incompatible with this device!"))
			else
				var/mob/living/carbon/M = usr
				pai.master = M.real_name
				pai.master_dna = M.dna.unique_enzymes
				to_chat(pai, span_notice("You have been bound to a new master."))
		if(href_list["wipe"])
			var/confirm = input("Are you CERTAIN you wish to delete the current personality? This action cannot be undone.", "Personality Wipe") in list("Yes", "No")
			if(confirm == "Yes")
				if(pai)
					to_chat(pai, span_warning("You feel yourself slipping away from reality."))
					to_chat(pai, span_danger("Byte by byte you lose your sense of self."))
					to_chat(pai, span_userdanger("Your mental faculties leave you."))
					to_chat(pai, span_rose("oblivion... "))
					qdel(pai)
		if(href_list["wires"] && pai.radio)
			pai.radio.wires.cut(href_list["wires"])
		if(href_list["reset_radio_short"])
			pai.unshort_radio()
		if(href_list["setlaws"])
			var/newlaws = stripped_multiline_input(usr, "Enter any additional directives you would like your pAI personality to follow. Note that these directives will not override the personality's allegiance to its imprinted master. Conflicting directives will be ignored.", "pAI Directive Configuration", "", MAX_MESSAGE_LEN)
			if(newlaws && pai)
				pai.add_supplied_law(0,newlaws)
		if(href_list["toggle_holo"])
			if(pai.canholo)
				to_chat(pai, span_userdanger("Your owner has disabled your holomatrix projectors!"))
				pai.canholo = FALSE
				to_chat(usr, span_warning("You disable your pAI's holomatrix!"))
			else
				to_chat(pai, span_boldnotice("Your owner has enabled your holomatrix projectors!"))
				pai.canholo = TRUE
				to_chat(usr, span_notice("You enable your pAI's holomatrix!"))

	attack_self(usr)

// 		WIRE_SIGNAL = 1
//		WIRE_RECEIVE = 2
//		WIRE_TRANSMIT = 4

/obj/item/paicard/proc/setPersonality(mob/living/silicon/pai/personality)
	src.pai = personality
	src.add_overlay("pai-null")

	playsound(loc, 'sound/effects/pai_boot.ogg', 50, 1, -1)
	audible_message("\The [src] plays a cheerful startup noise!")

/obj/item/paicard/proc/setEmotion(emotion)
	if(pai)
		src.cut_overlays()
		switch(emotion)
			if(1)
				src.add_overlay("pai-happy")
			if(2)
				src.add_overlay("pai-cat")
			if(3)
				src.add_overlay("pai-extremely-happy")
			if(4)
				src.add_overlay("pai-face")
			if(5)
				src.add_overlay("pai-laugh")
			if(6)
				src.add_overlay("pai-off")
			if(7)
				src.add_overlay("pai-sad")
			if(8)
				src.add_overlay("pai-angry")
			if(9)
				src.add_overlay("pai-what")
			if(10)
				src.add_overlay("pai-null")
			if(11)
				src.add_overlay("pai-exclamation")
			if(12)
				src.add_overlay("pai-question")
			if(13)
				src.add_overlay("pai-sunglasses")

/obj/item/paicard/proc/alertUpdate()
	visible_message("<span class ='info'>[src] flashes a message across its screen, \"Additional personalities available for download.\"", span_notice("[src] bleeps electronically."))

/obj/item/paicard/emp_act(severity)
	. = ..()
	if (. & EMP_PROTECT_SELF)
		return
	if(pai && !pai.holoform)
		pai.emp_act(severity)
