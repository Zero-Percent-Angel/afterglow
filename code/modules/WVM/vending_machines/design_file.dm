/datum/design/vendorlathe
	build_type = VENDORLATHE
	/// Automatically sets the ammo's material cost through Dynamic Stuff~
	var/autocalc_material_values = TRUE

/datum/design/vendorlathe/InitializeMaterials()
	if(autocalc_material_values)
		calculate_ammobox_materials()
	. = ..()

/// spawns some ammo boxes, rips the material data, and then trashes them
/datum/design/vendorlathe/proc/calculate_ammobox_materials()
	if(!ispath(build_path, /obj/item/ammo_box))
		return
	var/list/design_materials = list()
	var/obj/item/ammo_box/this_box = new build_path()
	counterlist_combine(design_materials, this_box.custom_materials) // box materials
	if(!ispath(this_box.ammo_type, /obj/item/ammo_casing) || this_box.start_empty)
		qdel(this_box)
		set_build_cost(design_materials)
		return
	var/obj/item/ammo_casing/this_bullet = new this_box.ammo_type()
	var/list/bullet_materials = this_bullet.custom_materials
	bullet_materials = counterlist_scale(bullet_materials, this_box.max_ammo)
	counterlist_combine(design_materials, bullet_materials) // add ammo materials
	qdel(this_box)
	qdel(this_bullet)
	set_build_cost(design_materials)

/// Sets the material cost to whatever we came up with
/datum/design/vendorlathe/proc/set_build_cost(list/material_list)
	if(!LAZYLEN(material_list))
		return
	for(var/mat in GLOB.ammo_material_multipliers)
		if(mat in material_list)
			material_list[mat] *= GLOB.ammo_material_multipliers[mat]
	materials = material_list

//materials
/datum/design/vendorlathe/caps
	name = "Bottle Cap"
	id = "bottlecap"
	materials = list(/datum/material/f13cash = 1)
	build_path = /obj/item/stack/f13Cash/caps
	category = list("initial", "Materials")
	maxstack = 50
	autocalc_material_values = FALSE

/* --Tier 1 Ammo and Magazines-- */
//Tier 1 Magazines

/* Duplicate Design IDs... Not allowed I'm afraid
/datum/design/vendorlathe/zip9mm
	name = "zipgun clip (9mm)"
	id = "zip9m"
	materials = list(/datum/material/f13cash = 10)
	build_path = /obj/item/ammo_box/magazine/zipgun
	category = list("initial", "Simple Magazines", "Handmade Magazines")

/datum/design/vendorlathe/m45
	name = "empty handgun magazine (.45)"
	id = "m45"
	materials = list(/datum/material/f13cash = 15)
	build_path = /obj/item/ammo_box/magazine/m45/empty
	category = list("initial", "Simple Magazines")
*/
