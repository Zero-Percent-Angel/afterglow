/*
What are the archived variables for?
	Calculations are done using the archived variables with the results merged into the regular variables.
	This prevents race conditions that arise based on the order of tile processing.
*/
#define MINIMUM_HEAT_CAPACITY	0.0003
#define MINIMUM_MOLE_COUNT		0.01

/datum/gas_mixture
	/// Never ever set this variable, hooked into vv_get_var for view variables viewing.
	var/gas_list_view_only
	var/initial_volume = CELL_VOLUME //liters
	var/list/reaction_results
	var/list/analyzer_results //used for analyzer feedback - not initialized until its used
	var/_extools_pointer_gasmixture // Contains the index in the gas vector for this gas mixture in rust land. Don't. Touch. This. Var.
	var/list/local_gas_mix = list()
	var/temp = T20C
	var/static_air = FALSE
	var/validated = FALSE

/datum/gas_mixture/New(volume)
	if (!isnull(volume))
		initial_volume = volume
	reaction_results = new

/datum/gas_mixture/vv_edit_var(var_name, var_value)
	if(var_name == NAMEOF(src, _extools_pointer_gasmixture))
		return FALSE // please no. segfaults bad.
	if(var_name == NAMEOF(src, gas_list_view_only))
		return FALSE
	return ..()

/datum/gas_mixture/vv_get_var(var_name)
	. = ..()
	if(var_name == NAMEOF(src, gas_list_view_only))
		var/list/dummy = get_gases()
		for(var/gas in dummy)
			dummy[gas] = get_moles(gas)
			dummy["CAP [gas]"] = partial_heat_capacity(gas)
		dummy["TEMP"] = return_temperature()
		dummy["PRESSURE"] = return_pressure()
		dummy["HEAT CAPACITY"] = heat_capacity()
		dummy["TOTAL MOLES"] = total_moles()
		dummy["VOLUME"] = return_volume()
		dummy["THERMAL ENERGY"] = thermal_energy()
		return debug_variable("gases (READ ONLY)", dummy, 0, src)

/datum/gas_mixture/vv_get_dropdown()
	. = ..()
	VV_DROPDOWN_OPTION("", "---")
	VV_DROPDOWN_OPTION(VV_HK_PARSE_GASSTRING, "Parse Gas String")
	VV_DROPDOWN_OPTION(VV_HK_EMPTY, "Empty")
	VV_DROPDOWN_OPTION(VV_HK_SET_MOLES, "Set Moles")
	VV_DROPDOWN_OPTION(VV_HK_SET_TEMPERATURE, "Set Temperature")
	VV_DROPDOWN_OPTION(VV_HK_SET_VOLUME, "Set Volume")

/datum/gas_mixture/vv_do_topic(list/href_list)
	. = ..()
	if(!.)
		return
	if(href_list[VV_HK_PARSE_GASSTRING])
		var/gasstring = input(usr, "Input Gas String (WARNING: Advanced. Don't use this unless you know how these work.", "Gas String Parse") as text|null
		if(!istext(gasstring))
			return
		log_admin("[key_name(usr)] modified gas mixture [REF(src)]: Set to gas string [gasstring].")
		message_admins("[key_name(usr)] modified gas mixture [REF(src)]: Set to gas string [gasstring].")
		parse_gas_string(gasstring)
	if(href_list[VV_HK_EMPTY])
		log_admin("[key_name(usr)] emptied gas mixture [REF(src)].")
		message_admins("[key_name(usr)] emptied gas mixture [REF(src)].")
		clear()
	if(href_list[VV_HK_SET_MOLES])
		var/list/gases = get_gases()
		for(var/gas in gases)
			gases[gas] = get_moles(gas)
		var/gasid = input(usr, "What kind of gas?", "Set Gas") as null|anything in GLOB.gas_data.ids
		if(!gasid)
			return
		var/amount = input(usr, "Input amount", "Set Gas", gases[gasid] || 0) as num|null
		if(!isnum(amount))
			return
		amount = max(0, amount)
		log_admin("[key_name(usr)] modified gas mixture [REF(src)]: Set gas [gasid] to [amount] moles.")
		message_admins("[key_name(usr)] modified gas mixture [REF(src)]: Set gas [gasid] to [amount] moles.")
		set_moles(gasid, amount)
	if(href_list[VV_HK_SET_TEMPERATURE])
		var/temp = input(usr, "Set the temperature of this mixture to?", "Set Temperature", return_temperature()) as num|null
		if(!isnum(temp))
			return
		temp = max(2.7, temp)
		log_admin("[key_name(usr)] modified gas mixture [REF(src)]: Changed temperature to [temp].")
		message_admins("[key_name(usr)] modified gas mixture [REF(src)]: Changed temperature to [temp].")
		set_temperature(temp)
	if(href_list[VV_HK_SET_VOLUME])
		var/volume = input(usr, "Set the volume of this mixture to?", "Set Volume", return_volume()) as num|null
		if(!isnum(volume))
			return
		volume = max(0, volume)
		log_admin("[key_name(usr)] modified gas mixture [REF(src)]: Changed volume to [volume].")
		message_admins("[key_name(usr)] modified gas mixture [REF(src)]: Changed volume to [volume].")
		set_volume(volume)

