///////////
// LIGHT //
///////////

/* Stats
 * No slowdown, mobility key
 * 10% DR for general armor
 * 15-20% for specialist armor (most everything else is butt)
 * Assuming 25 damage from the average attack:
 * - goes from 4 hit crit to 5 at 25
 * - 5 hit crit to 6 at 20 dmg
 * - 4 hit crit to 5 at 30 for specialists maybe???
 *
 * Types:
 * Tribal
 * Duster
 * Raider
 * leather (special, ++melee , --bullet, --laser)
 * light ballistic vest (special, ++bullet , --melee, --laser, chest only)
 * metal breastplate (special, ++laser , +melee, --bullet, chest only)
 */

//// LIGHT ARMOR PARENT ////
/obj/item/clothing/suit/armor/light
	name = "light armor template"
	icon = 'icons/fallout/clothing/armored_light.dmi'
	mob_overlay_icon = 'icons/fallout/onmob/clothes/armor_light.dmi'
	cold_protection = CHEST|GROIN
	heat_protection = CHEST|GROIN
	min_cold_protection_temperature = ARMOR_MIN_TEMP_PROTECT
	max_heat_protection_temperature = ARMOR_MAX_TEMP_PROTECT
	strip_delay = 10
	equip_delay_other = 10
	max_integrity = 100
	pocket_storage_component_path = /datum/component/storage/concrete/pockets/armor
	slowdown = ARMOR_SLOWDOWN_LIGHT * ARMOR_SLOWDOWN_GLOBAL_MULT
	armor = ARMOR_VALUE_LIGHT
	armor_tier_desc = ARMOR_CLOTHING_LIGHT
	stiffness = LIGHT_STIFFNESS
	custom_price = PRICE_ALMOST_EXPENSIVE

////////////////////////
// LIGHT TRIBAL ARMOR //
////////////////////////

/obj/item/clothing/suit/armor/light/tribal
	name = "tribal armor"
	desc = "A set of armor made of gecko hides.<br>It's pretty good for makeshift armor."
	icon_state = "tribal"
	item_state = "tribal"
	//flags_inv = HIDEJUMPSUIT
	cold_protection = CHEST|GROIN|ARMS|LEGS // worm
	heat_protection = CHEST|GROIN|ARMS|LEGS // chyll
	min_cold_protection_temperature = ARMOR_MIN_TEMP_PROTECT
	max_heat_protection_temperature = ARMOR_MAX_TEMP_PROTECT

/obj/item/clothing/suit/armor/light/tribal/wastetribe
	name = "wasteland tribe armor"
	desc = "Soft armor made from layered dog hide strips glued together, with some metal bits here and there."
	icon_state = "tribal"
	item_state = "tribal"
	body_parts_hidden = GROIN|ARMS|LEGS

/obj/item/clothing/suit/armor/light/tribal/cloak
	name = "light tribal cloak"
	desc = "A light cloak made from gecko skins and small metal plates at vital areas to give some protection, a favorite amongst scouts of the tribe."
	icon_state = "lightcloak"
	item_state = "lightcloak"
	body_parts_hidden = ARMS

/obj/item/clothing/suit/armor/light/tribal/simple
	name = "simple tribal armor"
	desc = "Armor made of leather strips and a large, flat piece of turquoise. The wearer is displaying the Wayfinders traditional garb."
	icon_state = "tribal_armor"
	item_state = "tribal_armor"
	body_parts_hidden = CHEST|ARMS|LEGS

/obj/item/clothing/suit/armor/light/tribal/outcast
	name = "outcast tribal armor"
	desc = "Armor made up of ruggid and weathered leather strips, large pieces of cloth, chitten, and other forms of materials. Clearly showing the marks of a lost soul."
	icon_state = "tribal_outcast"
	item_state = "tribal_outcast"
	body_parts_hidden = CHEST|ARMS|LEGS

/obj/item/clothing/suit/armor/light/tribal/whitelegs
	name = "White Legs light armour"
	desc = "A series of tan armour plates, held in place with a small amount of strapping. Commonly worn by members of the White Legs tribe."
	icon_state = "white_legs_armour_light"
	item_state = "white_legs_armour_light"

/obj/item/clothing/suit/armor/light/tribal/deadhorses
	name = "Dead Horses light armour"
	desc = "A simple leather bandolier and gecko hide chest covering. Commonly worn by the members of the Dead Horses tribe."
	icon_state = "dead_horses_armour_light"
	item_state = "dead_horses_armour_light"
	body_parts_hidden = CHEST|ARMS|LEGS

/obj/item/clothing/suit/armor/light/tribal/rustwalkers
	name = "Rustwalkers light armour"
	desc = "A car seat leather duster and a timing belt bandolier. Commonly worn by members of the Rustwalkers tribe."
	icon_state = "rustwalkers_armour_light"
	item_state = "rustwalkers_armour_light"
	body_parts_hidden = CHEST|ARMS|LEGS

/obj/item/clothing/suit/armor/light/tribal/eighties
	name = "Eighties light armour"
	desc = "A fairly simple, black leather jacket with an overly popped collar. Commonly worn by the members of the 80s tribe."
	icon_state = "eighties_armour_light"
	item_state = "eighties_armour_light"
	body_parts_hidden = CHEST|ARMS

