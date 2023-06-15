/*PARENT ITEMS FOR REFERENCE PURPOSES. DO NOT UNCOMMENT

/obj/item/clothing/head
	name = BODY_ZONE_HEAD
	icon = 'icons/obj/clothing/hats.dmi'
	icon_state = "top_hat"
	item_state = "that"
	body_parts_covered = HEAD
	slot_flags = ITEM_SLOT_HEAD
	var/blockTracking = 0 //For AI tracking
	var/can_toggle = null
	dynamic_hair_suffix = "+generic"
	var/datum/beepsky_fashion/beepsky_fashion //the associated datum for applying this to a secbot
	var/list/speechspan = null

/obj/item/clothing/head/Initialize()
	. = ..()
	if(ishuman(loc) && dynamic_hair_suffix)
		var/mob/living/carbon/human/H = loc
		H.update_hair()

/obj/item/clothing/head/get_head_speechspans(mob/living/carbon/user)
	if(speechspan)
		return speechspan
	else
		return

/obj/item/clothing/head/helmet
	name = "helmet"
	desc = "Standard Security gear. Protects the head from impacts."
	icon_state = "helmet"
	item_state = "helmet"
	armor = list("melee" = 40, "bullet" = 40, "laser" = 40, "energy" = 20, "bomb" = 50, "bio" = 60, "rad" = 10, "fire" = 60, "acid" = 20)
	flags_inv = HIDEEARS | HIDEHAIR
	cold_protection = HEAD
	min_cold_protection_temperature = HELMET_MIN_TEMP_PROTECT
	heat_protection = HEAD
	max_heat_protection_temperature = HELMET_MAX_TEMP_PROTECT
	strip_delay = 60
	resistance_flags = NONE
	flags_cover = HEADCOVERSEYES

	dog_fashion = /datum/dog_fashion/head/helmet

/obj/item/clothing/head/helmet/ComponentInitialize()
	. = ..()
	AddComponent(/datum/component/wearertargeting/earprotection, list(SLOT_HEAD))*/

//Combat Armor FACTION SPECIFIC COMBAT ARMOR IN f13factionhead.dm

/obj/item/clothing/head/f13
	flags_inv = null

/obj/item/clothing/head/f13/rastacap
	name = "rastacap"
	desc = "<font color='#157206'>Him haffi drop him fork and run,</font><br><font color='green'>Him can't stand up to Jah Jah son,</font><br><font color='#fd680e'>Him haffi lef' ya with him gun,</font><br><font color='red'>Dig off with him bomb.</font>"
	icon_state = "rastacap"
	item_state = "fedora"
	cold_protection = HEAD //This tam brings the warm reggae and Jamaican sun with it.
	min_cold_protection_temperature = FIRE_HELM_MIN_TEMP_PROTECT

/obj/item/clothing/head/f13/hairband
	name = "hairband"
	desc = "Pretty yellow hairband"
	icon_state = "50shairband"
	item_state = "50shairband"
	dynamic_hair_suffix = ""

/obj/item/clothing/head/f13/nursehat
	name = "nursehat"
	desc = "White cloth headdress for nurses"
	icon_state = "nursehat"
	item_state = "nursehat"
	dynamic_hair_suffix = ""

/obj/item/clothing/head/f13/beaver
	name = "beaverkin"
	desc = "A hat made from felted beaver fur which makes the wearer feel both comfortable and elegant."
	icon_state = "beaver"
	item_state = "that"

/obj/item/clothing/head/f13/purple
	name = "purple top hat"
	desc = "You may not own the best jail in the observed Universe, or the best chocolate factory in the entire world, but at least you can try to have that purple top hat."
	icon_state = "ptophat"
	item_state = "that"

/obj/item/clothing/head/f13/trilby
	name = "feather trilby"
	desc = "A sharp, stylish blue hat with a feather."
	icon_state = "trilby"
	item_state = "fedora"

/obj/item/clothing/head/f13/stormchaser
	name = "stormchaser hat"
	desc = "Home, home on the wastes,<br>Where the mole rat and the fire gecko play.<br>Where seldom is heard a discouraging word,<br>And my skin is not glowing all day."
	icon_state = "stormchaser"
	item_state = "fedora"
	flags_inv = HIDEEARS|HIDEHAIR

