
/client/proc/cmd_admin_add_skill_check(atom/M in view())
	set category = "Admin.Events"
	set name = "Add Skill Check"
	var/check = input(src, "Choose which skill you wish to use.", "Add Skill Check") as null|anything in list(SKILL_GUNS, SKILL_ENERGY, SKILL_MELEE, SKILL_THROWING, SKILL_UNARMED, SKILL_DOCTOR, SKILL_FIRST_AID, SKILL_LOCKPICK, SKILL_SNEAK, SKILL_TRAPS, SKILL_REPAIR, SKILL_SCIENCE, SKILL_SPEECH, SKILL_BARTER, SKILL_OUTDOORSMAN)
	if (check)
		var/roll = input(src, "Choose if you want the skill check to be a roll or threshold check.", "Add Skill Check") as null|anything in list("roll", "threshold")
		if (roll)
			var/mod = 0
			if (roll == "threshold")
				mod = input(src, "How much skill do we need to pass?", "Set threshold", 0) as num|null
				if (mod > 0)
					M.has_a_added_skill_check = TRUE
					M.added_skill_check = check
					M.added_skill_can_be_retried = TRUE
					M.added_skill_difficulty = mod
					M.added_skill_check_is_a_roll = FALSE
					M.added_skill_failures = null
					log_admin("[key_name_admin(usr)] added a skill check to: [M]")
			else
				mod = input(src, "What is the skill modifier? Positive to make the check harder, negative for easier.", "Set difficulty", 0) as num|null
				var/retry = input(src, "Can a user try the skill roll over and over?", "Can be retried") as null|anything in list("yes", "no")
				M.has_a_added_skill_check = TRUE
				M.added_skill_check = check
				M.added_skill_can_be_retried = retry == "yes" ? TRUE : FALSE
				M.added_skill_difficulty = mod
				M.added_skill_check_is_a_roll = TRUE
				M.added_skill_failures = list()
				log_admin("[key_name_admin(usr)] added a skill roll to: [M]")
	SSblackbox.record_feedback("tally", "admin_verb", 1, "Add Skill Check")
