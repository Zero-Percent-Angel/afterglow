/obj/item/clothing/head/helmet/f13
	name = "Generic helmet"
	desc = "This is a helmet master-path. You shouldn't be seeing this.."
	icon = 'icons/fallout/clothing/hats.dmi'					// Someone should repath all helmets to here at some point. I cannot be fucked to rn though, holy shit. -Rebel0
	mob_overlay_icon = 'icons/fallout/onmob/clothes/head.dmi'
	armor = ARMOR_VALUE_LIGHT

/obj/item/clothing/head/helmet/f13/raider
	name = "yankee raider helmet"
	desc = "Long time ago, it has belonged to a football player, now it belongs to wasteland."
	icon_state = "yankee"
	item_state = "yankee"
	flags_inv = HIDEEARS|HIDEEYES|HIDEFACE

/obj/item/clothing/head/helmet/f13/raider/arclight
	name = "arclight raider helmet"
	desc = "Welding mask with rare polarizing glass thats somehow still in working order. A treasured item in the wasteland."
	icon_state = "arclight"
	item_state = "arclight"
	visor_flags_inv = HIDEMASK|HIDEEARS|HIDEEYES|HIDEFACE
	flash_protect = 2
	tint = 0.5
	can_toggle = 1

/obj/item/clothing/head/helmet/f13/motorcycle
	name = "motorcycle helmet"
	desc = "A type of helmet used by motorcycle riders.<br>The primary goal of a motorcycle helmet is motorcycle safety - to protect the rider's head during impact, thus preventing or reducing head injury and saving the rider's life."
	icon_state = "motorcycle"
	item_state = "motorcycle"
	flags_cover = HEADCOVERSEYES
	flags_inv = HIDEMASK|HIDEEARS|HIDEHAIR
	strip_delay = 10

/obj/item/clothing/head/helmet/f13/raider/eyebot
	name = "eyebot helmet"
	desc = "It is a dismantled eyebot, hollowed out to accommodate for a humanoid head."
	icon_state = "eyebot"
	item_state = "eyebot"
	flags_cover = HEADCOVERSEYES | HEADCOVERSMOUTH
	flags_inv = HIDEEARS|HIDEEYES|HIDEFACE|HIDEHAIR|HIDEFACIALHAIR
	strip_delay = 50
	resistance_flags = LAVA_PROOF | FIRE_PROOF
	dynamic_hair_suffix = ""
	dynamic_fhair_suffix = ""

/obj/item/clothing/head/helmet/f13/raider/blastmaster
	name = "blastmaster raider helmet"
	desc = "A sturdy helmet to protect against both the elements and from harm, if only it was not looking in such poor condition."
	icon_state = "blastmaster"
	item_state = "blastmaster"
	armor_tokens = list(ARMOR_MODIFIER_UP_BOMB_T3, ARMOR_MODIFIER_UP_DT_T1)
	dynamic_hair_suffix = ""
	dynamic_fhair_suffix = ""

/obj/item/clothing/head/helmet/f13/raider/yankee
	name = "yankee raider helmet"
	desc = "Long time ago, it has belonged to a football player, now it belongs to wasteland."
	icon_state = "yankee"
	item_state = "yankee"
	flags_inv = HIDEEARS|HIDEEYES|HIDEFACE

/obj/item/clothing/head/helmet/f13/fiend
	name = "fiend helmet"
	desc = "A leather cap cobbled together adorned with a bighorner skull, perfect for any drug-fueled frenzy."
	icon_state = "fiend"
	item_state = "fiend"
	flags_inv = HIDEEARS|HIDEHAIR

/obj/item/clothing/head/helmet/f13/fiend_reinforced
	name = "reinforced fiend helmet"
	desc = "A leather cap cobbled together adorned with a bighorner skull, perfect for any drug-fueled frenzy. This helmet has been reinforced with metal plates under its skull"
	icon_state = "fiend"
	item_state = "fiend"
	armor_tokens = list(ARMOR_MODIFIER_UP_DT_T2)
	flags_inv = HIDEEARS|HIDEHAIR
	slowdown = 0.025

/obj/item/clothing/head/helmet/f13/firefighter
	name = "firefighter helmet"
	desc = "A firefighter's helmet worn on top of a fire-retardant covering and broken gas mask.<br>It smells heavily of sweat."
	icon_state = "firefighter"
	item_state = "firefighter"
	flags_cover = HEADCOVERSEYES | HEADCOVERSMOUTH
	flags_inv = HIDEMASK|HIDEEARS|HIDEEYES|HIDEFACE|HIDEHAIR|HIDEFACIALHAIR
	cold_protection = HEAD
	min_cold_protection_temperature = SPACE_HELM_MIN_TEMP_PROTECT
	heat_protection = HEAD
	max_heat_protection_temperature = SPACE_HELM_MAX_TEMP_PROTECT
	strip_delay = 30
	resistance_flags = FIRE_PROOF

/obj/item/clothing/head/helmet/f13/deathskull
	name = "eerie helm"
	desc = "A helmet fastened from the skull of a deer. Something about it doesn't look right."
	icon_state = "shamskull"
	item_state = "shamskull"

/obj/item/clothing/head/helmet/f13/wayfarer/hunter
	name = "hunter headdress"
	desc = "Azure decorations dangle from the sturdy cap, it is sung that the wearers of these are watched over by the spirits."
	icon_state = "hunterhelm"
	item_state = "hunterhelm"

/obj/item/clothing/head/helmet/f13/wayfarer/antler
	name = "antler skullcap"
	desc = "An antler skull headdress traditionally worn by the spiritually inclined."
	icon_state = "antlerhelm"
	item_state = "antlerhelm"

/obj/item/clothing/head/helmet/f13/wastewarhat
	name = "warrior helmet"
	desc = "It might have been a cooking pot once, now its a helmet, with a piece of cloth covering the neck from the sun."
	icon = 'icons/fallout/clothing/helmets.dmi'
	mob_overlay_icon = 'icons/fallout/onmob/clothes/helmet.dmi'
	icon_state = "wastewar"
	item_state = "wastewar"
	flags_inv = HIDEEARS|HIDEHAIR

/obj/item/clothing/head/helmet/f13/combat
	name = "combat helmet"
	desc = "An old military grade pre-war combat helmet."
	icon_state = "combat_helmet"
	item_state = "combat_helmet"
	armor = ARMOR_VALUE_MEDIUM
	strip_delay = 50
	flags_inv = HIDEEARS|HIDEHAIR
	resistance_flags = LAVA_PROOF | FIRE_PROOF
	dynamic_hair_suffix = ""
	dynamic_fhair_suffix = ""
	salvage_loot = list(/obj/item/stack/crafting/armor_plate = 3)
	custom_price = PRICE_ABOVE_EXPENSIVE

