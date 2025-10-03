/*
Town access doors
Sheriff/Deputy, Gatehouse etc: 62 ACCESS_GATEWAY
General access: 25 ACCESS_BAR
Clinic surgery/storage: 68 ACCESS_CLONING
Shopkeeper: 34 ACCESS_CARGO_BOT
Barkeep : 28 ACCESS_KITCHEN - you jebronis made default bar for no reason bruh
Prospector : 48 ACCESS_MINING
Detective : 4 ACCESS_FORENSICS_LOCKERS
here's a tip, go search DEFINES/access.dm
*/

// Headsets for everyone!!
/datum/outfit/job/den
	name = "Nash Default Template"
	//ears = /obj/item/radio/headset/headset_town
	id = /obj/item/card/id/dogtag/town
	uniform = /obj/item/clothing/under/f13/settler
	shoes = /obj/item/clothing/shoes/jackboots
	backpack = /obj/item/storage/backpack/satchel/explorer
	r_pocket = /obj/item/flashlight/flare
	backpack_contents = list(
		/obj/item/storage/pill_bottle/chem_tin/radx,
		/obj/item/storage/bag/money/small/settler = 1,
		/obj/item/melee/onehanded/knife/hunting = 1
		)

/*
Mayor
*/

/datum/job/oasis
	exp_type = EXP_TYPE_OASIS
	faction = FACTION_OASIS

/datum/job/oasis/f13mayor   // /obj/item/card/id/captains_spare for any elected mayors. - Blue
	title = "Mayor"
	flag = F13MAYOR
	department_flag = DEP_OASIS
	total_positions = 1
	spawn_positions = 1
	supervisors = "Ripley"
	description = "You are the civil leader of the Town of Ripley. You were chosen by the people to represent and lead them from your manor. Your town is in a terse situation with the slaver town to the south, Redwater. While not at war, you will have to work to keep your people safe from their predations. The Tribals to the south east are also a nuisance but it's best not to provoke them needlessly. Do what's best for the town, and it's people. All while lining your pockets occasionally, of course."
	enforces = "The Secretary is your stand-in replacement, and under this the Sheriff."
	selection_color = "#d7b088"

	exp_requirements = 750

	outfit = /datum/outfit/job/den/f13mayor
	access = list(ACCESS_BAR, ACCESS_MAYOR, ACCESS_OFFICER, ACCESS_CLONING, ACCESS_GATEWAY, ACCESS_CARGO_BOT, ACCESS_MINT_VAULT, ACCESS_CLINIC, ACCESS_KITCHEN, ACCESS_MINING, ACCESS_FORENSICS_LOCKERS, ACCESS_FOLLOWER)
	minimal_access = list(ACCESS_BAR, ACCESS_MAYOR, ACCESS_OFFICER, ACCESS_CLONING, ACCESS_GATEWAY, ACCESS_CARGO_BOT, ACCESS_MINT_VAULT, ACCESS_KITCHEN, ACCESS_CLINIC, ACCESS_MINING, ACCESS_FORENSICS_LOCKERS, ACCESS_FOLLOWER)
	matchmaking_allowed = list(
		/datum/matchmaking_pref/friend = list(
			/datum/job/oasis
		),
		/datum/matchmaking_pref/rival = list(
			/datum/job/oasis
		)
	)


/datum/outfit/job/den/f13mayor/pre_equip(mob/living/carbon/human/H, visualsOnly = FALSE)
	..()
	if(visualsOnly)
		return
	H.mind.teach_crafting_recipe(/datum/crafting_recipe/tribalradio)
	H.mind.teach_crafting_recipe(/datum/crafting_recipe/durathread_vest)
	H.mind.teach_crafting_recipe(/datum/crafting_recipe/pico_manip)
	H.mind.teach_crafting_recipe(/datum/crafting_recipe/super_matter_bin)
	H.mind.teach_crafting_recipe(/datum/crafting_recipe/phasic_scanning)
	H.mind.teach_crafting_recipe(/datum/crafting_recipe/super_capacitor)
	H.mind.teach_crafting_recipe(/datum/crafting_recipe/ultra_micro_laser)
	H.mind.teach_crafting_recipe(/datum/crafting_recipe/town_combat)
	H.mind.teach_crafting_recipe(/datum/crafting_recipe/town_combat_mk2)
	//ADD_TRAIT(H, TRAIT_TECHNOPHREAK, src)
	ADD_TRAIT(H, TRAIT_GENERIC, src)

/datum/outfit/job/den/f13mayor
	name = "Mayor"
	jobtype = /datum/job/oasis/f13mayor
	id = /obj/item/card/id/silver/mayor
	ears = /obj/item/radio/headset/headset_town/mayor
	backpack = /obj/item/storage/backpack/satchel/explorer
	satchel = /obj/item/storage/backpack/satchel/explorer
	l_pocket = /obj/item/storage/bag/money/small/oasis
	r_pocket = /obj/item/flashlight/seclite
	shoes = /obj/item/clothing/shoes/f13/tan
	uniform = /obj/item/clothing/under/f13/gentlesuit
	suit = /obj/item/clothing/suit/armor/light/duster/town/coat
	head = /obj/item/clothing/head/f13/town/mayor
	backpack_contents = list(
		/obj/item/storage/pill_bottle/chem_tin/radx,
		/obj/item/storage/box/citizenship_permits = 1,
		/obj/item/pen/fountain/captain = 1,
		/obj/item/gun/ballistic/automatic/pistol/mk23 = 1,
		/obj/item/ammo_box/magazine/m45/socom = 2
		)


/*--------------------------------------------------------------*/

/datum/job/oasis/f13secretary
	title = "Secretary"
	flag = F13SECRETARY
	department_flag = DEP_OASIS
	total_positions = 1
	spawn_positions = 1
	supervisors = "The Mayor"
	description = "The settlement of Ripley is a busy place, and the Mayor often can't handle everything by themselves. You are here to help them with anything and everything they require, and make sure the more trivial problems do not concern them. You handle clerical work, hear complaints, and set meetings within the manor. An efficient and smooth running town means a happy Mayor - just remember that if things go wrong, you're a convenient scapegoat."
	enforces = "You are the stand-in leader of Ripley if a Mayor does not exist."
	selection_color = "#d7b088"
	exp_requirements = 400

	outfit = /datum/outfit/job/den/f13secretary

	loadout_options = list(
	/datum/outfit/loadout/pr,
	/datum/outfit/loadout/pw
	)

	access = list(ACCESS_BAR, ACCESS_MAYOR, ACCESS_CLONING, ACCESS_GATEWAY, ACCESS_CARGO_BOT, ACCESS_MINT_VAULT, ACCESS_CLINIC, ACCESS_KITCHEN, ACCESS_MINING, ACCESS_FORENSICS_LOCKERS, ACCESS_FOLLOWER)
	minimal_access = list(ACCESS_BAR, ACCESS_MAYOR, ACCESS_CLONING, ACCESS_GATEWAY, ACCESS_CARGO_BOT, ACCESS_MINT_VAULT, ACCESS_KITCHEN, ACCESS_CLINIC, ACCESS_MINING, ACCESS_FORENSICS_LOCKERS, ACCESS_FOLLOWER)
	matchmaking_allowed = list(
		/datum/matchmaking_pref/friend = list(
			/datum/job/oasis
		),
		/datum/matchmaking_pref/rival = list(
			/datum/job/oasis
		)
	)