/*
we use a hook instead
/datum/gas_mixture/Del()
	__gasmixture_unregister()
	. = ..()
	*/

/datum/gas_mixture/proc/__gasmixture_unregister()
/datum/gas_mixture/proc/__gasmixture_register()

/proc/gas_types()
	var/list/L = subtypesof(/datum/gas)
	for(var/gt in L)
		var/datum/gas/G = gt
		L[gt] = initial(G.specific_heat)
	return L

/datum/gas_mixture/proc/heat_capacity() //joules per kelvin
	return 700

/datum/gas_mixture/proc/partial_heat_capacity(gas_type)
	return 700

/datum/gas_mixture/proc/total_moles()
	var/moles_total = 0
	for(var/I in local_gas_mix)
		moles_total += local_gas_mix[I]
	return moles_total

/datum/gas_mixture/proc/return_pressure() //kilopascals
	if (!validated)
		validate()
	return total_moles() * R_IDEAL_GAS_EQUATION * return_temperature()/return_volume()

/datum/gas_mixture/proc/return_temperature() //kelvins
	return temp

/datum/gas_mixture/proc/set_min_heat_capacity(n)
	return 0

/datum/gas_mixture/proc/set_temperature(new_temp)
	temp = new_temp

/datum/gas_mixture/proc/set_volume(new_volume)
	initial_volume = new_volume

/datum/gas_mixture/proc/get_moles(gas_type)
	return local_gas_mix[gas_type]

/datum/gas_mixture/proc/set_moles(gas_type, moles)
	if (moles > 0 && GLOB.the_gases.Find(gas_type))
		local_gas_mix[gas_type] = moles
	else
		local_gas_mix.Remove(gas_type)

// VV WRAPPERS - EXTOOLS HOOKED PROCS DO NOT TAKE ARGUMENTS FROM CALL() FOR SOME REASON.
/datum/gas_mixture/proc/vv_set_moles(gas_type, moles)
	return set_moles(gas_type, moles)
/datum/gas_mixture/proc/vv_get_moles(gas_type)
	return get_moles(gas_type)
/datum/gas_mixture/proc/vv_set_temperature(new_temp)
	return set_temperature(new_temp)
/datum/gas_mixture/proc/vv_set_volume(new_volume)
	return set_volume(new_volume)
/datum/gas_mixture/proc/vv_react(datum/holder)
	return react(holder)

/datum/gas_mixture/proc/scrub_into(datum/gas_mixture/target, ratio, list/gases)
/datum/gas_mixture/proc/mark_immutable()
	static_air = TRUE
/datum/gas_mixture/proc/get_gases()
	return local_gas_mix
/datum/gas_mixture/proc/multiply(factor)
/datum/gas_mixture/proc/get_last_share()

/datum/gas_mixture/proc/clear()
	local_gas_mix = list()
	temp = T20C

/datum/gas_mixture/proc/adjust_moles(gas_type, amt = 0)
	set_moles(gas_type, clamp(get_moles(gas_type) + amt,0,INFINITY))

/datum/gas_mixture/proc/return_volume() //liters
	return initial_volume

