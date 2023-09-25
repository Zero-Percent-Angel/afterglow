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

/datum/gear/donator/mutie
	name = "Coin"
	path = /obj/item/coin/silver
	subcategory = LOADOUT_SUBCATEGORY_DONATOR_MUTIE
	ckeywhitelist = list("asterixcodix","yecrowbarman","tzula","spensara","bengalninja","wotzizname",
					"tamedachilles","southernsaint","zeropercentangel","melodicdeity","brainbodger",
					"afroterk","theetneralflame","myrios","omnisalad","zephyrtfa","daemontinadel",
					"sb208","oblivionandbeyondthestars","sanshoom","medalis","wh0t00kthejam","theman1178",
					"spockye","xenonia","breensecuter","fluidhelix","charliehere","ryzzz3n","ourlordspungus",
					"manyfacedfool","ifrickfracki","mikuel","Theshroudedlord")
	cost = 1

/datum/gear/donator/mutie/helmet
	name = "Mutant Aviator Hat"
	path = /obj/item/clothing/head/helmet/f13/mutie
	slot = SLOT_HEAD

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
	slot = SLOT_W_UNIFORM

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
	slot = SLOT_WEAR_SUIT

/datum/gear/donator/mutie/armour
	name = "Mutant Metal Armour"
	path = /obj/item/clothing/suit/armor/medium/vest/breastplate/scrap/mutie

/datum/gear/donator/mutie/armour/cloak
	name = "Mutant Cloak"
	path = /obj/item/clothing/suit/hooded/cloak/mutie

/datum/gear/donator/mutie/armour/poncho
	name = "Mutant Poncho"
	path = /obj/item/clothing/suit/hooded/cloak/mutie/poncho

/datum/gear/donator/mutie/armour/poncho
	name = "Mutant Weathered Poncho"
	path = /obj/item/clothing/suit/hooded/cloak/mutie/poncho/weathered

/datum/gear/donator/mutie/gloves
	name = "Mutant Bracers"
	path = /obj/item/clothing/gloves/f13/mutie
	slot = SLOT_GLOVES

/datum/gear/donator/mutie/gloves/signs
	name = "Mutant Sign Bracers"
	path = /obj/item/clothing/gloves/f13/mutie/sign

/datum/gear/donator/mutie/gloves/gloves
	name = "Mutant Gloves"
	path = /obj/item/clothing/gloves/f13/mutie/gloves

/datum/gear/donator/mutie/shoes
	name = "Mutant Sandals"
	path = /obj/item/clothing/shoes/f13/mutie
	slot = SLOT_SHOES

/datum/gear/donator/mutie/shoes
	name = "Mutant Boots"
	path = /obj/item/clothing/shoes/f13/mutie/boots

/datum/gear/donator/mutie/shoes/dark
	name = "Mutant Dark Boots"
	path = /obj/item/clothing/shoes/f13/mutie/boots/dark

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
