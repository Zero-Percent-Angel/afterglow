/*
/obj/item/gun_upgrade/scope/watchman
	name = "old scope"
	desc = "A medium range scope, with a bit of heft to it.  Amazing that it's even still dialed in."
	icon_state = "Watchman"

/obj/item/gun_upgrade/scope/watchman/New()
	..()
	var/datum/component/item_upgrade/I = AddComponent(/datum/component/item_upgrade)
	I.weapon_upgrades = list(
		GUN_UPGRADE_RECOIL = 1.1,
		//GUN_UPGRADE_ZOOM = 1.2
		)
	I.gun_loc_tag = GUN_SCOPE
	I.req_gun_tags = list(GUN_SCOPE)

*/
/obj/item/gun_upgrade/scope/low
	name = "reflex sights"
	desc = "A short range scope, designed to be used on the move."
	icon_state = "2,0"

/obj/item/gun_upgrade/scope/low/New()
	..()
	var/datum/component/item_upgrade/I = AddComponent(/datum/component/item_upgrade)
	I.weapon_upgrades = list(
		GUN_UPGRADE_ZOOM = 1,
		GUN_UPGRADE_ZOOM_SLOWDOWN = SCOPED_IN_ADD_SLOWDOWN_LOW
		)
	I.gun_loc_tag = GUN_SCOPE
	I.req_gun_tags = list(GUN_SCOPE)

/obj/item/gun_upgrade/scope/mid
	name = "ACOG scope"
	desc = "A mid range scope, jack of all trades."
	icon_state = "Watchman"

/obj/item/gun_upgrade/scope/mid/New()
	..()
	var/datum/component/item_upgrade/I = AddComponent(/datum/component/item_upgrade)
	I.weapon_upgrades = list(
		GUN_UPGRADE_ZOOM = 1.5,
		GUN_UPGRADE_ZOOM_SLOWDOWN = SCOPED_IN_ADD_SLOWDOWN_MID
		)
	I.gun_loc_tag = GUN_SCOPE
	I.req_gun_tags = list(GUN_SCOPE)

/obj/item/gun_upgrade/scope/high
	name = "telescopic sights"
	desc = "A long range scope, designed for supreme marksmanship."
	icon_state = "Killer"

/obj/item/gun_upgrade/scope/high/New()
	..()
	var/datum/component/item_upgrade/I = AddComponent(/datum/component/item_upgrade)
	I.weapon_upgrades = list(
		GUN_UPGRADE_ZOOM = 2,
		GUN_UPGRADE_ZOOM_SLOWDOWN = SCOPED_IN_ADD_SLOWDOWN_HIGH
		)
	I.gun_loc_tag = GUN_SCOPE
	I.req_gun_tags = list(GUN_SCOPE)
