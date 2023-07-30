//This is the file that handles donator loadout items.

/datum/gear/donator
	name = "IF YOU SEE THIS, PING A CODER RIGHT NOW!"
	slot = SLOT_IN_BACKPACK
	path = /obj/item/storage/belt/shoulderholster/ranger45
	category = LOADOUT_CATEGORY_DONATOR
	subcategory = LOADOUT_SUBCATEGORY_DONATOR_DONATOR
	ckeywhitelist = list("This entry should never appear with this variable set.") //If it does, then that means somebody fucked up the whitelist system pretty hard
	cost = 0

/datum/gear/donator/donortestingbikehorn
	name = "Donor item testing"
	slot = SLOT_IN_BACKPACK
	path = /obj/item/storage/belt/shoulderholster/ranger45
	geargroupID = list("DONORTEST") //This is a list mainly for the sake of testing, but geargroupID works just fine with ordinary strings


/////////////////////
///MUTIE LOADOUTS//// Do not touch these unless you know what it is you are changing. Please and thank you - Asterix
/////////////////////

/datum/gear/donator/kits/mutie
	subcategory = LOADOUT_SUBCATEGORY_DONATOR_MUTIE
	ckeywhitelist = list("asterixcodix","yecrowbarman","tzula","spensara","bengalninja","wotzizname",
					"tamedachilles","southernsaint","zeropercentangel","melodicdeity","brainbodger",
					"afroterk","theetneralflame","myrios","omnisalad","zephyrtfa","daemontinadel",
					"sb208")

//NCR

/datum/gear/donator/kits/muite/ncr
	name = "Mutant NCR Trooper"
	path = /obj/item/storage/box/large/custom_kit/mutie/ncr_trooper
	restricted_desc = "NCR"
	restricted_roles = list("NCR Colonel",
							"NCR Captain",
							"NCR Lieutenant",
							"NCR Sergeant",
							"NCR Heavy Trooper",
							"NCR Corporal",
							"NCR Trooper",
							"NCR Recruit",
							"NCR Rear Echelon",
							"NCR Off-Duty"
							)
	cost = 5

/datum/gear/donator/kits/muite/heavy
	name = "Mutant NCR Heavy Trooper"
	path = /obj/item/storage/box/large/custom_kit/mutie/ncr_heavy_trooper
	restricted_desc = "NCR Heavy Trooper"
	restricted_roles = list("NCR Heavy Trooper")

/datum/gear/donator/kits/muite/ncr/officer
	name = "Mutant NCR Officer"
	path = /obj/item/storage/box/large/custom_kit/mutie/ncr_officer
	restricted_desc = "NCR"
	restricted_roles = list("NCR Colonel",
							"NCR Captain",
							"NCR Lieutenant"
							)

/datum/gear/donator/kits/muite/ncr/ranger
	name = "Mutant Ranger"
	path = /obj/item/storage/box/large/custom_kit/mutie/ranger
	restricted_desc = "NCR Rangers"
	restricted_roles = list("NCR Ranger",
							"NCR Civilian Ranger")

/datum/gear/donator/kits/muite/ncr/ranger/vet
	name = "Mutant Veteran Ranger"
	path = /obj/item/storage/box/large/custom_kit/mutie/vet_ranger
	restricted_desc = "NCR Veteran Ranger"
	restricted_roles = list("NCR Veteran Ranger")

//Mutownie

/datum/gear/donator/kits/muite/townie
	name = "Mutant Townie"
	path = /obj/item/storage/box/large/custom_kit/mutie/townie
	restricted_desc = "Ripley/Klamat"
	restricted_roles = list("Mayor",
							"Secretary",
							"Sheriff",
							"Deputy",
							"Doctor",
							"Citizen",
							"Shopkeeper",
							"Farmer",
							"Prospector",
							"Detective",
							"Barkeep"
							)
	cost = 4

/datum/gear/donator/kits/muite/townie/deputy
	name = "Mutant Police"
	path = /obj/item/storage/box/large/custom_kit/mutie/townie/police
	restricted_desc = "Ripley/Klamat"
	restricted_roles = list("Mayor",
							"Secretary",
							"Sheriff",
							"Deputy",
							"Detective"
							)

/datum/gear/donator/kits/muite/townie/labourer
	name = "Mutant Labourer"
	path = /obj/item/storage/box/large/custom_kit/mutie/labourer
	restricted_desc = "Ripley/Klamat"
	restricted_roles = list("Citizen",
							"Ripley Trade Worker",
							"Farmer",
							"Prospector",
							"Barkeep"
							)

