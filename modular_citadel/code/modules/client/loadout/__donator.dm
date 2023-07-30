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

/datum/gear/donator/kits/muite/townie/deputy
	name = "Mutant Police"
	path = /obj/item/storage/box/large/custom_kit/mutie/townie/deputy
	restricted_desc = "Ripley/Klamat"
	restricted_roles = list("Mayor",
							"Secretary",
							"Sheriff",
							"Deputy"
							"Detective"
							)

//Other Mutie

/datum/gear/donator/mutie
	subcategory = LOADOUT_SUBCATEGORY_DONATOR_MUTIE
	ckeywhitelist = list("asterixcodix","yecrowbarman","tzula","spensara","bengalninja","wotzizname",
					"tamedachilles","southernsaint","zeropercentangel","melodicdeity","brainbodger",
					"afroterk","theetneralflame","myrios","omnisalad","zephyrtfa","daemontinadel",
					"sb208")

/datum/gear/donator/mutie/helmet
	name = "Mutant Aviator Hat"
	path = /obj/item/clothing/head/helmet/f13/mutie
	cost = 1

/datum/gear/donator/mutie/helmet/metal
	name = "Mutant Bladed Helmet"
	path = /obj/item/clothing/head/helmet/knight/f13/metal/mutie

/datum/gear/donator/mutie/helmet/metal/knight
	name = "Mutant Knight Helmet"
	path = /obj/item/clothing/head/helmet/knight/f13/metal/mutie/knight

/datum/gear/donator/mutie/helmet/metal/crown
	name = "Mutant Crowned Helmet"
	path = /obj/item/clothing/head/helmet/knight/f13/metal/mutie/knight/crown

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