/obj/item/clothing/head/f13/headscarf
	name = "headscarf"
	desc = "A piece of cloth worn on head for a variety of purposes, such as protection of the head or hair from rain, wind, dirt, cold, warmth, for sanitation, for fashion, recognition or social distinction - with religious significance, to hide baldness, out of modesty, or other forms of social convention."
	icon_state = "headscarf"
	item_state = "dethat"
	flags_inv = HIDEMASK|HIDEEARS|HIDEFACE|HIDEHAIR|HIDEFACIALHAIR

/obj/item/clothing/head/f13/headscarf/Initialize()
	. = ..()
	AddComponent(/datum/component/armor_plate)

/obj/item/clothing/head/f13/pot
	name = "metal cooking pot"
	desc = "Step one: Start with the sauce.<br>Step two: Add the noodles.<br>Step three: Stir the pasta.<br>Step four: Turn up the heat.<br>Step five: Burn the house."
	icon_state = "pot"
	item_state = "fedora"
	force = 20
	hitsound = 'sound/items/trayhit1.ogg'
	flags_inv = HIDEHAIR

/obj/item/clothing/head/f13/cowboy
	name = "cowboy hat"
	desc = "I've never seen so many men wasted so badly."
	icon_state = "cowboy"
	item_state = "dethat"
	flags_inv = HIDEHAIR

/obj/item/clothing/head/f13/cowboy/Initialize()
	. = ..()
	AddComponent(/datum/component/armor_plate)


/obj/item/clothing/head/f13/bandit
	name = "bandit hat"
	desc = "A black cowboy hat with a large brim that's curved to the sides.<br>A silver eagle pin is attached to the front."
	icon_state = "bandit"
	item_state = "fedora"
	flags_inv = HIDEHAIR

/obj/item/clothing/head/f13/bandit/Initialize()
	. = ..()
	AddComponent(/datum/component/armor_plate)

/obj/item/clothing/head/f13/gambler
	name = "gambler hat"
	desc = "A perfect hat for a ramblin' gamblin' man." //But I got to ramble (ramblin' man) //Oh I got to gamble (gamblin' man) //Got to got to ramble (ramblin' man) //I was born a ramblin' gamblin' man
	icon_state = "gambler"
	item_state = "dethat"
	flags_inv = HIDEHAIR

/obj/item/clothing/head/helmet/f13/vaquerohat
	name = "vaquero hat"
	desc = "An old sombrero worn by Vaqueros to keep off the harsh sun."
	icon_state = "vaquerohat"
	item_state = "vaquerohat"
	flags_inv = HIDEEARS|HIDEHAIR

/obj/item/clothing/head/helmet/f13/hoodedmask
	name = "hooded mask"
	desc = "A gask mask with the addition of a hood."
	icon_state = "Hooded_Gas_Mask"
	item_state = "Hooded_Gas_Mask"
	flags_inv = HIDEMASK|HIDEEARS|HIDEEYES|HIDEFACE|HIDEHAIR|HIDEFACIALHAIR
	dynamic_hair_suffix = ""
	dynamic_fhair_suffix = ""

/obj/item/clothing/head/helmet/f13/brahmincowboyhat
	name = "brahmin leather cowboy hat"
	desc = "A cowboy hat made from brahmin hides."
	icon_state = "brahmin_leather_cowboy_hat"
	item_state = "brahmin_leather_cowboy_hat"
	flags_inv = HIDEEARS|HIDEHAIR

/obj/item/clothing/head/helmet/f13/rustedcowboyhat
	name = "Rusted Cowboy Hat"
	desc = "A hat made from tanned leather hide."
	icon_state = "rusted_cowboy"
	item_state = "rusted_cowboy"
	flags_inv = HIDEEARS|HIDEHAIR

/obj/item/clothing/head/f13/police
	name = "police hat"
	desc = "The wasteland's finest."
	icon_state = "retropolice"
	item_state = "fedora"
	flags_inv = HIDEHAIR

/obj/item/clothing/head/simplekitty
	name = "kitty headband"
	desc = "A headband with a pair of cute kitty ears."
	icon_state = "kittyb"
	color = "#999999"
	dynamic_hair_suffix = ""

/obj/item/clothing/head/f13/riderw
	name = "Reinforced Rider Helmet" //Not raider. Rider. //Count up your sins
	desc = "It's a fancy two-tone metal helmet. It's been lined with additional plating and given a fresh coat of paint."
	icon_state = "riderw"
	item_state = "riderw"

//Soft caps
/obj/item/clothing/head/soft/f13
	flags_inv = HIDEEARS|HIDEHAIR