/obj/item/clothing/suit/armor/light/tribal/bonedancers
	name = "Bone Dancers light armour"
	desc = "A chestplate, pauldrons and thigh guards made from bone and sinew. Commonly worn by members of the Bone Dancers tribe."
	icon_state = "eighties_armour_light"
	item_state = "eighties_armour_light"
	body_parts_hidden = CHEST

/// to be refactored to work with the New Tier System (tm)
/obj/item/clothing/suit/hooded/cloak
	name = "cloak"
	desc = "A cloak, made out of cloak."
	icon_state = "clawsuitcloak"
	item_state = "clawsuitcloak"
	hoodtype = /obj/item/clothing/head/hooded/cloakhood/goliath
	// body_parts_covered = CHEST|GROIN|LEGS|FEET|ARMS|HANDS
	cold_protection = CHEST|GROIN|ARMS|LEGS
	heat_protection = CHEST|GROIN|ARMS|LEGS
	min_cold_protection_temperature = ARMOR_MIN_TEMP_PROTECT
	max_heat_protection_temperature = ARMOR_MAX_TEMP_PROTECT
	strip_delay = 10
	equip_delay_other = 10
	max_integrity = 100
	pocket_storage_component_path = /datum/component/storage/concrete/pockets/armor
	body_parts_hidden = 0
	slowdown = ARMOR_SLOWDOWN_LIGHT * ARMOR_SLOWDOWN_GLOBAL_MULT
	armor = ARMOR_VALUE_LIGHT
	armor_tokens = list(ARMOR_MODIFIER_UP_ENV_T2, ARMOR_MODIFIER_UP_DT_T1)

/obj/item/clothing/suit/hooded/cloak/Initialize()
	/// make sure the parents work first for this, child lists take priority
	. = ..()
	/// i hate my extended family
	allowed = GLOB.default_all_armor_slot_allowed

/obj/item/clothing/suit/hooded/cloak/goliath
	name = "deathclaw cloak"
	desc = "A staunch, practical cloak made out of sinew and skin from the fearsome deathclaw."
	icon_state = "clawsuitcloak"
	item_state = "clawsuitcloak"
	hoodtype = /obj/item/clothing/head/hooded/cloakhood/goliath
	// body_parts_covered = CHEST|GROIN|LEGS|FEET|ARMS|HANDS
	slowdown = ARMOR_SLOWDOWN_MEDIUM * ARMOR_SLOWDOWN_GLOBAL_MULT
	armor = ARMOR_VALUE_MEDIUM
	armor_tokens = list(ARMOR_MODIFIER_UP_ENV_T1, ARMOR_MODIFIER_UP_BULLET_T2, ARMOR_MODIFIER_UP_DT_T2)

/obj/item/clothing/head/hooded/cloakhood/goliath
	name = "deathclaw cloak hood"
	desc = "A protective & concealing hood."
	icon_state = "clawheadcloak"
	item_state = "clawheadcloak"
	flags_inv = HIDEEARS|HIDEEYES|HIDEHAIR|HIDEFACIALHAIR
	slowdown = ARMOR_SLOWDOWN_MEDIUM * ARMOR_SLOWDOWN_GLOBAL_MULT
	armor = ARMOR_VALUE_MEDIUM
	armor_tokens = list(ARMOR_MODIFIER_UP_ENV_T1, ARMOR_MODIFIER_UP_BULLET_T2, ARMOR_MODIFIER_UP_DT_T2)

/obj/item/clothing/suit/hooded/cloak/goliath/tatteredred
	name = "tattered red cloak"
	desc = "An old ragged, tattered red cloak that is covered in burns and bullet holes."
	icon_state = "goliath_cloak"
	item_state = "goliath_cloak"
	hoodtype = /obj/item/clothing/head/hooded/cloakhood/goliath/tattered
	// body_parts_covered = CHEST|GROIN|LEGS|FEET|ARMS|HANDS
	slowdown = ARMOR_SLOWDOWN_MEDIUM * ARMOR_SLOWDOWN_GLOBAL_MULT
	armor = ARMOR_VALUE_MEDIUM
	armor_tokens = list(ARMOR_MODIFIER_UP_ENV_T1)

/obj/item/clothing/head/hooded/cloakhood/goliath/tattered
	name = "tattered red cloak hood"
	desc = "A tattered hood, better than nothing in the waste."
	icon_state = "golhood"
	item_state = "golhood"
	slowdown = ARMOR_SLOWDOWN_MEDIUM * ARMOR_SLOWDOWN_GLOBAL_MULT
	armor = ARMOR_VALUE_MEDIUM
	armor_tokens = list(ARMOR_MODIFIER_UP_ENV_T1, ARMOR_MODIFIER_UP_BULLET_T2)

