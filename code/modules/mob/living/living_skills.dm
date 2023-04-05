
/mob
	var/skill_guns = 100
	var/skill_energy = 100
	var/skill_unarmed = 100
	var/skill_melee = 100
	var/skill_throwing = 100
	var/skill_first_aid = 100
	var/skill_doctor = 100
	var/skill_sneak = 100
	var/skill_lockpick = 100
	var/skill_traps = 100
	var/skill_science = 100
	var/skill_repair = 100
	var/skill_speech = 100
	var/skill_barter = 100
	var/skill_outdoorsman = 100
	var/sneaking = FALSE

// -20 for an easy roll
// -10 for difficulty on a 'normal' roll
// 0 for a challenging roll
// +20 for an expert roll
/mob/proc/skill_roll(check, difficulty = DIFFICULTY_NORMAL, do_message = 1)
	if ((skill_value(check) + special_l) >= (rand(1,100) + difficulty))
		if (do_message)
			to_chat(src, span_green("You succeed the skill check using: [check]"))
		return TRUE
	else
		if (do_message)
			to_chat(src, span_red("You fail the skill check using: [check]"))
		return FALSE
	

/mob/proc/skill_roll_under(check, difficulty = DIFFICULTY_NORMAL)
	return  ((rand(1,100) + difficulty) - (skill_value(check)))

/mob/proc/skill_check(check, threshold = REGULAR_CHECK)
	return (skill_value(check) >= threshold)

/mob/proc/skill_value(check)
	if (SKILL_GUNS == check)
		return skill_guns + special_a
	if (SKILL_ENERGY == check)
		return skill_energy + special_a
	if (SKILL_UNARMED == check)
		return skill_unarmed + round((special_a + special_s)/2)
	if (SKILL_MELEE == check)
		return skill_melee + round((special_a + special_s)/2)
	if (SKILL_THROWING == check)
		return skill_throwing + special_a
	if (SKILL_FIRST_AID == check)
		return skill_first_aid + round((special_p*2 + special_i)/2)
	if (SKILL_DOCTOR == check)
		return skill_doctor + round((special_p*2 + special_i)/2)
	if (SKILL_SNEAK == check)
		return skill_sneak + special_a
	if (SKILL_LOCKPICK == check)
		return skill_lockpick + round((special_p*2 + special_a)/2)
	if (SKILL_TRAPS == check)
		return skill_traps + round((special_p*2 + special_a)/2)
	if (SKILL_SCIENCE == check)
		return skill_science + (special_i * 2)
	if (SKILL_REPAIR == check)
		return skill_repair + special_i
	if (SKILL_SPEECH == check)
		return skill_speech + (special_c * 2)
	if (SKILL_BARTER == check)
		return skill_barter + (special_c * 2)
	if (SKILL_OUTDOORSMAN == check)
		return skill_outdoorsman + round((special_i + special_e)/2)
	return 0


/mob/proc/update_skill_value(skill, value)
	if (SKILL_GUNS == skill)
		skill_guns = value
	if (SKILL_ENERGY == skill)
		skill_energy = value
	if (SKILL_UNARMED == skill)
		skill_unarmed = value
	if (SKILL_MELEE == skill)
		skill_melee = value
	if (SKILL_THROWING == skill)
		skill_throwing = value
	if (SKILL_FIRST_AID == skill)
		skill_first_aid = value
	if (SKILL_DOCTOR == skill)
		skill_doctor = value
	if (SKILL_SNEAK == skill)
		skill_sneak = value
	if (SKILL_LOCKPICK == skill)
		skill_lockpick = value
	if (SKILL_TRAPS == skill)
		skill_traps = value
	if (SKILL_SCIENCE == skill)
		skill_science = value
	if (SKILL_REPAIR == skill)
		skill_repair = value
	if (SKILL_SPEECH == skill)
		skill_speech = value
	if (SKILL_BARTER == skill)
		skill_barter = value
	if (SKILL_OUTDOORSMAN == skill)
		skill_outdoorsman = value
	invalidate_skill_caches()
	
/mob/proc/invalidate_skill_caches()
	cached_knowable_recipies = list()
	cached_unknowable_recipies = list()