/obj/item/clothing/head/soft/f13/baseball
	name = "baseball cap"
	desc = "A type of soft cap with a rounded crown and a stiff peak projecting out the front."
	icon_state = "baseballsoft"
	soft_type = "baseball"

/obj/item/clothing/head/soft/f13/utility
	name = "grey utility cover"
	desc = "An eight-pointed hat, with a visor similar to a baseball cap, known as utility cover, also called the utility cap or eight-pointed cover."
	icon_state = "utility_g"
	item_color = "utility_g"

/obj/item/clothing/head/soft/f13/utility/navy
	name = "navy utility cover"
	icon_state = "utility_n"
	item_color = "utility_n"

/obj/item/clothing/head/soft/f13/utility/olive
	name = "olive utility cover"
	icon_state = "utility_o"
	item_color = "utility_o"

/obj/item/clothing/head/soft/f13/utility/tan
	name = "tan utility cover"
	icon_state = "utility_t"
	item_color = "utility_t"

/obj/item/clothing/head/f13/servant
	name = "servant headwear"
	desc = "A simple uncoloured linen cloth wrapped around the head, the mark of a servant slave trained in household work."
	icon = 'icons/fallout/clothing/hats.dmi'
	mob_overlay_icon = 'icons/fallout/onmob/clothes/head.dmi'
	icon_state = "legion-servant"
	item_state = "legion-servant"
	flags_inv = HIDEEARS
	flags_cover = null

/obj/item/clothing/head/f13/auxilia
	name = "auxilia headwear"
	desc = "A soft red cap with a black band, used by female Auxilia outside camp."
	icon = 'icons/fallout/clothing/hats.dmi'
	mob_overlay_icon = 'icons/fallout/onmob/clothes/head.dmi'
	icon_state = "legion-aux"
	item_state = "legion-aux"
	flags_inv = HIDEEARS
	flags_cover = null

/obj/item/clothing/head/f13/ncr/ncr_flapcap
	name = "NCR field cap"
	desc = "A special issue canvas NCR field cap with cotton neckflap, for sun protection in arid climates."
	icon_state = "ncr_flapcap"
	item_state = "ncr_flapcap"
	armor = ARMOR_VALUE_CLOTHES

/obj/item/clothing/head/f13/ncr/ncr_slouch
	name = "NCR slouch hat"
	desc = "An irregular issue NCR sun hat, the left side of the brim is pinned to the crown for ease with shouldering rifles."
	icon_state = "ncr_slouch"
	item_state = "ncr_slouch"
	armor = ARMOR_VALUE_CLOTHES

/obj/item/clothing/head/f13/ncr/ncr_stetson
	name = "NCR air cavalry stetson"
	desc = "A black brahmin leather stetson, authorized for usage amongst all troopers assigned to Air Cavalry units."
	icon_state = "ncr_stetson"
	item_state = "ncr_stetson"
	armor = ARMOR_VALUE_CLOTHES

/obj/item/clothing/head/f13/ncr/ncr_cap
	name = "NCR garrison cap"
	desc = "A simple cloth garrison cap to be worn when a helmet isn't necessary."
	icon_state = "ncr_cap"
	item_state = "ncr_cap"
	armor = ARMOR_VALUE_CLOTHES

/obj/item/clothing/head/f13/ncr/ncr_campaign
	name = "NCR campaign hat"
	desc = "A khaki campaign hat, popularly used by senior NCOs in the NCRA."
	icon_state = "ncr_campaign"
	item_state = "ncr_campaign"

/obj/item/clothing/head/beret/ncr
	name = "NCR officer beret"
	desc = "A green beret, standard issue for all commissioned NCR Officers."
	icon_state = "ncr_officer_beret"
	item_state = "ncr_officer_beret"

/obj/item/clothing/head/beret/ncr/ncr_medic
	name = "NCR medical beret"
	desc = "A white beret, issued to officers of the medical corps."
	icon_state = "ncr_medical_beret"
	item_state = "ncr_medical_beret"

/obj/item/clothing/head/beret/ncr/ncr_sapper
	name = "NCR Sapper beret"
	desc = "A grey beret, issued to troopers that have passed Sapper School."
	icon_state = "ncr_sapper_beret"
	item_state = "ncr_sapper_beret"

/obj/item/clothing/head/beret/ncr/ncr_sof
	name = "NCR SOF beret"
	desc = "A tan beret, issued members of the New California Republic Special Operations Command."
	icon_state = "ncr_sof_beret"
	item_state = "ncr_sof_beret"