/obj/item/clothing/head/helmet/f13/combat/dark
	color = "#302E2E" // Dark Grey

/obj/item/clothing/head/helmet/f13/combat/Initialize()
	. = ..()
	AddComponent(/datum/component/spraycan_paintable)
	START_PROCESSING(SSobj, src)

/obj/item/clothing/head/helmet/f13/combat/Destroy()
	STOP_PROCESSING(SSobj, src)
	return ..()

/obj/item/clothing/head/helmet/f13/combat/mk2
	name = "reinforced combat helmet"
	desc = "An advanced pre-war titanium plated, ceramic coated, kevlar, padded helmet designed to withstand extreme punishment of all forms."
	icon_state = "combat_helmet_mk2"
	item_state = "combat_helmet_mk2"
	armor_tokens = list(ARMOR_MODIFIER_UP_BULLET_T2, ARMOR_MODIFIER_UP_MELEE_T2)
	flags_inv = HIDEEARS|HIDEEYES|HIDEHAIR
	flags_cover = HEADCOVERSEYES
	salvage_loot = list(/obj/item/stack/crafting/armor_plate = 5)

/obj/item/clothing/head/helmet/f13/combat/mk2/dark
	name = "reinforced combat helmet"
	color = "#302E2E" // Dark Grey

/obj/item/clothing/head/helmet/f13/combat/raider
	name = "customized raider combat helmet"
	desc = "A reinforced combat helmet painted black with the laser designator removed."
	icon_state = "combat_helmet_raider"
	item_state = "combat_helmet_raider"

/obj/item/clothing/head/helmet/f13/combat/mk2/raider
	name = "customized reinforced raider combat helmet"
	desc = "A reinforced combat helmet painted black with the laser designator removed. This one has extra plating."
	icon_state = "combat_helmet_raider"
	item_state = "combat_helmet_raider"

/obj/item/clothing/head/helmet/f13/combat/tribal
	name = "tribalized combat helmet"
	desc = "An old military grade pre-war combat helmet, repainted and re-purposed with bones and sinew."
	icon_state = "tribe_helmet"
	item_state = "tribe_helmet"

/obj/item/clothing/head/helmet/f13/combat/mk2/tribal
	name = "tribalized reinforced helmet"
	desc = "An old military grade pre-war reinforced combat helmet, repainted and re-purposed with bones and sinew."
	icon_state = "tribe_helmet"
	item_state = "tribe_helmet"

/////////////////////////////
//Combat Helmets - Factions//
/////////////////////////////

//NCR
/obj/item/clothing/head/helmet/f13/combat/ncr
	name = "ncr combat helmet"
	desc = "An old military grade pre-war combat helmet. This one is marked with NCR colors."
	icon_state = "combat_helmet_ncr"
	item_state = "combat_helmet_ncr"
	armor = ARMOR_VALUE_MEDIUM
	strip_delay = 50
	flags_inv = HIDEEARS|HIDEHAIR
	resistance_flags = LAVA_PROOF | FIRE_PROOF
	dynamic_hair_suffix = ""
	dynamic_fhair_suffix = ""
	custom_price = PRICE_ABOVE_EXPENSIVE

/obj/item/clothing/head/helmet/f13/combat/mk2/ncr
	name = "ncr reinforced combat helmet"
	desc = "An advanced pre-war titanium plated, ceramic coated, kevlar, padded helmet designed to withstand extreme punishment of all forms. This one is marked with NCR colors."
	icon_state = "combat_helmet_ncr_mk2"
	item_state = "combat_helmet_ncr_mk2"
	armor_tokens = list(ARMOR_MODIFIER_UP_BULLET_T2, ARMOR_MODIFIER_UP_MELEE_T2)
	flags_inv = HIDEEARS|HIDEEYES|HIDEHAIR
	flags_cover = HEADCOVERSEYES

//Legion
/obj/item/clothing/head/helmet/f13/combat/legion
	name = "legion combat helmet"
	desc = "An old military grade pre-war combat helmet. This one is marked with Legion colors."
	icon_state = "combat_helmet_legion"
	item_state = "combat_helmet_legion"
	armor = ARMOR_VALUE_MEDIUM
	strip_delay = 50
	flags_inv = HIDEEARS|HIDEHAIR
	resistance_flags = LAVA_PROOF | FIRE_PROOF
	dynamic_hair_suffix = ""
	dynamic_fhair_suffix = ""
	custom_price = PRICE_ABOVE_EXPENSIVE

/obj/item/clothing/head/helmet/f13/combat/mk2/legion
	name = "legion reinforced combat helmet"
	desc = "An advanced pre-war titanium plated, ceramic coated, kevlar, padded helmet designed to withstand extreme punishment of all forms. This one is marked with Legion colors."
	icon_state = "combat_helmet_legion_mk2"
	item_state = "combat_helmet_legion_mk2"
	armor_tokens = list(ARMOR_MODIFIER_UP_BULLET_T2, ARMOR_MODIFIER_UP_MELEE_T2)
	flags_inv = HIDEEARS|HIDEEYES|HIDEHAIR
	flags_cover = HEADCOVERSEYES


/obj/item/clothing/head/helmet/f13/combat/rangerbroken
	name = "broken riot helmet"
	icon_state = "ranger_broken"
	item_state = "ranger_broken"
	desc = "An old riot police helmet, out of use around the time of the war."
	flags_inv = HIDEMASK|HIDEEARS|HIDEEYES|HIDEHAIR|HIDEFACIALHAIR|HIDEFACE
	flags_cover = HEADCOVERSEYES | HEADCOVERSMOUTH
	resistance_flags = LAVA_PROOF | FIRE_PROOF
	dynamic_hair_suffix = ""
	dynamic_fhair_suffix = ""
	flash_protect = 1

/obj/item/clothing/head/helmet/f13/combat/swat
	name = "SWAT combat helmet"
	desc = "A prewar combat helmet issued to S.W.A.T. personnel."
	icon_state = "swatsyndie"
	item_state = "swatsyndie"
	armor_tokens = list(ARMOR_MODIFIER_UP_MELEE_T2)

/obj/item/clothing/head/helmet/f13/combat/environmental
	name = "environmental armor helmet"
	desc = "A full head helmet and gas mask, developed for use in heavily contaminated environments."
	icon_state = "env_helmet"
	item_state = "env_helmet"
	armor_tokens = list(ARMOR_MODIFIER_UP_ENV_T2)
	strip_delay = 60
	equip_delay_other = 60
	flags_cover = HEADCOVERSEYES | HEADCOVERSMOUTH

