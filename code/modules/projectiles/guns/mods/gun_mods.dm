/*
//Silences the weapon, reduces damage multiplier slightly, Legacy port.
/obj/item/gun_upgrade/muzzle/silencer
	name = "silencer"
	desc = "A threaded silencer that can be attached to the muzzle of certain guns. Vastly reduces noise, but impedes muzzle velocity."
	icon_state = "silencer"


/obj/item/gun_upgrade/muzzle/silencer/New()
	..()
	var/datum/component/item_upgrade/I = AddComponent(/datum/component/item_upgrade)
	I.weapon_upgrades = list(
		GUN_UPGRADE_SILENCER = TRUE,
		GUN_UPGRADE_MUZZLEFLASH = 0.8,
		GUN_UPGRADE_DAMAGE_PLUS = -0.1,
		GUN_UPGRADE_RECOIL = 0.9
		)
	I.gun_loc_tag = GUN_MUZZLE
	I.req_gun_tags = list(GUN_SILENCABLE)


//Decreases fire delay. Acquired through loot spawns
/obj/item/gun_upgrade/barrel/forged
	name = "forged barrel"
	desc = "Despite pre-war advancements in weapon manufacture, a properly forged steel barrel is still a great addition to any gun."
	icon_state = "Forged_barrel"

/obj/item/gun_upgrade/barrel/forged/New()
	..()
	var/datum/component/item_upgrade/I = AddComponent(/datum/component/item_upgrade)
	I.weapon_upgrades = list(
		GUN_UPGRADE_FIRE_DELAY_MULT = 0.8,
		GUN_UPGRADE_RECOIL = 1.3
		)
	I.gun_loc_tag = GUN_BARREL

/obj/item/tool_upgrade/refinement/ported_barrel
	name = "ported barrel"
	desc = "A barrel extension for a welding tool (or gun) which helps manage gas pressure and keep the torch (or barrel) steady. When attached to a gun it allows for greater recoil control and a smaller flash at the cost of stopping power."
	icon_state = "ported_barrel"

/obj/item/tool_upgrade/refinement/ported_barrel/New()
	..()
	var/datum/component/item_upgrade/I = AddComponent(/datum/component/item_upgrade)
	/*I.tool_upgrades = list(
	UPGRADE_PRECISION = 12,
	UPGRADE_DEGRADATION_MULT = 1.15,
	UPGRADE_BULK = 1,
	UPGRADE_HEALTH_THRESHOLD = 10
	)*/
	I.weapon_upgrades = list(
		GUN_UPGRADE_FIRE_DELAY_MULT = 0.90,
		GUN_UPGRADE_PROJ_SPEED_MULT = 1.05,
		GUN_UPGRADE_MUZZLEFLASH = 0.8,
		GUN_UPGRADE_RECOIL = 0.8
	)
	I.req_gun_tags = list(GUN_PROJECTILE)
	I.gun_loc_tag = GUN_MUZZLE
	//I.required_qualities = list(QUALITY_WELDING)
	I.prefix = "ported"
*/