/obj/item/clothing/head/beret/ncr_dresscap
	name = "NCR peaked cap"
	desc = "A tan peaked cap with silver pin, designated for enlisted NCRA personnel."
	icon_state = "ncr_dresscap"
	item_state = "ncr_dresscap"

/obj/item/clothing/head/beret/ncr_codresscap
	name = "NCR peaked cap"
	desc = "A tan peaked cap with golden pin, designated for commissioned NCRA personnel."
	icon_state = "ncr_codresscap"
	item_state = "ncr_codresscap"

/Oasis/Town

/obj/item/clothing/head/f13/town
	name = "town tricorn"
	desc = "Why are there tricorns in the desert again?"
	icon_state = "tricorn"
	item_state = "dethat"
	flags_inv = HIDEHAIR

/obj/item/clothing/head/f13/town/mayor
	name = "mayoral tricorn"
	desc = "A tricorn in the desert.  Stranger things have happened."

/obj/item/clothing/head/f13/town/big
	name = "big hat"
	desc = "It's a big hat."
	icon_state = "bigcowboyhat"

/obj/item/clothing/head/f13/town/deputy/Initialize()
	. = ..()
	AddComponent(/datum/component/armor_plate)

/obj/item/clothing/head/f13/town/officer
	name = "Ripley officer's cap"
	desc = "A simple dark navy peaked cap, worn by police."
	icon = 'icons/fallout/clothing/hats.dmi'
	mob_overlay_icon = 'icons/fallout/onmob/clothes/head.dmi'
	icon_state = "police_officer"
	item_state = "police_officer"

/obj/item/clothing/head/f13/town/chief
	name = "NPD Chief's hat"
	desc = "A blue hat with a silver badge."
	icon = 'icons/fallout/clothing/hats.dmi'
	mob_overlay_icon = 'icons/fallout/onmob/clothes/head.dmi'
	icon_state = "police_chief"
	item_state = "police_chief"

/obj/item/clothing/head/f13/det_hat_alt
	name = "detective's fedora"
	desc = "There's only one man who can sniff out the dirty stench of crime, and he's likely wearing this black hat."
	icon_state = "detectivealt"
	item_state = "fedora"
	flags_inv = HIDEHAIR

/obj/item/clothing/head/helmet/f13/wayfarer/chief/green
	name = "helm of the helping hand"
	desc = "The many eyed helper to the village and all, the Chief that chooses this Mr. Handy based mantle is clever and kind in equal measure, they embody industry and diplomacy. Though they aren't defensive, they are surgically precise in eliminating those who oppose them."
	icon_state = "chiefgreen"
	item_state = "chiefgreen"

/obj/item/clothing/head/helmet/f13/wayfarer/shamanblue
	name = "ritual headdress"
	desc = "An ancient mask fashioned at the coasts of the Great Salt Water, imbued with the ancestral blessing through a long forgotten ritual."
	icon_state = "shamanblue"
	item_state = "shamanblue"
	flags_inv = HIDEMASK|HIDEEARS|HIDEEYES|HIDEFACE|HIDEHAIR|HIDEFACIALHAIR

/obj/item/clothing/head/helmet/f13/wayfarer/shamanred
	name = "crimson mask"
	desc = "An uncanny helm passed down through generations, originating from a tribal culture once situated at the top of a Sonoran mesa."
	icon_state = "shamanred"
	item_state = "shamanred"
	flags_inv = HIDEMASK|HIDEEARS|HIDEEYES|HIDEFACE|HIDEHAIR|HIDEFACIALHAIR

//Old World Law Enforcement
//Police and State Police

/obj/item/clothing/head/f13/police/officer
	name = "police officer's cap"
	desc = "A simple dark navy peaked cap, worn by police."
	icon = 'icons/fallout/clothing/hats.dmi'
	mob_overlay_icon = 'icons/fallout/onmob/clothes/head.dmi'
	icon_state = "police_officer"
	item_state = "police_officer"

/obj/item/clothing/head/f13/police/sergeant
	name = "police campaign hat"
	desc = "A simple dark navy campaign hat, worn by police."
	icon = 'icons/fallout/clothing/hats.dmi'
	mob_overlay_icon = 'icons/fallout/onmob/clothes/head.dmi'
	icon_state = "police_sergeant"
	item_state = "police_sergeant"