/datum/outfit/job/den/f13secretary
	name = "Secretary"
	jobtype = /datum/job/oasis/f13secretary
	id = /obj/item/card/id/silver
	ears = /obj/item/radio/headset/headset_town/mayor
	glasses = /obj/item/clothing/glasses/regular/hipster
	gloves = /obj/item/clothing/gloves/color/white
	backpack = /obj/item/storage/backpack/satchel/leather
	satchel = /obj/item/storage/backpack/satchel/leather
	r_hand = /obj/item/storage/briefcase/secretary
	l_pocket = /obj/item/storage/bag/money/small/settler
	r_pocket = /obj/item/flashlight/seclite
	shoes = /obj/item/clothing/shoes/f13/fancy
	uniform = /obj/item/clothing/under/suit/black
	backpack_contents = list(
		/obj/item/storage/pill_bottle/chem_tin/radx = 1,
		/obj/item/gun/ballistic/automatic/pistol/ninemil = 1,
		/obj/item/ammo_box/magazine/m9mm = 1,
		/obj/item/melee/onehanded/knife/switchblade = 1,
		/obj/item/pda = 1
		)

/datum/outfit/loadout/pr
	name = "Public Relations"
	backpack_contents = list(
		/obj/item/megaphone = 1,
		/obj/item/reagent_containers/food/snacks/store/cake/birthday = 1,
		/obj/item/clothing/accessory/medal/ribbon = 1,
		/obj/item/clothing/gloves/color/latex/nitrile = 1,
		/obj/item/camera = 1,
		/obj/item/storage/crayons = 1,
		/obj/item/choice_beacon/box/carpet = 1
		)

/datum/outfit/loadout/pw
	name = "Public Works"
	backpack_contents = list(
		/obj/item/clothing/head/hardhat = 1,
		/obj/item/clothing/suit/hazardvest = 1,
		/obj/item/stack/sheet/metal/twenty = 2,
		/obj/item/stack/sheet/glass/ten = 2,
		/obj/item/stack/sheet/mineral/concrete/ten = 2
		)

/datum/outfit/job/den/f13secretary/pre_equip(mob/living/carbon/human/H, visualsOnly = FALSE)
	..()
	if(visualsOnly)
		return
	H.mind.teach_crafting_recipe(/datum/crafting_recipe/tribalradio)
	H.mind.teach_crafting_recipe(/datum/crafting_recipe/durathread_vest)
	H.mind.teach_crafting_recipe(/datum/crafting_recipe/policepistol)
	H.mind.teach_crafting_recipe(/datum/crafting_recipe/policerifle)
	H.mind.teach_crafting_recipe(/datum/crafting_recipe/steelbib/heavy)
	H.mind.teach_crafting_recipe(/datum/crafting_recipe/armyhelmetheavy)
	H.mind.teach_crafting_recipe(/datum/crafting_recipe/pico_manip)
	H.mind.teach_crafting_recipe(/datum/crafting_recipe/super_matter_bin)
	H.mind.teach_crafting_recipe(/datum/crafting_recipe/phasic_scanning)
	H.mind.teach_crafting_recipe(/datum/crafting_recipe/super_capacitor)
	H.mind.teach_crafting_recipe(/datum/crafting_recipe/ultra_micro_laser)
	//ADD_TRAIT(H, TRAIT_TECHNOPHREAK, src)
	ADD_TRAIT(H, TRAIT_GENERIC, src)
	//ADD_TRAIT(H, TRAIT_SELF_AWARE, src)


/*--------------------------------------------------------------*/

/datum/job/oasis/f13sheriff
	title = "Sheriff"
	flag = F13SHERIFF
	department_flag = DEP_OASIS
	head_announce = list("Security")
	total_positions = 1
	spawn_positions = 1
	supervisors = "The Mayor"
	description = "You are the civil enforcer of Ripley, keeping the settlement within firm control under the authority of the Mayor. With your loyal patrolmen, you maintain your claim to authority by keeping the peace, managing disputes, and protecting the citizens from threats within and without. Never leave Ripley undefended, and don't let its people die out. If this town falls, new conquerors don't tend to look kindly upon the old law."
	enforces = "You are the stand-in leader of Ripley if a Mayor or Secretary does not exist."
	selection_color = "#d7b088"
	exp_requirements = 750

	outfit = /datum/outfit/job/den/f13sheriff
	smutant_outfit = /datum/outfit/smutant/town/police

	loadout_options = list(
	/datum/outfit/loadout/thelaw,
	/datum/outfit/loadout/thechief,
	/datum/outfit/loadout/thegangster
	)

	access = list(ACCESS_BAR, ACCESS_CLONING, ACCESS_GATEWAY, ACCESS_CARGO_BOT, ACCESS_MINT_VAULT, ACCESS_KITCHEN, ACCESS_MINING, ACCESS_FORENSICS_LOCKERS, ACCESS_CLINIC, ACCESS_FOLLOWER, ACCESS_OFFICER)
	minimal_access = list(ACCESS_BAR, ACCESS_CLONING, ACCESS_GATEWAY, ACCESS_CARGO_BOT, ACCESS_MINT_VAULT, ACCESS_CLINIC, ACCESS_KITCHEN, ACCESS_MINING, ACCESS_FORENSICS_LOCKERS, ACCESS_CLINIC, ACCESS_FOLLOWER, ACCESS_OFFICER)
	matchmaking_allowed = list(
		/datum/matchmaking_pref/friend = list(
			/datum/job/oasis
		),
		/datum/matchmaking_pref/rival = list(
			/datum/job/oasis
		)
	)

/datum/outfit/smutant/town/police
	suit = /obj/item/clothing/suit/armor/medium/duster/mutie
	uniform = /obj/item/clothing/under/f13/mutie/townie/deputy
	shoes = /obj/item/clothing/shoes/f13/mutie/boots
	gloves = /obj/item/clothing/gloves/f13/mutie/sign

/datum/outfit/job/den/f13sheriff
	name = "Sheriff"
	jobtype = /datum/job/oasis/f13sheriff
	id = /obj/item/card/id/dogtag/sheriff
	ears = /obj/item/radio/headset/headset_town/lawman
	backpack = /obj/item/storage/backpack/satchel/explorer
	satchel = /obj/item/storage/backpack/satchel/explorer
	uniform = /obj/item/clothing/under/f13/sheriff
	shoes = /obj/item/clothing/shoes/f13/cowboy
	glasses = /obj/item/clothing/glasses/sunglasses
	l_pocket = /obj/item/storage/bag/money/small/den
	backpack_contents = list(
		/obj/item/storage/pill_bottle/chem_tin/radx,
		/obj/item/storage/box/deputy_badges = 1,
		/obj/item/restraints/handcuffs = 1,
		/obj/item/melee/classic_baton = 1,
		/obj/item/melee/onehanded/knife/bowie = 1,
		/obj/item/grenade/flashbang = 1,
		/obj/item/storage/belt/army = 1
		)