/obj/item/clothing/suit/hooded/cloak/hhunter
	name = "Razorclaw armour"
	desc = "A suit of armour fashioned out of the remains of a legendary deathclaw."
	icon_state = "rcarmour"
	item_state = "rcarmour"
	hoodtype = /obj/item/clothing/head/hooded/cloakhood/hhunter
	heat_protection = CHEST|GROIN|LEGS|ARMS|HANDS
	// body_parts_covered = CHEST|GROIN|LEGS|ARMS|HANDS
	resistance_flags = FIRE_PROOF | ACID_PROOF
	slowdown = ARMOR_SLOWDOWN_MEDIUM * ARMOR_SLOWDOWN_GLOBAL_MULT
	armor = ARMOR_VALUE_MEDIUM
	armor_tokens = list(ARMOR_MODIFIER_UP_ENV_T2, ARMOR_MODIFIER_UP_MELEE_T2, ARMOR_MODIFIER_DOWN_LASER_T2, ARMOR_MODIFIER_UP_DT_T2)
	body_parts_hidden = 0

/obj/item/clothing/head/hooded/cloakhood/hhunter
	name = "Razorclaw helm"
	desc = "The skull of a legendary deathclaw."
	icon_state = "rchelmet"
	item_state = "rchelmet"
	heat_protection = HEAD
	resistance_flags = FIRE_PROOF | ACID_PROOF
	slowdown = ARMOR_SLOWDOWN_MEDIUM * ARMOR_SLOWDOWN_GLOBAL_MULT
	armor = ARMOR_VALUE_MEDIUM
	armor_tokens = list(ARMOR_MODIFIER_UP_ENV_T2, ARMOR_MODIFIER_UP_MELEE_T2, ARMOR_MODIFIER_DOWN_LASER_T2, ARMOR_MODIFIER_UP_DT_T2)

/obj/item/clothing/suit/hooded/cloak/shunter
	name = "quickclaw armour"
	desc = "A suit of armour fashioned out of the remains of a legendary deathclaw, this one has been crafted to remove a good portion of its protection to improve on speed and trekking."
	icon_state = "birdarmor"
	item_state = "birdarmor"
	hoodtype = /obj/item/clothing/head/hooded/cloakhood/shunter
	heat_protection = CHEST|GROIN|LEGS|ARMS|HANDS
	// body_parts_covered = CHEST|GROIN|LEGS|ARMS|HANDS
	resistance_flags = FIRE_PROOF | ACID_PROOF
	slowdown = ARMOR_SLOWDOWN_LIGHT * ARMOR_SLOWDOWN_GLOBAL_MULT
	armor = ARMOR_VALUE_LIGHT
	armor_tokens = list(ARMOR_MODIFIER_UP_ENV_T2, ARMOR_MODIFIER_UP_MELEE_T2, ARMOR_MODIFIER_DOWN_LASER_T2, ARMOR_MODIFIER_UP_DT_T2)
	body_parts_hidden = 0

/obj/item/clothing/head/hooded/cloakhood/shunter
	name = "quickclaw hood"
	desc = "A hood made of deathclaw hides, light while also being comfortable to wear, designed for speed."
	icon_state = "birdhood"
	item_state = "birdhood"
	heat_protection = HEAD
	resistance_flags = FIRE_PROOF | ACID_PROOF
	slowdown = ARMOR_SLOWDOWN_LIGHT * ARMOR_SLOWDOWN_GLOBAL_MULT
	armor = ARMOR_VALUE_LIGHT
	armor_tokens = list(ARMOR_MODIFIER_UP_ENV_T2, ARMOR_MODIFIER_UP_MELEE_T2, ARMOR_MODIFIER_DOWN_LASER_T2, ARMOR_MODIFIER_UP_DT_T2)

/obj/item/clothing/suit/hooded/cloak/deathclaw
	name = "deathclaw cloak"
	icon_state = "desertcloak"
	item_state = "desertcloak"
	desc = "Made from the sinew and skin of the fearsome deathclaw, this cloak will shield its wearer from harm."
	hoodtype = /obj/item/clothing/head/hooded/cloakhood/deathclaw
	// body_parts_covered = CHEST|GROIN|LEGS|FEET|ARMS|HANDS
	slowdown = ARMOR_SLOWDOWN_MEDIUM * ARMOR_SLOWDOWN_GLOBAL_MULT
	armor = ARMOR_VALUE_MEDIUM
	armor_tokens = list(ARMOR_MODIFIER_UP_ENV_T1, ARMOR_MODIFIER_UP_BULLET_T2, ARMOR_MODIFIER_UP_DT_T2)
	body_parts_hidden = 0

/obj/item/clothing/head/hooded/cloakhood/deathclaw
	name = "deathclaw cloak hood"
	icon_state = "hood_desertcloak"
	item_state = "hood_desertcloak"
	desc = "A protective and concealing hood."
	flags_inv = HIDEEARS|HIDEEYES|HIDEHAIR|HIDEFACIALHAIR
	slowdown = ARMOR_SLOWDOWN_MEDIUM * ARMOR_SLOWDOWN_GLOBAL_MULT
	armor = ARMOR_VALUE_MEDIUM
	armor_tokens = list(ARMOR_MODIFIER_UP_ENV_T1, ARMOR_MODIFIER_UP_BULLET_T2, ARMOR_MODIFIER_UP_DT_T2)

