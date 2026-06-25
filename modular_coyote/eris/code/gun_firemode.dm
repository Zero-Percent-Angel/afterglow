/*
	Defines a firing mode for a gun.

	A firemode is created from a list of fire mode settings. Each setting modifies the value of the gun var with the same name.
	If the fire mode value for a setting is null, it will be replaced with the initial value of that gun's variable when the firemode is created.
	Obviously not compatible with variables that take a null value. If a setting is not present, then the corresponding var will not be modified.
*/
/datum/firemode
	var/name = "default"
	var/desc = "The default firemode"
	var/icon_state
	var/list/settings = list()
	/// is the gun semi, burst, or fullauto?
	var/fire_type = GUN_FIREMODE_SEMIAUTO
	var/burst_count = 1
	var/accuracy_mod = 0
	var/obj/item/gun/gun = null

/datum/firemode/New(obj/item/gun/_gun, list/properties = null)
	..()
	gun = _gun

	if(!properties || !properties.len)
		return

	for(var/propname in properties)
		var/propvalue = properties[propname]
		if(propname == "mode_name")
			name = propvalue
		else if(propname == "mode_desc")
			desc = propvalue
		else if(propname == "icon")
			icon_state = properties["icon"]
		else if(isnull(propvalue))
			settings[propname] = gun.vars[propname] //better than initial() as it handles list vars like dispersion
		else
			settings[propname] = propvalue

/datum/firemode/Destroy()
	gun = null
	return ..()

/datum/firemode/proc/apply_firemode()

	for(var/propname in settings)
		if(propname in gun.vars)
			gun.vars[propname] = settings[propname]
			// Apply gunmods effects that have been erased by the previous line
		else if(propname == "damage_mult_add")
			gun.damage_multiplier += settings[propname]

	gun.automatic = (fire_type == GUN_FIREMODE_AUTO)
	gun.burst_size = burst_count
	gun.added_spread = initial(gun.added_spread) + accuracy_mod

	for(var/obj/I in gun.item_upgrades)
		var/datum/component/item_upgrade/IU = I.GetComponent(/datum/component/item_upgrade)
		if(IU.weapon_upgrades[GUN_UPGRADE_CHARGECOST])
			gun.vars["charge_cost"] *= IU.weapon_upgrades[GUN_UPGRADE_CHARGECOST]
		if(IU.weapon_upgrades[GUN_UPGRADE_FIRE_DELAY_MULT])
			gun.fire_delay = max(round(gun.fire_delay * IU.weapon_upgrades[GUN_UPGRADE_FIRE_DELAY_MULT], 1), 1)
		if(IU.weapon_upgrades[GUN_UPGRADE_OFFSET])
			gun.added_spread = max(0, gun.added_spread + IU.weapon_upgrades[GUN_UPGRADE_OFFSET])

//Called whenever the firemode is switched to, or the gun is picked up while its active
/datum/firemode/proc/update()
	return

/datum/firemode/semi_auto
	name = "Semi Automatic"
	desc = "Shoot one shot per trigger pull."
	icon_state = "semi"
	fire_type = GUN_FIREMODE_SEMIAUTO
	burst_count = 1

/datum/firemode/semi_auto/shotgun_fixed
	name = "One at a time"
	desc = "Send vagabonds flying back several paces"

/datum/firemode/automatic
	name = "Fully Automatic"
	desc = "Spray and pray."
	icon_state = "auto"
	fire_type = GUN_FIREMODE_AUTO

/datum/firemode/burst
	name = "Burstfire"
	desc = "Shoot multiple shots per triggerpull."
	icon_state = "burst"
	fire_type = GUN_FIREMODE_BURST
	burst_count = 3

/datum/firemode/burst/two
	name = "2-Round Burst"
	desc = "Short, controlled bursts."
	fire_type = GUN_FIREMODE_BURST
	burst_count = 2

/datum/firemode/burst/two/shotgun_fixed
	name = "Both barrels"
	desc = "Give them the side-by-side"
	fire_type = GUN_FIREMODE_BURST
	burst_count = 2

/datum/firemode/burst/two/shotgun_fixed/apply_firemode()
	..()
	gun.fire_delay = 0

/datum/firemode/burst/four
	name = "4-Round Burst"
	desc = "Short, controlled bursts."
	fire_type = GUN_FIREMODE_BURST
	burst_count = 4

/datum/firemode/burst/four/fastest/hobo
	name = "All four barrels"
	desc = "Unleash the whole gun at once."

/datum/firemode/burst/three
	name = "3-Round Burst"
	desc = "Short, controlled bursts."
	fire_type = GUN_FIREMODE_BURST
	burst_count = 3

/datum/firemode/burst/five
	name = "5-Round Burst"
	desc = "Short, controlled bursts."
	fire_type = GUN_FIREMODE_BURST
	burst_count = 5



