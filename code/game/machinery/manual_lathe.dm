/obj/machinery/autolathe/manual
	name = "manual lathe"
	use_power = NO_POWER_USE
	idle_power_usage = 0
	active_power_usage = 0
	interaction_flags_machine = INTERACT_MACHINE_OFFLINE

/obj/machinery/autolathe/manual/use_power(amount, chan = -1)
	return

/obj/machinery/autolathe/manual/begin_item_creation(power, list/materials_used, list/picked_materials, multiplier, coeff, is_stack, mob/user, time)
	if(do_after(user, time SECONDS/2, target = src))
		return make_item(power, materials_used, picked_materials, multiplier, coeff, is_stack)
