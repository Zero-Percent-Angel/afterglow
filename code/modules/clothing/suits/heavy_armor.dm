///////////
// HEAVY //
///////////

/*
 * Stats
 * Big slowdown, high protection
 * 40% DR for general armor - ???% effective HP
 * 50-60% for specialist armor (most everything else is butt)
 *
 * Types:
 * Tribal Raider (basically the same at this point)
 * metal (-bullet , ++melee, ++laser)
 * Polished (--bullet , +melee, +++laser)
 * riot (special, +++melee , -bullet, --laser)
 * Vest - bulletproof (special, +++bullet, --everything else)
 * Salvaged PA (partway to PA, but super sloooow and bulky)
 */

/obj/item/clothing/suit/armor/heavy
	name = "heavy armor template"
	icon = 'icons/fallout/clothing/armored_heavy.dmi'
	mob_overlay_icon = 'icons/fallout/onmob/clothes/armor_heavy.dmi'
	slowdown = 1
	strip_delay = 50
	equip_delay_other = 50
	max_integrity = 300
	pocket_storage_component_path = /datum/component/storage/concrete/pockets/armor
	slowdown = ARMOR_SLOWDOWN_HEAVY * ARMOR_SLOWDOWN_GLOBAL_MULT
	armor = ARMOR_VALUE_HEAVY
	armor_tier_desc = ARMOR_CLOTHING_HEAVY
	stiffness = HEAVY_STIFFNESS
	custom_price = PRICE_ABOVE_EXPENSIVE

//////////////////////
//// TRIBAL ARMOR ////
//////////////////////

/obj/item/clothing/suit/armor/heavy/tribal
	name = "tribal heavy carapace"
	desc = "Thick layers of leather and bone, with metal reinforcements, surely this will make the wearer tough and uncaring for claws and blades."
	icon = 'icons/fallout/clothing/armored_heavy.dmi'
	mob_overlay_icon = 'icons/fallout/onmob/clothes/armor_heavy.dmi'
	icon_state = "tribal_heavy"
	item_state = "tribal_heavy"
	pocket_storage_component_path = /datum/component/storage/concrete/pockets/jacket
	slowdown = ARMOR_SLOWDOWN_HEAVY * ARMOR_SLOWDOWN_LESS_T1 * ARMOR_SLOWDOWN_GLOBAL_MULT
	armor_tokens = list(ARMOR_MODIFIER_UP_MELEE_T1, ARMOR_MODIFIER_DOWN_LASER_T1)

/obj/item/clothing/suit/armor/heavy/tribal/bone
	name = "Heavy Bone armor"
	desc = "A tribal full armor plate, crafted from animal bone, metal and leather. Usually worn by the Bone Dancers"
	mob_overlay_icon = null
	icon_state = "bone_dancer_armor_heavy"
	item_state = "bone_dancer_armor_heavy"
	blood_overlay_type = "armor"
	armor_tokens = list(ARMOR_MODIFIER_UP_MELEE_T2, ARMOR_MODIFIER_DOWN_LASER_T1)

/obj/item/clothing/suit/armor/heavy/tribal/rustwalkers
	name = "Rustwalkers heavy armour"
	desc = "A car seat leather duster, a timing belt bandolier, and armour plating made from various parts of a car, it surely would weigh the wearer down. Commonly worn by members of the Rustwalkers tribe."
	icon_state = "rustwalkers_armour_heavy"
	item_state = "rustwalkers_armour_heavy"
	body_parts_hidden = CHEST|GROIN|LEGS|ARMS

/obj/item/clothing/suit/armor/heavy/tribal/whitelegs
	name = "White Legs heavy armour"
	desc = "A series of tan and khaki armour plates, held in place with a considerable amount of strapping and possibly duct tape. Commonly worn by members of the White Legs tribe."
	icon_state = "white_legs_armour_heavy"
	item_state = "white_legs_armour_heavy"
	body_parts_hidden = ARMS | LEGS

/obj/item/clothing/suit/armor/heavy/tribal/eighties
	name = "80s heavy armour"
	desc = "A ballistic duster with the number 80 stitched onto the back worn over a breastplate made from a motorcycle's engine housing, with kneepads made from stirrups. Worn by the members of the 80s tribe."
	icon_state = "80s_armour_heavy"
	item_state = "80s_armour_heavy"
	body_parts_hidden = CHEST|GROIN|LEGS|ARMS

/obj/item/clothing/suit/armor/heavy/tribal/deadhorses
	name = "Dead Horses heavy armour"
	desc = "A simple leather bandolier and gecko hide chest covering, with an engraved metal pauldron and a set of black leather straps, one holding a shinpad in place. Commonly worn by the members of the Dead Horses tribe."
	icon_state = "dead_horses_armour_heavy"
	item_state = "dead_horses_armour_heavy"
	body_parts_hidden = CHEST

