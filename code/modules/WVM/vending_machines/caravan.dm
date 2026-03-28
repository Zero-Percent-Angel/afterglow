/obj/machinery/autolathe/ammo_buyer
	name = "ammo seller"
	icon = 'icons/obj/machines/reloadingbench.dmi'
	desc = "This should not exist"
	circuit = /obj/item/circuitboard/machine/autolathe/ammo
  //stored_research = /datum/techweb/specialized/autounlocking/autolathe/ammo
	stored_research = null
	categories = list(
					"Simple Magazines",
					"Materials"
					)
	allowed_materials = list(
		/datum/material/f13cash
		)
	var/simple = 1
	var/basic = 1
	var/intermediate = 1
	var/advanced = 1
	/// does this bench accept books?
	var/accepts_books = TRUE
	/// does this bench accept books?
	tooadvanced = TRUE //technophobes will still need to be able to make ammo	//not anymore they wont


// no discounts for sticky fingers!
/obj/machinery/autolathe/ammo_buyer/get_design_cost(datum/design/D)
	var/dat
	for(var/i in D.materials)
		if(istext(i)) //Category handling
			dat += "[D.materials[i]] [i]"
		else
			var/datum/material/M = i
			dat += "[D.materials[i]] [M.name] "
	return dat
/*
/obj/machinery/autolathe/ammo_buyer/can_build(datum/design/D, amount = 1)
	if("Simple Ammo" in D.category)
		if(simple == 0)
			return FALSE
		else
			. = ..()
	else
		. = ..()
	if("Simple Magazines" in D.category)
		if(simple == 0)
			return FALSE
		else
			. = ..()
	else
		. = ..()
*/


/obj/machinery/autolathe/ammo_buyer/can_build(datum/design/D, amount = 1)
	if("Simple Ammo" in D.category)
		if(simple == 0)
			return FALSE
		else
			. = ..()
	else
		. = ..()
	if("Simple Magazines" in D.category)
		if(simple == 0)
			return FALSE
		else
			. = ..()
	else
		. = ..()
	if("Basic Ammo" in D.category)
		if(basic == 0)
			return FALSE
		else
			. = ..()
	else
		. = ..()
	if("Basic Magazines" in D.category)
		if(basic == 0)
			return FALSE
		else
			. = ..()
	else
		. = ..()
	if("Intermediate Ammo" in D.category)
		if(intermediate == 0)
			return FALSE
		else
			. = ..()
	else
		. = ..()
	if("Intermediate Magazines" in D.category)
		if(intermediate == 0)
			return FALSE
		else
			. = ..()
	else
		. = ..()
	if("Advanced Ammo" in D.category)
		if(advanced == 0)
			return FALSE
		else
			. = ..()
	else
		. = ..()
	if("Advanced Magazines" in D.category)
		if(advanced == 0)
			return FALSE
		else
			. = ..()
	else
		. = ..()

/obj/machinery/autolathe/ammo_buyer/on_deconstruction()
	..()

	return