/obj/item/clothing/head/f13/police/lieutenant
	name = "police lieutenant's cap"
	desc = "A simple dark navy peaked cap, worn by police."
	icon = 'icons/fallout/clothing/hats.dmi'
	mob_overlay_icon = 'icons/fallout/onmob/clothes/head.dmi'
	icon_state = "police_lieutenant"
	item_state = "police_lieutenant"

/obj/item/clothing/head/f13/police/chief
	name = "police chief's cap"
	desc = "A simple dark navy peaked cap, worn by police."
	icon = 'icons/fallout/clothing/hats.dmi'
	mob_overlay_icon = 'icons/fallout/onmob/clothes/head.dmi'
	icon_state = "police_chief"
	item_state = "police_chief"

/obj/item/clothing/head/f13/police/trooper
	name = "state police campaign hat"
	desc = "A gray campaign hat, worn by the State Police."
	icon = 'icons/fallout/clothing/hats.dmi'
	mob_overlay_icon = 'icons/fallout/onmob/clothes/head.dmi'
	icon_state = "state_trooper"
	item_state = "state_trooper"


//Old World Militaries
//US Army and PLA

/obj/item/clothing/head/f13/army
	name = "US Army field cap"
	desc = "Standard issue US Army field cap."
	icon = 'icons/fallout/clothing/hats.dmi'
	mob_overlay_icon = 'icons/fallout/onmob/clothes/head.dmi'
	icon_state = "army_cap"
	item_state = "army_cap"
	dynamic_hair_suffix = "+generic"

/obj/item/clothing/head/f13/army/officer
	name = "US Army officer's cap"
	desc = "US Army officer's cap."
	icon = 'icons/fallout/clothing/hats.dmi'
	mob_overlay_icon = 'icons/fallout/onmob/clothes/head.dmi'
	icon_state = "army_officer"
	item_state = "army_officer"


/obj/item/clothing/head/f13/army/general
	name = "US Army general's cap"
	desc = "US Army officer's cap."
	icon = 'icons/fallout/clothing/hats.dmi'
	mob_overlay_icon = 'icons/fallout/onmob/clothes/head.dmi'
	icon_state = "army_general"
	item_state = "army_general"

obj/item/clothing/head/f13/army/beret
	name = "US Army beret"
	desc = "A black beret, standard issue for all US Army personnel not authorised to wear a different beret."
	icon = 'icons/fallout/clothing/hats.dmi'
	mob_overlay_icon = 'icons/fallout/onmob/clothes/head.dmi'
	icon_state = "army_beret"
	item_state = "army_beret"

/obj/item/clothing/head/f13/army/beret/airborne
	name = "US Army airborne beret"
	desc = "A red beret, issued to US Army Airborne personnel."
	icon = 'icons/fallout/clothing/hats.dmi'
	mob_overlay_icon = 'icons/fallout/onmob/clothes/head.dmi'
	icon_state = "army_beret_airborne"
	item_state = "army_beret_airborne"

/obj/item/clothing/head/f13/army/beret/rangers
	name = "US Army rangers beret"
	desc = "A tan beret, issued to US Army Rangers."
	icon = 'icons/fallout/clothing/hats.dmi'
	mob_overlay_icon = 'icons/fallout/onmob/clothes/head.dmi'
	icon_state = "army_beret_ranger"
	item_state = "army_beret_ranger"

/obj/item/clothing/head/f13/army/beret/specialforces
	name = "US Army special forces beret"
	desc = "A green beret, issued to US Army Special Forces personnel."
	icon = 'icons/fallout/clothing/hats.dmi'
	mob_overlay_icon = 'icons/fallout/onmob/clothes/head.dmi'
	icon_state = "army_beret_specialforces"
	item_state = "army_beret_specialforces"

//People's Liberation Army

/obj/item/clothing/head/f13/chinese
	name = "PLA field cap"
	desc = "A People's Liberation Army cap, worn by enlisted and non-commissioned officers."
	icon = 'icons/fallout/clothing/hats.dmi'
	mob_overlay_icon = 'icons/fallout/onmob/clothes/head.dmi'
	icon_state = "chinese_soldier"
	item_state = "chinese_soldier"

/obj/item/clothing/head/f13/chinese/officer
	name = "PLA officer's cap"
	desc = "A People's Liberation Army peaked cap, worn by officers."
	icon = 'icons/fallout/clothing/hats.dmi'
	mob_overlay_icon = 'icons/fallout/onmob/clothes/head.dmi'
	icon_state = "chinese_officer"
	item_state = "chinese_officer"