/obj/item/clothing/head/helmet/f13/combat/environmental/ComponentInitialize()
	. = ..()
	AddComponent(/datum/component/rad_insulation, RAD_NO_INSULATION, TRUE, FALSE)

//Sulphite Helm

/obj/item/clothing/head/helmet/f13/sulphitehelm
	name = "sulphite helmet"
	desc = "A sulphite raider helmet, affixed with thick anti-ballistic glass over the eyes."
	icon_state = "sulphite_helm"
	item_state = "sulphite_helm"
	armor_tokens = list(ARMOR_MODIFIER_UP_BULLET_T2, ARMOR_MODIFIER_UP_MELEE_T2, ARMOR_MODIFIER_UP_FIRE_T3)
	flags_inv = HIDEMASK|HIDEEARS|HIDEEYES|HIDEFACE|HIDEHAIR|HIDEFACIALHAIR
	flags_cover = HEADCOVERSEYES | HEADCOVERSMOUTH

//Metal

/obj/item/clothing/head/helmet/knight/f13/metal
	name = "metal helmet"
	desc = "An iron helmet forged by tribal warriors, with a unique design to protect the face from arrows and axes."
	icon_state = "metalhelmet"
	item_state = "metalhelmet"
	flags_inv = HIDEMASK|HIDEEARS|HIDEEYES|HIDEFACE|HIDEHAIR|HIDEFACIALHAIR
	armor_tokens = list(ARMOR_MODIFIER_UP_LASER_T2, ARMOR_MODIFIER_UP_MELEE_T2)
	custom_price = PRICE_EXPENSIVE

/obj/item/clothing/head/helmet/knight/f13/metal/reinforced
	name = "reinforced metal helmet"
	icon_state = "metalhelmet_r"
	item_state = "metalhelmet_r"
	armor_tokens = list(ARMOR_MODIFIER_UP_BULLET_T1, ARMOR_MODIFIER_UP_LASER_T2, ARMOR_MODIFIER_UP_MELEE_T3)

//////////
//LEGION//
//////////

/obj/item/clothing/head/helmet/f13/legion
	name = "legion helmet template"
	desc = "should not exist."
	icon = 'icons/fallout/clothing/helmets.dmi'
	mob_overlay_icon = 'icons/fallout/onmob/clothes/head.dmi'
	lefthand_file = ""
	righthand_file = ""
	flags_inv = HIDEEARS|HIDEHAIR
	strip_delay = 50
	dynamic_hair_suffix = ""
	dynamic_fhair_suffix = ""
	salvage_loot = list(/obj/item/stack/crafting/armor_plate = 1)
	armor = ARMOR_VALUE_LIGHT

/////////////
/*LINE LEG */
/////////////

/obj/item/clothing/head/helmet/f13/legion/recruit
	name = "legion recruit helmet"
	desc = "It's a leather skullcap issued to recruits."
	icon_state = "legrecruit"
	item_state = "legrecruit"
	flags_inv = HIDEEARS|HIDEHAIR

/obj/item/clothing/head/helmet/f13/legion/prime
	name = "legion prime helmet"
	desc = "A helmet from reinforced leather with a red peak."
	icon_state = "legprime"
	item_state = "legprime"
	flags_inv = HIDEEARS|HIDEHAIR

/obj/item/clothing/head/helmet/f13/legion/vet
	name = "legion veteran helmet"
	desc = "It's a metal legion veteran helmet, clearly inspired by old world sports uniforms."
	icon_state = "legvet"
	item_state = "legvet"
	salvage_loot = list(/obj/item/stack/crafting/armor_plate = 2)
	flags_inv = HIDEEARS|HIDEHAIR
	armor = ARMOR_VALUE_MEDIUM

////////////////
/*RECON/SCOUT */
////////////////

/obj/item/clothing/head/helmet/f13/legion/explorer
	name = "legion explorer hood"
	desc = "It's a leather hood with metal reinforcments and built in headphones to plug the radio into."
	icon_state = "legion-hood"
	item_state = "legion-hood"
	flags_inv = HIDEEARS|HIDEHAIR

/obj/item/clothing/head/helmet/f13/legion/venator
	name = "legion venator hood"
	desc = "A leather hood with a sturdy metal skullcap and a gold bull insignia in the front."
	icon_state = "legion-venator"
	item_state = "legion-venator"

//////////
/*DECANI*/
//////////

/obj/item/clothing/head/helmet/f13/legion/recruit/decan
	name = "legion recruit decanus helmet"
	desc = "This reinforced leather helmet has a plume of black and dark red feathers."
	lefthand_file = ""
	righthand_file = ""
	icon_state = "legdecan"
	item_state = "legdecan"

/obj/item/clothing/head/helmet/f13/legion/prime/decan
	name = "legion prime decanus helmet"
	desc = "This reinforced leather helmet with a red peak has a plume of black feathers."
	lefthand_file = ""
	righthand_file = ""
	icon_state = "legdecanprime"
	item_state = "legdecanprime"

/obj/item/clothing/head/helmet/f13/legion/vet/decan
	name = "legion veteran decanus helmet"
	desc = "It's a metal helmet with an array of red, white and black feathers, unmistakably a Veteran Decanus."
	lefthand_file = ""
	righthand_file = ""
	icon_state = "legdecanvet"
	item_state = "legdecanvet"

/obj/item/clothing/head/helmet/f13/legion/vet/vexil
	name = "legion fox vexillarius helmet"
	desc = "This helmet is decorated with the pelt of a desert fox."
	icon_state = "legvex"
	item_state = "legvex"

/obj/item/clothing/head/helmet/f13/legion/vet/combvexil
	name = "legion bear vexillarius helmet"
	desc = "This helmet is decorated with the pelt of a ashland bear."
	lefthand_file = ""
	righthand_file = ""
	icon_state = "legvex_alt"
	item_state = "legvex_alt"

/obj/item/clothing/head/helmet/f13/legion/vet/decan/heavy
	name = "reinforced legion veteran decanus helmet"
	desc = "It's a metal helmet with an array of red, white, and black feathers. Unmistakably a Veterna Decanus's helmet. This one, however, sports a face-shield and plating to protect the user."
	lefthand_file = ""
	righthand_file = ""
	icon = 'icons/fallout/clothing/helmets.dmi'
	icon_state = "legheavy"
	item_state = "legheavy"
	can_toggle = 1

/////////////
/*CENTURION*/
/////////////