/obj/item/clothing/suit/hooded/cloak/desert/raven_cloak
	name = "Raven cloak"
	desc = "A huge cloak made out of hundreds of knife-like black bird feathers. It glitters in the light, ranging from blue to dark green and purple."
	icon_state = "raven_cloak"
	item_state = "raven_cloak"
	hoodtype = /obj/item/clothing/head/hooded/cloakhood/desert/raven_hood

/obj/item/clothing/head/hooded/cloakhood/desert/raven_hood
	name = "Raven cloak hood"
	desc = "A hood fashioned out of patchwork and feathers"
	icon_state = "raven_hood"
	item_state = "raven_hood"

//////////////////
// LIGHT RAIDER //
//////////////////
// more style and pockets, less protection

//Base-parent path for all light-raider armors.
/obj/item/clothing/suit/armor/light/raider
	cold_protection = CHEST|GROIN
	heat_protection = CHEST|GROIN
	min_cold_protection_temperature = ARMOR_MIN_TEMP_PROTECT
	max_heat_protection_temperature = ARMOR_MAX_TEMP_PROTECT
	strip_delay = 10
	equip_delay_other = 10
	max_integrity = 150
	pocket_storage_component_path = /datum/component/storage/concrete/pockets/jacket
	armor_tokens = list(ARMOR_MODIFIER_UP_ENV_T1, ARMOR_MODIFIER_UP_BULLET_T1, ARMOR_MODIFIER_UP_DT_T1)


/obj/item/clothing/suit/armor/light/raider/badlands
	name = "badlands raider armor"
	desc = "A leather top with a bandolier over it and a straps that cover the arms. Suited for warm climates, comes with storage space."
	icon_state = "badlands"
	item_state = "badlands"
	body_parts_hidden = ARMS

/obj/item/clothing/suit/armor/light/raider/leather
	name = "punk raider jacket"
	desc = "A leather jacket adorned with a metal spiked arm piece and some reinforced leather lining its inside."
	icon_state = "leather_jacket_fighter"
	item_state = "leather_jacket_fighter"
	body_parts_hidden = ARMS | GROIN

/obj/item/clothing/suit/armor/light/raider/wastewar
	name = "wasteland warrior armor"
	desc = "a mad attempt to recreate armor based of images of japanese samurai, using a sawn up old car tire as shoulder pads, bits of chain to cover the hips and pieces of furniture for a breastplate. Might stop a blade but nothing else, burns easily too. Comes with an enormous scabbard welded to the back!"
	icon_state = "wastewar"
	item_state = "wastewar"
	resistance_flags = FLAMMABLE
	pocket_storage_component_path = /datum/component/storage/concrete/pockets/massive/swords
	body_parts_hidden = CHEST | GROIN

/////////////////////
// DUSTERS & COATS //
/////////////////////

/obj/item/clothing/suit/armor/light/duster
	name = "duster"
	desc = "A long brown leather overcoat with discrete protective reinforcements sewn into the lining."
	icon_state = "duster"
	item_state = "duster"
	permeability_coefficient = 0.5
	heat_protection = CHEST|GROIN|ARMS|LEGS
	cold_protection = CHEST|GROIN|ARMS|LEGS
	min_cold_protection_temperature = ARMOR_MIN_TEMP_PROTECT
	max_heat_protection_temperature = ARMOR_MAX_TEMP_PROTECT
	strip_delay = 20
	equip_delay_other = 20
	max_integrity = 150
	pocket_storage_component_path = /datum/component/storage/concrete/pockets/duster
	armor_tokens = list(ARMOR_MODIFIER_UP_ENV_T2, ARMOR_MODIFIER_UP_DT_T1)
	// Nothing extra fancy for their storage, but they can carry an extra 2 normal-sized guns in their pockets

/obj/item/clothing/suit/armor/light/duster/lonesome
	name = "lonesome duster"
	desc = "A blue leather coat with the number 21 on the back.<br><i>If war doesn't change, men must change, and so must their symbols.</i><br><i>Even if there is nothing at all, know what you follow.</i>"
	icon_state = "duster_courier"
	item_state = "duster_courier"

/obj/item/clothing/suit/armor/light/duster/autumn //Based of Colonel Autumn's uniform.
	name = "tan trenchcoat"
	desc = "A heavy-duty tan trenchcoat typically worn by pre-War generals."
	icon_state = "duster_autumn"
	item_state = "duster_autumn"

/obj/item/clothing/suit/armor/light/duster/vet
	name = "merc veteran coat"
	desc = "A blue leather coat with its sleeves cut off, adorned with war medals.<br>This type of outfit is common for professional mercenaries and bounty hunters."
	icon_state = "duster_vet"
	item_state = "duster_vet"

/obj/item/clothing/suit/armor/light/duster/brahmin
	name = "brahmin leather duster"
	desc = "A duster made from tanned brahmin hide. It has a thick waxy surface from the processing, making it surprisingly laser resistant."
	icon_state = "duster_brahmin"
	item_state = "duster_brahmin"
	armor_tokens = list(ARMOR_MODIFIER_UP_ENV_T1, ARMOR_MODIFIER_UP_LASER_T1, ARMOR_MODIFIER_UP_DT_T1)