/datum/outfit/loadout/thelaw
	name = "The Law Man"
	suit = /obj/item/clothing/suit/armor/medium/town/riot
	head = /obj/item/clothing/head/f13/town/sheriff
	uniform = /obj/item/clothing/under/f13/police/formal
	neck = /obj/item/storage/belt/shoulderholster/ranger45
	suit_store = /obj/item/gun/ballistic/rifle/repeater/brush
	shoes = /obj/item/clothing/shoes/f13/military/plated

	backpack_contents = list(
		/obj/item/ammo_box/tube/c4570 = 3,
		/obj/item/gun_upgrade/scope/watchman = 1
	)

/datum/outfit/loadout/thechief
	name = "The Chief"
	uniform = /obj/item/clothing/under/f13/police/chief
	suit = /obj/item/clothing/suit/armor/medium/town/riot
	head = /obj/item/clothing/head/helmet/f13/combat/town
	neck = /obj/item/storage/belt/shoulderholster/ranger45
	shoes = /obj/item/clothing/shoes/combat
	suit_store = /obj/item/gun/ballistic/shotgun/automatic/combat/citykiller
	backpack_contents = list(/obj/item/ammo_box/shotgun/slug = 1,
		/obj/item/ammo_box/shotgun/buck = 2
		)

/datum/outfit/loadout/thegangster
	name = "The Gangster"
	uniform = /obj/item/clothing/under/f13/police/chief
	suit = /obj/item/clothing/suit/armor/medium/town/riot
	head = /obj/item/clothing/head/helmet/f13/combat/town
	neck = /obj/item/storage/belt/shoulderholster/ranger45
	suit_store = /obj/item/gun/ballistic/automatic/smg/tommygun
	backpack_contents = list(/obj/item/ammo_box/magazine/tommygunm45/stick = 2,
		)

/*--------------------------------------------------------------*/

/datum/job/oasis/f13deputy
	title = "Deputy"
	flag = F13DEPUTY
	department_flag = DEP_OASIS
	total_positions = 0
	spawn_positions = 0
	supervisors = "The Sheriff"
	description = "You are a loyal protector of Ripley, keeping the settlement within firm control under the authority of the Mayor. The sheriff is your direct superior, and you should expect to take your day-to-day orders from them. Maintain your claim to authority by keeping the peace, managing disputes, and protecting the citizens from threats within and without. Never leave Ripley undefended, and don't let its people die out."
	enforces = "You may be elected temporary Sheriff if one does not exist. This may make you the stand-in leader of Ripley if a Mayor or Secretary does not exist."
	selection_color = "#dcba97"
	exp_type = EXP_TYPE_OASIS
	exp_requirements = 300

	loadout_options = list(
	/datum/outfit/loadout/frontierjustice,
	/datum/outfit/loadout/police,
	/datum/outfit/loadout/mercenary,
	)

	outfit = /datum/outfit/job/den/f13deputy
	smutant_outfit = /datum/outfit/smutant/town/police
	access = list(ACCESS_BAR, ACCESS_GATEWAY, ACCESS_OFFICER)
	minimal_access = list(ACCESS_BAR, ACCESS_GATEWAY, ACCESS_OFFICER)
	matchmaking_allowed = list(
		/datum/matchmaking_pref/friend = list(
			/datum/job/oasis
		),
		/datum/matchmaking_pref/rival = list(
			/datum/job/oasis
		)
	)

/datum/outfit/job/den/f13deputy
	name = "Deputy"
	jobtype = /datum/job/oasis/f13deputy
	id = /obj/item/card/id/dogtag/deputy
	ears = /obj/item/radio/headset/headset_town/lawman
	backpack = /obj/item/storage/backpack/satchel/explorer
	satchel = /obj/item/storage/backpack/satchel/explorer
	suit_store = /obj/item/storage/belt/legholster
	l_pocket = /obj/item/storage/bag/money/small/settler
	r_pocket = /obj/item/flashlight/flare
	shoes = /obj/item/clothing/shoes/f13/explorer
	uniform = /obj/item/clothing/under/f13/cowboyb
	backpack_contents = list(
		/obj/item/storage/pill_bottle/chem_tin/radx,
		/obj/item/restraints/handcuffs = 1,
		/obj/item/melee/onehanded/knife/bowie = 1,
		/obj/item/grenade/flashbang = 1,
		/obj/item/flashlight/seclite = 1,
		/obj/item/storage/belt/army/assault = 1
		)

/datum/outfit/loadout/frontierjustice
	name = "Frontier Justice"
	suit = /obj/item/clothing/suit/armor/medium/duster/deputy
	head = /obj/item/clothing/head/f13/town/deputy
	neck = /obj/item/storage/belt/shoulderholster
	backpack_contents = list(
		/obj/item/ammo_box/m44 = 2,
		/obj/item/gun/ballistic/revolver/m29 = 2,
		/obj/item/flashlight/seclite = 1
		)

/datum/outfit/loadout/police
	name = "Ripley PD"
	uniform = /obj/item/clothing/under/f13/police/officer
	suit = /obj/item/clothing/suit/armor/medium/vest/bulletproof
	head = /obj/item/clothing/head/f13/town/deputy
	belt = /obj/item/storage/belt/legholster
	suit_store = /obj/item/gun/ballistic/shotgun/police
	shoes = /obj/item/clothing/shoes/jackboots
	backpack_contents = list(
		/obj/item/ammo_box/shotgun/slug = 1,
		/obj/item/ammo_box/shotgun/buck = 1,
		/obj/item/ammo_box/a357 = 3,
		/obj/item/flashlight/seclite = 1,
		/obj/item/gun/ballistic/revolver/police = 1
		)

/datum/outfit/loadout/mercenary
	name = "Hired Gun"
	uniform = /obj/item/clothing/under/f13/police/swat
	suit = /obj/item/clothing/suit/armor/medium/vest/bulletproof
	head = /obj/item/clothing/head/helmet/alt
	mask = /obj/item/clothing/mask/balaclava
	gloves = /obj/item/clothing/gloves/f13/military
	suit_store = /obj/item/gun/ballistic/automatic/combat
	backpack_contents = list(
		/obj/item/ammo_box/magazine/m10mm/adv/simple=2,
		/obj/item/gun/ballistic/automatic/pistol/n99=1,
		/obj/item/ammo_box/magazine/tommygunm45/stick=2,
		/obj/item/flashlight/seclite = 1
		)


/datum/job/oasis/f13prospector
	title = "Prospector"
	flag = F13PROSPECTOR
	department_flag = DEP_OASIS
	total_positions = 1
	spawn_positions = 1
	supervisors = "The Mayor"
	description = "Prospecting is a complicated business. Some call it scrounging or looting, but there is more to it than sifting through rubble - few can boast the valuable skills of mining and scavenging the ruins of fallen empires. The settlement of Ripley understands the value of this, and you've found purpose within their mines. Sell the materials you find to the highest bidder - the local store may be particularly interested in metals."
	enforces = "Mining is a public service, and you are under control of local governance - but by default you are expected to work with private businesses and individual clients."
	selection_color = "#dcba97"

	outfit = /datum/outfit/job/den/f13prospector
	smutant_outfit = /datum/outfit/smutant/town/labourer

	access = list(ACCESS_BAR, ACCESS_MINING)
	minimal_access = list(ACCESS_BAR, ACCESS_MINING)
	matchmaking_allowed = list(
		/datum/matchmaking_pref/friend = list(
			/datum/job/oasis,
		),
		/datum/matchmaking_pref/rival = list(
			/datum/job/oasis,
		),
	)

	loadout_options = list(
	/datum/outfit/loadout/engineer,
	/datum/outfit/loadout/miner,)