/obj/item/clothing/head/helmet/f13/legion/centurion
	name = "legion centurion helmet"
	desc = "A sturdy helmet from steel and brass with a red horizontal plume."
	lefthand_file = ""
	righthand_file = ""
	icon_state = "legion-centurion"
	item_state = "legion-centurion"
	resistance_flags = LAVA_PROOF | FIRE_PROOF
	armor = ARMOR_VALUE_HEAVY

/obj/item/clothing/head/helmet/f13/legion/palacent
	name = "legion centurion paladin-slayer helmet"
	desc = "The once-marvelous helmet of the T-45d power armor set, repurposed by the Legion into a symbol of its might. It has a large plume of red horse hair across the top of it going horizontally, donoting the rank of Centurion."
	lefthand_file = ""
	righthand_file = ""
	icon_state = "legcentpal"
	item_state = "legcentpal"
	resistance_flags = LAVA_PROOF | FIRE_PROOF
	armor = ARMOR_VALUE_SALVAGE

/obj/item/clothing/head/helmet/f13/legion/rangercent
	name = "legion centurion ranger-hunter helmet"
	desc = "The helmet of an NCR ranger, refit to serve as a Centurions helmet."
	lefthand_file = ""
	righthand_file = ""
	icon_state = "legcentrang"
	item_state = "legcentrang"
	resistance_flags = LAVA_PROOF | FIRE_PROOF
	armor = ARMOR_VALUE_MEDIUM

//Don't give this to anything outside of event crap
/obj/item/clothing/head/helmet/f13/legion/legate
	name = "legion legate helmet"
	desc = "A custom forged steel full helmet complete with abstract points and arches. The face is extremely intimidating, as it was meant to be. This particular one was ordered to be forged by Caesar, given to his second legate in exchange for his undying loyalty to Caesar."
	lefthand_file = ""
	righthand_file = ""
	icon_state = "legate"
	item_state = "legate"
	flags_cover = HEADCOVERSEYES | HEADCOVERSMOUTH
	flags_inv = HIDEEARS|HIDEEYES|HIDEHAIR
	resistance_flags = LAVA_PROOF | FIRE_PROOF

/obj/item/clothing/head/helmet/f13/legion/orator
	name = "legion death mask"
	desc = "A decorative helmet made of metal with a gold trim around its faceplate, etched with extremely fine details modeled into it. It looks life-like, as if modeled after a mans face..."
	icon_state = "legion-slavemaster"
	item_state = "legion-slavemaster"
	flags_inv = null
	armor = ARMOR_VALUE_LIGHT

///////
/*NCR*/
///////

//Army
/obj/item/clothing/head/helmet/f13/ncr
	name = "NCR helmet"
	desc = "A standard issue NCR pith helmet made out of scrap and covered over with leather." //THESE ARE MADE OUT OF LEATHER HOLY HELL MAN
	icon_state = "ncr_helmet"			//Not actually a steel pot..
	item_state = "ncr_helmet"
	unique_reskin = list("M1" = "ncr_old")
	strip_delay = 50
	armor = ARMOR_VALUE_LIGHT

/obj/item/clothing/head/helmet/f13/ncr/gambler
	name = "NCR gambler helmet"
	desc = "A standard issue NCR pith helmet. Stashed in the strap are decks of cards, dominoes and cigarettes for personal use."
	icon_state = "ncr_gambler"
	item_state = "ncr_gambler"
	unique_reskin = list("M1" = "ncr_old_gambler")

/obj/item/clothing/head/helmet/f13/ncr/bandolier
	name = "NCR bandolier helmet"
	desc = "A standard issue NCR pith helmet. This one has clearly seen heavy use, as well as having additional bullets tucked into the strap."
	icon_state = "ncr_bandolier"
	item_state = "ncr_bandolier"
	unique_reskin = list("M1" = "ncr_old_bandolier")

/obj/item/clothing/head/helmet/f13/ncr/med
	name = "NCR medic helmet"
	desc = "A standard issue NCR pith helmet with the addition of decalling signifying a medic."
	icon_state = "ncr_helmet_medic"
	item_state = "ncr_helmet_medic"

/obj/item/clothing/head/helmet/f13/ncr/engineer //Whoever named these steelpots should go to get their eyes checked
	name = "NCR engineer helmet"
	desc = "A standard issue NCR steel helmet, issued with an additional pair of storm goggles for weather resistance."
	icon_state = "ncr_helmet_storm"
	item_state = "ncr_helmet_storm"
	alt_toggle_message = "You push the goggles down"
	can_toggle = 1
	flags_inv = HIDEEARS
	actions_types = list(/datum/action/item_action/toggle)
	toggle_cooldown = 0
	flags_cover = HEADCOVERSEYES
	visor_flags_cover = HEADCOVERSEYES
	dog_fashion = null

/obj/item/clothing/head/f13/ncr/storm/attack_self(mob/user)
	if(can_toggle && !user.incapacitated())
		if(world.time > cooldown + toggle_cooldown)
			cooldown = world.time
			up = !up
			flags_1 ^= visor_flags
			flags_inv ^= visor_flags_inv
			flags_cover ^= visor_flags_cover
			icon_state = "[initial(icon_state)][up ? "-up" : ""]"
			to_chat(user, "[up ? alt_toggle_message : toggle_message] \the [src]")

			user.update_inv_head()
			if(iscarbon(user))
				var/mob/living/carbon/C = user
				C.head_update(src, forced = 1)

			if(active_sound)
				while(up)
					playsound(src.loc, "[active_sound]", 100, 0, 4)
					sleep(15)

/obj/item/clothing/head/helmet/f13/ncr/mp
	name = "NCR military police helmet"
	desc = "A standard issue NCR steel helmet emblazoned with the initials of the military police."
	icon_state = "ncr_helmet_mp"
	item_state = "ncr_helmet_mp"

//Ranger
//Yes, nearly all of these are not helmets - but this is because they ACT as helmets for balance-purposes.

/obj/item/clothing/head/f13/ncr/ranger
	icon = 'icons/fallout/clothing/hats.dmi'
	mob_overlay_icon = 'icons/fallout/onmob/clothes/head.dmi'
	name = "NCR ranger hat"
	desc = "a rustic, homely style cowboy hat worn by NCR rangers. Yeehaw!"
	icon_state = "ncr_ranger"
	item_state = "ncr_ranger"
	armor = ARMOR_VALUE_LIGHT

/obj/item/clothing/head/f13/ncr/patrol
	icon = 'icons/fallout/clothing/hats.dmi'
	mob_overlay_icon = 'icons/fallout/onmob/clothes/head.dmi'
	name = "NCR ranger campaign hat"
	desc = "An NCR ranger hat, standard issue amongst all but the most elite rangers."
	icon_state = "ncr_ranger_patrol"
	item_state = "ncr_ranger_patrol"
	armor = ARMOR_VALUE_MEDIUM

