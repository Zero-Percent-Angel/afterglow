///////////////////
// SMG MAGAZINES //
///////////////////

/obj/item/ammo_box/magazine/greasegun
	name = "Grease gun magazine (.45ACP)"
	icon = 'icons/fallout/objects/guns/ammo.dmi'
	icon_state = "grease"
	ammo_type = /obj/item/ammo_casing/c45
	caliber = list(CALIBER_45ACP)
	max_ammo = 30
	multiple_sprites = 2
	custom_materials = list(/datum/material/iron = MATS_SMG)
	w_class = WEIGHT_CLASS_SMALL

/obj/item/ammo_box/magazine/greasegun/empty
	start_empty = 1

/obj/item/ammo_box/magazine/uzim9mm
	name = "Uzi magazine (9mm)"
	icon = 'icons/fallout/objects/guns/ammo.dmi'
	icon_state = "uzi9mm"
	ammo_type = /obj/item/ammo_casing/c9mm
	max_ammo = 32
	custom_materials = list(/datum/material/iron = MATS_SMG)
	w_class = WEIGHT_CLASS_SMALL

/obj/item/ammo_box/magazine/uzim9mm/update_icon()
	..()
	icon_state = "[initial(icon_state)]-[round(ammo_count(),4)]"

/obj/item/ammo_box/magazine/uzim9mm/empty
	start_empty = 1

/obj/item/ammo_box/magazine/pps9mm
	name = "PPSh magazine (9mm)"
	icon = 'icons/fallout/objects/guns/ammo.dmi'
	icon_state = "ppshDrum"
	ammo_type = /obj/item/ammo_casing/c9mm
	caliber = list(CALIBER_9MM)
	max_ammo = 71
	multiple_sprites = 2
	custom_materials = list(/datum/material/iron = MATS_SMG_EXTENDED)
	w_class = WEIGHT_CLASS_NORMAL

/obj/item/ammo_box/magazine/pps9mm/empty
	start_empty = 1

/obj/item/ammo_box/magazine/m10mm/smg
	name = "submachine gun magazine (10mm)"
	icon_state = "smg10mm"
	ammo_type = /obj/item/ammo_casing/c10mm
	max_ammo = 30
	multiple_sprites = 2
	custom_materials = list(/datum/material/iron = MATS_SMG)
	w_class = WEIGHT_CLASS_SMALL

/obj/item/ammo_box/magazine/m10mm/smg/empty
	start_empty = 1

/obj/item/ammo_box/magazine/m10mm/smg/ext
	name = "extended submachine gun magazine (10mm)"
	max_ammo = 40

/obj/item/ammo_box/magazine/m10mm/smg/ext/empty
	start_empty = 1

/obj/item/ammo_box/magazine/m22smg
	name = "toploader magazine (.22lr)"
	icon = 'icons/fallout/objects/guns/ammo.dmi'
	icon_state = "smg22"
	ammo_type = /obj/item/ammo_casing/a22
	caliber = list(CALIBER_22LR)
	max_ammo = 180
	multiple_sprites = 2
	custom_materials = list(/datum/material/iron = MATS_SMG_EXTENDED)
	w_class = WEIGHT_CLASS_NORMAL

/obj/item/ammo_box/magazine/m22smg/empty
	start_empty = 1

/obj/item/ammo_box/magazine/tommygunm45
	name = "Thompson drum magazine (.45)"
	icon = 'icons/fallout/objects/guns/ammo.dmi'
	icon_state = "tommydrum"
	ammo_type = /obj/item/ammo_casing/c45
	caliber = list(CALIBER_45ACP)
	max_ammo = 50
	custom_materials = list(/datum/material/iron = MATS_SMG_EXTENDED)
	w_class = WEIGHT_CLASS_NORMAL

/obj/item/ammo_box/magazine/tommygunm45/stick
	name = "Thompson stick magazine (.45)"
	icon = 'icons/fallout/objects/guns/ammo.dmi'
	icon_state = "tommystick"
	ammo_type = /obj/item/ammo_casing/c45
	max_ammo = 20
	multiple_sprites = 2
	custom_materials = list(/datum/material/iron = MATS_SMG)
	w_class = WEIGHT_CLASS_SMALL

/obj/item/ammo_box/magazine/tommygunm45/empty
	start_empty = 1

/obj/item/ammo_box/magazine/tommygunm45/stick/empty
	start_empty = 1

/obj/item/ammo_box/magazine/smg14
	name = "14mm smg magazine"
	icon = 'icons/fallout/objects/guns/ammo.dmi'
	icon_state = "14smg"
	ammo_type = /obj/item/ammo_casing/p14mm
	caliber = list(CALIBER_14MM)
	max_ammo = 21
	custom_materials = list(/datum/material/iron = MATS_SMG)
	w_class = WEIGHT_CLASS_SMALL

/obj/item/ammo_box/magazine/smg14/empty
	start_empty = 1

/obj/item/ammo_box/magazine/smg14/stacked
	name = "14mm smg stacked magazine"
	icon = 'icons/fallout/objects/guns/ammo.dmi'
	icon_state = "14smge"
	ammo_type = /obj/item/ammo_casing/p14mm
	max_ammo = 27
	multiple_sprites = 2
	custom_materials = list(/datum/material/iron = MATS_SMG_EXTENDED)

/obj/item/ammo_box/magazine/smg14/stacked/empty
	start_empty = 1

/obj/item/ammo_box/magazine/m10mm_p90
	name = "toploader magazine (10mm)"
	icon = 'icons/fallout/objects/guns/ammo.dmi'
	icon_state = "5.56m"
	ammo_type = /obj/item/ammo_casing/c10mm
	caliber = list(CALIBER_10MM)
	max_ammo = 24
	multiple_sprites = 2
	custom_materials = list(/datum/material/iron = MATS_SMG_EXTENDED)
	w_class = WEIGHT_CLASS_NORMAL

/obj/item/ammo_box/magazine/m10mm_p90/empty
	start_empty = 1
