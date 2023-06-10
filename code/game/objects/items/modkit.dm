/obj/item/modkit
	name = "modkit"
	desc = "A small container of parts made to modify a specific item. Use the target item on this kit to convert it."
	icon = 'icons/obj/items_and_weapons.dmi'
	icon_state = "modkit"
	w_class = WEIGHT_CLASS_NORMAL
	var/list/target_items = list()
	var/result_item = null

/obj/item/modkit/pre_attack(obj/item/I, mob/user)
	if(is_type_in_list(I, target_items))
		var/obj/item/R = new result_item(get_turf(user))
		to_chat(user, span_notice("You apply the [src] to [I], using the custom parts to turn it into [R]."))
		remove_item_from_storage(I)
		qdel(I)
		user.put_in_hands(R)
		qdel(src)
		return TRUE
	else
		return ..()

/obj/item/modkit/riotgear
	name = "desert ranger riot gear modkit"
	target_items = list(/obj/item/clothing/suit/armor/rangercombat)
	result_item = /obj/item/clothing/suit/armor/medium/combat/desert_ranger

/obj/item/modkit/riotgear_helmet
	name = "desert ranger riot helmet modkit"
	target_items = list(/obj/item/clothing/head/helmet/f13/ncr/rangercombat)
	result_item = /obj/item/clothing/head/helmet/f13/ncr/rangercombat/desert

/obj/item/modkit/riotgear/fox
	name = "sniper riot gear modkit"
	result_item = /obj/item/clothing/suit/armor/rangercombat/foxcustom

/*
/obj/item/modkit/custom_excess
	name = "champion of kanab's armor modkit"
	target_items = list(/obj/item/clothing/suit/armor/legion/centurion,
						/obj/item/clothing/suit/armor/legion/rangercent,
						/obj/item/clothing/suit/armor/legion/palacent)
	result_item = /obj/item/clothing/suit/armor/legion/palacent/custom_excess

/obj/item/modkit/custom_excess_helmet
	name = "champion of kanab's helm modkit"
	target_items = list(/obj/item/clothing/head/helmet/f13/legion/centurion,
						/obj/item/clothing/head/helmet/f13/legion/rangercent,
						/obj/item/clothing/head/helmet/f13/legion/palacent)
	result_item = /obj/item/clothing/head/helmet/f13/legion/palacent/custom_excess
*/

//YEEHAWGUVNAH/Trinity Kemble
/obj/item/modkit/kemblevest
	name = "light riot armour modkit"
	target_items = list(/obj/item/clothing/suit/armor/trailranger)
	result_item = /obj/item/clothing/suit/armor/trailranger/kemble

/obj/item/modkit/kemblehat
	name = "ranger slouch hat modkit"
	target_items = list(/obj/item/clothing/head/f13/trailranger)
	result_item = /obj/item/clothing/head/f13/trailranger/kemble