/obj/item/clothing/head/helmet/f13/ncr/veteran
	name = "NCR veteran ranger combat helmet"
	desc = "An old combat helmet, out of use around the time of the war."
	icon_state = "ncr_ranger_veteran"
	item_state = "ncr_ranger_veteran"
	armor = ARMOR_VALUE_HEAVY
	flags_inv = HIDEMASK|HIDEEARS|HIDEEYES|HIDEHAIR|HIDEFACIALHAIR|HIDEFACE
	flags_cover = HEADCOVERSEYES | HEADCOVERSMOUTH
	resistance_flags = LAVA_PROOF | FIRE_PROOF
	dynamic_hair_suffix = ""
	dynamic_fhair_suffix = ""
	flash_protect = 1
	glass_colour_type = /datum/client_colour/glass_colour/red
	lighting_alpha = LIGHTING_PLANE_ALPHA_NV_TRAIT
	darkness_view = 24

///////
/*BOS*/
///////

/obj/item/clothing/head/helmet/f13/combat/brotherhood
	name = "brotherhood helmet"
	desc = "An improved combat helmet, bearing the symbol of the Knights."
	icon_state = "brotherhood_helmet_knight"
	item_state = "brotherhood_helmet_knight"
	armor = ARMOR_VALUE_MEDIUM

/obj/item/clothing/head/helmet/f13/combat/brotherhood/senior
	name = "brotherhood senior knight helmet"
	desc = "An improved combat helmet, bearing the symbol of a Senior Knight."
	icon_state = "brotherhood_helmet_senior"
	item_state = "brotherhood_helmet_senior"
	armor = ARMOR_VALUE_HEAVY

/obj/item/clothing/head/helmet/f13/combat/brotherhood/initiate
	name = "initiate helmet"
	desc = "An old degraded pre-war combat helmet, repainted to the colour scheme of the Brotherhood of Steel."
	icon_state = "brotherhood_helmet"
	item_state = "brotherhood_helmet"

/obj/item/clothing/head/helmet/f13/combat/brotherhood/mk2
	name = "brotherhood helmet Mk II"
	desc = "An advanced pre-war titanium plated, ceramic coated, kevlar, padded helmet designed to withstand extreme punishment of all forms, repainted to the colour scheme of the Brotherhood of Steel."
	icon_state = "brotherhood_helmet"
	item_state = "brotherhood_helmet"
	armor_tokens = list(ARMOR_MODIFIER_UP_BULLET_T2, ARMOR_MODIFIER_UP_MELEE_T2)

///////////
/*T O W N*/
///////////
// Just like Rangers, a lot are not helmets.. but they are going to act akin to helmets for our purposes.
/obj/item/clothing/head/f13/town
	armor = ARMOR_VALUE_LIGHT
	icon = 'icons/fallout/clothing/hats.dmi'
	mob_overlay_icon = 'icons/fallout/onmob/clothes/head.dmi'

/obj/item/clothing/head/f13/town/deputy
	name = "town lawman's hat"
	desc = "A stylish classic hat used by lawmen."
	icon_state = "town_deputy"
	item_state = "town_deputy"
	icon = 'icons/fallout/clothing/hats.dmi'
	mob_overlay_icon = 'icons/fallout/onmob/clothes/head.dmi'

/obj/item/clothing/head/f13/town/sheriff
	name = "town sheriff's hat"
	desc = "A stylish classic hat used by lawmen. This one belongs to the man of big iron"
	icon_state = "town_marshal"
	item_state = "town_marshal"
	icon = 'icons/fallout/clothing/hats.dmi'
	mob_overlay_icon = 'icons/fallout/onmob/clothes/head.dmi'

/obj/item/clothing/head/helmet/f13/combat/town
	name = "town security helmet"
	desc = "An old riot helmet reinforced with proper alloys and stripped of it's faceshield to be more usable outside of confines of a vault."
	armor = ARMOR_VALUE_MEDIUM
	icon_state = "town_helmet"
	item_state = "town_helmet"
	flags_inv = HIDEEARS

/obj/item/clothing/head/helmet/f13/combat/mk2/town
	name = "town reinforced security helmet"
	desc = "An old riot helmet reinforced with proper alloys and stripped of it's faceshield to be more usable outside of confines of a vault. This one is reinforced."
	icon_state = "town_helmet"
	item_state = "town_helmet"
	flags_inv = HIDEEARS

/obj/item/clothing/head/helmet/f13/town/riot //UN Glowie
	name = "town sheriff combat helmet"
	desc = "An old riot helmet bastardized into a what is essentially a maska without functioning internals. Belongs to the big gun of the town."
	icon_state = "town_marshal_riot"
	item_state = "town_marshal_riot"
	armor = ARMOR_VALUE_HEAVY
	flags_inv = HIDEMASK|HIDEEARS|HIDEEYES|HIDEHAIR|HIDEFACIALHAIR|HIDEFACE
	flags_cover = HEADCOVERSEYES | HEADCOVERSMOUTH
	resistance_flags = LAVA_PROOF | FIRE_PROOF
	dynamic_hair_suffix = ""
	dynamic_fhair_suffix = ""
	flash_protect = 1
	glass_colour_type = /datum/client_colour/glass_colour/red
	lighting_alpha = LIGHTING_PLANE_ALPHA_NV_TRAIT
	darkness_view = 24

////////////////////////
// GREAT KHAN HELMETS //
////////////////////////

/obj/item/clothing/head/helmet/f13/khan
	name = "horned helmet"
	desc = "A piece of headwear commonly worn by the horned tribals that appears to resemble stereotypical traditional Mongolian helmets - likely adapted from a pre-War motorcycle helmet.<br>It is black with two horns on either side and a small spike jutting from the top, much like a pickelhaube.<br>A leather covering protects the wearer's neck and ears from sunburn."
	icon_state = "khan_helmet"
	item_state = "khan_helmet"
	flags_inv = null
	flags_cover = null
	strip_delay = 20
	dynamic_hair_suffix = "+generic"
	dynamic_fhair_suffix = null

/obj/item/clothing/head/helmet/f13/khan/pelt
	desc = "A helmet with traditional horns, but wasteland-chique fur trimming instead of the classic leather cover. For the Khan who wants to show off their hair."
	icon_state = "khan_helmetpelt"
	item_state = "khan_helmetpelt"