/obj/item/clothing/suit/armor/light/duster/desperado
	name = "desperado's duster"
	desc = "A dyed brahmin hide duster, with a thick waxy surface, making it less vulnerable to lasers and energy based weapons."
	icon = 'icons/fallout/clothing/armored_light.dmi'
	mob_overlay_icon = 'icons/fallout/onmob/clothes/armor_light.dmi'
	icon_state = "duster_lawman"
	item_state = "duster_lawman"
	armor_tokens = list(ARMOR_MODIFIER_UP_ENV_T1, ARMOR_MODIFIER_UP_LASER_T1, ARMOR_MODIFIER_UP_DT_T1)

/obj/item/clothing/suit/armor/light/duster/vaquero
	name = "vaquero suit"
	desc = "An ornate suit popularized by traders from the south, using tiny metal studs and plenty of silver thread wich serves as decoration and also reflects energy very well, useful when facing the desert sun or a rogue Eyebot."
	icon_state = "vaquero"
	item_state = "vaquero"
	flags_inv = HIDEJUMPSUIT
	heat_protection = CHEST | GROIN | LEGS| ARMS | HEAD
	siemens_coefficient = 1.1
	armor_tokens = list(ARMOR_MODIFIER_UP_ENV_T1, ARMOR_MODIFIER_UP_LASER_T1, ARMOR_MODIFIER_UP_DT_T1)

/obj/item/clothing/suit/armor/light/duster/battlecoat //Maxson's battlecoat from Fallout 4
	name = "battlecoat"
	desc = "A heavy padded leather coat, worn by pre-War bomber pilots in the past and post-War zeppelin pilots in the future."
	icon_state = "maxson_battlecoat"
	item_state = "maxson_battlecoat"
	icon = 'icons/fallout/clothing/armored_light.dmi'
	mob_overlay_icon = 'icons/fallout/onmob/clothes/armor_light.dmi'

/obj/item/clothing/suit/armor/light/duster/rustedcowboy
	name = "rusted cowboy outfit"
	desc = "A weather treated leather cowboy outfit.  Yeehaw Pard'!"
	icon = 'icons/fallout/clothing/armored_light.dmi'
	mob_overlay_icon = 'icons/fallout/onmob/clothes/armor_light.dmi'
	icon_state = "rusted_cowboy"
	item_state = "rusted_cowboy"
	armor_tokens = list(ARMOR_MODIFIER_UP_ENV_T2, ARMOR_MODIFIER_UP_MELEE_T1)

///////////////////
// LEATHER ARMOR //
///////////////////

/obj/item/clothing/suit/armor/light/leather
	name = "leather armor"
	desc = "Before the war motorcycle-football was one of the largest specator sports in America. This armor copies the style of armor used by the players,	using leather boiled in corn oil to make hard sheets to emulate the light weight and toughness of the original polymer armor."
	icon = 'icons/fallout/clothing/armored_light.dmi'
	mob_overlay_icon = 'icons/fallout/onmob/clothes/armor_light.dmi'
	icon_state = "leather_armor"
	item_state = "leather_armor"
	permeability_coefficient = 0.9
	heat_protection = CHEST|GROIN|ARMS|LEGS
	cold_protection = CHEST|GROIN|ARMS|LEGS
	min_cold_protection_temperature = ARMOR_MIN_TEMP_PROTECT
	max_heat_protection_temperature = ARMOR_MAX_TEMP_PROTECT
	strip_delay = 20
	equip_delay_other = 20
	max_integrity = 150
	pocket_storage_component_path = /datum/component/storage/concrete/pockets/armor
	armor_tokens = list(ARMOR_MODIFIER_UP_MELEE_T1, ARMOR_MODIFIER_UP_BULLET_T1, ARMOR_MODIFIER_UP_DT_T2)
	body_parts_hidden = ARMS | CHEST

// Recipe the above + 2 gecko hides
/obj/item/clothing/suit/armor/light/leather/leathermk2
	name = "leather armor mk II"
	desc = "Armor in the motorcycle-football style, either with intact original polymer plating, or reinforced with gecko hide."
	icon_state = "leather_armor_mk2"
	item_state = "leather_armor_mk2"
	armor_tokens = list(ARMOR_MODIFIER_UP_MELEE_T2, ARMOR_MODIFIER_UP_BULLET_T1, ARMOR_MODIFIER_DOWN_FIRE_T2, ARMOR_MODIFIER_UP_DT_T3)

/obj/item/clothing/suit/armor/light/leather/leathersuit
	name = "leather suit"
	desc = "Comfortable suit of tanned leather leaving one arm mostly bare. Keeps you warm and cozy."
	icon_state = "combat_jacket"
	item_state = "combat_jacket"
	flags_inv = HIDEJUMPSUIT
	cold_protection = CHEST | GROIN | LEGS| ARMS | HEAD
	siemens_coefficient = 0.9
	body_parts_hidden = ARMS | CHEST | GROIN | LEGS

/obj/item/clothing/suit/armor/light/leather/leathercoat
	name = "thick leather coat"
	desc = "Reinforced leather jacket with a overcoat. Well insulated, creaks a lot while moving."
	icon_state = "leather_suit"
	item_state = "leather_suit"
	siemens_coefficient = 0.8
	armor_tokens = list(ARMOR_MODIFIER_UP_ENV_T1, ARMOR_MODIFIER_UP_MELEE_T1, ARMOR_MODIFIER_UP_BULLET_T1, ARMOR_MODIFIER_DOWN_LASER_T2, ARMOR_MODIFIER_UP_DT_T2)
	body_parts_hidden = ARMS | CHEST

