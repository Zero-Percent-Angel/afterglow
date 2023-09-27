/datum/keybinding/living
	category = CATEGORY_HUMAN
	weight = WEIGHT_MOB

/datum/keybinding/living/can_use(client/user)
	return isliving(user.mob)

/datum/keybinding/living/resist
	hotkey_keys = list("B")
	name = "resist"
	full_name = "Resist"
	description = "Break free of your current state. Handcuffed? on fire? Resist!"

/datum/keybinding/living/resist/down(client/user)
	var/mob/living/L = user.mob
	L.resist()
	return TRUE

/datum/keybinding/living/toggle_resting
	hotkey_keys = list("V")
	name = "toggle_resting"
	full_name = "Toggle Resting"
	description = "Toggles whether or not you are intentionally laying down."

/datum/keybinding/living/toggle_resting/down(client/user)
	var/mob/living/L = user.mob
	L.lay_down()

/datum/keybinding/living/cancel_action
	hotkey_keys = list("Unbound")
	name = "cancel_action"
	full_name = "Cancel Action"
	description = "Cancel the current action."

/// Technically you shouldn't be doing any actions if you were sleeping either but...
/datum/keybinding/living/can_use(client/user)
	. = ..()
	var/mob/living/mob = user.mob
	return . && (mob.stat == CONSCIOUS)

/datum/keybinding/living/cancel_action/down(client/user)
	var/mob/M = user.mob
	if(length(M.do_afters))
		var/atom/target = M.do_afters[M.do_afters.len]
		to_chat(M, span_notice("You stop interacting with \the [target]."))
		LAZYREMOVE(M.do_afters, target)
	else
		to_chat(M, span_notice("There's nothing that you can cancel right now."))
	return TRUE

//-->Gun safety toggle hotkey
/datum/keybinding/living/gunsafety
	hotkey_keys = list("Unbound")
	name = "gunsafety"
	full_name = "Gun Safety Toggle"
	category = CATEGORY_COMBAT
	description = "Toggle your weapon's safety."

/datum/keybinding/living/gunsafety/down(client/user)
	var/mob/living/carbon/C = user.mob
	var/obj/item/gun/firearm

	for(var/obj/item/gun/F in C.held_items)
		firearm = F
		break
	if(!istype(firearm))
		return FALSE
	. = ..()
	firearm.ui_action_click(usr, "safety")
	return TRUE

//-->Gun scope toggle hotkey
/datum/keybinding/living/gunscope
	hotkey_keys = list("Unbound")
	name = "gunscope"
	full_name = "Gun Scope Toggle"
	category = CATEGORY_COMBAT
	description = "Use your gun's scope."

/datum/keybinding/living/gunscope/down(client/user)
	var/mob/living/carbon/C = user.mob
	var/obj/item/gun/firearm

	for(var/obj/item/gun/F in C.held_items)
		firearm = F
		break
	if(!istype(firearm))
		return FALSE
	. = ..()
	firearm.ui_action_click(usr, "scope")
	return TRUE

//-->Gun switch firing mode hotkey
/datum/keybinding/living/gunmode
	hotkey_keys = list("Unbound")
	name = "gunmode"
	full_name = "Gun Firing Mode"
	category = CATEGORY_COMBAT
	description = "Switch your weapon's firing mode."

/datum/keybinding/living/gunmode/down(client/user)
	var/mob/living/carbon/C = user.mob
	var/obj/item/gun/firearm

	for(var/obj/item/gun/F in C.held_items)
		firearm = F
		break
	if(!istype(firearm))
		return FALSE
	. = ..()
	firearm.ui_action_click(usr, "fire mode")
	return TRUE