/obj/item/clothing/head/helmet/f13/khan/fullhelm
	name = "Great Khan full helmet"
	desc = " A Khan helmet modified with steel horns and a full guard comprised of red sunglass lenses and a thick metal plate to conceal the lower face."
	icon_state = "khanhelmet"
	item_state = "khanhelmet"
	armor = ARMOR_VALUE_MEDIUM
	flags_inv = HIDEMASK|HIDEEARS|HIDEEYES|HIDEFACE|HIDEHAIR|HIDEFACIALHAIR
	flags_cover = HEADCOVERSEYES | HEADCOVERSMOUTH
	strip_delay = 20

/obj/item/clothing/head/helmet/f13/khan/bandana
	icon = 'icons/fallout/clothing/khans.dmi'
	name = "outlaw bandana"
	desc = "A bandana. Tougher than it looks. One side of the cloth is dark, the other red, so it can be reversed."
	icon_state = "khan_bandana"
	item_state = "khan_bandana"
	strip_delay = 10
	dynamic_hair_suffix = null
	dynamic_fhair_suffix = null
	var/helmettoggled = FALSE
	armor = ARMOR_VALUE_LIGHT

/obj/item/clothing/head/helmet/f13/khan/bandana/AltClick(mob/user)
	. = ..()
	if(!user.canUseTopic(src, BE_CLOSE, ismonkey(user)))
		return
	helmet_toggle(user)
	return TRUE

/obj/item/clothing/head/helmet/f13/khan/bandana/ui_action_click()
	helmet_toggle()

/obj/item/clothing/head/helmet/f13/khan/bandana/proc/helmet_toggle()
	set src in usr

	if(!can_use(usr))
		return 0

	to_chat(usr, span_notice("You turn the [src] inside out."))
	if(src.helmettoggled)
		src.icon_state = "[initial(icon_state)]"
		src.item_state = "[initial(icon_state)]"
		src.helmettoggled = FALSE
	else if(!src.helmettoggled)
		src.icon_state = "[initial(icon_state)]_t"
		src.item_state = "[initial(icon_state)]_t"
		src.helmettoggled = TRUE
	usr.update_inv_head()
	for(var/X in actions)
		var/datum/action/A = X
		A.UpdateButtonIcon()

///////////////
// V A U L T //
///////////////

/obj/item/clothing/head/helmet/riot/vaultsec
	name = "security helmet"
	desc = "A standard issue vault security helmet, pretty robust."
	slowdown = 0.01


/obj/item/clothing/head/helmet/riot/vaultsec/vc
	name = "vtcc riot helmet"
	desc = "A riot helmet adapted from the design of most pre-war riot helmets, painted blue."
	icon_state = "vtcc_riot_helmet"
	item_state = "vtcc_riot_helmet"

//////////////////////////
// Salvaged Power Armor //
//////////////////////////

/obj/item/clothing/head/helmet/f13/heavy/salvaged_pa
	name = "salvaged power helmet"
	desc = "It's a salvaged power armor helmet of what..? YOU CAN'T SEE ME! STOP! REPORT TO CODERS!!"
	slowdown = ARMOR_SLOWDOWN_NONE * ARMOR_SLOWDOWN_GLOBAL_MULT
	armor = ARMOR_VALUE_SALVAGE

// T-45B
/obj/item/clothing/head/helmet/f13/heavy/salvaged_pa/t45b
	name = "salvaged T-45d helmet"
	desc = "It's a salvaged T-45d power armor helmet."
	icon_state = "t45bhelmet"
	item_state = "t45bhelmet"

/obj/item/clothing/head/helmet/f13/heavy/salvaged_pa/t45b/raider
	name = "raider T-45d power helmet"
	desc = "a raider's attempt to duplicate a power armor helmet. The result is a fuzed mass of metal and ceramic that nonetheless provides protection"
	icon_state = "raiderpa_helm"
	item_state = "raiderpa_helm"

/obj/item/clothing/head/helmet/f13/heavy/salvaged_pa/t45b/ncr
	name = "ncr salvaged T-45d helmet"
	desc = "It's an NCR salvaged T-45d power armor helmet, better repaired than regular salvaged PA, and decorated with the NCR flag and other markings for an NCR Heavy Trooper."
	icon_state = "t45bhelmet_ncr"
	item_state = "t45bhelmet_ncr"

/obj/item/clothing/head/helmet/f13/heavy/salvaged_pa/t45b/hotrod
	name = "hotrod T-45d power helmet"
	desc = "This power armor helmet is so decrepit and battle-worn that it have lost most of its capability to protect the wearer from harm."
	icon_state = "t45hotrod_helm"
	item_state = "t45hotrod_helm"
	armor_tokens = list(ARMOR_MODIFIER_UP_FIRE_T3)

/obj/item/clothing/head/helmet/f13/heavy/salvaged_pa/t45b/tribal
	name = "tribal t-45d headdress"
	desc = "A salvaged T-45d powered armor, with the servos removed and a feathered headdress. Certain bits of plating have been stripped out to retain more freedom of movement."
	icon_state = "tribal"
	item_state = "tribal"
	armor_tokens = list(ARMOR_MODIFIER_DOWN_MELEE_T2, ARMOR_MODIFIER_DOWN_BULLET_T2, ARMOR_MODIFIER_DOWN_LASER_T2)
	slowdown = 0
	resistance_flags = LAVA_PROOF | FIRE_PROOF

// T-45D
/obj/item/clothing/head/helmet/f13/heavy/salvaged_pa/t45d
	name = "salvaged T-45d helmet"
	desc = "It's a salvaged T-45d power armor helmet."
	icon_state = "t45dhelmet0"
	item_state = "t45dhelmet0"
	armor_tokens = list(ARMOR_MODIFIER_UP_MELEE_T1, ARMOR_MODIFIER_UP_BULLET_T1)

// T-51B
/obj/item/clothing/head/helmet/f13/heavy/salvaged_pa/t51b
	name = "salvaged T-51b power armor"
	desc = "It's a salvaged T-51b power armor helmet."
	icon_state = "t51bhelmet0"
	item_state = "t51bhelmet0"
	armor_tokens = list(ARMOR_MODIFIER_UP_MELEE_T1, ARMOR_MODIFIER_UP_BULLET_T1, ARMOR_MODIFIER_UP_LASER_T2)

// X-02
/obj/item/clothing/head/helmet/f13/heavy/salvaged_pa/x02
	name = "salvaged Enclave helmet"
	desc = "It's a salvaged X-02 power armor helmet."
	icon_state = "advanced"
	item_state = "advanced"
	armor_tokens = list(ARMOR_MODIFIER_UP_MELEE_T3, ARMOR_MODIFIER_UP_BULLET_T3, ARMOR_MODIFIER_UP_LASER_T3)

