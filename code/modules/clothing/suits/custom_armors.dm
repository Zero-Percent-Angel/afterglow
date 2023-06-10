/*
This file contains all modkit armor item paths. Why is this file used instead of light, medium, heavy or power armor files?
1. To avoid clutter - ALL custom items that are modkits are to be put here. No exemptions.
2. To avoid abuse of item-setting - ALL custom items that are modkits NEVER should have unique armor values.
3. ALL custom items that are modkits should ALWAYS pull from a master file. I.E - your custom armor a varient of T-45? Then pull from T-45. Do NOT make it a unique path.

Make sure you ALWAYS direct the icon path of these custom items to: "suit(s)_custom.dmi" - otherwise your sprite will not work! This is for organization simplicity.

Below you will find all the templates for modkit items.*/

//Custom item - BOS Mid-West ATA, sprited by Rebel0 / Mariya Sankinova
/obj/item/clothing/suit/armor/f13/power_armor/t45d/mari
	name = "modified midwestern power armor"
	desc = "This set of power armor once belonged to the Midwestrn branch of the Brotherhood. Though now it appears to be modified and sporting a new paintjob reflecting its new chapter colors."
	icon = 'icons/fallout/clothing/custom/suits_custom.dmi'
	icon_state = "mariarmor"
	item_state = "mariarmor"

//Custom item - T60 PA; literally just an alt of T45 since it's just a mass-produced T45 piece in-lore anyway.
/obj/item/clothing/suit/armor/power_armor/t45d/t60
	name = "T-60a power armor"
	desc = "Developed in early 2077 after the Anchorage Reclamation, the T-60 series of power armor was designed to eventually replace the T-51b as the pinnacle of powered armor technology in the U.S. military arsenal."
	icon_state = "t60powerarmor"
	item_state = "t60powerarmor"

//Custom item - Hellfire PA; literally just an alt of x02 snowflake stuff.
/obj/item/clothing/suit/armor/power_armor/advanced/x02/hellfire
	name = "hellfire power armor"
	desc = "A deep black helmet of Enclave-manufactured heavy power armor, based on pre-war designs such as the T-51 and improving off of data gathered by post-war designs such as the X-01. Most commonly fielded on the East Coast, no other helmet rivals it's strength."
	icon_state = "hellfire"
	item_state = "hellfire"