/obj/item/clothing/suit/armor/heavy/tribal/bonedancers
	name = "Bone Dancers heavy armour"
	desc = "A chestplate, pauldrons, bracers, thigh guards and greaves made from bone, metal and sinew. Commonly worn by members of the Bone Dancers tribe."
	icon_state = "bone_dancer_armor_heavy"
	item_state = "bone_dancer_armor_heavy"
	body_parts_hidden = CHEST|GROIN|LEGS|ARMS

/obj/item/clothing/suit/armor/heavy/tribal/westernwayfarer
	name = "Western Wayfarer heavy armor"
	desc = "A Suit of armor crafted by Tribals using pieces of scrap metals and the armor of fallen foes, a bighorner's skull sits on the right pauldron along with bighorner fur lining the collar of the leather bound chest. Along the leather straps adoring it are multiple bone charms with odd markings on them."
	body_parts_covered = CHEST|GROIN|LEGS|ARMS|HANDS

/////////////////////
//// METAL ARMOR ////
/////////////////////

/obj/item/clothing/suit/armor/heavy/metal
	name = "metal armor"
	desc = "A set of plates formed together to form a crude chestplate."
	icon_state = "metalarmor"
	item_state = "metalarmor"
	slowdown = ARMOR_SLOWDOWN_HEAVY * ARMOR_SLOWDOWN_MORE_T1 * ARMOR_SLOWDOWN_GLOBAL_MULT
	armor_tokens = list(ARMOR_MODIFIER_UP_MELEE_T2, ARMOR_MODIFIER_UP_LASER_T2, ARMOR_MODIFIER_UP_ENV_T2, ARMOR_MODIFIER_UP_DT_T1)

/obj/item/clothing/suit/armor/heavy/metal/reinforced
	name = "reinforced metal armor"
	desc = "A set of well-fitted plates formed together to provide effective protection."
	slowdown = ARMOR_SLOWDOWN_HEAVY * ARMOR_SLOWDOWN_MORE_T1 * ARMOR_SLOWDOWN_GLOBAL_MULT
	armor_tokens = list(ARMOR_MODIFIER_UP_MELEE_T3, ARMOR_MODIFIER_UP_BULLET_T1, ARMOR_MODIFIER_UP_LASER_T2, ARMOR_MODIFIER_UP_ENV_T2, ARMOR_MODIFIER_UP_DT_T2)

/obj/item/clothing/suit/armor/heavy/metal/sulphite
	name = "sulphite armor"
	desc = "A combination of what seems to be raider metal armor with a jerry-rigged flame-exhaust system and ceramic plating."
	icon = 'icons/fallout/clothing/armored_heavy.dmi'
	mob_overlay_icon = 'icons/fallout/onmob/clothes/armor_heavy.dmi'
	resistance_flags = FIRE_PROOF
	icon_state = "sulphite"
	item_state = "sulphite"
	slowdown = ARMOR_SLOWDOWN_HEAVY * ARMOR_SLOWDOWN_MORE_T1 * ARMOR_SLOWDOWN_GLOBAL_MULT
	armor_tokens = list(ARMOR_MODIFIER_UP_MELEE_T3, ARMOR_MODIFIER_UP_BULLET_T1, ARMOR_MODIFIER_UP_LASER_T2, ARMOR_MODIFIER_UP_ENV_T2, ARMOR_MODIFIER_UP_FIRE_T3)
	mutantrace_variation = NONE

////////////////////
//// RIOT ARMOR ////
////////////////////

/obj/item/clothing/suit/armor/heavy/riot
	name = "riot suit"
	desc = "A suit of semi-flexible polycarbonate body armor with heavy padding to protect against melee attacks. Helps the wearer resist shoving in close quarters."
	icon_state = "riot"
	item_state = "riot"
	pocket_storage_component_path = /datum/component/storage/concrete/pockets/magpouch // 4 slots for ammo!
	blocks_shove_knockdown = TRUE
	slowdown = ARMOR_SLOWDOWN_HEAVY * ARMOR_SLOWDOWN_GLOBAL_MULT
	armor_tokens = list(ARMOR_MODIFIER_UP_MELEE_T3, ARMOR_MODIFIER_UP_BULLET_T1, ARMOR_MODIFIER_DOWN_LASER_T2, ARMOR_MODIFIER_DOWN_FIRE_T3, ARMOR_MODIFIER_UP_DT_T2)