// Legion T-45D
/obj/item/clothing/head/helmet/f13/heavy/salvaged_pa/t45d/legion
	name = "salvaged parma T-45d helmet"
	desc = "It's a reforged T-45d power armor helmet worn by the Legion. The faceplate has been removed and red paint has been applied on the forehead."
	icon_state = "parmahelm"
	item_state = "parmahelm"
	armor_tokens = list(ARMOR_MODIFIER_DOWN_MELEE_T1, ARMOR_MODIFIER_DOWN_BULLET_T1, ARMOR_MODIFIER_DOWN_LASER_T1)

// Legion T-51B
/obj/item/clothing/head/helmet/f13/heavy/salvaged_pa/t51b/legion
	name = "salvaged scutum T-51b helmet"
	desc = "It's a reforged T-51b power armor helmet worn by the Legion. The mouthplate has been removed and gold wreaths have been inlaid on its front."
	icon_state = "scutumhelm"
	item_state = "scutumhelm"
	armor_tokens = list(ARMOR_MODIFIER_UP_LASER_T1)


/////////////////
// Power Armor //
/////////////////

/obj/item/clothing/head/helmet/f13/power_armor
	cold_protection = HEAD
	heat_protection = HEAD
	ispowerarmor = 1 //TRUE
	strip_delay = 200
	equip_delay_self = 20
	slowdown = 0.05
	flags_inv = HIDEEARS|HIDEEYES|HIDEFACE|HIDEHAIR|HIDEFACIALHAIR|HIDEMASK|HIDEJUMPSUIT
	flags_cover = HEADCOVERSEYES | HEADCOVERSMOUTH
	clothing_flags = THICKMATERIAL
	resistance_flags = LAVA_PROOF | FIRE_PROOF | ACID_PROOF
	item_flags = SLOWS_WHILE_IN_HAND
	flash_protect = 2
	dynamic_hair_suffix = ""
	dynamic_fhair_suffix = ""
	speechspan = SPAN_ROBOT //makes you sound like a robot
	max_heat_protection_temperature = FIRE_HELM_MAX_TEMP_PROTECT
	cold_protection = HEAD
	min_cold_protection_temperature = FIRE_HELM_MIN_TEMP_PROTECT
	light_system = MOVABLE_LIGHT_DIRECTIONAL
	light_range = 5
	light_on = FALSE
	//salvage_loot = list(/obj/item/stack/crafting/armor_plate = 10)
	salvage_tool_behavior = TOOL_WELDER
	/// Projectiles below this damage will get deflected
	var/deflect_damage = 18
	/// If TRUE - it requires PA training trait to be worn
	var/requires_training = TRUE
	/// If TRUE - the suit will give its user specific traits when worn
	var/powered = TRUE
	/// Path of item that this helmet gets salvaged into
	var/obj/item/salvaged_type = null
	/// Used to track next tool required to salvage the suit
	var/salvage_step = 0
	armor = ARMOR_VALUE_PA
	custom_price = PRICE_ULTRA_EXPENSIVE

/obj/item/clothing/head/helmet/f13/power_armor/ComponentInitialize()
	. = ..()
	AddElement(/datum/element/update_icon_updates_onmob)

/obj/item/clothing/head/helmet/f13/power_armor/attack_self(mob/living/user)
	toggle_helmet_light(user)

/obj/item/clothing/head/helmet/f13/power_armor/proc/toggle_helmet_light(mob/living/user)
	set_light_on(!light_on)
	update_icon()


/obj/item/clothing/head/helmet/f13/power_armor/mob_can_equip(mob/user, mob/equipper, slot, disable_warning = 1)
	var/mob/living/carbon/human/H = user
	if(src == H.head) //Suit is already equipped
		return ..()
	if (!HAS_TRAIT(H, TRAIT_PA_WEAR) && slot == SLOT_HEAD && requires_training)
		to_chat(user, span_warning("You don't have the proper training to operate the power armor!"))
		return 0
	if(slot == SLOT_HEAD)
		return ..()
	return

/obj/item/clothing/head/helmet/f13/power_armor/run_block(mob/living/owner, atom/object, damage, attack_text, attack_type, armour_penetration, mob/attacker, def_zone, final_block_chance, list/block_return)
	if((attack_type == ATTACK_TYPE_PROJECTILE) && (def_zone in protected_zones))
		if(prob(70) && (damage < deflect_damage))
			block_return[BLOCK_RETURN_REDIRECT_METHOD] = REDIRECT_METHOD_DEFLECT
			return BLOCK_SHOULD_REDIRECT | BLOCK_REDIRECTED | BLOCK_SUCCESS | BLOCK_PHYSICAL_INTERNAL
	return ..()

/obj/item/clothing/head/helmet/f13/power_armor/attackby(obj/item/I, mob/living/carbon/human/user, params)
	if(ispath(salvaged_type))
		switch(salvage_step)
			if(0)
				// Salvage
				if(istype(I, /obj/item/screwdriver))
					if(ishuman(user) && user.wear_suit == src)
						to_chat(user, span_warning("You have to take off the helmet before salvaging it."))
						return
					to_chat(user, span_notice("You begin unsecuring the cover..."))
					if(I.use_tool(src, user, 60, volume=50))
						salvage_step = 1
						to_chat(user, span_notice("You unsecure the cover."))
					return
			if(1)
				// Salvage
				if(istype(I, /obj/item/wrench))
					if(ishuman(user) && user.wear_suit == src)
						to_chat(user, span_warning("You have to take off the helmet before salvaging it."))
						return
					to_chat(user, span_notice("You begin disconnecting the connection ports..."))
					if(I.use_tool(src, user, 80, volume=50))
						salvage_step = 2
						to_chat(user, span_notice("You disconnect the connection ports."))
					return
				// Fix
				if(istype(I, /obj/item/screwdriver))
					if(ishuman(user) && user.wear_suit == src)
						to_chat(user, span_warning("You have to take off the helmet before fixing it."))
						return
					to_chat(user, span_notice("You begin securing the cover..."))
					if(I.use_tool(src, user, 60, volume=50))
						salvage_step = 0
						to_chat(user, span_notice("You secure the cover."))
					return
			if(2)
				// Salvage
				if(istype(I, /obj/item/wirecutters))
					if(ishuman(user) && user.wear_suit == src)
						to_chat(user, span_warning("You have to take off the helmet before salvaging it."))
						return
					to_chat(user, span_notice("You begin disconnecting wires..."))
					if(I.use_tool(src, user, 60, volume=70))
						to_chat(user, span_notice("You finish salvaging the helmet."))
						var/obj/item/ST = new salvaged_type(src)
						user.put_in_hands(ST)
						qdel(src)
					return
				// Fix
				if(istype(I, /obj/item/wrench))
					if(ishuman(user) && user.wear_suit == src)
						to_chat(user, span_warning("You have to take off the helmet before fixing it."))
						return
					to_chat(user, span_notice("You try to anchor connection ports to the frame..."))
					if(I.use_tool(src, user, 80, volume=60))
						salvage_step = 1
						to_chat(user, span_notice("You re-connect connection ports."))
					return
	return ..()

