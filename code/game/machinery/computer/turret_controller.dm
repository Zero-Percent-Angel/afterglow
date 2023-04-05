/obj/machinery/computer/turret_controller
	name = "turret control terminal"
	desc = "A RobCo Industries terminal, widely available for commercial and private use before the war."
	icon_state = "terminal"
	icon_keyboard = "terminal_key"
	icon_screen = "terminal_on_alt"
	connectable = FALSE
	light_color = LIGHT_COLOR_GREEN
	var/hack_id = ""
	var/list/obj/machinery/porta_turret/f13/controlled_turrets = list()
	var/locked_console = FALSE

/obj/machinery/computer/turret_controller/Initialize()
	. = ..()
	for (var/obj/machinery/porta_turret/f13/turret in orange(10, src))
		if (turret.hack_id == hack_id)
			controlled_turrets += turret

/obj/machinery/computer/turret_controller/ui_interact(mob/user)
	. = ..()

	var/dat = ""
	dat += "<head><style>body {padding: 0; margin: 15px; background-color: #062113; color: #4aed92; line-height: 170%;} a, button, a:link, a:visited, a:active, .linkOn, .linkOff {color: #4aed92; text-decoration: none; background: #062113; border: none; padding: 1px 4px 1px 4px; margin: 0 2px 0 0; cursor:default;} a:hover {color: #062113; background: #4aed92; border: 1px solid #4aed92} a.white, a.white:link, a.white:visited, a.white:active {color: #4aed92; text-decoration: none; background: #4aed92; border: 1px solid #161616; padding: 1px 4px 1px 4px; margin: 0 2px 0 0; cursor:default;} a.white:hover {color: #062113; background: #4aed92;} .linkOn, a.linkOn:link, a.linkOn:visited, a.linkOn:active, a.linkOn:hover {color: #4aed92; background: #062113; border-color: #062113;} .linkOff, a.linkOff:link, a.linkOff:visited, a.linkOff:active, a.linkOff:hover{color: #4aed92; background: #062113; border-color: #062113;}</style></head><font face='courier'>"
	dat += "<center><b>ROBCO INDUSTRIES UNIFIED OPERATING SYSTEM v.85</b><br>"
	dat += "<b>COPYRIGHT 2075-2077 ROBCO INDUSTRIES</b><br>"
	dat += "TERMINAL FUNCTIONS"
	if (!locked_console)
		dat += "<br><a href='byond://?src=[REF(src)];choice=1'>\>  Turret Control (Hack - SCIENCE)</a>"
	else
		dat += "<br>ERR 403 --- CONSOLE LOCKED --- CONTACT SYS_ADMIN"
	if (locked_console && user.skill_check(SKILL_SCIENCE, EXPERT_CHECK))
		dat += "<br><a href='byond://?src=[REF(src)];choice=2'>\>  Turret Control (Hack - SCIENCE)</a>"

	var/datum/browser/popup = new(user, "terminal", null, 600, 400)
	popup.set_content(dat)
	popup.open()


/obj/machinery/computer/turret_controller/Topic(href, href_list)
	..()
	var/mob/living/U = usr

	if(usr.canUseTopic(src) && !href_list["close"])
		add_fingerprint(U)
		U.set_machine(src)

		switch(href_list["choice"])
			if ("1")
				if (!locked_console)
					to_chat(U, span_notice("You begin hacking the turret."))
					if (do_after(U, 5 SECONDS, target = src))
						if (U.skill_check(SKILL_SCIENCE, HARD_CHECK) || U.skill_roll(SKILL_SCIENCE, DIFFICULTY_CHALLENGE))
							var/hack = input(U, "Do you wish to disable or reprogram the turrets to attack anyone not in your faction?", "Hack") in list("Disable", "Faction")
							if (hack == "Disable")
								for (var/obj/machinery/porta_turret/f13/turret in controlled_turrets)
									turret.toggle_on(FALSE)
							if (hack == "Faction")
								for (var/obj/machinery/porta_turret/f13/turret in controlled_turrets)
									turret.faction = U.faction
									turret.clear_targets()
							to_chat(U, span_good("You sucessfully reprogram the turrets"))
						else
							say("Commands not accepted. Turrets remaining active; Locking console.")
							locked_console = TRUE
			if("2")
				if(U.skill_check(SKILL_SCIENCE, EXPERT_CHECK))
					if (do_after(U, 5 SECONDS, target = src))
						say("Lock lifted.")
						locked_console = FALSE
	updateUsrDialog()
	return