/datum/gas_mixture/proc/thermal_energy() //joules
	return return_temperature()*heat_capacity()

/datum/gas_mixture/proc/archive()
	validate()
	return 1
	//Update archived versions of variables
	//Returns: 1 in all cases

/datum/gas_mixture/proc/validate()
	if (validated)
		return
	var/list/removal_list = list()
	for (var/I in local_gas_mix)
		if (!GLOB.the_gases.Find(I))
			removal_list.Add(I)
	local_gas_mix.RemoveAll(removal_list)
	validated = TRUE

/datum/gas_mixture/proc/merge(datum/gas_mixture/giver)
	if (static_air)
		return
	for(var/I in giver.local_gas_mix)
		if (local_gas_mix.Find(I))
			local_gas_mix[I] += giver.get_moles(I)
		else
			local_gas_mix[I] = giver.get_moles(I)
	//Merges all air from giver into self. giver is untouched.
	//Returns: 1 if we are mutable, 0 otherwise

/datum/gas_mixture/proc/remove(amount)
	var/datum/gas_mixture/new_mix = new /datum/gas_mixture
	for(var/I in local_gas_mix)
		var/myMoles = get_moles(I);
		if (!static_air)
			set_moles(I, (myMoles - (amount * myMoles/total_moles())))
		new_mix.set_moles(I, (amount * myMoles/total_moles()))
		new_mix.validate()
	return new_mix
	//Removes amount of gas from the gas_mixture
	//Returns: gas_mixture with the gases removed

/datum/gas_mixture/proc/transfer_to(datum/gas_mixture/target, amount)
	if (!target.static_air)
		target.merge(remove(amount))
	//Transfers amount of gas to target. Equivalent to target.merge(remove(amount)) but faster.

/datum/gas_mixture/proc/transfer_ratio_to(datum/gas_mixture/target, ratio)
	if (!target.static_air)
		target.merge(remove_ratio(ratio))
	//Transfers ratio of gas to target. Equivalent to target.merge(remove_ratio(amount)) but faster.

/datum/gas_mixture/proc/remove_ratio(ratio)
	var/datum/gas_mixture/new_mix = new /datum/gas_mixture
	for(var/I in local_gas_mix)
		var/myMoles = get_moles(I);
		if (!static_air)
			set_moles(I, (myMoles - (myMoles * 100 * ratio/total_moles())))
		new_mix.set_moles(I, (myMoles * 100 * ratio/total_moles()))
	return new_mix
	//Proportionally removes amount of gas from the gas_mixture
	//Returns: gas_mixture with the gases removed

/datum/gas_mixture/proc/copy()
	var/datum/gas_mixture/new_mix = new /datum/gas_mixture(return_volume())
	for (var/I in local_gas_mix)
		new_mix.set_moles(I, get_moles(I))
	new_mix.set_temperature(return_temperature())
	new_mix.validate()
	return new_mix
	//Creates new, identical gas mixture
	//Returns: duplicate gas mixture

/datum/gas_mixture/proc/copy_from(datum/gas_mixture/sample)
	if (!static_air)
		for (var/I in sample.local_gas_mix)
			set_moles(I, sample.get_moles(I))
		set_temperature(sample.return_temperature())
		validated = 0
		validate()
		return 1
	return 0
	//Copies variables from sample
	//Returns: 1 if we are mutable, 0 otherwise

/datum/gas_mixture/proc/copy_from_turf(turf/model)
	return 0
	//Copies all gas info from the turf into the gas list along with temperature
	//Returns: 1 if we are mutable, 0 otherwise

/datum/gas_mixture/proc/parse_gas_string(gas_string)
	//Copies variables from a particularly formatted string.
	//Returns: 1 if we are mutable, 0 otherwise

/datum/gas_mixture/proc/share(datum/gas_mixture/sharer)
	//Performs air sharing calculations between two gas_mixtures assuming only 1 boundary length
	//Returns: amount of gas exchanged (+ if sharer received)

/datum/gas_mixture/proc/temperature_share(datum/gas_mixture/sharer, conduction_coefficient,temperature=null,heat_capacity=null)
	//Performs temperature sharing calculations (via conduction) between two gas_mixtures assuming only 1 boundary length
	//Returns: new temperature of the sharer