/datum/outfit/smutant/town/labourer
	suit = /obj/item/clothing/suit/hooded/cloak/mutie/poncho/weathered/townie
	uniform = /obj/item/clothing/under/f13/mutie/townie/overalls
	shoes = /obj/item/clothing/shoes/f13/mutie
	gloves = /obj/item/clothing/gloves/f13/mutie

/datum/outfit/job/den/f13prospector
	name = "Prospector"
	jobtype = /datum/job/oasis/f13prospector

	id = /obj/item/card/id/dogtag/town
	backpack = /obj/item/storage/backpack/satchel/explorer
	satchel = /obj/item/storage/backpack/satchel/explorer
	l_pocket = /obj/item/storage/bag/money/small/settler
	r_pocket = /obj/item/flashlight/lantern
	belt = /obj/item/storage/bag/ore
	shoes = /obj/item/clothing/shoes/jackboots
	backpack_contents = list(
		/obj/item/mining_scanner,
		/obj/item/melee/onehanded/knife/hunting,
		/obj/item/gun/ballistic/automatic/pistol/n99,
		/obj/item/ammo_box/magazine/m10mm/adv/simple = 2,
		)

/datum/outfit/job/den/f13settler/pre_equip(mob/living/carbon/human/H)
	..()
	uniform = pick(
		/obj/item/clothing/under/f13/machinist, \
		/obj/item/clothing/under/f13/roving, \
		/obj/item/clothing/under/f13/cowboyt)

/datum/outfit/job/den/f13prospector/pre_equip(mob/living/carbon/human/H, visualsOnly = FALSE)
	..()
	if(visualsOnly)
		return
	H.mind.teach_crafting_recipe(/datum/crafting_recipe/tribalradio)
	H.mind.teach_crafting_recipe(/datum/crafting_recipe/durathread_vest)
	//ADD_TRAIT(H, TRAIT_TECHNOPHREAK, src)
	ADD_TRAIT(H, TRAIT_GENERIC, src)

/datum/outfit/loadout/engineer
	name = "Salvager"
	suit = /obj/item/clothing/suit/apron/overalls
	glasses = /obj/item/clothing/glasses/welding
	uniform = /obj/item/clothing/under/misc/overalls
	belt = /obj/item/storage/belt/utility/full
	shoes = /obj/item/clothing/shoes/workboots
	suit_store = /obj/item/gun/ballistic/rifle/mag/varmint
	backpack_contents = list(
		/obj/item/ammo_box/magazine/m556/rifle/small = 2,
		/obj/item/pickaxe/mini = 1,
		/obj/item/shovel/spade = 1,
		)

/datum/outfit/loadout/miner
	name = "Miner"
	suit = /obj/item/clothing/suit/armor/light/leather/rig
	uniform = /obj/item/clothing/under/f13/lumberjack
	head = /obj/item/clothing/head/hardhat
	belt = /obj/item/storage/belt/utility/mining/alt
	shoes = /obj/item/clothing/shoes/f13/miner
	suit_store = /obj/item/gun/ballistic/revolver/caravan_shotgun
	backpack_contents = list(
		/obj/item/ammo_box/shotgun/buck = 1,
		/obj/item/t_scanner/adv_mining_scanner = 1,
		/obj/item/pickaxe/silver = 1,
		/obj/item/shovel = 1,
		)


/*--------------------------------------------------------------*/

/datum/job/oasis/f13dendoc
	title = "Doctor"
	flag = F13DENDOC
	department_flag = DEP_OASIS
	total_positions = 0
	spawn_positions = 0
	supervisors = "The Mayor"
	description = "Handy with a scalpel and scanner, your expertise in the practice of medicine makes you an indispensible asset to the settlement of Ripley. Just remember that you're no Follower - medicine doesn't come for free, and you aren't here out of the kindness of your heart. Make sure to turn a profit on your services, or the Mayor might reconsider your position!"
	enforces = "Medicine is a public service, and you are under control of local governance - but remember public doesn't equate to free."
	selection_color = "#dcba97"

	outfit = /datum/outfit/job/den/f13dendoc
	access = list(ACCESS_BAR, ACCESS_CLINIC, ACCESS_CLONING, ACCESS_FOLLOWER)
	minimal_access = list(ACCESS_BAR, ACCESS_CLINIC, ACCESS_CLONING, ACCESS_FOLLOWER)
	matchmaking_allowed = list(
		/datum/matchmaking_pref/friend = list(
			/datum/job/oasis
		),
		/datum/matchmaking_pref/rival = list(
			/datum/job/oasis
		)
	)

/datum/outfit/job/den/f13dendoc
	name = "Doctor"
	jobtype = /datum/job/oasis/f13dendoc
	ears = /obj/item/radio/headset/headset_town/medical
	uniform = /obj/item/clothing/under/f13/medic
	neck = /obj/item/clothing/neck/stethoscope
	suit = /obj/item/clothing/suit/toggle/labcoat
	head = /obj/item/clothing/head/beret/chem
	backpack = /obj/item/storage/backpack/medic
	satchel = /obj/item/storage/backpack/satchel/med
	shoes = /obj/item/clothing/shoes/sneakers/white
	id = /obj/item/card/id/dendoctor
	l_pocket = /obj/item/storage/bag/money/small/settler
	r_pocket = /obj/item/flashlight/flare
	backpack_contents = list(
		/obj/item/storage/pill_bottle/chem_tin/radx,
		/obj/item/reagent_containers/hypospray/medipen/stimpak=2,
		/obj/item/storage/firstaid/regular,
		/obj/item/clothing/accessory/armband/medblue,
		/obj/item/reagent_containers/glass/beaker/plastic,
		/obj/item/reagent_containers/glass/beaker/meta,
		/obj/item/reagent_containers/hypospray,
		/obj/item/circuitboard/machine/bloodbankgen,
		)

/datum/outfit/job/den/f13dendoc/post_equip(mob/living/carbon/human/H, visualsOnly = FALSE)
	..()
	if(visualsOnly)
		return
	H.mind.teach_crafting_recipe(GLOB.chemwhiz_recipes)
	H.mind.teach_crafting_recipe(/datum/crafting_recipe/pico_manip)
	H.mind.teach_crafting_recipe(/datum/crafting_recipe/super_matter_bin)
	H.mind.teach_crafting_recipe(/datum/crafting_recipe/phasic_scanning)
	H.mind.teach_crafting_recipe(/datum/crafting_recipe/super_capacitor)
	H.mind.teach_crafting_recipe(/datum/crafting_recipe/ultra_micro_laser)
	//ADD_TRAIT(H, TRAIT_CHEMWHIZ, src)
	ADD_TRAIT(H, TRAIT_GENERIC, src)
	//ADD_TRAIT(H, TRAIT_SURGERY_HIGH, src)