/obj/item/clothing/suit/armor/light/leather/leather_jacket
	name = "thick leather jacket"
	desc = "This heavily padded leather jacket is unusual in that it has two sleeves. You'll definitely make a fashion statement whenever, and wherever, you rumble."
	icon_state = "leather_jacket_thick"
	item_state = "leather_jacket_thick"
	armor_tokens = list(ARMOR_MODIFIER_UP_ENV_T1, ARMOR_MODIFIER_UP_MELEE_T2, ARMOR_MODIFIER_UP_BULLET_T1, ARMOR_MODIFIER_DOWN_LASER_T2, ARMOR_MODIFIER_DOWN_FIRE_T2, ARMOR_MODIFIER_UP_DT_T3)
	body_parts_hidden = ARMS | CHEST | LEGS

/obj/item/clothing/suit/armor/light/leather/tanvest
	name = "tanned vest"
	icon_state = "tanleather"
	item_state = "tanleather"
	desc = "Layers of leather glued together to make a stiff vest, crude but gives some protection against wild beasts and knife stabs to the liver."
	body_parts_hidden = 0

/obj/item/clothing/suit/armor/light/leather/cowboyvest
	name = "cowboy vest"
	icon_state = "cowboybvest"
	item_state = "cowboybvest"
	desc = "Stylish and has discrete lead plates inserted, just in case someone brings a laser to a fistfight."

/obj/item/clothing/suit/armor/light/leather/durathread
	name = "makeshift vest"
	desc = "A makeshift vest made of heat-resistant fiber."
	icon = 'icons/obj/clothing/suits.dmi'
	mob_overlay_icon = null
	icon_state = "durathread"
	item_state = "durathread"
	armor_tokens = list(ARMOR_MODIFIER_UP_ENV_T1, ARMOR_MODIFIER_UP_BULLET_T1, ARMOR_MODIFIER_DOWN_LASER_T1, ARMOR_MODIFIER_UP_DT_T1)

/obj/item/clothing/suit/armor/light/leather/rig
	name = "chest gear harness"
	desc = "a handmade tactical rig. The actual rig is made of a black, fiberous cloth, being attached to a dusty desert-colored belt with enough room for four small items."
	icon_state = "r_gear_rig"
	item_state = "r_gear_rig"
	body_parts_hidden = 0
	pocket_storage_component_path = /datum/component/storage/concrete/pockets/jacket

////////////////
// ARMOR KITS //
////////////////

/obj/item/clothing/suit/armor/light/kit
	name = "armor kit"
	desc = "Separate armor parts you can wear over your clothing, giving basic protection against bullets entering some of your organs. Very well ventilated."
	icon_state = "armorkit"
	item_state = "armorkit"
	heat_protection = CHEST | GROIN | LEGS| ARMS | HEAD
	siemens_coefficient = 1.1
	body_parts_hidden = 0
	armor_tokens = list(ARMOR_MODIFIER_UP_DT_T1)

/obj/item/clothing/suit/armor/light/kit/punk
	name = "punk armor kit"
	desc = "A couple of armor parts that can be worn over the clothing for moderate protection against the dangers of wasteland.<br>Do you feel lucky now? Well, do ya, punk?"
	icon_state = "armorkit_punk"
	item_state = "armorkit_punk"
	icon = 'icons/fallout/clothing/armored_light.dmi'
	mob_overlay_icon = 'icons/fallout/onmob/clothes/armor_light.dmi'

/obj/item/clothing/suit/armor/light/kit/plates
	name = "light armor plates"
	desc = "Well-made metal plates covering your vital organs."
	icon_state = "light_plates"
	item_state = "armorkit"
	slowdown = ARMOR_SLOWDOWN_MEDIUM * ARMOR_SLOWDOWN_LESS_T1 * ARMOR_SLOWDOWN_GLOBAL_MULT
	armor_tokens = list(ARMOR_MODIFIER_DOWN_BULLET_T1, ARMOR_MODIFIER_UP_MELEE_T1, ARMOR_MODIFIER_UP_LASER_T1, ARMOR_MODIFIER_UP_DT_T1)

/obj/item/clothing/suit/armor/light/mutantkit
	name = "oversized armor kit"
	desc = "Bits of armor fitted to a giant harness. Clearly not made for use by humans."
	icon = 'icons/fallout/clothing/armored_light.dmi'
	mob_overlay_icon = 'icons/fallout/onmob/clothes/armor_light.dmi'
	icon_state = "mutie_armorkit"
	item_state = "mutie_armorkit"
	heat_protection = CHEST | GROIN | LEGS| ARMS | HEAD
	siemens_coefficient = 1.1

///////////////////////////
// !!!FACTION SECTION!!! //
///////////////////////////

/////////
// NCR //
/////////

/obj/item/clothing/suit/armor/light/ncr
	armor_tokens = list(ARMOR_MODIFIER_UP_BULLET_T1, ARMOR_MODIFIER_UP_DT_T1)

