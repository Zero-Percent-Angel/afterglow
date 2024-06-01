/obj/machinery/computer/telecomms/jammer
	name = "telecommunications jamming console"
	icon_state = "fallout_console"
	icon_screen = "fallout_screen_radio"
	icon_keyboard = "fallout_attatchments_radio"
	desc = "Can be used to jam frequencies."
	circuit = /obj/item/circuitboard/computer/comm_server
	req_access = list()
	max_integrity = 750
	var/list/machinelist = list()	// the servers located by the computer
	var/obj/machinery/telecomms/server/SelectedMachine = null
	var/universal_translate = FALSE // set to TRUE(1) if it can translate nonhuman speech
	var/on_cooldown = FALSE

/obj/machinery/computer/telecomms/jammer/Initialize(mapload, obj/item/circuitboard/C)
	. = ..()
	for(var/obj/machinery/telecomms/T in GLOB.telecomms_list)
		LAZYADD(machinelist, T)

/obj/machinery/computer/telecomms/jammer/ui_interact(mob/user)
	if(!user.skill_check(SKILL_SCIENCE))
		to_chat(user, span_warning("You don't have the skill needed to use this."))
		return
	var/dat = ""
	dat += "<head><style>body {padding: 0; margin: 15px; background-color: #062113; color: #4aed92; line-height: 170%;} a, button, a:link, a:visited, a:active, .linkOn, .linkOff {color: #4aed92; text-decoration: none; background: #062113; border: none; padding: 1px 4px 1px 4px; margin: 0 2px 0 0; cursor:default;} a:hover {color: #062113; background: #4aed92; border: 1px solid #4aed92} a.white, a.white:link, a.white:visited, a.white:active {color: #4aed92; text-decoration: none; background: #4aed92; border: 1px solid #161616; padding: 1px 4px 1px 4px; margin: 0 2px 0 0; cursor:default;} a.white:hover {color: #062113; background: #4aed92;} .linkOn, a.linkOn:link, a.linkOn:visited, a.linkOn:active, a.linkOn:hover {color: #4aed92; background: #062113; border-color: #062113;} .linkOff, a.linkOff:link, a.linkOff:visited, a.linkOff:active, a.linkOff:hover{color: #4aed92; background: #062113; border-color: #062113;}</style></head><font face='courier'>"
	dat += "<center><b>ROBCO INDUSTRIES UNIFIED OPERATING SYSTEM v.85</b><br>"
	dat += "<b>COPYRIGHT 2075-2077 ROBCO INDUSTRIES</b><br><br><br><br>"
	for(var/obj/machinery/telecomms/server/T in machinelist)
		if (!T.interference)
			dat += "<a href='?src=[REF(src)];terminate=[REF(T)]'> [T.name]<br>"
	var/datum/browser/popup = new(user, "radio_jammer", "Radio Jammer Terminal")
	popup.set_content(dat)
	popup.open()

/obj/machinery/computer/telecomms/jammer/Topic(href, href_list)
	if(..())
		return
	usr.set_machine(src)
	add_fingerprint(usr)
	if(href_list["terminate"])
		if (on_cooldown)
			to_chat(usr, span_warning("Can't jam again so soon."))
			return
		if (usr.skill_roll(SKILL_SCIENCE, DIFFICULTY_EXPERT))
			var/obj/machinery/telecomms/server/terminate = locate(href_list["terminate"]) in GLOB.machines
			terminate(terminate)
			to_chat(usr, span_good("Communications Jammed"))
		else
			to_chat(usr, span_warning("Failed to Jam communictations"))
		on_cooldown = TRUE
		addtimer(CALLBACK(src, PROC_REF(online)), 5 MINUTES)
	updateUsrDialog()
	return

/obj/machinery/computer/telecomms/jammer/proc/terminate(obj/machinery/telecomms/server/T)
	T.disrupt()

/obj/machinery/computer/telecomms/jammer/proc/online()
	on_cooldown = FALSE