/datum/job/oasis/f13barkeep
	title = "Barkeep"
	flag = F13BARKEEP
	department_flag = DEP_OASIS
	total_positions = 2
	spawn_positions = 2
	supervisors = "the free market and the khan's Laws"
	description = "As a proprietor of Heavens Night, you are responsible for ensuring both citizens and travellers in the valley can get some food, drink and rest. Speak to the farmers for fresh produce!"
	enforces = "Heaven's Night is a private business and you can decide who is welcome there. However, you are still subject to the overarching laws of the khan's."
	selection_color = "#ff915e"

	outfit = /datum/outfit/job/den/f13barkeep
	smutant_outfit = /datum/outfit/smutant/town/labourer

	loadout_options = list(
	/datum/outfit/loadout/rugged,
	/datum/outfit/loadout/frontier,
	/datum/outfit/loadout/richmantender,
	/datum/outfit/loadout/diner)

	access = list(ACCESS_KITCHEN, ACCESS_KHAN)
	minimal_access = list(ACCESS_KITCHEN, ACCESS_KHAN)
	matchmaking_allowed = list(
		/datum/matchmaking_pref/friend = list(
			/datum/job/oasis
		),
		/datum/matchmaking_pref/rival = list(
			/datum/job/oasis
		)
	)


/datum/outfit/job/den/f13barkeep
	name = "Barkeep"
	jobtype = /datum/job/oasis/f13barkeep
	uniform = /obj/item/clothing/under/f13/bartenderalt
	id = /obj/item/card/id/khantattoo
	ears = /obj/item/radio/headset/headset_khans
	shoes = /obj/item/clothing/shoes/workboots/mining
	backpack = /obj/item/storage/backpack/satchel/leather
	backpack_contents = list(
		/obj/item/storage/pill_bottle/chem_tin/radx,
		/obj/item/storage/bag/money/small/settler = 1,
		/obj/item/ammo_box/shotgun/buck = 2,
		/obj/item/book/manual/nuka_recipes = 1,
		/obj/item/stack/f13Cash/caps/onezerozero = 1,
		/obj/item/reagent_containers/food/drinks/bottle/rotgut = 1,
		/obj/item/gun/ballistic/revolver/caravan_shotgun = 1,
		)

/datum/outfit/loadout/rugged
	name = "Rugged"
	head = /obj/item/clothing/head/helmet/f13/brahmincowboyhat
	uniform = /obj/item/clothing/under/f13/cowboyb
	suit = /obj/item/clothing/suit/armor/light/duster/brahmin
	gloves = /obj/item/clothing/gloves/color/brown
	shoes = /obj/item/clothing/shoes/f13/brownie

/datum/outfit/loadout/frontier
	name = "Frontier"
	head = /obj/item/clothing/head/bowler
	mask = /obj/item/clothing/mask/fakemoustache
	uniform = /obj/item/clothing/under/f13/westender
	suit = /obj/item/clothing/suit/armor/light/duster/town/bartender
	gloves = /obj/item/clothing/gloves/fingerless
	shoes = /obj/item/clothing/shoes/f13/fancy

/datum/outfit/loadout/richmantender
	name = "Fancy"
	head = /obj/item/clothing/head/fedora
	glasses = /obj/item/clothing/glasses/sunglasses
	uniform = /obj/item/clothing/under/rank/bartender
	suit = /obj/item/clothing/suit/toggle/lawyer/black
	gloves = /obj/item/clothing/gloves/fingerless
	shoes = /obj/item/clothing/shoes/f13/fancy
	neck = /obj/item/clothing/neck/tie/black

/datum/outfit/loadout/diner
	name = "Diner"
	glasses = /obj/item/clothing/glasses/orange
	uniform = /obj/item/clothing/under/f13/brahminf
	neck = /obj/item/clothing/neck/apron/chef
	gloves = /obj/item/clothing/gloves/color/white
	shoes = /obj/item/clothing/shoes/f13/military/ncr

/*--------------------------------------------------------------*/
/datum/job/oasis/f13settler
	title = "Citizen"
	flag = F13SETTLER
	department_flag = DEP_OASIS
	total_positions = 4
	spawn_positions = 4
	supervisors = "Ripley's laws"
	description = "You are a citizen living in Ripley. Treat your town with respect and make sure to follow the laws in place, as your premium status may be revoked if you are considered a danger to the populace. One of the local businesses may have work if you require funds."
	selection_color = "#dcba97"

	outfit = /datum/outfit/job/den/f13settler
	smutant_outfit = /datum/outfit/smutant/town

	loadout_options = list(
		/datum/outfit/loadout/gambler,
		/datum/outfit/loadout/resident,
		/datum/outfit/loadout/outdoorsman
	)
	access = list(ACCESS_BAR)
	minimal_access = list(ACCESS_BAR)
	matchmaking_allowed = list(
		/datum/matchmaking_pref/friend = list(
			/datum/job/oasis
		),
		/datum/matchmaking_pref/rival = list(
			/datum/job/oasis
		)
	)

/datum/outfit/smutant/town
	suit = /obj/item/clothing/suit/hooded/cloak/mutie/poncho/weathered/townie
	uniform = /obj/item/clothing/under/f13/mutie/townie
	shoes = /obj/item/clothing/shoes/f13/mutie/boots
	gloves = /obj/item/clothing/gloves/f13/mutie/sign

/datum/outfit/job/den/f13settler
	name = "Citizen"
	jobtype = /datum/job/oasis/f13settler
	id = /obj/item/card/id/dogtag/town
	uniform = /obj/item/clothing/under/f13/settler
	shoes = /obj/item/clothing/shoes/jackboots
	backpack = /obj/item/storage/backpack/satchel/explorer
	r_pocket = /obj/item/flashlight/flare
	backpack_contents = list(
		/obj/item/storage/pill_bottle/chem_tin/radx,
		/obj/item/storage/bag/money/small/settler = 1,
		/obj/item/melee/onehanded/knife/hunting = 1
		)

/datum/outfit/job/den/f13settler/pre_equip(mob/living/carbon/human/H)
	. = ..()
	head = pick(/obj/item/clothing/head/soft/mime,
		/obj/item/clothing/head/soft/black,
		/obj/item/clothing/head/soft/grey,
		/obj/item/clothing/head/f13/gambler,
		/obj/item/clothing/head/f13/cowboy,
		/obj/item/clothing/head/cowboyhat/white,
		/obj/item/clothing/head/beret/headband,
		/obj/item/clothing/head/cowboyhat/pink,
		/obj/item/clothing/head/f13/police/trooper,
		/obj/item/clothing/head/fedora/curator,
		/obj/item/clothing/head/fedora/det_hat,
		/obj/item/clothing/head/bowler)
	uniform = pick(
		/obj/item/clothing/under/f13/gentlesuit,
		/obj/item/clothing/under/f13/formal,
		/obj/item/clothing/under/f13/spring,
		/obj/item/clothing/under/f13/relaxedwear,
		/obj/item/clothing/under/f13/machinist,
		/obj/item/clothing/under/f13/brahminf,
		/obj/item/clothing/under/f13/cowboyb,
		/obj/item/clothing/under/f13/cowboyg,
		/obj/item/clothing/under/f13/cowboyt)

/datum/outfit/loadout/gambler
	name = "Gambler"
	suit = /obj/item/clothing/suit/vickyblack
	gloves = /obj/item/pda
	shoes = /obj/item/clothing/shoes/laceup
	uniform = /obj/item/clothing/under/f13/worn
	gloves = /obj/item/clothing/gloves/f13/leather
	backpack_contents = list(/obj/item/reagent_containers/food/drinks/flask = 1,
		/obj/item/gun/ballistic/automatic/pistol/pistol22 = 1,
		/obj/item/ammo_box/magazine/m22 = 1,
		/obj/item/stack/f13Cash/caps/twofivezero = 1,
	)

