//////////////////////////////////////////
// 										//
//										//
//			PRIMITIVE MEDICAL			//
//										//
//										//
//////////////////////////////////////////

// ------------------- BUTCHERS TABLE -----------------------------

/obj/structure/table/optable/primitive
	name = "butchers table"
	desc = "Used for painful, primitive medical procedures."
	icon = 'modular_afterglow/icons/primitive_medical.dmi'


// ------------------- PRIMITIVE SURGERY STUFF -----------------------------  Could use more janky ghetto stuff feeling, messing about in the wound datums maybe or whatnot. Currently basically reskins with a bit slower speed.

/obj/item/cautery/primitive
	name = "primitive cautery"
	desc = "A welding device tuned down to cauterize wounds. Not very precise."
	icon = 'modular_afterglow/icons/primitive_medical.dmi'
	righthand_file = 'modular_afterglow/legio_invicta/icons/onmob_legion_righthand.dmi'
	lefthand_file = 'modular_afterglow/legio_invicta/icons/onmob_legion_lefthand.dmi'
	icon_state = "cautery_primitive"
	toolspeed = 1.5

/obj/item/circular_saw/primitive
	name = "handsaw"
	desc = "For sawing through wood or possibly bones."
	icon = 'modular_afterglow/icons/primitive_medical.dmi'
	icon_state = "saw"
	item_state = "saw"
	lefthand_file = 'icons/mob/inhands/equipment/tools_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/equipment/tools_righthand.dmi'
	hitsound = 'sound/effects/shovel_dig.ogg'
	usesound = 'sound/effects/shovel_dig.ogg'
	custom_materials = list(/datum/material/iron=2000)
	toolspeed = 1.2
	wound_bonus = 0
	bare_wound_bonus = 10
	attack_verb = list("sawed", "scratched")

/obj/item/stack/medical/bone_gel/superglue
	name = "superglue (bonegel)"
	singular_name = "superglue"
	desc = "Good for gluing together broken bones!"
	icon = 'modular_afterglow/icons/primitive_medical.dmi'
	icon_state = "superglue"
	lefthand_file = NONE
	righthand_file = NONE
	grind_results = NONE

/obj/item/reagent_containers/medspray/sterilizine/honey
	name = "medical honey (sterilizer)"
	desc = "Pure honey has antiseptic properties, and probably works just as a sterilizing agent."
	icon = 'modular_afterglow/icons/primitive_medical.dmi'
	icon_state = "sterilizer_honey"
	apply_method = "smear"

/obj/item/storage/backpack/duffelbag/med/surgery/primitive
	name = "surgical duffel bag"
	desc = "A large duffel bag for holding extra medical supplies - this one seems to be designed for holding surgical tools."
	icon = 'modular_afterglow/icons/primitive_medical.dmi'
	righthand_file = 'modular_afterglow/legio_invicta/icons/onmob_legion_righthand.dmi'
	lefthand_file = 'modular_afterglow/legio_invicta/icons/onmob_legion_lefthand.dmi'
	icon_state = "toolbag_primitive"

/obj/item/storage/backpack/duffelbag/med/surgery/primitive/PopulateContents()
	new /obj/item/scalpel(src)
	new /obj/item/hemostat/tribal(src)
	new /obj/item/retractor/tribal(src)
	new /obj/item/circular_saw/primitive(src)
	new /obj/item/cautery/primitive(src)
	new /obj/item/bonesetter(src)
	new /obj/item/bedsheet/blanket(src)
	new /obj/item/reagent_containers/medspray/sterilizine/honey(src)
	new /obj/item/stack/sticky_tape/surgical(src)
	new /obj/item/stack/medical/bone_gel/superglue(src)

/obj/item/storage/backpack/duffelbag/med/surgery/primitive/anchored
	name = "surgical toolset"
	desc = "Large piece of felt with various surgical tools laid out."
	icon_state = "surgicalset_primitive"
	anchored = TRUE

/obj/machinery/iv_drip/primitive
	name = "wooden IV drip"
	desc = "Simple frame for infusing liquids using gravity. Can't suck out fluids."
	icon = 'modular_afterglow/icons/primitive_medical.dmi'
	anchored = TRUE
	plane = MOB_PLANE

//////////////////////////////////////////
// 										//
//										//
//				LEGION SIGNS			//
//										//
//										//
//////////////////////////////////////////

/obj/structure/sign/legion
	name = "war room"
	desc = "For planning the next great victory!"
	icon = 'modular_afterglow/legio_invicta/icons/icons_legion.dmi'
	icon_state = "sign"
	layer = SIGN_LAYER

/obj/structure/sign/legion/radio
	name = "radio room"
	desc = "Spare radios and radio linking equipment are kept here"

/obj/structure/sign/legion/medicus
	name = "medicus tent"
	desc = "Caesar approves the methods used here. Degenerates not welcome."
	icon_state = "sign_medicus"
	layer = BELOW_MOB_LAYER

/obj/structure/sign/legion/recruit
	name = "recruit barracks"
	desc = "The decanus sleeps with his men and keeps track of them." // Theyre definitively straight
	icon_state = "sign_ground"

/obj/structure/sign/legion/smithy
	name = "smithy"
	desc = "Where weapons are forged and tools stored"

/obj/structure/sign/legion/armory
	name = "armory"
	desc = "Great amounts of weapons and equipment are stored here"

/obj/structure/sign/legion/prime
	name = "prime barracks"
	desc = "Primes and their decanus live here"
	icon_state = "sign_ground"

/obj/structure/sign/legion/veteran
	name = "veteran barracks"
	desc = "Experienced troops live here in comparable comfort."

/obj/structure/sign/legion/mess
	name = "mess pavillion"
	desc = "Food and a place to talk to brothers in arms."
	icon_state = "sign_ground"

/obj/structure/sign/legion/gym
	name = "the temple"
	desc = "Build your body or use it as a speaking platform."

/obj/structure/sign/legion/latrine
	name = "latrine"
	desc = "Has a certain odor."
	icon_state = "sign_ground"

/obj/structure/sign/legion/mines
	name = "mines"
	desc = "Put slave here"
	icon_state = "sign_chain"

/obj/structure/sign/legion/prison
	name = "prison"
	desc = "Lets the prisoner enjoy the local climate without interfering roofing."
	icon_state = "sign_ground"

/obj/structure/sign/legion/storeroom
	name = "storeroom"
	desc = "a place to store low-value goods and slaving equipment."

/obj/structure/sign/legion/records
	name = "office of records"
	desc = "Where the Treasurer and other nerds store paperwork about stores and payrolls, and maybe the treasury."

/obj/structure/sign/legion/stronghold
	name = "stronghold"
	desc = "Main building, fortified."

/obj/structure/sign/legion/guardhouse
	name = "guardhouse"
	desc = "Sit in the gloom and wait for something to happen."