/datum/gas_mixture/proc/compare(datum/gas_mixture/sample)
	//Compares sample to self to see if within acceptable ranges that group processing may be enabled
	//Returns: a string indicating what check failed, or "" if check passes

/datum/gas_mixture/proc/react(datum/holder)
	//Performs various reactions such as combustion or fusion (LOL)

	//Returns: 1 if any reaction took place; 0 otherwise
/datum/gas_mixture/proc/adjust_heat(amt)
	//Adjusts the thermal energy of the gas mixture, rather than having to do the full calculation.
	//Returns: null

/datum/gas_mixture/proc/equalize_with(datum/gas_mixture/giver)
	//Makes this mix have the same temperature and gas ratios as the giver, but with the same pressure, accounting for volume.
	//Returns: null

/datum/gas_mixture/proc/get_oxidation_power(temp)
	//Gets how much oxidation this gas can do, optionally at a given temperature.

/datum/gas_mixture/proc/get_fuel_amount(temp)
	//Gets how much fuel for fires (not counting trit/plasma!) this gas has, optionally at a given temperature.

/proc/equalize_all_gases_in_list(list/L)
	var/total_vol = 0
	var/total_mol = 0
	var/average_temp = 0
	for (var/datum/gas_mixture/GM in L)
		total_vol += GM.return_volume()
		total_mol += GM.total_moles()

	//fuck all here and we don't want to divide by zero
	if (total_mol == 0)
		return
	for (var/datum/gas_mixture/GM in L)
		average_temp += (GM.return_temperature() * GM.total_moles()/total_mol)
	var/datum/gas_mixture/temp_mixer = new /datum/gas_mixture(total_vol)
	temp_mixer.set_temperature(average_temp)
	for (var/datum/gas_mixture/GM in L)
		GM.transfer_to(temp_mixer, GM.total_moles())
	for (var/datum/gas_mixture/GM in L)
		GM.set_temperature(average_temp)
		temp_mixer.transfer_ratio_to(GM, GM.return_volume()/temp_mixer.return_volume())

	//Makes every gas in the given list have the same pressure, temperature and gas proportions.
	//Returns: null

/datum/gas_mixture/proc/__remove()

/*
/datum/gas_mixture/remove(amount)
	var/datum/gas_mixture/removed = new type
	__remove(removed, amount)

	return removed
*/
/datum/gas_mixture/proc/__remove_ratio()
/*
/datum/gas_mixture/remove_ratio(ratio)
	var/datum/gas_mixture/removed = new type
	__remove_ratio(removed, ratio)

	return removed

/datum/gas_mixture/copy()
	var/datum/gas_mixture/copy = new type
	copy.copy_from(src)

	return copy
*/
/datum/gas_mixture/copy_from_turf(turf/model)
	set_temperature(initial(model.initial_temperature))
	parse_gas_string(model.initial_gas_mix)
	return 1

/datum/gas_mixture/parse_gas_string(gas_string)
	gas_string = SSair.preprocess_gas_string(gas_string)

	var/list/gas = params2list(gas_string)
	if(gas["TEMP"])
		var/temp = text2num(gas["TEMP"])
		gas -= "TEMP"
		if(!isnum(temp) || temp < 2.7)
			temp = 2.7
		set_temperature(temp)
	clear()
	for(var/id in gas)
		set_moles(id, text2num(gas[id]))
	archive()
	return 1