//Army
/obj/item/clothing/suit/armor/light/ncr/labcoat
	name = "NCR medical labcoat"
	desc = "An armored labcoat typically issued to NCR Medical Officers. It's a standard white labcoat with the Medical Officer's name stitched into the breast and a two headed bear sewn into the shoulder."
	icon_state = "ncr_labcoat"
	item_state = "ncr_labcoat"
	pocket_storage_component_path = /datum/component/storage/concrete/pockets/medical

//Ranger
/obj/item/clothing/suit/armor/light/ncr/trailranger
	name = "NCR ranger vest"
	desc = "A quaint little jacket and scarf worn by NCR trail rangers."
	icon_state = "ncr_ranger"
	item_state = "ncr_ranger"
	armor_tokens = list(ARMOR_MODIFIER_UP_BULLET_T1, ARMOR_MODIFIER_UP_MELEE_T1, ARMOR_MODIFIER_UP_DT_T1)
	slowdown = ARMOR_SLOWDOWN_LIGHT * ARMOR_SLOWDOWN_GLOBAL_MULT

//Mutie NCR Armor
/obj/item/cloathing/suit/armor/light/ncr/mutant
	name = "NCR mutant scraps"
	desc = "So-called 'armor' given to mutant members of the NCR military. Though.. this equates to little more than scraps of armor."
	icon_state = "mutie_ncr_scrap"
	item_state = "mutie_ncr_scrap"

////////////
// Legion //
////////////

/obj/item/clothing/suit/armor/light/legion
	armor_tokens = list(ARMOR_MODIFIER_UP_MELEE_T1, ARMOR_MODIFIER_UP_DT_T1)

/obj/item/clothing/suit/armor/light/legion/recruit
	name = "legion recruit armor"
	desc = "The most basic legion armor, clearly inspired by gear worn by old world football players and baseball catchers, much of it restored ancient actual sports equipment, other newly made from mostly leather, tanned and boiled in oil."
	icon_state = "legion_rec"
	item_state = "legion_rec"

/obj/item/clothing/suit/armor/light/legion/prime
	name = "legion prime armor"
	desc = "It's a legion prime armor, the warrior has been granted some additional protective pieces to add to his suit."
	icon_state = "legion_prime"
	item_state = "legion_prime"
	slowdown = ARMOR_SLOWDOWN_LIGHT * ARMOR_SLOWDOWN_MORE_T1 * ARMOR_SLOWDOWN_GLOBAL_MULT
	armor_tokens = list(ARMOR_MODIFIER_UP_MELEE_T2, ARMOR_MODIFIER_UP_BULLET_T1, ARMOR_MODIFIER_UP_DT_T1)

/obj/item/clothing/suit/armor/light/legion/explorer
	name = "legion explorer armor"
	desc = "A light armor with layered strips of laminated linen and leather and worn with a large pouch for storing your binoculars."
	icon_state = "legion_explorer"
	item_state = "legion_explorer"
	pocket_storage_component_path = /datum/component/storage/concrete/pockets/binocular
	armor_tokens = list(ARMOR_MODIFIER_UP_MELEE_T1, ARMOR_MODIFIER_UP_BULLET_T1)

/obj/item/clothing/suit/armor/light/legion/explorer/assassin
	name = "legion assassin armor"
	desc = "A suit of light armor with reinforced plates and leather added to it, protecting its user. Perfect for combatants specializing in hit-and-run."
	icon_state = "legion_praetorian"
	item_state = "legion_praetorian"
	slowdown = ARMOR_SLOWDOWN_LIGHT * ARMOR_SLOWDOWN_MORE_T1 * ARMOR_SLOWDOWN_GLOBAL_MULT
	armor_tokens = list(ARMOR_MODIFIER_UP_MELEE_T1, ARMOR_MODIFIER_UP_BULLET_T2, ARMOR_MODIFIER_UP_LASER_T1, ARMOR_MODIFIER_UP_DT_T2)

//////////////////////////
// Brotherhood of Steel //
////////////////////////// 

/obj/item/clothing/suit/armor/light/duster/bos/scribe
	name = "Brotherhood Scribe's robe"
	desc = "A red cloth robe worn by the Brotherhood of Steel Scribes."
	icon_state = "scribe"
	item_state = "scribe"
	armor_tokens = list(ARMOR_MODIFIER_UP_LASER_T1, ARMOR_MODIFIER_UP_ENV_T2)

/obj/item/clothing/suit/armor/light/duster/bos/scribe/headscribe
	name = "brotherhood head scribe robe"
	desc = " A red cloth robe with gold trimmings, worn eclusively by the Head Scribe of a chapter."
	icon_state = "headscribe"
	item_state = "headscribe"
	armor_tokens = list(ARMOR_MODIFIER_UP_LASER_T1, ARMOR_MODIFIER_UP_ENV_T2)

/obj/item/clothing/suit/armor/light/duster/bos/scribe/seniorscribe
	name = "Brotherhood Senior Scribe's robe"
	desc = "A red cloth robe with silver gildings worn by the Brotherhood of Steel Senior Scribes."
	icon_state = "seniorscribe"
	item_state = "seniorscribe"
	armor_tokens = list(ARMOR_MODIFIER_UP_LASER_T1, ARMOR_MODIFIER_UP_ENV_T2)

