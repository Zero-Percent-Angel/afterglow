GLOBAL_LIST(skill_chemical_reactions)
GLOBAL_LIST(skill_chemical_reactions_steps)

/obj/machinery/chem_research_station
	name = "chemical research station"
	density = TRUE
	icon = 'icons/obj/chemical.dmi'
	icon_state = "mixer0_b"
	var/icon_state_active = "mixer1_b"
	var/icon_state_inactive = "mixer0_b"
	use_power = IDLE_POWER_USE
	idle_power_usage = 40
	resistance_flags = FIRE_PROOF | ACID_PROOF
	circuit = /obj/item/circuitboard/machine/chem_research_station

/obj/machinery/chem_research_station/attackby(obj/item/I, mob/user, params)
	if(default_unfasten_wrench(user, I))
		return
	if(default_deconstruction_screwdriver(user, icon_state, icon_state, I))
		update_icon()
		return
	if(default_deconstruction_crowbar(I))
		return


/obj/machinery/chem_research_station/ui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "ChemHeater", name) // this needs to be changed to the one we create.
		ui.open()

/obj/machinery/chem_research_station/ui_data(mob/user)
	var/data = list()
	return data
