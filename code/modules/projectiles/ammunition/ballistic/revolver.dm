// .357
/obj/item/ammo_casing/a357
	name = ".357 FMJ bullet casing"
	desc = "A .357 FMJ bullet casing."
	caliber = CALIBER_357
	projectile_type = /obj/item/projectile/bullet/a357
	material_class = BULLET_IS_HEAVY_PISTOL
	custom_materials = list(
		/datum/material/iron = MATS_PISTOL_HEAVY_CASING + MATS_PISTOL_HEAVY_BULLET,
		/datum/material/blackpowder = MATS_PISTOL_HEAVY_POWDER)
	fire_power = CASING_POWER_HEAVY_PISTOL * CASING_POWER_MOD_SURPLUS

/obj/item/ammo_casing/a357/ricochet
	name = ".357 ricochet bullet casing"
	desc = "A .357 ricochet bullet casing."
	projectile_type = /obj/item/projectile/bullet/a357/ricochet
	fire_power = CASING_POWER_HEAVY_PISTOL * CASING_POWER_MOD_SURPLUS

/obj/item/ammo_casing/a357/incendiary
	name = ".357 incendiary bullet casing"
	desc = "A .357 incendiary bullet casing."
	projectile_type = /obj/item/projectile/bullet/a357/incendiary
	fire_power = CASING_POWER_HEAVY_PISTOL * CASING_POWER_MOD_HANDLOAD

/obj/item/ammo_casing/a357/improvised
	name = "shoddy .357 bullet casing"
	desc = "A handmade .357 magnum bullet casing."
	projectile_type = /obj/item/projectile/bullet/a357/improvised
	material_class = BULLET_IS_HEAVY_PISTOL
	casing_quality = BULLET_IS_HANDLOAD
	custom_materials = list(
		/datum/material/iron = (MATS_PISTOL_HEAVY_CASING * MATS_AMMO_CASING_HANDLOAD_MULT) + (MATS_PISTOL_HEAVY_BULLET * MATS_AMMO_BULLET_HANDLOAD_MULT),
		/datum/material/blackpowder = MATS_PISTOL_HEAVY_POWDER * MATS_AMMO_POWDER_HANDLOAD_MULT)
	fire_power = CASING_POWER_HEAVY_PISTOL * CASING_POWER_MOD_HANDLOAD

// .44 magnum
/obj/item/ammo_casing/m44
	name = ".44 magnum FMJ bullet casing"
	desc = "A .44 magnum full metal jacket bullet casing."
	caliber = CALIBER_44
	projectile_type = /obj/item/projectile/bullet/m44
	material_class = BULLET_IS_HEAVY_PISTOL
	custom_materials = list(
		/datum/material/iron = MATS_PISTOL_HEAVY_CASING + MATS_PISTOL_HEAVY_BULLET,
		/datum/material/blackpowder = MATS_PISTOL_HEAVY_POWDER)
	fire_power = CASING_POWER_HEAVY_PISTOL * CASING_POWER_MOD_SURPLUS

/obj/item/ammo_casing/m44/improvised
	name = "shoddy .44 magnum bullet casing"
	desc = "A homemade .44 magnum bullet casing."
	caliber = CALIBER_44
	projectile_type = /obj/item/projectile/bullet/m44/improvised
	material_class = BULLET_IS_HEAVY_PISTOL
	casing_quality = BULLET_IS_HANDLOAD
	custom_materials = list(
		/datum/material/iron = (MATS_PISTOL_HEAVY_CASING * MATS_AMMO_CASING_HANDLOAD_MULT) + (MATS_PISTOL_HEAVY_BULLET * MATS_AMMO_BULLET_HANDLOAD_MULT),
		/datum/material/blackpowder = MATS_PISTOL_HEAVY_POWDER * MATS_AMMO_POWDER_HANDLOAD_MULT)
	fire_power = CASING_POWER_HEAVY_PISTOL * CASING_POWER_MOD_HANDLOAD