/datum/outfit/loadout/resident
	name = "Resident"
	head = /obj/item/clothing/head/soft/grey
	belt = /obj/item/storage/belt/utility/waster
	suit = /obj/item/clothing/under/f13/mechanic
	gloves = /obj/item/clothing/gloves/color/black
	shoes = /obj/item/clothing/shoes/sneakers/noslip
	neck = /obj/item/storage/belt/shoulderholster
	suit_store = /obj/item/gun/ballistic/revolver/single_shotgun
	backpack_contents = list(/obj/item/ammo_box/shotgun/buck = 1,
		/obj/item/stack/f13Cash/caps/onezerozero = 1,
		/obj/item/storage/box/ration/menu_two = 1,
		/obj/item/storage/box/ration/menu_eight = 1,
		/obj/item/reagent_containers/food/drinks/flask/survival = 1,
	)

/datum/outfit/loadout/outdoorsman
	name = "Outdoorsman"
	head = /obj/item/clothing/head/soft/grey
	suit = /obj/item/clothing/suit/armor/light/leather/tanvest
	suit_store = /obj/item/gun/ballistic/rifle/mag/sportcarbine
	belt = /obj/item/melee/onehanded/knife/bowie
	uniform = /obj/item/clothing/under/f13/cowboyt
	gloves = /obj/item/clothing/gloves/botanic_leather
	shoes = /obj/item/clothing/shoes/f13/peltboots
	backpack_contents = list(
		/obj/item/ammo_box/magazine/m22 = 2,
		/obj/item/fishingrod = 1,
		/obj/item/binoculars = 1,
		/obj/item/crafting/campfirekit = 1,
		/obj/item/storage/fancy/rollingpapers/makeshift = 1,
		/obj/item/reagent_containers/food/drinks/flask/survival = 1,
	)

/*----------------------------------------------------------------
--							Detective							--
----------------------------------------------------------------*/

/datum/job/oasis/f13detective
	title = "Detective"
	flag = F13DETECTIVE
	total_positions = 1
	spawn_positions = 1
	supervisors = "paying clients and Ripley's laws"
	selection_color = "#dcba97"
	outfit = /datum/outfit/job/oasis/f13detective
	smutant_outfit = /datum/outfit/smutant/town/police/detective

	access = list(ACCESS_BAR, ACCESS_FORENSICS_LOCKERS, ACCESS_OFFICER)
	minimal_access = list(ACCESS_BAR, ACCESS_FORENSICS_LOCKERS, ACCESS_OFFICER)
	matchmaking_allowed = list(
		/datum/matchmaking_pref/friend = list(
			/datum/job/wasteland/f13wastelander,
			/datum/job/oasis/f13detective
		),
		/datum/matchmaking_pref/rival = list(
			/datum/job/wasteland/f13wastelander,
			/datum/job/oasis/f13detective
		),
		/datum/matchmaking_pref/mentor = list(
			/datum/job/wasteland/f13wastelander
		)
	)

/datum/outfit/smutant/town/police/detective
	uniform = /obj/item/clothing/under/f13/mutie/suit
	gloves = /obj/item/clothing/gloves/f13/mutie/gloves

/datum/outfit/job/oasis/f13detective
	name = "Detective"
	jobtype = /datum/job/oasis/f13detective
	suit = /obj/item/clothing/suit/det_suit/grey
	uniform = /obj/item/clothing/under/f13/detectivealt
	head = /obj/item/clothing/head/f13/det_hat_alt
	ears = /obj/item/radio/headset/headset_town/lawman
	shoes = /obj/item/clothing/shoes/laceup
	id = /obj/item/card/id/silver
	l_pocket = /obj/item/storage/bag/money/small/settler
	r_pocket = /obj/item/flashlight/flare
	backpack = /obj/item/storage/backpack/satchel/explorer
	satchel = /obj/item/storage/backpack/satchel/explorer
	suit_store = /obj/item/gun/ballistic/automatic/pistol/deagle
	backpack_contents = list(
		/obj/item/storage/pill_bottle/chem_tin/radx,
		/obj/item/pda/detective=1,
		/obj/item/camera/detective=1,
		/obj/item/toy/crayon/white=1,
		/obj/item/detective_scanner=1,
		/obj/item/storage/box/gloves=1,
		/obj/item/storage/box/evidence=1,
		/obj/item/ammo_box/magazine/m44 = 2)

/*--------------------------------------------------------------*/
/*
/datum/job/oasis/f13banker
	title = "Banker"
	flag = F13BANKER
	department_flag = DEP_OASIS
	total_positions = 1
	spawn_positions = 2
	supervisors = "The Mayor"
	description = "No matter the nature of society, fortune and profit are there to be made! It is up to you to make deals, distribute caps and earn interest - an easy first venture might be safekeeping possessions in the strongboxes of your vault within the First Bank of Ripley. Ensure you make a profit and retain enough capital for your day-to-day operations. You are under the governance of Ripley, but perhaps deal-making will take you into other alliances."
	enforces = "Your bank is a private business and you are not under direct control of local governance, but are subject to their laws."
	selection_color = "#dcba97"
	outfit = /datum/outfit/job/den/f13banker

	loadout_options = list(
	/datum/outfit/loadout/classy,
	/datum/outfit/loadout/loanshark,
	/datum/outfit/loadout/investor
	)

	access = list(ACCESS_BAR, ACCESS_MINT_VAULT)
	minimal_access = list(ACCESS_BAR, ACCESS_MINT_VAULT)

/datum/outfit/job/den/f13banker
	name = "Banker"
	jobtype = /datum/job/oasis/f13banker
	belt = /obj/item/kit_spawner/lawman

	uniform = /obj/item/clothing/under/lawyer/blacksuit
	id = /obj/item/card/id/silver
	ears = /obj/item/radio/headset/headset_town/commerce
	shoes = /obj/item/clothing/shoes/f13/fancy
	backpack = /obj/item/storage/backpack/satchel/leather
	satchel = /obj/item/storage/backpack/satchel/leather
	backpack_contents = list(
		/obj/item/storage/pill_bottle/chem_tin/radx,
		/obj/item/storage/bag/money/small = 1)

/datum/outfit/loadout/classy
	name = "Classy"
	head = /obj/item/clothing/head/collectable/tophat
	glasses = /obj/item/clothing/glasses/monocle
	uniform = /obj/item/clothing/under/suit_jacket/charcoal
	suit = /obj/item/clothing/suit/armor/outfit/jacket/banker
	gloves = /obj/item/clothing/gloves/color/white
	shoes = /obj/item/clothing/shoes/laceup
	backpack_contents = list(/obj/item/cane=1,
		///obj/item/storage/belt/shoulderholster/ranger45 =1,
		/obj/item/storage/fancy/cigarettes/cigpack_bigboss=1,
		/obj/item/reagent_containers/food/drinks/bottle/whiskey=1,
		/obj/item/reagent_containers/food/drinks/drinkingglass/shotglass=1,
		/obj/item/lighter/gold = 1
		)

/datum/outfit/loadout/loanshark
	name = "Loanshark"
	glasses = /obj/item/clothing/glasses/orange
	mask = /obj/item/clothing/mask/cigarette/cigar
	suit = /obj/item/clothing/suit/armor/outfit/vest
	uniform = /obj/item/clothing/under/f13/sleazeball
	shoes = /obj/item/clothing/shoes/sandal
	backpack_contents = list(/obj/item/reagent_containers/food/drinks/bottle/whiskey=1,
		/obj/item/storage/box/matches=1,
		///obj/item/gun/ballistic/automatic/smg/mini_uzi=1,
		/obj/item/instrument/violin/golden = 1
		)

/datum/outfit/loadout/investor
	name = "Investor"
	glasses = /obj/item/clothing/glasses/sunglasses
	suit = /obj/item/clothing/suit/toggle/lawyer/black
	uniform = /obj/item/clothing/under/f13/bennys
	gloves = /obj/item/clothing/gloves/fingerless
	shoes = /obj/item/clothing/shoes/laceup
	backpack_contents = list(/obj/item/storage/fancy/cigarettes/cigpack_bigboss=1,
		/obj/item/storage/box/matches=1,
		/obj/item/ingot/gold = 1,
		///obj/item/gun/ballistic/shotgun/automatic/combat/shotgunlever = 1
		)
*/
/*--------------------------------------------------------------*/