/obj/item/clothing/suit/armor/heavy/riot/police
	name = "riot police armor"
	icon_state = "bulletproof_heavy"
	item_state = "bulletproof_heavy"
	desc = "Heavy armor with ballistic inserts, sewn into a padded riot police coat."
	slowdown = ARMOR_SLOWDOWN_HEAVY * ARMOR_SLOWDOWN_LESS_T2 * ARMOR_SLOWDOWN_GLOBAL_MULT
	armor_tokens = list(ARMOR_MODIFIER_UP_BULLET_T3, ARMOR_MODIFIER_DOWN_LASER_T1, ARMOR_MODIFIER_DOWN_ENV_T2, ARMOR_MODIFIER_UP_DT_T3)

/obj/item/clothing/suit/armor/heavy/riot/elite
	name = "elite riot gear"
	desc = "A heavily reinforced set of military grade armor."
	icon_state = "elite_riot"
	item_state = "elite_riot"

//////////////////////////
// Salvaged Power Armor //
//////////////////////////

/obj/item/clothing/suit/armor/heavy/salvaged_pa
	name = "salvaged power armor"
	desc = "It's a set of early-model SS-13 power armor, except it isn't real. Stop looking at it, go ping coders or something. \
	It's literally not meant to be here, you are just wasting your time reading some text that someone wrote for you \
	because he thought it'd be funny, or expected someone to check GitHub for once, hello by the way. \
	If you still don't understand - it's a 'master' item, basically main type/parent object or something. \
	It isn't meant to be used, it just dictates procs and all that stuff to the subtypes, such as t45b and so on. \
	Now begone, report this to coders. NOW!"
	icon = 'icons/fallout/clothing/armored_heavy.dmi'
	mob_overlay_icon = 'icons/fallout/onmob/clothes/armor_heavy.dmi'
	pocket_storage_component_path = /datum/component/storage/concrete/pockets/armor
	slowdown = ARMOR_SLOWDOWN_SALVAGE * ARMOR_SLOWDOWN_GLOBAL_MULT
	armor = ARMOR_VALUE_SALVAGE
	armor_tier_desc = ARMOR_CLOTHING_SALVAGE
	custom_price = PRICE_ULTRA_EXPENSIVE
	strip_delay = 50

// T-45B
/obj/item/clothing/suit/armor/heavy/salvaged_pa/t45b
	name = "salvaged T-45b power armor"
	desc = "It's a set of early-model T-45 power armor with a custom air conditioning module and stripped out servomotors. Bulky and slow, but almost as good as the real thing."
	icon_state = "t45b_salvaged"
	item_state = "t45b_salvaged"

/obj/item/clothing/suit/armor/heavy/salvaged_pa/t45b/raider
	name = "salvaged raider power armor"
	desc = "A destroyed T-45b power armor has been brought back to life with the help of a welder and lots of scrap metal."
	icon_state = "raider_salvaged"
	item_state = "raider_salvaged"

/obj/item/clothing/suit/armor/heavy/salvaged_pa/t45b/hotrod
	name = "salvaged hotrod T-45b power armor"
	desc = " It's a set of T-45b power armor with a with some of its plating removed. This set has exhaust pipes piped to the pauldrons, flames erupting from them."
	icon_state = "t45hotrod"
	item_state = "t45hotrod"
	armor_tokens = list(ARMOR_MODIFIER_UP_FIRE_T3)

/obj/item/clothing/suit/armor/heavy/salvaged_pa/t45b/tribal
	name = "salvaged tribal T45-b power armor"
	desc = "A set of salvaged power armor, with certain bits of plating stripped out to retain more freedom of movement. No cooling module, though."
	icon_state = "tribal_power_armor"
	item_state = "tribal_power_armor"
	slowdown = ARMOR_SLOWDOWN_SALVAGE * ARMOR_SLOWDOWN_LESS_T1 * ARMOR_SLOWDOWN_GLOBAL_MULT // zooom
	armor_tokens = list(ARMOR_MODIFIER_DOWN_MELEE_T2, ARMOR_MODIFIER_DOWN_BULLET_T2, ARMOR_MODIFIER_DOWN_LASER_T2)

/obj/item/clothing/suit/armor/heavy/salvaged_pa/t45d
	name = "salvaged T-45d power armor"
	desc = "T-45d power armor with servomotors and all valuable components stripped out of it."
	icon_state = "t45d_salvaged"
	item_state = "t45d_salvaged"
	armor_tokens = list(ARMOR_MODIFIER_UP_MELEE_T1, ARMOR_MODIFIER_UP_BULLET_T1)