/*
/datum/gas_mixture/react(datum/holder)
	. = NO_REACTION
	if(!total_moles())
		return
	var/list/reactions = list()
	for(var/datum/gas_reaction/G in SSair.gas_reactions)
		if(get_moles(G.major_gas))
			reactions += G
	if(!length(reactions))
		return
	reaction_results = new
	var/temp = return_temperature()
	var/ener = thermal_energy()

	reaction_loop:
		for(var/r in reactions)
			var/datum/gas_reaction/reaction = r

			var/list/min_reqs = reaction.min_requirements
			if((min_reqs["TEMP"] && temp < min_reqs["TEMP"]) \
			|| (min_reqs["ENER"] && ener < min_reqs["ENER"]))
				continue

			for(var/id in min_reqs)
				if (id == "TEMP" || id == "ENER")
					continue
				if(get_moles(id) < min_reqs[id])
					continue reaction_loop
			//at this point, all minimum requirements for the reaction are satisfied.

			/*	currently no reactions have maximum requirements, so we can leave the checks commented out for a slight performance boost
				PLEASE DO NOT REMOVE THIS CODE. the commenting is here only for a performance increase.
				enabling these checks should be as easy as possible and the fact that they are disabled should be as clear as possible
			var/list/max_reqs = reaction.max_requirements
			if((max_reqs["TEMP"] && temp > max_reqs["TEMP"]) \
			|| (max_reqs["ENER"] && ener > max_reqs["ENER"]))
				continue
			for(var/id in max_reqs)
				if(id == "TEMP" || id == "ENER")
					continue
				if(cached_gases[id] && cached_gases[id][MOLES] > max_reqs[id])
					continue reaction_loop
			//at this point, all requirements for the reaction are satisfied. we can now react()
			*/
			. |= reaction.react(src, holder)
			if (. & STOP_REACTIONS)
				break
*/

/datum/gas_mixture/proc/set_analyzer_results(instability)
	if(!analyzer_results)
		analyzer_results = new
	analyzer_results["fusion"] = instability

//Mathematical proofs:
/*
get_breath_partial_pressure(gas_pp) --> gas_pp/total_moles()*breath_pp = pp
get_true_breath_pressure(pp) --> gas_pp = pp/breath_pp*total_moles()
10/20*5 = 2.5
10 = 2.5/5*20
*/

/datum/gas_mixture/turf

/*
/mob/verb/profile_atmos()
	/world{loop_checks = 0;}
	var/datum/gas_mixture/A = new
	var/datum/gas_mixture/B = new
	A.parse_gas_string("o2=200;n2=800;TEMP=50")
	B.parse_gas_string("co2=500;plasma=500;TEMP=5000")
	var/pa
	var/pb
	pa = world.tick_usage
	for(var/I in 1 to 100000)
		B.transfer_to(A, 1)
		A.transfer_to(B, 1)
	pb = world.tick_usage
	var/total_time = (pb-pa) * world.tick_lag
	to_chat(src, "Total time (gas transfer): [total_time]ms")
	to_chat(src, "Operations per second: [100000 / (total_time/1000)]")
	pa = world.tick_usage
	for(var/I in 1 to 100000)
		B.total_moles();
	pb = world.tick_usage
	total_time = (pb-pa) * world.tick_lag
	to_chat(src, "Total time (total_moles): [total_time]ms")
	to_chat(src, "Operations per second: [100000 / (total_time/1000)]")
	pa = world.tick_usage
	for(var/I in 1 to 100000)
		new /datum/gas_mixture
	pb = world.tick_usage
	total_time = (pb-pa) * world.tick_lag
	to_chat(src, "Total time (new gas mixture): [total_time]ms")
	to_chat(src, "Operations per second: [100000 / (total_time/1000)]")
*/

/// Releases gas from src to output air. This means that it can not transfer air to gas mixture with higher pressure.
/// a global proc due to rustmos
/proc/release_gas_to(datum/gas_mixture/input_air, datum/gas_mixture/output_air, target_pressure)
	var/output_starting_pressure = output_air.return_pressure()
	var/input_starting_pressure = input_air.return_pressure()

	if(output_starting_pressure >= min(target_pressure,input_starting_pressure-10))
		//No need to pump gas if target is already reached or input pressure is too low
		//Need at least 10 KPa difference to overcome friction in the mechanism
		return FALSE

	//Calculate necessary moles to transfer using PV = nRT
	if((input_air.total_moles() > 0) && (input_air.return_temperature()>0))
		var/pressure_delta = min(target_pressure - output_starting_pressure, (input_starting_pressure - output_starting_pressure)/2)
		//Can not have a pressure delta that would cause output_pressure > input_pressure

		var/transfer_moles = pressure_delta*output_air.return_volume()/(input_air.return_temperature() * R_IDEAL_GAS_EQUATION)

		//Actually transfer the gas
		input_air.transfer_to(output_air, transfer_moles)

		return TRUE
	return FALSE