//The Quartermaster
/datum/job/oasis/f13quartermaster
	title = "Ripley Quartermaster"
	flag = F13QUARTERMASTER
	department_flag = DEP_OASIS
	total_positions = 0
	spawn_positions = 0
	supervisors = "the free market and Ripley's laws"
	description = "You are the team leader for your various workers in the shop. Guide them as you see fit towards a profitable future."
	enforces = "The Ripley store is part of your workplace, but it is not your workplace alone. You should try to work with your team in order to turn a profit."
	selection_color = "#dcba97"
	exp_requirements = 400

	loadout_options = list(
	/datum/outfit/loadout/single_master,
	/datum/outfit/loadout/automatic_master
	)

	outfit = /datum/outfit/job/den/f13quartermaster
	access = list(ACCESS_BAR, ACCESS_CARGO_BOT)
	minimal_access = list(ACCESS_BAR, ACCESS_CARGO_BOT)
	matchmaking_allowed = list(
		/datum/matchmaking_pref/friend = list(
			/datum/job/oasis
		),
		/datum/matchmaking_pref/rival = list(
			/datum/job/oasis
		)
	)

/datum/outfit/job/den/f13quartermaster
	name = "Ripley Quartermaster"
	jobtype = /datum/job/oasis/f13quartermaster
	id = /obj/item/card/id/dogtag/town
	ears = /obj/item/radio/headset/headset_town/commerce
	uniform = /obj/item/clothing/under/f13/roving
	backpack = /obj/item/storage/backpack
	satchel = /obj/item/storage/backpack/satchel
	duffelbag = /obj/item/storage/backpack/duffelbag
	gloves = /obj/item/clothing/gloves/fingerless
	l_pocket = /obj/item/storage/bag/money/small/den
	r_pocket = /obj/item/flashlight/glowstick
	shoes = /obj/item/clothing/shoes/f13/explorer
	backpack_contents = list(
		/obj/item/storage/pill_bottle/chem_tin/radx,
		/obj/item/gun/ballistic/automatic/pistol/ninemil = 1,
		/obj/item/ammo_box/magazine/m9mm = 1,
		/obj/item/pda/quartermaster,
		/obj/item/stack/f13Cash/caps/twofivezero)

/datum/outfit/loadout/single_master
	name = "Old-Fashioned Master"
	backpack_contents = list(
		/obj/item/book/granter/crafting_recipe/blueprint/brushgun = 1
	)

/datum/outfit/loadout/automatic_master
	name = "Automatic Master"
	backpack_contents = list(
		/obj/item/book/granter/crafting_recipe/blueprint/r91 = 1
	)

/datum/outfit/job/den/f13quartermaster/pre_equip(mob/living/carbon/human/H, visualsOnly = FALSE)
	..()
	if(visualsOnly)
		return
	H.mind.teach_crafting_recipe(/datum/crafting_recipe/policepistol)
	H.mind.teach_crafting_recipe(/datum/crafting_recipe/policerifle)
	H.mind.teach_crafting_recipe(/datum/crafting_recipe/steelbib/heavy)
	H.mind.teach_crafting_recipe(/datum/crafting_recipe/armyhelmetheavy)
	H.mind.teach_crafting_recipe(/datum/crafting_recipe/tribalradio)
	H.mind.teach_crafting_recipe(/datum/crafting_recipe/durathread_vest)
	//ADD_TRAIT(H, TRAIT_TECHNOPHREAK, src)
	ADD_TRAIT(H, TRAIT_GENERIC, src)
	H.mind.teach_crafting_recipe(/datum/crafting_recipe/trail_carbine)
	H.mind.teach_crafting_recipe(/datum/crafting_recipe/lever_action)
	H.mind.teach_crafting_recipe(/datum/crafting_recipe/a180)
	H.mind.teach_crafting_recipe(/datum/crafting_recipe/huntingrifle)
	H.mind.teach_crafting_recipe(/datum/crafting_recipe/varmintrifle)
	H.mind.teach_crafting_recipe(/datum/crafting_recipe/huntingshotgun)
	H.mind.teach_crafting_recipe(/datum/crafting_recipe/thatgun)
	H.mind.teach_crafting_recipe(/datum/crafting_recipe/uzi)
	H.mind.teach_crafting_recipe(/datum/crafting_recipe/smg10mm)
	H.mind.teach_crafting_recipe(/datum/crafting_recipe/frag_shrapnel)
	H.mind.teach_crafting_recipe(/datum/crafting_recipe/concussion)
	H.mind.teach_crafting_recipe(/datum/crafting_recipe/explosive/shrapnelmine)
	H.mind.teach_crafting_recipe(/datum/crafting_recipe/pico_manip)
	H.mind.teach_crafting_recipe(/datum/crafting_recipe/super_matter_bin)
	H.mind.teach_crafting_recipe(/datum/crafting_recipe/phasic_scanning)
	H.mind.teach_crafting_recipe(/datum/crafting_recipe/super_capacitor)
	H.mind.teach_crafting_recipe(/datum/crafting_recipe/ultra_micro_laser)

/datum/outfit/job/den/f13quartermaster/post_equip(mob/living/carbon/human/H, visualsOnly = FALSE)
	..()
	if(visualsOnly)
		return

//The Trade Workers
/datum/job/oasis/f13shopkeeper
	title = "Ripley Trade Worker"
	flag = F13SHOPKEEPER
	department_flag = DEP_OASIS
	total_positions = 1
	spawn_positions = 1
	supervisors = "the free market and Ripley's laws"
	description = "You are one of the many workers who live in the city of Ripley. Working with the town council you have rented out a space in the shop for you to make your living."
	enforces = "The Ripley store is part of your workplace, but it is not your workplace alone. You should try work with the other trade workers to try and turn a profit."
	selection_color = "#dcba97"
	exp_requirements = 300

	loadout_options = list(
	/datum/outfit/loadout/energy_specialist,
	/datum/outfit/loadout/ballistic_specialist,
	/datum/outfit/loadout/jackofall_specialist
	)

	outfit = /datum/outfit/job/den/f13shopkeeper
	access = list(ACCESS_BAR, ACCESS_CARGO_BOT)
	minimal_access = list(ACCESS_BAR, ACCESS_CARGO_BOT)
	matchmaking_allowed = list(
		/datum/matchmaking_pref/friend = list(
			/datum/job/oasis
		),
		/datum/matchmaking_pref/rival = list(
			/datum/job/oasis
		)
	)

