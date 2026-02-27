/*
Family.
*/

/datum/outfit/job/family
	name = "Family Default Template"
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

/datum/job/family
	department_flag = DEP_FAMILY
	faction = FACTION_FAMILY
	exp_type = EXP_TYPE_FAMILY

/datum/job/family/family_head
	title = "Family Head"
	flag = F13FAMILYHEAD
	total_positions = 1
	spawn_positions = 1
	supervisors = "Yourself"
	description = "You are the head of the family who runs the farm on which the food that supplies the region is grown, it is you job to navigate the difficult political waters, you have an arrangement with the followers and khans already agreed."
	enforces = "The family and all of it's affairs are your business."
	selection_color = "#5b6aaf"
	outfit = /datum/outfit/job/family

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
	suit = /obj/item/clothing/suit/armor/tiered/light/leather/tanvest
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


/datum/job/family/family_member
	title = "Family Member"
	flag = F13FAMILYMEMBER
	total_positions = 4
	spawn_positions = 4
	supervisors = "The head of the family"
	description = "You are a member of the religious family that supply the Khans and Followers with food, you may not like them but the arrangement is such that they protect and you farm."
	enforces = "You can order the farm hands around."
	selection_color = "#5b6aaf"
	outfit = /datum/outfit/job/family

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

/datum/job/family/family_farmer
	title = "Farm Hand"
	flag = F13FAMILYMEMBER
	total_positions = 10
	spawn_positions = 10
	supervisors = "The Family"
	description = "You've found yourself working for the family in exchange for food and a roof, how you got here and what your ambitions are is up to you but for now you should do as they say."
	enforces = "You work for the family in exchange for food and a roof over your head."
	selection_color = "#5b6aaf"
	outfit = /datum/outfit/job/family
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
