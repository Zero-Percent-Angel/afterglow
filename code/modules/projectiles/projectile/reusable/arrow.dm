/obj/item/projectile/bullet/reusable/arrow
	name = "metal arrow"
	desc = "a simple arrow with a metal head."
	damage = 80
	armour_penetration = -1
	damage_threshold_penetration = -20
	icon_state = "arrow"
	ammo_type = /obj/item/ammo_casing/caseless/arrow

//CIT ARROWS
/obj/item/projectile/bullet/reusable/arrow/ash
	name = "ashen arrow"
	desc = "Fire harderned arrow."
	damage = 0.5
	ammo_type = /obj/item/ammo_casing/caseless/arrow/ash

/obj/item/projectile/bullet/reusable/arrow/bone //extra mob damage
	name = "bone arrow"
	desc = "Arrow made of bone and sinew."
	damage = 60
	armour_penetration = -1.25
	damage_threshold_penetration = -20
	supereffective_damage = 40
	supereffective_faction = list("hostile", "ant", "supermutant", "deathclaw", "cazador", "raider", "china", "gecko", "wastebot", "radscorpion")
	ammo_type = /obj/item/ammo_casing/caseless/arrow/bone

/obj/item/projectile/bullet/reusable/arrow/bronze //Just some AP shots
	name = "bronze arrow"
	desc = "Bronze tipped arrow."
	damage = 55
	armour_penetration = -0.65
	damage_threshold_penetration = -18
	ammo_type = /obj/item/ammo_casing/caseless/arrow/bronze

//FO13 ARROWS
/obj/item/projectile/bullet/reusable/arrow/cheap
	name = "lightweight arrow"
	desc = "A cheap, lightweight wooden arrow. Not as effective against armor."
	damage = 60
	armour_penetration = -1
	damage_threshold_penetration = -22
	icon_state = "arrow"
	ammo_type = /obj/item/ammo_casing/caseless/arrow/cheap

/obj/item/projectile/bullet/reusable/arrow/ap
	name = "sturdy arrow"
	desc = "A reinforced arrow with a metal shaft and heavy duty head."
	damage = 45
	armour_penetration = -0.45
	damage_threshold_penetration = -15
	icon_state = "arrow"
	ammo_type = /obj/item/ammo_casing/caseless/arrow/ap

/obj/item/projectile/bullet/reusable/arrow/poison
	name = "poison arrow"
	desc = "A simple arrow, tipped in a poisonous paste."
	damage = 35
	armour_penetration = -0.4
	damage_threshold_penetration = -20
	icon_state = "arrow"
	ammo_type = /obj/item/ammo_casing/caseless/arrow/poison

/obj/item/projectile/bullet/reusable/arrow/poison/on_hit(atom/target, blocked)
	. = ..()
	if(isliving(target))
		var/mob/living/targetHuman = target
		var/armor = targetHuman.run_armor_check(silent = TRUE)
		targetHuman.apply_damage(30, TOX, null, armor)

/obj/item/projectile/bullet/reusable/arrow/burning
	name = "burn arrow"
	desc = "A sumple arrow slathered in a paste that burns skin on contact."
	damage = 35 //gotta balance it!
	armour_penetration = -0.4
	damage_threshold_penetration = -20
	icon_state = "arrow"
	ammo_type = /obj/item/ammo_casing/caseless/arrow/burning

/obj/item/projectile/bullet/reusable/arrow/burning/on_hit(atom/target, blocked)
	. = ..()
	if(ishuman(target))
		var/mob/living/carbon/human/targetHuman = target
		targetHuman.adjust_fire_stacks(6)
		targetHuman.IgniteMob() //you just got burned!


/obj/item/projectile/bullet/reusable/arrow/broadhead
	name = "broadhead arrow"
	desc = "An arrow that sticks in wounds. Badly."
	armour_penetration = -1.25
	damage_threshold_penetration = -20
	damage = 70
	sharpness = SHARP_EDGED
	ammo_type = /obj/item/ammo_casing/caseless/arrow/broadhead
	embedding = list(embed_chance=50, fall_chance=60, jostle_chance=3, ignore_throwspeed_threshold=TRUE, pain_stam_pct=0.2, pain_mult=2, jostle_pain_mult=1, rip_time=25, projectile_payload = /obj/item/ammo_casing/caseless/arrow/broadhead)

/obj/item/projectile/bullet/reusable/arrow/broadhead/on_hit(atom/target, blocked)
	if(iscarbon(target))
		dropped = TRUE
	..()

/obj/item/projectile/bullet/reusable/arrow/serrated
	name = "serrated arrow"
	desc = "An arrow that can sever arteries!"
	wound_bonus = 75
	bare_wound_bonus = 20
	sharpness = SHARP_EDGED
	armour_penetration = -1.25
	damage_threshold_penetration = -20
	damage = 55
	ammo_type = /obj/item/ammo_casing/caseless/arrow/serrated

/obj/item/projectile/bullet/reusable/arrow/blunt
	name = "knockout arrow"
	desc = "An arrow with a thick cloth sack at the end, filled with rocks."
	wound_bonus = 0
	bare_wound_bonus = 0
	wound_falloff_tile = 0
	armour_penetration = -1.25
	damage_threshold_penetration = -20
	damage = 15
	stamina = 80
	ammo_type = /obj/item/ammo_casing/caseless/arrow/blunt

// Special Arrows

/obj/item/projectile/ion/arrow //im sorry but this is TECHNICALLY an arrow SOOO
	name = "ion arrow"
	desc = "An arrow that created an EMP where it lands."
	icon_state = "arrow"
	damage = 28
	armour_penetration = 0.75
	damage_type = BURN
	flag = "energy"
	impact_effect_type = /obj/effect/temp_visual/impact_effect/ion

/obj/item/projectile/ion/arrow/on_hit(atom/target, blocked = FALSE)
	..()
	empulse_using_range(target, emp_radius)
	return BULLET_ACT_HIT

/obj/item/projectile/ion/arrow/weak
	emp_radius = 1
	damage = 20
	armour_penetration = 0.5