/obj/item/ammo_casing/m44/incendiary
	name = ".44 magnum incendiary bullet casing"
	desc = "A .44 magnum incendiary bullet casing."
	projectile_type = /obj/item/projectile/bullet/c45/incendiary
	fire_power = CASING_POWER_HEAVY_PISTOL * CASING_POWER_MOD_HANDLOAD

// .45-70 Gov't
/obj/item/ammo_casing/c4570
	name = ".45-70 FMJ bullet casing"
	desc = "A .45-70 full metal jacket bullet casing."
	caliber = CALIBER_4570
	projectile_type = /obj/item/projectile/bullet/c4570
	material_class = BULLET_IS_HEAVY_RIFLE
	casing_quality = BULLET_IS_MATCH
	custom_materials = list(
		/datum/material/iron = (MATS_RIFLE_HEAVY_CASING * MATS_AMMO_CASING_MATCH_MULT) + (MATS_RIFLE_HEAVY_BULLET * MATS_AMMO_BULLET_MATCH_MULT),
		/datum/material/blackpowder = MATS_RIFLE_HEAVY_POWDER * MATS_AMMO_POWDER_MATCH_MULT)
	fire_power = CASING_POWER_HEAVY_RIFLE * CASING_POWER_MOD_SURPLUS

/obj/item/ammo_casing/c4570/improvised
	name = "shoddy .45-70 bullet casing"
	desc = "A homemade .45-70 bullet casing."
	caliber = CALIBER_4570
	projectile_type = /obj/item/projectile/bullet/c4570/improvised
	material_class = BULLET_IS_HEAVY_RIFLE
	casing_quality = BULLET_IS_HANDLOAD
	custom_materials = list(
		/datum/material/iron = (MATS_RIFLE_HEAVY_CASING * MATS_AMMO_CASING_HANDLOAD_MULT) + (MATS_RIFLE_HEAVY_BULLET * MATS_AMMO_BULLET_HANDLOAD_MULT),
		/datum/material/blackpowder = MATS_RIFLE_HEAVY_POWDER * MATS_AMMO_POWDER_HANDLOAD_MULT)
	fire_power = CASING_POWER_HEAVY_RIFLE * CASING_POWER_MOD_HANDLOAD

/obj/item/ammo_casing/c4570/surplus
	name = ".45-70 bullet casing"
	desc = "A .45-70 bullet casing."
	caliber = CALIBER_4570
	projectile_type = /obj/item/projectile/bullet/c4570/surplus
	material_class = BULLET_IS_HEAVY_RIFLE
	casing_quality = BULLET_IS_SURPLUS
	custom_materials = list(
		/datum/material/iron = MATS_RIFLE_HEAVY_CASING + MATS_RIFLE_HEAVY_BULLET,
		/datum/material/blackpowder = MATS_RIFLE_HEAVY_POWDER * MATS_AMMO_POWDER_HANDLOAD_MULT)
	fire_power = CASING_POWER_HEAVY_RIFLE * CASING_POWER_MOD_HANDLOAD

/obj/item/ammo_casing/c4570/explosive
	name = ".45-70 explosive bullet casing"
	desc = "A .45-70 explosive bullet casing."
	projectile_type = /obj/item/projectile/bullet/c4570/explosive
	fire_power = CASING_POWER_HEAVY_RIFLE * CASING_POWER_MOD_SURPLUS

/obj/item/ammo_casing/c4570/knockback
	name = ".45-70 ultradense bullet casing"
	desc = "A .45-70 ultradense bullet casing."
	projectile_type = /obj/item/projectile/bullet/c4570/knockback
	material_class = BULLET_IS_HEAVY_RIFLE
	casing_quality = BULLET_IS_RUBBER
	custom_materials = list(
		/datum/material/iron = (MATS_RIFLE_HEAVY_CASING * MATS_AMMO_CASING_HANDLOAD_MULT) + (MATS_RIFLE_HEAVY_BULLET * MATS_AMMO_BULLET_HANDLOAD_MULT),
		/datum/material/blackpowder = MATS_RIFLE_HEAVY_POWDER * MATS_AMMO_POWDER_HANDLOAD_MULT)
	fire_power = CASING_POWER_HEAVY_RIFLE * CASING_POWER_MOD_MATCH
