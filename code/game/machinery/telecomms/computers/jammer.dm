/obj/machinery/computer/telecomms/jammer
	name = "telecommunications jamming console"
	icon_screen = "comm_logs"
	desc = "Can be used to jam frequencies."
	circuit = /obj/item/circuitboard/computer/comm_server
	req_access = list(ACCESS_TCOMSAT)

	var/list/machinelist = list()	// the servers located by the computer
	var/obj/machinery/telecomms/server/SelectedMachine = null

	var/network = "NULL"		// the network to probe
	var/notice = ""
	var/universal_translate = FALSE // set to TRUE(1) if it can translate nonhuman speech
	var/all_seeing = FALSE

/obj/machinery/computer/telecomms/jammer/ui_interact(mob/user, datum/tgui/ui)
	if(!user.skill_check(SKILL_SCIENCE))
		to_chat(user, span_warning("You don't have the skill needed to use this."))
		return
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "TelecommsLogBrowser", "Telecomms Server Monitor")
		ui.open()
