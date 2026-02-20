/*
//For energy weapons, increases the damage output, but also the charge cost. Acquired through loot spawns or Eye of the Protector.
/obj/item/gun_upgrade/barrel/excruciator
	name = "Wattz \"GigaLens\" 3000"
	desc = "A Pre-war Wattz-brand upgrade kit, or an imitation of one. Exchanges the gun's lens frame with a hyper-focused one."
	icon_state = "Excruciator"

/obj/item/gun_upgrade/barrel/excruciator/New()
	..()
	var/datum/component/item_upgrade/I = AddComponent(/datum/component/item_upgrade)
	I.weapon_upgrades = list(
		GUN_UPGRADE_DAMAGE_MULT = 1.1,
		GUN_UPGRADE_CHARGECOST = 1.3
		)
	I.gun_loc_tag = GUN_BARREL
	I.req_gun_tags = list(GUN_ENERGY)


// Heat disperser can be attached to any tool that uses fuel or power
/obj/item/tool_upgrade/reinforcement/plasmablock
	name = "Jet coolant radiator"
	desc = "A haphazardly crafted radiator with coils filled with jet coolant wrapped around it."
	icon_state = "plasmablock"

/obj/item/tool_upgrade/reinforcement/plasmablock/New()
	..()
	var/datum/component/item_upgrade/I = AddComponent(/datum/component/item_upgrade)
	/*I.tool_upgrades = list(
		UPGRADE_DEGRADATION_MULT = 0.45,
		UPGRADE_HEALTH_THRESHOLD = 10,
		UPGRADE_POWERCOST_MULT = 1.05,
		UPGRADE_FUELCOST_MULT = 1.05
		)*/
	I.weapon_upgrades = list(
		GUN_UPGRADE_DAMAGE_MULT = 0.75,
		GUN_UPGRADE_FIRE_DELAY_MULT = 0.8,
		GUN_UPGRADE_PROJ_SPEED_MULT = 1.4
	)
	I.prefix = "plasma-cooled"
	I.req_fuel_cell = REQ_FUEL_OR_CELL
	I.gun_loc_tag = GUN_MECHANISM
	I.req_gun_tags = list(GUN_ENERGY)

	/obj/item/tool_upgrade/productivity/booster
	name = "booster"
	desc = "When you do not care about energy comsumption and just want to get shit done quickly. This device shunts the power safeties of your tool whether it uses fuel or electricity."
	icon_state = "booster"

/obj/item/tool_upgrade/productivity/booster/New()
	..()
	var/datum/component/item_upgrade/I = AddComponent(/datum/component/item_upgrade)
	/*I.tool_upgrades = list(
	UPGRADE_WORKSPEED = 0.35,
	UPGRADE_DEGRADATION_MULT = 1.15,
	UPGRADE_POWERCOST_MULT = 1.25,
	UPGRADE_FUELCOST_MULT = 1.25
	)*/
	I.weapon_upgrades = list(
		GUN_UPGRADE_DAMAGE_MULT = 1.20,
		GUN_UPGRADE_FIRE_DELAY_MULT = 1.1,
		GUN_UPGRADE_CHARGECOST = 1.35
	)
	I.prefix = "boosted"
	I.req_fuel_cell = REQ_FUEL_OR_CELL
	I.gun_loc_tag = GUN_MECHANISM
	I.req_gun_tags = list(GUN_ENERGY)

*/
