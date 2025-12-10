/obj/item/clothing/suit/armor/tiered/hooded
	actions_types = list(/datum/action/item_action/toggle_hood)
	var/obj/item/clothing/head/hooded/hood
	var/hoodtype = /obj/item/clothing/head/hooded/winterhood //so the chaplain hoodie or other hoodies can override this

/obj/item/clothing/suit/armor/tiered/hooded/Initialize()
	. = ..()
	hood = MakeHelmet()

/obj/item/clothing/suit/armor/tiered/hooded/Destroy()
	. = ..()
	qdel(hood)
	hood = null

/obj/item/clothing/suit/armor/tiered/proc/MakeHelmet(obj/item/clothing/head/H)
	SEND_SIGNAL(src, COMSIG_SUIT_MADE_HELMET, H)
	return H

/obj/item/clothing/suit/armor/tiered/hooded/MakeHelmet(obj/item/clothing/head/hooded/H)
	if(!hood)
		H = new hoodtype(src)
		H.suit = src
		return ..()

/obj/item/clothing/suit/armor/tiered/hooded/ui_action_click()
	ToggleHood()

/obj/item/clothing/suit/armor/tiered/item_action_slot_check(slot, mob/user, datum/action/A)
	if(slot == SLOT_WEAR_SUIT || slot == SLOT_NECK)
		return 1

/obj/item/clothing/suit/armor/tiered/equipped(mob/user, slot)
	if(slot != SLOT_WEAR_SUIT && slot != SLOT_NECK)
		RemoveHood()
	..()

/obj/item/clothing/suit/armor/tiered/hooded/proc/RemoveHood()
	suittoggled = FALSE
	if(ishuman(hood.loc))
		var/mob/living/carbon/H = hood.loc
		H.transferItemToLoc(hood, src, TRUE)
		H.update_inv_wear_suit()
	else
		hood.forceMove(src)
	update_icon()

/obj/item/clothing/suit/armor/tiered/hooded/update_icon_state()
	icon_state = "[initial(icon_state)]"
	if(ishuman(hood?.loc))
		var/mob/living/carbon/human/H = hood.loc
		if(H.head == hood)
			icon_state += "_t"

/obj/item/clothing/suit/armor/tiered/dropped(mob/user)
	..()
	RemoveHood()

/obj/item/clothing/suit/armor/tiered/hooded/proc/ToggleHood()
	if(!hood)
		to_chat(loc, span_warning("[src] seems to be missing its hood.."))
		return
	if(atom_colours)
		hood.atom_colours = atom_colours.Copy()
		hood.update_atom_colour()
	if(!suittoggled)
		if(ishuman(src.loc))
			var/mob/living/carbon/human/H = src.loc
			if(H.wear_suit != src)
				to_chat(H, span_warning("You must be wearing [src] to put up the hood!"))
				return
			if(H.head)
				to_chat(H, span_warning("You're already wearing something on your head!"))
				return
			else if(H.equip_to_slot_if_possible(hood,SLOT_HEAD,0,0,1))
				suittoggled = TRUE
				update_icon()
				H.update_inv_wear_suit()
	else
		RemoveHood()

/obj/item/clothing/head/helmet/f13/hooded
	var/obj/item/clothing/suit/hooded/suit
	dynamic_hair_suffix = ""

/obj/item/clothing/head/helmet/f13/hooded/Destroy()
	suit = null
	return ..()

/obj/item/clothing/head/helmet/f13/hooded/dropped(mob/user)
	..()
	if(suit)
		suit.RemoveHood()

/obj/item/clothing/head/helmet/f13/hooded/equipped(mob/user, slot)
	..()
	if(slot != SLOT_HEAD)
		if(suit)
			suit.RemoveHood()
		else
			qdel(src)

//Toggle exosuits for different aesthetic styles (hoodies, suit jacket buttons, etc)
/obj/item/clothing/suit/armor/tiered/toggle
	/// If the suit has different hidden parts when toggled, use these for what it hides
	var/toggled_hidden_parts

/obj/item/clothing/suit/armor/tiered/toggle/AltClick(mob/user)
	. = ..()
	if(!user.canUseTopic(src, BE_CLOSE, ismonkey(user)))
		return
	suit_toggle(user)
	return TRUE

/obj/item/clothing/suit/armor/tiered/toggle/ui_action_click()
	suit_toggle()

/obj/item/clothing/suit/armor/tiered/toggle/proc/suit_toggle()
	set src in usr

	if(!can_use(usr))
		return 0

	to_chat(usr, span_notice("You toggle [src]'s [togglename]."))
	if(src.suittoggled)
		src.icon_state = "[initial(icon_state)]"
		src.body_parts_hidden = initial(src.body_parts_hidden)
		src.suittoggled = FALSE
	else if(!src.suittoggled)
		src.icon_state = "[initial(icon_state)]_t"
		if(!isnull(toggled_hidden_parts))
			src.body_parts_hidden = src.toggled_hidden_parts
		src.suittoggled = TRUE
	usr.update_inv_wear_suit()
	if(ismob(src.loc))
		var/mob/mob_carrying_this = src.loc
		mob_carrying_this.update_body(TRUE) // update skimpiness
	for(var/X in actions)
		var/datum/action/A = X
		A.UpdateButtonIcon()

/obj/item/clothing/suit/armor/tiered/toggle/examine(mob/user)
	. = ..()
	. += "Alt-click on [src] to toggle the [togglename]."