// T-51B
/obj/item/clothing/suit/armor/heavy/salvaged_pa/t51b
	name = "salvaged T-51b power armor"
	desc = "T-51b power armor with servomotors and all valuable components stripped out of it."
	icon_state = "t51b_salvaged"
	item_state = "t51b_salvaged"
	armor_tokens = list(ARMOR_MODIFIER_UP_MELEE_T1, ARMOR_MODIFIER_UP_BULLET_T1, ARMOR_MODIFIER_UP_LASER_T2, ARMOR_MODIFIER_UP_DT_T1)

// X-02
/obj/item/clothing/suit/armor/heavy/salvaged_pa/x02
	name = "salvaged Enclave power armor"
	desc = "X-02 power armor with servomotors and all valuable components stripped out of it."
	icon_state = "advanced_salvaged"
	item_state = "advanced_salvaged"
	armor_tokens = list(ARMOR_MODIFIER_UP_MELEE_T3, ARMOR_MODIFIER_UP_BULLET_T3, ARMOR_MODIFIER_UP_LASER_T2, ARMOR_MODIFIER_UP_DT_T2)


// Just generic PA I guess??
/obj/item/clothing/suit/armor/heavy/salvaged_pa/recycled
	name = "recycled power armor"
	desc = "Taking pieces off from a wrecked power armor will at least give you thick plating, but don't expect too much of this shot up, piecemeal armor.."
	icon_state = "recycled_power"
	item_state = "recycled_power"


///////////////////////////
// !!!FACTION SECTION!!! //
///////////////////////////


/////////
// NCR //
///////// 

/obj/item/clothing/suit/armor/heavy/salvaged_pa/t45b/ncr
	name = "salvaged NCR power armor"
	desc = "It's a set of T-45b power armor with a air conditioning module installed, sadly it lacks servomotors to enhance the users strength. The paintjob and the two headed bear painted onto the chestplate shows it belongs to the NCR."
	icon = 'icons/fallout/clothing/armored_heavy.dmi'
	mob_overlay_icon = 'icons/fallout/onmob/clothes/armor_heavy.dmi'
	icon_state = "ncr_salvaged"
	item_state = "ncr_salvaged"

////////////
// Legion //
////////////

/obj/item/clothing/suit/armor/heavy/legion
	icon = 'icons/fallout/clothing/armored_heavy.dmi'
	mob_overlay_icon = 'icons/fallout/onmob/clothes/armor_heavy.dmi'

/obj/item/clothing/suit/armor/heavy/legion/vetdecan
	name = "legion veteran decanus armor"
	desc = "An armor worn by veteran legionary decanus who have proven their combat prowess in many battles, strapped to it is various forms of kevlar and other bullet-proof armors."
	icon_state = "legion_heavy"
	item_state = "legion_heavy"
	slowdown = ARMOR_SLOWDOWN_HEAVY * ARMOR_SLOWDOWN_LESS_T2 *ARMOR_SLOWDOWN_GLOBAL_MULT
	armor_tokens = list(ARMOR_MODIFIER_UP_BULLET_T1, ARMOR_MODIFIER_DOWN_LASER_T2)

/obj/item/clothing/suit/armor/heavy/legion/centurion //good all around
	name = "legion centurion armor"
	desc = "Every Centurion is issued some of the best armor available in the Legion, and adds better pieces from slain opponents over time."
	icon_state = "legion_centurion"
	item_state = "legion_centurion"
	slowdown = ARMOR_SLOWDOWN_HEAVY * ARMOR_SLOWDOWN_LESS_T1 *ARMOR_SLOWDOWN_GLOBAL_MULT

/obj/item/clothing/suit/armor/heavy/salvaged_pa/t45b/palacent //laser resist spec
	name = "legion centurion paladin-slayer armor"
	desc = "A Centurion able to defeat a Brotherhood Paladin gets the honorific title 'Paladin-Slayer', and adds bits of the looted armor to his own."
	icon_state = "legion_palacent"
	item_state = "legion_palacent"
	slowdown = ARMOR_SLOWDOWN_SALVAGE * ARMOR_SLOWDOWN_LESS_T1 *ARMOR_SLOWDOWN_GLOBAL_MULT
	armor_tokens = list(ARMOR_MODIFIER_DOWN_MELEE_T1, ARMOR_MODIFIER_UP_BULLET_T1, ARMOR_MODIFIER_UP_LASER_T2)
	
/obj/item/clothing/suit/armor/heavy/legion/legate
	name = "legion legate armor"
	desc = "Made by the most skilled blacksmiths in Arizona, the bronzed steel of this rare armor offers good protection, and the scars on its metal proves it has seen use on the field."
	icon_state = "leg_legate"
	item_state = "leg_legate"
