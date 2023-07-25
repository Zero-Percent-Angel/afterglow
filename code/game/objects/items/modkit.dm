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

/*Examples

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

//YEEHAWGUVNAH/Trinity Kemble
/obj/item/modkit/kemblevest
	name = "light riot armour modkit"
	target_items = list(/obj/item/clothing/suit/armor/trailranger)
	result_item = /obj/item/clothing/suit/armor/trailranger/kemble

/obj/item/modkit/kemblehat
	name = "ranger slouch hat modkit"
	target_items = list(/obj/item/clothing/head/f13/trailranger)
	result_item = /obj/item/clothing/head/f13/trailranger/kemble
*/

/obj/item/modkit/mutie/vet_ranger_armour
	name = "Mutie Veteran Ranger Armour modkit"
	target_items = list(/obj/item/clothing/suit/armor/medium/combat/mk2/ncr/vetranger)
	result_item = /obj/item/clothing/suit/armor/medium/combat/mk2/ncr/vetranger/mutie

/obj/item/modkit/mutie/vet_ranger_helmet
	name = "Mutie Veteran Ranger Helmet modkit"
	target_items = list(/obj/item/clothing/head/helmet/f13/ncr/veteran)
	result_item = /obj/item/clothing/head/helmet/f13/ncr/veteran/mutie

/obj/item/modkit/mutie/ranger_armour
	name = "Mutie Veteran Ranger Armour modkit"
	target_items = list(/obj/item/clothing/suit/armor/medium/combat/patrol)
	result_item = /obj/item/clothing/suit/armor/medium/combat/patrol/mutie

/obj/item/modkit/mutie/ranger_helmet
	name = "Mutie Ranger Helmet modkit"
	target_items = list(/obj/item/clothing/head/f13/ncr/patrol)
	result_item = /obj/item/clothing/head/f13/ncr/patrol/mutie

/obj/item/modkit/mutie/ncr_trooper_armour
	name = "Mutie Trooper Armour modkit"
	target_items = list(/obj/item/clothing/suit/armor/light/ncr)
	result_item = /obj/item/clothing/suit/armor/light/ncr/mutie

/obj/item/modkit/mutie/ncr_trooper_helmet
	name = "Mutie Trooper Helmet modkit"
	target_items = list(/obj/item/clothing/head/helmet/f13/ncr)
	result_item = /obj/item/clothing/head/helmet/f13/ncr/mutie

/obj/item/modkit/mutie/ncr_heavy_trooper_armour
	name = "Mutie Heavy Trooper Armour modkit"
	target_items = list(/obj/item/clothing/suit/armor/heavy/salvaged_pa/t45b/ncr)
	result_item = /obj/item/clothing/suit/armor/heavy/salvaged_pa/t45b/mutie/ncr

/obj/item/modkit/mutie/ncr_officer_helmet
	name = "Mutie Officer Helmet modkit"
	target_items = list(/obj/item/clothing/head/beret/ncr)
	result_item = /obj/item/clothing/head/helmet/f13/ncr/mutie

/obj/item/modkit/mutie/ncr_officer_armour
	name = "Mutie Officer Armour modkit"
	target_items = list(/obj/item/clothing/suit/armor/medium/vest/ncr/officerr)
	result_item = /obj/item/clothing/suit/armor/light/ncr/mutie