/mob/proc/get_skill_all_values()
	var/list/dat = list()
	dat = list(list("name" = SKILL_GUNS, "value" = num2text(skill_guns + special_a), "description" = "Applies to ballistic weapons. Controls things like recoil and dispersion. Higher values; tighter firing arcs and slower recoil buildup."),
	list("name" = SKILL_ENERGY, "value" = num2text(skill_energy + special_a), "description" = "Applies to energy weapons. Controls things like recoil and dispersion. Higher values; tighter firing arcs and slower recoil buildup. Also important for failure to fire chance."),
	list("name" = SKILL_UNARMED, "value" = num2text(skill_unarmed + round((special_a + special_s)/2)), "description" = "Hit chance when unarmed, also determines chances to disarm and break out of grabs and the like."),
	list("name" = SKILL_MELEE, "value" = num2text(skill_melee + round((special_a + special_s)/2)), "description" = "Hit chance when using a melee weapon."),
	list("name" = SKILL_THROWING, "value" = num2text(skill_throwing + special_a), "description" = "Hit chance for projectiles thrown by your character."),
	list("name" = SKILL_FIRST_AID, "value" = num2text(skill_first_aid + round((special_p*2 + special_i)/2)), "description" = "Bandage, Suture, Salves, basic medicine effectiveness, higher values means longer lifetimes and more healing. Also can be used to read from health scanners."),
	list("name" = SKILL_DOCTOR, "value" = num2text(skill_doctor + round((special_p*2 + special_i)/2)), "description" = "Surgical success chance, higher values also unlock more surgeries. Can also be used to control various medical devices autosurgeons and the like."),
	list("name" = SKILL_SNEAK, "value" = num2text(skill_sneak + special_a), "description" = "Determines what happens when using the sneak verb. Higher values make your sprite more transparent and lower mob dectection chance."),
	list("name" = SKILL_LOCKPICK, "value" = num2text(skill_lockpick + round((special_p*2 + special_a)/2)), "description" = "Lockpicking; success chance for opening locks both on doors and for lock boxes!"),
	list("name" = SKILL_TRAPS, "value" = num2text(skill_traps + round((special_p*2 + special_a)/2)), "description" = "Disarming traps; such as on locked doors and locked boxes. Also lets you spot hidden traps. Used as the skill for creating explosives when crafting."),
	list("name" = SKILL_SCIENCE, "value" = num2text(skill_science + (special_i * 2)), "description" = "Research effectiveness; determines what nodes you can research as well as how good your experiments will be. Dictates chemistry skill too higher values, more known chemicals; and is used for 'hacking'."),
	list("name" = SKILL_REPAIR, "value" = num2text(skill_repair + special_i), "description" = "The primary construction and crafting skill, limits what you can do based on the value. Can be used for smithing too."),
	list("name" = SKILL_SPEECH, "value" = num2text(skill_speech + (special_c * 2)), "description" = "Higher skill, better chance of convincing npcs to do what you want them to."),
	list("name" = SKILL_BARTER, "value" = num2text(skill_barter + (special_c * 2)), "description" = "Higher skill, better prices from npc traders."),
	list("name" = SKILL_OUTDOORSMAN, "value" = num2text(skill_outdoorsman + round((special_i + special_e)/2)), "description" = "The primary skill for tribal crafting, can be used for smithing too. higher values will also give you more yeild from plants and butchering."))
	return dat


/mob/living/verb/try_to_talk_to(atom/A as mob in view())
	set name = "Talk to"
	set category = "IC"
	if (HAS_TRAIT(src, TRAIT_MUTE))
		to_chat(src, span_alert("You're mute, how will you talk to them?"))
		return
	var/mob/m = A
	if(!(A in view(client ? client.view : world.view, src)) || !m.will_talk)
		// shift-click catcher may issue examinate() calls for out-of-sight turfs
		return
	
	m.talk_to(src)

/mob/living/verb/sneak()
	set name = "Sneak"
	set category = "IC"
	if (!sneaking)
		start_sneaking()
	else
		stop_sneaking()

/mob/living/proc/start_sneaking()
	if (!sneaking)
		sneaking = TRUE
		src.alpha = (255 - (src.skill_value(SKILL_SNEAK) * 2))
		to_chat(src, span_notice("You start sneaking."))
		if (m_intent != MOVE_INTENT_WALK)
			toggle_move_intent()
		

/mob/living/proc/stop_sneaking()
	if (sneaking)
		sneaking = FALSE
		src.alpha = 255
		to_chat(src, span_warning("You stop sneaking."))
