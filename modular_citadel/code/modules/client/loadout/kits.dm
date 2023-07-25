///Item boxes for custom loadouts transferred from Legacy.

/obj/item/storage/box/large/custom_kit
	name = "Custom Loadout"
	desc = "Your custom loadout items!"
	w_class = WEIGHT_CLASS_BULKY

//And here we get into the mutie shite

/obj/item/storage/box/large/custom_kit/mutie/vet_ranger
	name = "Mutant Veteran Ranger"
	desc = "Contains the necessary equipment to modify the Veteran Ranger Combat Armour and Helmet, to better fit a Mutant. Also contains their uniform."

/obj/item/storage/box/large/custom_kit/mutie/vet_ranger/PopulateContents()
	new /obj/item/modkit/mutie/vet_ranger_helmet(src)
	new /obj/item/modkit/mutie/vet_ranger_armour(src)
	new /obj/item/clothing/under/f13/mutie/ncr/ranger(src)
	new /obj/item/clothing/shoes/f13/mutie/boots/ncr/ranger(src)
	new /obj/item/clothing/gloves/f13/mutie/gloves(src)

/obj/item/clothing/suit/armor/medium/combat/patrol/mutie

/obj/item/storage/box/large/custom_kit/mutie/ranger
	name = "Mutant Ranger"
	desc = "Contains the necessary equipment to modify the standard issue Ranger armour and helmet, to better fit a Mutant. Also contains their uniform."

/obj/item/storage/box/large/custom_kit/mutie/ranger/PopulateContents()
	new /obj/item/modkit/mutie/ranger_helmet(src)
	new /obj/item/modkit/mutie/ranger_armour(src)
	new /obj/item/clothing/under/f13/mutie/ncr/ranger(src)
	new /obj/item/clothing/shoes/f13/mutie/boots/ncr/ranger(src)
	new /obj/item/clothing/gloves/f13/mutie/gloves(src)

/obj/item/storage/box/large/custom_kit/mutie/ncr_trooper
	name = "Mutant NCR Trooper"
	desc = "Contains the necessary equipment to modify the standard issue NCR armour and helmet, to better fit a Mutant. Also contains their uniform."

/obj/item/storage/box/large/custom_kit/mutie/ncr_trooper/PopulateContents()
	new /obj/item/modkit/mutie/ncr_trooper_helmet(src)
	new /obj/item/modkit/mutie/ncr_trooper_armour(src)
	new /obj/item/clothing/under/f13/mutie/ncr(src)
	new /obj/item/clothing/shoes/f13/mutie/boots/ncr(src)
	new /obj/item/clothing/gloves/f13/mutie/gloves(src)
