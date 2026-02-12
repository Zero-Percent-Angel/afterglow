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
	exp_type = "The Family"

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