//Other Mutie

/datum/gear/donator/mutie
	subcategory = LOADOUT_SUBCATEGORY_DONATOR_MUTIE
	ckeywhitelist = list("asterixcodix","yecrowbarman","tzula","spensara","bengalninja","wotzizname",
					"tamedachilles","southernsaint","zeropercentangel","melodicdeity","brainbodger",
					"afroterk","theetneralflame","myrios","omnisalad","zephyrtfa","daemontinadel",
					"sb208")
	cost = 1

/datum/gear/donator/mutie/helmet
	name = "Mutant Aviator Hat"
	path = /obj/item/clothing/head/helmet/f13/mutie

/datum/gear/donator/mutie/helmet/metal
	name = "Mutant Bladed Helmet"
	path = /obj/item/clothing/head/helmet/knight/f13/metal/mutie

/datum/gear/donator/mutie/helmet/metal/knight
	name = "Mutant Knight Helmet"
	path = /obj/item/clothing/head/helmet/knight/f13/metal/mutie/knight

/datum/gear/donator/mutie/helmet/metal/crown
	name = "Mutant Crowned Helmet"
	path = /obj/item/clothing/head/helmet/knight/f13/metal/mutie/knight/crown

/datum/gear/donator/mutie/under
	name = "Mutant Shorts"
	path = /obj/item/clothing/under/f13/mutie

/datum/gear/donator/mutie/under/santa
	name = "Mutant Red and White Jumpsuit"
	path = /obj/item/clothing/under/f13/mutie/santa

/datum/gear/donator/mutie/under/vault
	name = "Mutant Vault Jumpsuit"
	path = /obj/item/clothing/under/f13/mutie/vault

/datum/gear/donator/mutie/under/loincloth
	name = "Mutant Loincloth"
	path = /obj/item/clothing/under/f13/mutie/cloth

/datum/gear/donator/mutie/under/suit
	name = "Mutant Suit"
	path = /obj/item/clothing/under/f13/mutie/suit

/datum/gear/donator/mutie/under/suit/burgundy
	name = "Mutant Burgundy Suit"
	path = /obj/item/clothing/under/f13/mutie/suit/burgundy

/datum/gear/donator/mutie/under/suit/purple
	name = "Mutant Purple Suit"
	path = /obj/item/clothing/under/f13/mutie/suit/purple

/datum/gear/donator/mutie/under/suit/purple/pinstripe
	name = "Mutant Purple Zootsuit"
	path = /obj/item/clothing/under/f13/mutie/suit/purple/pinstripe

/datum/gear/donator/mutie/under/suit/purple/pinstripe/torn
	name = "Mutant Torn Purple Zootsuit"
	path = /obj/item/clothing/under/f13/mutie/suit/purple/pinstripe/torn

/datum/gear/donator/mutie/under/police
	name = "Mutant Police"
	path = /obj/item/clothing/under/f13/mutie/townie/police

/datum/gear/donator/mutie/armour/light
	name = "Mutant Forged Armour"
	path = /obj/item/clothing/suit/armor/light/mutie

/datum/gear/donator/mutie/armour
	name = "Mutant Metal Armour"
	path = /obj/item/clothing/suit/armor/medium/vest/breastplate/scrap/mutie

/datum/gear/donator/mutie/cloak
	name = "Mutant Cloak"
	path = /obj/item/clothing/suit/hooded/cloak/mutie

/datum/gear/donator/mutie/poncho
	name = "Mutant Poncho"
	path = /obj/item/clothing/suit/hooded/cloak/mutie/poncho

/datum/gear/donator/mutie/poncho
	name = "Mutant Poncho"
	path = /obj/item/clothing/suit/hooded/cloak/mutie/weathered

/////////////////////
///Loadout Boxes///// See kits.dm, use this model for loadouts that have more than one item per character.
/////////////////////
/datum/gear/donator/kits
	slot = SLOT_IN_BACKPACK


/*example
/datum/gear/donator/kits/averyamadeus
	name = "Avery Amadeus' belongings"
	path = /obj/item/storage/box/large/custom_kit/averyamadeus
	ckeywhitelist = list("topbirb")
*/

//Please alphebetize entries by ckey.
// A
// B
// C
// D
// E
// F
// G
// H
// I
// J
// K
// L
// M
// N
// O
// P
// Q
// R
// S
// T
// U
// V
// W
// X
// Y
// Z