/obj/item/clothing/head/helmet/f13/power_armor/examine(mob/user)
	. = ..()
	if(ispath(salvaged_type))
		. += salvage_hint()

/obj/item/clothing/head/helmet/f13/power_armor/proc/salvage_hint()
	switch(salvage_step)
		if(0)
			return "<span class='notice'>The metal cover can be <i>screwed</i> open.</span>"
		if(1)
			return "<span class='notice'>The cover is <i>screwed</i> open with connection ports <i>bolted down</i>.</span>"
		if(2)
			return "<span class='warning'>The connections ports have been <i>unanchored</i> and only <i>wires</i> remain.</span>"

/obj/item/clothing/head/helmet/f13/power_armor/t45b
	name = "T-45d helmet"
	desc = "It's a T-45d power armor helmet."
	icon_state = "t45bhelmet"
	item_state = "t45bhelmet"
	salvaged_type = /obj/item/clothing/head/helmet/f13/heavy/salvaged_pa/t45b

/obj/item/clothing/head/helmet/f13/power_armor/t45d
	name = "T-45d power helmet"
	desc = "t's an old pre-War power armor helmet. It's pretty hot inside of it."
	icon_state = "t45dhelmet0"
	item_state = "t45dhelmet0"
	actions_types = list(/datum/action/item_action/toggle_helmet_light)
	armor_tokens = list(ARMOR_MODIFIER_UP_MELEE_T1, ARMOR_MODIFIER_UP_BULLET_T1)
	salvaged_type = /obj/item/clothing/head/helmet/f13/heavy/salvaged_pa/t45d

/obj/item/clothing/head/helmet/f13/power_armor/t45d/update_icon_state()
	icon_state = "t45dhelmet[light_on]"
	item_state = "t45dhelmet[light_on]"

/obj/item/clothing/head/helmet/f13/power_armor/t51b
	name = "T-51b power helmet"
	desc = "It's a T-51b power helmet, typically used by the Brotherhood. It looks somewhat charming."
	icon_state = "t51bhelmet0"
	item_state = "t51bhelmet0"
	armor_tokens = list(ARMOR_MODIFIER_UP_MELEE_T1, ARMOR_MODIFIER_UP_BULLET_T1, ARMOR_MODIFIER_UP_LASER_T1)
	actions_types = list(/datum/action/item_action/toggle_helmet_light)
	salvaged_type = /obj/item/clothing/head/helmet/f13/heavy/salvaged_pa/t51b

/obj/item/clothing/head/helmet/f13/power_armor/t51b/update_icon_state()
	icon_state = "t51bhelmet[light_on]"
	item_state = "t51bhelmet[light_on]"

/obj/item/clothing/head/helmet/f13/power_armor/excavator
	name = "excavator power helmet"
	desc = "The helmet of the excavator power armor suit."
	icon_state = "excavator"
	item_state = "excavator"
	armor_tokens = list(ARMOR_MODIFIER_UP_MELEE_T2, ARMOR_MODIFIER_DOWN_BULLET_T2, ARMOR_MODIFIER_DOWN_LASER_T2, ARMOR_MODIFIER_UP_ENV_T3, ARMOR_MODIFIER_UP_DT_T1)

/obj/item/clothing/head/helmet/f13/power_armor/vaulttec
	name = "Vault Tec power helmet"
	desc = "The helmet of the Vault-Tec power armor suit."
	icon_state = "vaultpahelm"
	item_state = "vaultpahelm"
	armor_tokens = list(ARMOR_MODIFIER_UP_MELEE_T2, ARMOR_MODIFIER_DOWN_BULLET_T1, ARMOR_MODIFIER_DOWN_LASER_T1, ARMOR_MODIFIER_UP_ENV_T3, ARMOR_MODIFIER_UP_DT_T1)

/obj/item/clothing/head/helmet/f13/power_armor/advanced
	name = "advanced power helmet"
	desc = "It's an advanced power armor MK1 helmet, typically used by the Enclave. It looks somewhat threatening."
	icon_state = "advhelmet1"
	item_state = "advhelmet1"
	armor_tokens = list(ARMOR_MODIFIER_UP_MELEE_T2, ARMOR_MODIFIER_UP_BULLET_T2, ARMOR_MODIFIER_UP_LASER_T2)


//Part of the peacekeeper enclave stuff, adjust values as needed.
/obj/item/clothing/head/helmet/f13/power_armor/x02helmet
	name = "Enclave power armor helmet"
	desc = "The Enclave Mark II Powered Combat Armor helmet."
	icon_state = "advanced"
	item_state = "advanced"
	slowdown = 0.1
	armor_tokens = list(ARMOR_MODIFIER_UP_MELEE_T3, ARMOR_MODIFIER_UP_BULLET_T3, ARMOR_MODIFIER_UP_LASER_T3)
	actions_types = list(/datum/action/item_action/toggle_helmet_light)
	salvaged_type = /obj/item/clothing/head/helmet/f13/heavy/salvaged_pa/x02


//Generic Tribal - For Wayfarer specific, see f13factionhead.dm

/obj/item/clothing/head/helmet/f13/tribal
	name = "tribal power helmet"
	desc = "This power armor helmet was salvaged by savages from the battlefield.<br>They believe that these helmets capture the spirits of their fallen wearers, so they painted some runes on to give it a more sacred meaning."
	icon_state = "tribal"
	item_state = "tribal"
	flags_cover = HEADCOVERSEYES | HEADCOVERSMOUTH
	armor_tokens = list(ARMOR_MODIFIER_DOWN_MELEE_T2, ARMOR_MODIFIER_DOWN_BULLET_T2, ARMOR_MODIFIER_DOWN_LASER_T2)
	flags_inv = HIDEMASK|HIDEEARS|HIDEEYES|HIDEFACE|HIDEHAIR|HIDEFACIALHAIR
	strip_delay = 30
	dynamic_hair_suffix = ""
	dynamic_fhair_suffix = ""