/datum/outfit/job/den/f13shopkeeper
	name = "Shopkeeper"
	jobtype = /datum/job/oasis/f13shopkeeper
	id = /obj/item/card/id/dogtag/town
	ears = /obj/item/radio/headset/headset_town/commerce
	uniform = /obj/item/clothing/under/f13/roving
	backpack = /obj/item/storage/backpack
	satchel = /obj/item/storage/backpack/satchel
	duffelbag = /obj/item/storage/backpack/duffelbag
	gloves = /obj/item/clothing/gloves/fingerless
	l_pocket = /obj/item/storage/bag/money/small/den
	r_pocket = /obj/item/flashlight/glowstick
	shoes = /obj/item/clothing/shoes/f13/explorer
	backpack_contents = list(
		/obj/item/storage/pill_bottle/chem_tin/radx)

/datum/outfit/loadout/energy_specialist
	name = "Energy Specialist"
	backpack_contents = list(
		/obj/item/book/granter/crafting_recipe/blueprint/aep7=1,
		/obj/item/book/granter/crafting_recipe/blueprint/aer9=1
	)

/datum/outfit/loadout/ballistic_specialist
	name = "Frontiersman"
	backpack_contents = list(
		/obj/item/book/granter/crafting_recipe/blueprint/leveraction=1,
		/obj/item/book/granter/crafting_recipe/blueprint/deagle=1
	)

/datum/outfit/loadout/jackofall_specialist
	name = "Arms Dealer"
	backpack_contents = list(
		/obj/item/book/granter/crafting_recipe/ODF=1,
		/obj/item/book/granter/crafting_recipe/blueprint/n99=1
	)

/datum/outfit/job/den/f13shopkeeper/pre_equip(mob/living/carbon/human/H, visualsOnly = FALSE)
	..()
	if(visualsOnly)
		return
	H.mind.teach_crafting_recipe(/datum/crafting_recipe/policepistol)
	H.mind.teach_crafting_recipe(/datum/crafting_recipe/steelbib/heavy)
	H.mind.teach_crafting_recipe(/datum/crafting_recipe/armyhelmetheavy)
	H.mind.teach_crafting_recipe(/datum/crafting_recipe/tribalradio)
	H.mind.teach_crafting_recipe(/datum/crafting_recipe/durathread_vest)
	//ADD_TRAIT(H, TRAIT_TECHNOPHREAK, src)
	ADD_TRAIT(H, TRAIT_GENERIC, src)
	H.mind.teach_crafting_recipe(/datum/crafting_recipe/trail_carbine)
	H.mind.teach_crafting_recipe(/datum/crafting_recipe/lever_action)
	H.mind.teach_crafting_recipe(/datum/crafting_recipe/a180)
	H.mind.teach_crafting_recipe(/datum/crafting_recipe/huntingrifle)
	H.mind.teach_crafting_recipe(/datum/crafting_recipe/varmintrifle)
	H.mind.teach_crafting_recipe(/datum/crafting_recipe/huntingshotgun)
	H.mind.teach_crafting_recipe(/datum/crafting_recipe/thatgun)
	H.mind.teach_crafting_recipe(/datum/crafting_recipe/uzi)
	H.mind.teach_crafting_recipe(/datum/crafting_recipe/smg10mm)
	H.mind.teach_crafting_recipe(/datum/crafting_recipe/frag_shrapnel)
	H.mind.teach_crafting_recipe(/datum/crafting_recipe/concussion)
	H.mind.teach_crafting_recipe(/datum/crafting_recipe/explosive/shrapnelmine)
	H.mind.teach_crafting_recipe(/datum/crafting_recipe/pico_manip)
	H.mind.teach_crafting_recipe(/datum/crafting_recipe/super_matter_bin)
	H.mind.teach_crafting_recipe(/datum/crafting_recipe/phasic_scanning)
	H.mind.teach_crafting_recipe(/datum/crafting_recipe/super_capacitor)
	H.mind.teach_crafting_recipe(/datum/crafting_recipe/ultra_micro_laser)

/datum/outfit/job/den/f13shopkeeper/post_equip(mob/living/carbon/human/H, visualsOnly = FALSE)
	..()
	if(visualsOnly)
		return


/datum/job/oasis/family_head
	title = "Family Head"
	flag = F13SETTLER
	department_flag = F13SETTLER
	total_positions = 0
	spawn_positions = 0
	supervisors = "Yourself"
	description = "You are the head of the family who runs the farm on which the food that supplies the region is grown, it is you job to navigate the difficult political waters, you have an arrangement with the followers and khans already agreed."
	enforces = "The family and all of it's affairs are your business."
	selection_color = "#5b6aaf"
	outfit = /datum/outfit/job/den/f13settler

	loadout_options = list(
		/datum/outfit/loadout/resident,
		/datum/outfit/loadout/outdoorsman
	)
	access = list(ACCESS_BAR)
	minimal_access = list(ACCESS_BAR)
	matchmaking_allowed = list(
		/datum/matchmaking_pref/friend = list(
			/datum/job/oasis,
			/datum/job/khan
		),
		/datum/matchmaking_pref/rival = list(
			/datum/job/oasis,
			/datum/job/khan
		)
	)

/datum/job/oasis/family_member
	title = "Family Member"
	flag = F13SETTLER
	department_flag = F13SETTLER
	total_positions = 0
	spawn_positions = 0
	supervisors = "The head of the family"
	description = "You are a member of the religious family that supply the Khans and Followers with food, you may not like them but the arrangement is such that they protect and you farm."
	enforces = "You can order the farm hands around."
	selection_color = "#5b6aaf"
	outfit = /datum/outfit/job/den/f13settler

	loadout_options = list(
		/datum/outfit/loadout/resident,
		/datum/outfit/loadout/outdoorsman
	)
	access = list(ACCESS_BAR)
	minimal_access = list(ACCESS_BAR)
	matchmaking_allowed = list(
		/datum/matchmaking_pref/friend = list(
			/datum/job/oasis,
			/datum/job/khan
		),
		/datum/matchmaking_pref/rival = list(
			/datum/job/oasis,
			/datum/job/khan
		)
	)

/datum/job/oasis/family_farmer
	title = "Farm Hand"
	flag = F13SETTLER
	department_flag = F13SETTLER
	total_positions = 0
	spawn_positions = 0
	supervisors = "The Family"
	description = "You've found yourself working for the family in exchange for food and a roof, how you got here and what your ambitions are is up to you but for now you should do as they say."
	enforces = "You work for the family in exchange for food and a roof over your head."
	selection_color = "#5b6aaf"
	outfit = /datum/outfit/job/den/f13settler
	loadout_options = list(
		/datum/outfit/loadout/resident,
		/datum/outfit/loadout/outdoorsman
	)
	access = list()
	minimal_access = list()
	matchmaking_allowed = list(
		/datum/matchmaking_pref/friend = list(
			/datum/job/oasis,
			/datum/job/khan
		),
		/datum/matchmaking_pref/rival = list(
			/datum/job/oasis,
			/datum/job/khan
		)
	)