/obj/item/clothing/suit/armor/light/duster/bos/scribe/field_coat
	name = "fieldscribe coat"
	desc = "A heavy-duty coat and chestrig fitted with tons of pockets. Ballistic weave and ceramic inserts are included to substantially increase Field Scribe survival rates."
	icon_state = "scribecoat"
	item_state = "scribecoat"
	armor_tokens = list(ARMOR_MODIFIER_UP_LASER_T1, ARMOR_MODIFIER_UP_BULLET_T1, ARMOR_MODIFIER_UP_ENV_T2, ARMOR_MODIFIER_UP_DT_T1)
	slowdown = ARMOR_SLOWDOWN_LIGHT * ARMOR_SLOWDOWN_GLOBAL_MULT

/obj/item/clothing/suit/armor/light/duster/bos/scribe/elder
	name = "Brotherhood Elder's robe"
	desc = "A blue cloth robe with some scarlet red parts, traditionally worn by the Brotherhood of Steel Elder."
	icon_state = "elder"
	item_state = "elder"
	armor_tokens = list(ARMOR_MODIFIER_UP_LASER_T2, ARMOR_MODIFIER_UP_ENV_T2, ARMOR_MODIFIER_UP_DT_T1)

/obj/item/clothing/suit/armor/light/combat/brotherhood
	icon = 'icons/fallout/clothing/armored_light.dmi'
	mob_overlay_icon = 'icons/fallout/onmob/clothes/armor_light.dmi'

/obj/item/clothing/suit/armor/light/combat/brotherhood/scout
	name = "brotherhood scout armor"
	desc = "A pre-war set of combat armor with stripped armor plating, allowing for better mobility over their heavier combat armor mk 2 armor counterparts."
	icon_state = "brotherhood_scout_knight"
	item_state = "brotherhood_scout_knight"
	armor_tokens = list(ARMOR_MODIFIER_UP_MELEE_T1, ARMOR_MODIFIER_UP_BULLET_T1, ARMOR_MODIFIER_UP_LASER_T1, ARMOR_MODIFIER_UP_DT_T1)
	slowdown = ARMOR_SLOWDOWN_LIGHT * ARMOR_SLOWDOWN_GLOBAL_MULT

/obj/item/clothing/suit/armor/light/combat/brotherhood/scout/senior
	name = "brotherhood senior scout armor"
	desc = "A pre-war set of combat armor with stripped armor plating, allowing for better mobility over their heavier combat armor mk 2 armor counterparts. It bears a silver stripe."
	icon_state = "brotherhood_scout_senior"
	item_state = "brotherhood_scout_senior"

//////////
// Town //
//////////

/obj/item/clothing/suit/armor/light/duster/town/bartender
	name = "bartender's trenchcoat"
	desc = "A fancy long trenchcoat belonging to a bartender, features an internal pocket large enough to hold a shotgun concealed."
	icon_state = "town_bartender"
	item_state = "town_bartender"

/obj/item/clothing/suit/armor/light/duster/town/coat
	name = "lightly armored trenchcoat"
	desc = "A lightly armored stylish trenchcoat for officals who need the protection."
	icon_state = "town_security"
	item_state = "town_security"

/////////////////
// Great Khans //
////////////////

//These are from light jackets 
/obj/item/clothing/suit/toggle/labcoat/khan_jacket
	name = "Great Khan jacket"
	desc = "A black leather jacket. <br>There is an illustration on the back - an aggressive, red-eyed skull wearing a fur hat with horns.<br>The skull has a mongoloid moustache - it's obviously a Great Khans emblem."
	icon_state = "khan_jacket"
	item_state = "khan_jacket"
	cold_protection = CHEST|GROIN
	heat_protection = CHEST|GROIN
	min_cold_protection_temperature = ARMOR_MIN_TEMP_PROTECT
	max_heat_protection_temperature = ARMOR_MAX_TEMP_PROTECT
	strip_delay = 10
	equip_delay_other = 10
	max_integrity = 100
	pocket_storage_component_path = /datum/component/storage/concrete/pockets/armor
	slowdown = ARMOR_SLOWDOWN_LIGHT * ARMOR_SLOWDOWN_GLOBAL_MULT
	armor = ARMOR_VALUE_LIGHT
	armor_tier_desc = ARMOR_CLOTHING_LIGHT
	stiffness = LIGHT_STIFFNESS
	pocket_storage_component_path = /datum/component/storage/concrete/pockets

/obj/item/cloathing/suit/toggle/labcoat/khan_jacket/reinforced
	name = "Reinforced Great Khan jacket"
	desc = "A black leather jacket with metal layered between it. <br>There is an illustration on the back - and aggressive, red-eyed skull wearing a fur hat with horns.<br>The skull has a mongoloid mustache it is obviously a Great Khans emblem."
	armor_tokens = list(ARMOR_MODIFIER_UP_MELEE_T1, ARMOR_MODIFIER_UP_BULLET_T1, ARMOR_MODIFIER_UP_DT_T1)
