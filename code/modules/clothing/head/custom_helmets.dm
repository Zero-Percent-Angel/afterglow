/*
This file contains all modkit helmet item paths. Why is this file used instead of light, medium, heavy or power armor helmet files?
1. To avoid clutter - ALL custom items that are modkits are to be put here. No exemptions.
2. To avoid abuse of item-setting - ALL custom items that are modkits NEVER should have unique helmet values.
3. ALL custom items that are modkits should ALWAYS pull from a master file. I.E - your custom helmet a varient of T-45? Then pull from T-45. Do NOT make it a unique path.

Below you will find all the templates for modkit items.*/

//Custom item - BOS Mid-West ATA, sprited by Rebel0 / Mariya Sankinova
/obj/item/clothing/head/helmet/f13/power_armor/t45d/mari
	name = "modified midwestern power helmet"
	desc = "This helmet once belonged to the Midwestern branch of the Brotherhood of Steel. Though it appears to sport a new paintjob now as well as a few modifications to its helmet; specified to fit the wearer."
	icon_state = "marihelm"
	item_state = "marihelm"

//You need this if you want the helmet to have a light on/off state; otherwise the icon will not update between them.
/obj/item/clothing/head/helmet/f13/power_armor/t45d/mari/update_icon_state()
	icon_state = "marihelm[light_on]"
	item_state = "marihelm[light_on]"

//Custom item - T60; meant to be an alt-sprite for T45; it is just cheaper T45 anyway in-lore.
/obj/item/clothing/head/helmet/f13/power_armor/t45d/t60
	name = "T-60a power helmet"
	desc = "The T-60 powered helmet, equipped with targetting software suite, Friend-or-Foe identifiers, dynamic HuD, and an internal music player."
	icon_state = "t60helmet0"
	item_state = "t60helmet0"
	actions_types = list(/datum/action/item_action/toggle_helmet_light)

/obj/item/clothing/head/helmet/f13/power_armor/t60/update_icon_state()
	icon_state = "t60helmet[light_on]"
	item_state = "t60helmet[light_on]"

//Custom item - Hellfire; meant to be an alt-sprite for hardened advanced PA (Enclave PA)
/obj/item/clothing/head/helmet/f13/power_armor/x02helmet/hellfire
	name = "hellfire power armor"
	desc = "A deep black helmet of Enclave-manufactured heavy power armor with yellow ballistic glass, based on pre-war designs such as the T-51 and improving off of data gathered by post-war designs such as the X-01. Most commonly fielded on the East Coast, no other helmet rivals it's strength."
	icon_state = "hellfirehelm"
	item_state = "hellfirehelm"
