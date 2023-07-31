///Item boxes for custom loadouts transferred from Legacy.

/obj/item/storage/box/large/custom_kit
	name = "Custom Loadout"
	desc = "Your custom loadout items!"
	w_class = WEIGHT_CLASS_BULKY

//And here we get into the mutie shite
//NCR

/obj/item/storage/box/large/custom_kit/mutie/vet_ranger
	name = "Mutant Veteran Ranger"
	desc = "Contains a set of Mutant Veteran Ranger Combat Armour and a Helmet. Also contains their uniform."

/obj/item/storage/box/large/custom_kit/mutie/vet_ranger/PopulateContents()
	new /obj/item/clothing/head/helmet/f13/ncr/veteran/mutie(src)
	new /obj/item/clothing/suit/armor/medium/combat/mk2/ncr/vetranger/mutie(src)
	new /obj/item/clothing/under/f13/mutie/ncr/ranger(src)
	new /obj/item/clothing/shoes/f13/mutie/boots/ncr/ranger(src)
	new /obj/item/clothing/gloves/f13/mutie/gloves(src)

/obj/item/storage/box/large/custom_kit/mutie/ranger
	name = "Mutant Ranger"
	desc = "Contains a set of Mutant Ranger Armour and a Helmet. Also contains their uniform."

/obj/item/storage/box/large/custom_kit/mutie/ranger/PopulateContents()
	new /obj/item/clothing/head/f13/ncr/patrol/mutie(src)
	new /obj/item/clothing/suit/armor/medium/combat/patrol/mutie(src)
	new /obj/item/clothing/under/f13/mutie/ncr/ranger(src)
	new /obj/item/clothing/shoes/f13/mutie/boots/ncr/ranger(src)
	new /obj/item/clothing/gloves/f13/mutie/gloves(src)

/obj/item/storage/box/large/custom_kit/mutie/civ_ranger
	name = "Mutant Civilian Ranger"
	desc = "Contains a set of Mutant Civilian Ranger Combat Armour and a Helmet. Also contains their uniform."

/obj/item/storage/box/large/custom_kit/mutie/civ_ranger/PopulateContents()
	new /obj/item/clothing/head/f13/ncr/patrol/mutie(src)
	new /obj/item/clothing/suit/armor/light/ncr/trailranger/mutie(src)
	new /obj/item/clothing/under/f13/mutie/ncr/ranger(src)
	new /obj/item/clothing/shoes/f13/mutie/boots/ncr/ranger(src)
	new /obj/item/clothing/gloves/f13/mutie/gloves(src)

/obj/item/storage/box/large/custom_kit/mutie/ncr_officer
	name = "Mutant NCR Officer"
	desc = "Contains the armour and helmet of a Mutant NCR Officer. Also contains their uniform."

/obj/item/storage/box/large/custom_kit/mutie/ncr_officer/PopulateContents()
	new /obj/item/clothing/head/helmet/f13/ncr/mutie(src)
	new /obj/item/clothing/suit/armor/light/ncr/mutie(src)
	new /obj/item/clothing/under/f13/mutie/ncr/officer(src)
	new /obj/item/clothing/shoes/f13/mutie/boots/ncr(src)
	new /obj/item/clothing/gloves/f13/mutie/gloves(src)

/obj/item/storage/box/large/custom_kit/mutie/ncr_heavy_trooper
	name = "Mutant NCR Heavy Trooper"
	desc = "Contains the armour and helmet of a Mutant NCR Heavy Trooper. Also contains their uniform."

/obj/item/storage/box/large/custom_kit/mutie/ncr_heavy_trooper/PopulateContents()
	new /obj/item/clothing/head/helmet/f13/heavy/salvaged_pa/t45b/mutie/ncr(src)
	new /obj/item/clothing/suit/armor/heavy/salvaged_pa/t45b/mutie/ncr(src)
	new /obj/item/clothing/under/f13/mutie/ncr/heavy(src)
	new /obj/item/clothing/shoes/f13/mutie/boots/ncr(src)
	new /obj/item/clothing/gloves/f13/mutie/gloves(src)

/obj/item/storage/box/large/custom_kit/mutie/ncr_trooper
	name = "Mutant NCR Trooper"
	desc = "Contains the armour and helmet of a Mutant NCR Trooper. Also contains their uniform."

/obj/item/storage/box/large/custom_kit/mutie/ncr_trooper/PopulateContents()
	new /obj/item/clothing/head/helmet/f13/ncr/mutie(src)
	new /obj/item/clothing/suit/armor/light/ncr/mutie(src)
	new /obj/item/clothing/under/f13/mutie/ncr(src)
	new /obj/item/clothing/shoes/f13/mutie/boots/ncr(src)
	new /obj/item/clothing/gloves/f13/mutie/gloves(src)

//Townies

/obj/item/storage/box/large/custom_kit/mutie/townie
	name = "Mutant Townie"
	desc = "Contains the clothing typically worn by Mutant townies. Also contains their under clothes."

/obj/item/storage/box/large/custom_kit/mutie/townie/PopulateContents()
	new /obj/item/clothing/suit/hooded/cloak/mutie/poncho/weathered/townie(src)
	new /obj/item/clothing/under/f13/mutie/townie(src)
	new /obj/item/clothing/shoes/f13/mutie/boots(src)
	new /obj/item/clothing/gloves/f13/mutie/sign(src)

/obj/item/storage/box/large/custom_kit/mutie/labourer
	name = "Mutant Townie Labourer"
	desc = "Contains the clothing typically worn by Mutant Farmers, Prospectors, or even traders. Also contains their under clothes."

/obj/item/storage/box/large/custom_kit/mutie/labourer/PopulateContents()
	new /obj/item/clothing/suit/hooded/cloak/mutie/poncho/weathered/townie(src)
	new /obj/item/clothing/under/f13/mutie/townie/overalls(src)
	new /obj/item/clothing/shoes/f13/mutie(src)
	new /obj/item/clothing/gloves/f13/mutie(src)

/obj/item/storage/box/large/custom_kit/mutie/townie/police
	name = "Mutant Deputy"
	desc = "Contains the clothing typically worn by Mutant Deputies and Sheriffs. Also contains their under clothes."

/obj/item/storage/box/large/custom_kit/mutie/townie/police/PopulateContents()
	new /obj/item/clothing/suit/armor/medium/duster/mutie(src)
	new /obj/item/clothing/under/f13/mutie/townie/deputy(src)
	new /obj/item/clothing/shoes/f13/mutie/boots(src)
	new /obj/item/clothing/gloves/f13/mutie/sign(src)
