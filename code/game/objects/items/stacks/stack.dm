/* Stack type objects!
 * Contains:
 * 		Stacks
 * 		Recipe datum
 * 		Recipe list datum
 */

/*
 * Stacks
 */
/obj/item/stack
	icon = 'icons/obj/stack_objects.dmi'
	gender = PLURAL
	material_modifier = 0.01
	var/list/datum/stack_recipe/recipes
	var/singular_name
	var/amount = 1
	var/max_amount = 50 //also see stack recipes initialisation, param "max_res_amount" must be equal to this max_amount
	var/is_cyborg = 0 // It's 1 if module is used by a cyborg, and uses its storage
	var/datum/robot_energy_storage/source
	var/cost = 1 // How much energy from storage it costs
	var/merge_type = null // This path and its children should merge with this stack, defaults to src.type
	var/full_w_class = WEIGHT_CLASS_NORMAL //The weight class the stack should have at amount > 2/3rds max_amount
	var/novariants = TRUE //Determines whether the item should update it's sprites based on amount.
	var/list/mats_per_unit //list that tells you how much is in a single unit.
	///Datum material type that this stack is made of
	var/material_type
	max_integrity = 100
	var/latin = 0 // Use weird latin pluralization.
	//NOTE: When adding grind_results, the amounts should be for an INDIVIDUAL ITEM - these amounts will be multiplied by the stack size in on_grind()
	var/obj/structure/table/tableVariant // we tables now (stores table variant to be built from this stack)

		// The following are all for medical treatment, they're here instead of /stack/medical because sticky tape can be used as a makeshift bandage or splint
	/// If set and this used as a splint for a broken bone wound, this is used as a multiplier for applicable slowdowns (lower = better) (also for speeding up burn recoveries)
	var/splint_factor
	/// How much blood flow this stack can absorb if used as a bandage on a cut wound, note that absorption is how much we lower the flow rate, not the raw amount of blood we suck up
	var/absorption_capacity
	/// How quickly we lower the blood flow on a cut wound we're bandaging. Expected lifetime of this bandage in ticks is thus absorption_capacity/absorption_rate, or until the cut heals, whichever comes first
	var/absorption_rate

/obj/item/stack/on_grind()
	for(var/i in 1 to grind_results.len) //This should only call if it's ground, so no need to check if grind_results exists
		grind_results[grind_results[i]] *= get_amount() //Gets the key at position i, then the reagent amount of that key, then multiplies it by stack size

/obj/item/stack/grind_requirements()
	if(is_cyborg)
		to_chat(usr, span_danger("[src] is electronically synthesized in your chassis and can't be ground up!"))
		return
	return TRUE

/obj/item/stack/Initialize(mapload, new_amount, merge = TRUE)
	if(new_amount != null)
		amount = new_amount
	while(amount > max_amount)
		amount -= max_amount
		new type(loc, max_amount, FALSE)
	if(!merge_type)
		merge_type = type
	if(custom_materials && custom_materials.len)
		mats_per_unit = list()
		var/in_process_mat_list = custom_materials.Copy()
		for(var/i in custom_materials)
			mats_per_unit[SSmaterials.GetMaterialRef(i)] = in_process_mat_list[i]
			custom_materials[i] *= amount
	. = ..()
	var/static/list/loc_connections = list(
		COMSIG_ATOM_ENTERED = PROC_REF(on_movable_entered_occupied_turf),
	)
	AddElement(/datum/element/connect_loc, loc_connections)

	if(merge)
		for(var/obj/item/stack/item_stack in loc)
			if(item_stack == src)
				continue
			if(can_merge(item_stack))
				INVOKE_ASYNC(src, PROC_REF(merge_without_del), item_stack)
				if(zero_amount())
					return INITIALIZE_HINT_QDEL
	var/list/temp_recipes = get_main_recipes()
	recipes = temp_recipes.Copy()
	if(material_type)
		var/datum/material/M = SSmaterials.GetMaterialRef(material_type) //First/main material
		for(var/i in M.categories)
			switch(i)
				if(MAT_CATEGORY_BASE_RECIPES)
					var/list/temp = SSmaterials.rigid_stack_recipes.Copy()
					recipes += temp
	update_weight()
	update_icon()

/obj/item/stack/proc/get_main_recipes()
	return list()//empty list

/obj/item/stack/proc/update_weight()
	if(amount <= (max_amount * (1/3)))
		w_class = clamp(full_w_class-2, WEIGHT_CLASS_TINY, full_w_class)
	else if (amount <= (max_amount * (2/3)))
		w_class = clamp(full_w_class-1, WEIGHT_CLASS_TINY, full_w_class)
	else
		w_class = full_w_class

/obj/item/stack/update_icon_state()
	if(novariants)
		return
	if(amount <= (max_amount * (1/3)))
		icon_state = initial(icon_state)
	else if (amount <= (max_amount * (2/3)))
		icon_state = "[initial(icon_state)]_2"
	else
		icon_state = "[initial(icon_state)]_3"


/obj/item/stack/Destroy()
	if (usr && usr.machine==src)
		usr << browse(null, "window=stack")
	. = ..()

/obj/item/stack/examine(mob/user)
	. = ..()
	if (is_cyborg)
		if(singular_name)
			. += "There is enough energy for [get_amount()] [singular_name]\s."
		else
			. += "There is enough energy for [get_amount()]."
		return
	if(singular_name)
		if (latin)
			if(get_amount()>1)
				to_chat(user, "There are [get_amount()] [singular_name]i in the stack.")
			else
				to_chat(user, "There is [get_amount()] [singular_name]us in the stack.")
		else
			if(get_amount()>1)
				to_chat(user, "There are [get_amount()] [singular_name]\s in the stack.")
			else
				to_chat(user, "There is [get_amount()] [singular_name] in the stack.")
		if(get_amount()>1)
			. += "There are [get_amount()] [singular_name]\s in the stack."
		else
			. += "There is [get_amount()] [singular_name] in the stack."
	else if(get_amount()>1)
		. += "There are [get_amount()] in the stack."
	else
		. += "There is [get_amount()] in the stack."
	. += span_notice("Alt-click to take a custom amount.")

/obj/item/stack/proc/get_amount()
	if(is_cyborg)
		. = round(source.energy / cost)
	else
		. = (amount)

/obj/item/stack/attack_self(mob/user)
	interact(user)

/obj/item/stack/interact(mob/user, sublist)
	ui_interact(user, sublist)

/obj/item/stack/ui_interact(mob/user, recipes_sublist)
	. = ..()
	if (!recipes)
		return
	if (!src || get_amount() <= 0)
		user << browse(null, "window=stack")
	user.set_machine(src) //for correct work of onclose
	var/list/recipe_list = recipes
	if (recipes_sublist && recipe_list[recipes_sublist] && istype(recipe_list[recipes_sublist], /datum/stack_recipe_list))
		var/datum/stack_recipe_list/srl = recipe_list[recipes_sublist]
		recipe_list = srl.recipes
	var/t1 = "Amount Left: [get_amount()]<br>"
	for(var/i in 1 to length(recipe_list))
		var/E = recipe_list[i]
		if (isnull(E))
			t1 += "<hr>"
			continue
		if (i>1 && !isnull(recipe_list[i-1]))
			t1+="<br>"

		if (istype(E, /datum/stack_recipe_list))
			var/datum/stack_recipe_list/srl = E
			t1 += "<a href='byond://?src=[REF(src)];sublist=[i]'>[srl.title]</a>"

		if (istype(E, /datum/stack_recipe))
			var/datum/stack_recipe/R = E
			var/max_multiplier = round(get_amount() / R.req_amount)
			var/title
			var/can_build = 1
			can_build = (can_build && (max_multiplier>0) && user.skill_check(SKILL_REPAIR, R.skill_threshold))

			if (R.res_amount>1)
				title+= "[R.res_amount]x [R.title]\s"
			else
				title+= "[R.title]"
			title+= " ([R.req_amount] [singular_name]\s)"
			if (can_build)
				t1 += text("<A href='byond://?src=[REF(src)];sublist=[recipes_sublist];make=[i];multiplier=1'>[title]</A>  ")
			else if (user.skill_check(SKILL_REPAIR, R.skill_threshold))
				t1 += text("[]", title)
				continue
			else
				//Don't show anything if we don't have the skill to make it, you don't know what you don't know!
				continue
			if (R.max_res_amount>1 && max_multiplier>1 && can_build)
				max_multiplier = min(max_multiplier, round(R.max_res_amount/R.res_amount))
				t1 += " |"
				var/list/multipliers = list(5,10,25)
				for (var/n in multipliers)
					if (max_multiplier>=n)
						t1 += " <A href='byond://?src=[REF(src)];make=[i];multiplier=[n]'>[n*R.res_amount]x</A>"
				if (!(max_multiplier in multipliers))
					t1 += " <A href='byond://?src=[REF(src)];make=[i];multiplier=[max_multiplier]'>[max_multiplier*R.res_amount]x</A>"

	var/datum/browser/popup = new(user, "stack", name, 400, 400)
	popup.set_content(t1)
	popup.open(0)
	onclose(user, "stack")

/obj/item/stack/Topic(href, href_list)
	..()
	if (usr.restrained() || usr.stat || usr.get_active_held_item() != src)
		return
	if (href_list["sublist"] && !href_list["make"])
		interact(usr, text2num(href_list["sublist"]))
	if (href_list["make"])
		if (get_amount() < 1 && !is_cyborg)
			qdel(src)

		var/list/recipes_list = recipes
		if (href_list["sublist"])
			var/datum/stack_recipe_list/srl = recipes_list[text2num(href_list["sublist"])]
			recipes_list = srl.recipes
		var/datum/stack_recipe/R = recipes_list[text2num(href_list["make"])]
		var/multiplier = round(text2num(href_list["multiplier"]))
		if(!multiplier || multiplier < 1 || !IS_FINITE(multiplier)) //href exploit protection
			stack_trace("Invalid multiplier value in stack creation [multiplier], [usr] is likely attempting an exploit")
			return
		if(!building_checks(R, multiplier) || !usr.skill_check(SKILL_REPAIR, R.skill_threshold))
			return
		if (R.time)
			var/adjusted_time = 0
			usr.visible_message(span_notice("[usr] starts building [R.title]."), span_notice("You start building [R.title]..."))
			if(HAS_TRAIT(usr, R.trait_booster))
				adjusted_time = (R.time * R.trait_modifier)
			else
				adjusted_time = R.time
			if (!do_after(usr, adjusted_time, target = usr))
				return
			if(!building_checks(R, multiplier))
				return

		var/obj/O
		if(R.max_res_amount > 1) //Is it a stack?
			O = new R.result_type(usr.drop_location(), R.res_amount * multiplier)
		else if(ispath(R.result_type, /turf))
			var/turf/T = usr.drop_location()
			if(!isturf(T))
				return
			T.PlaceOnTop(R.result_type, flags = CHANGETURF_INHERIT_AIR)
		else
			O = new R.result_type(get_turf(usr))
		if(O)
			O.setDir(usr.dir)
			log_craft("[O] crafted by [usr] at [loc_name(O.loc)]")

		use(R.req_amount * multiplier)

		if(R.applies_mats && custom_materials && custom_materials.len)
			var/list/used_materials = list()
			for(var/i in custom_materials)
				used_materials[SSmaterials.GetMaterialRef(i)] = R.req_amount / R.res_amount * (MINERAL_MATERIAL_AMOUNT / custom_materials.len)
			O.set_custom_materials(used_materials)

		//START: oh fuck i'm so sorry
		if(istype(O, /obj/structure/windoor_assembly))
			var/obj/structure/windoor_assembly/W = O
			W.ini_dir = W.dir
		else if(istype(O, /obj/structure/window))
			var/obj/structure/window/W = O
			W.ini_dir = W.dir
		//END: oh fuck i'm so sorry

		else if(istype(O, /obj/item/restraints/handcuffs/cable))
			var/obj/item/cuffs = O
			cuffs.color = color

		if (QDELETED(O))
			return //It's a stack and has already been merged

		if (isitem(O))
			usr.put_in_hands(O)
		O.add_fingerprint(usr)

		//BubbleWrap - so newly formed boxes are empty
		if ( istype(O, /obj/item/storage) )
			for (var/obj/item/I in O)
				qdel(I)
		//BubbleWrap END

/obj/item/stack/proc/building_checks(datum/stack_recipe/R, multiplier)
	if (get_amount() < R.req_amount*multiplier)
		if (R.req_amount*multiplier>1)
			to_chat(usr, span_warning("You haven't got enough [src] to build \the [R.req_amount*multiplier] [R.title]\s!"))
		else
			to_chat(usr, span_warning("You haven't got enough [src] to build \the [R.title]!"))
		return FALSE
	var/turf/T = get_turf(usr)

	var/obj/D = R.result_type
	if(R.window_checks && !valid_window_location(T, initial(D.dir) == FULLTILE_WINDOW_DIR ? FULLTILE_WINDOW_DIR : usr.dir))
		to_chat(usr, span_warning("The [R.title] won't fit here!"))
		return FALSE
	if(R.one_per_turf && (locate(R.result_type) in T))
		to_chat(usr, span_warning("There is another [R.title] here!"))
		return FALSE
	if(R.on_floor)
		if(!isfloorturf(T) && !isgroundturf(T))
			to_chat(usr, span_warning("\The [R.title] must be constructed on the floor!"))
			return FALSE
		for(var/obj/AM in T)
			if(istype(AM,/obj/structure/grille))
				continue
			if(istype(AM,/obj/structure/table))
				continue
			if(istype(AM,/obj/structure/window))
				var/obj/structure/window/W = AM
				if(!W.fulltile)
					continue
			if(AM.density)
				to_chat(usr, span_warning("Theres a [AM.name] here. You cant make a [R.title] here!"))
				return FALSE
	if(R.placement_checks)
		switch(R.placement_checks)
			if(STACK_CHECK_CARDINALS)
				var/turf/step
				for(var/direction in GLOB.cardinals)
					step = get_step(T, direction)
					if(locate(R.result_type) in step)
						to_chat(usr, span_warning("\The [R.title] must not be built directly adjacent to another!"))
						return FALSE
			if(STACK_CHECK_ADJACENT)
				if(locate(R.result_type) in range(1, T))
					to_chat(usr, span_warning("\The [R.title] must be constructed at least one tile away from others of its type!"))
					return FALSE
	return TRUE

/obj/item/stack/use(used, transfer = FALSE, check = TRUE) // return 0 = borked; return 1 = had enough
	if(check && zero_amount())
		return FALSE
	if (is_cyborg)
		return source.use_charge(used * cost)
	if (amount < used)
		return FALSE
	amount -= used
	if(check && zero_amount())
		return TRUE
	if(length(mats_per_unit))
		var/temp_materials = custom_materials.Copy()
		for(var/i in mats_per_unit)
			temp_materials[i] = mats_per_unit[i] * src.amount
		set_custom_materials(temp_materials)
	update_icon()
	update_weight()
	return TRUE

/obj/item/stack/tool_use_check(mob/living/user, amount)
	if(get_amount() < amount)
		if(singular_name)
			if(amount > 1)
				to_chat(user, span_warning("You need at least [amount] [singular_name]\s to do this!"))
			else
				to_chat(user, span_warning("You need at least [amount] [singular_name] to do this!"))
		else
			to_chat(user, span_warning("You need at least [amount] to do this!"))

		return FALSE

	return TRUE

/obj/item/stack/proc/zero_amount()
	if(is_cyborg)
		return source.energy < cost
	if(amount < 1)
		qdel(src)
		return 1
	return 0

/obj/item/stack/proc/add(amount)
	if (is_cyborg)
		source.add_charge(amount * cost)
	else
		src.amount += amount
	if(length(mats_per_unit))
		var/temp_materials = custom_materials.Copy()
		for(var/i in mats_per_unit)
			temp_materials[i] = mats_per_unit[i] * src.amount
		set_custom_materials(temp_materials)
	update_icon()
	update_weight()

/** Checks whether this stack can merge itself into another stack.
 *
 * Arguments:
 * - [check][/obj/item/stack]: The stack to check for mergeability.
 * - [inhand][boolean]: Whether or not the stack to check should act like it's in a mob's hand.
 */
/obj/item/stack/proc/can_merge(obj/item/stack/check, inhand = FALSE)
	if(!istype(check))
		return FALSE
	if(check.merge_type != merge_type)
		return FALSE
	if(mats_per_unit ~! check.mats_per_unit) // ~! in case of lists this operator checks only keys, but not values
		return FALSE
	if(is_cyborg) // No merging cyborg stacks into other stacks
		return FALSE
	if(ismob(loc) && !inhand) // no merging with items that are on the mob
		return FALSE
	return TRUE

/**
 * Merges as much of src into target_stack as possible. If present, the limit arg overrides target_stack.max_amount for transfer.
 *
 * This calls use() without check = FALSE, preventing the item from qdeling itself if it reaches 0 stack size.
 *
 * As a result, this proc can leave behind a 0 amount stack.
 */
/obj/item/stack/proc/merge_without_del(obj/item/stack/target_stack, limit)
	// Cover edge cases where multiple stacks are being merged together and haven't been deleted properly.
	// Also cover edge case where a stack is being merged into itself, which is supposedly possible.
	if(QDELETED(target_stack))
		CRASH("Stack merge attempted on qdeleted target stack.")
	if(QDELETED(src))
		CRASH("Stack merge attempted on qdeleted source stack.")
	if(target_stack == src)
		CRASH("Stack attempted to merge into itself.")

	var/transfer = get_amount()
	if(target_stack.is_cyborg)
		transfer = min(transfer, round((target_stack.source.max_energy - target_stack.source.energy) / target_stack.cost))
	else
		transfer = min(transfer, (limit ? limit : target_stack.max_amount) - target_stack.amount)
	if(pulledby)
		INVOKE_ASYNC(pulledby, TYPE_PROC_REF(/atom/movable/, start_pulling), target_stack)
	target_stack.copy_evidences(src)
	use(transfer, transfer = TRUE, check = FALSE)
	target_stack.add(transfer)
	if(target_stack.mats_per_unit != mats_per_unit) // We get the average value of mats_per_unit between two stacks getting merged
		var/list/temp_mats_list = list() // mats_per_unit is passed by ref into this coil, and that same ref is used in other places. If we didn't make a new list here we'd end up contaminating those other places, which leads to batshit behavior
		for(var/mat_type in target_stack.mats_per_unit)
			temp_mats_list[mat_type] = (target_stack.mats_per_unit[mat_type] * (target_stack.amount - transfer) + mats_per_unit[mat_type] * transfer) / target_stack.amount
		target_stack.mats_per_unit = temp_mats_list
	return transfer

/obj/item/stack/proc/merge(obj/item/stack/target_stack, limit)
	. = merge_without_del(target_stack, limit)
	zero_amount()

/// Signal handler for connect_loc element. Called when a movable enters the turf we're currently occupying. Merges if possible.
/obj/item/stack/proc/on_movable_entered_occupied_turf(datum/source, atom/movable/arrived)
	SIGNAL_HANDLER

	// Edge case. This signal will also be sent when src has entered the turf. Don't want to merge with ourselves.
	if(arrived == src)
		return

	if(!arrived.throwing && can_merge(arrived))
		INVOKE_ASYNC(src, PROC_REF(merge), arrived)

/obj/item/stack/hitby(atom/movable/AM, skipcatch, hitpush, blocked, datum/thrownthing/throwingdatum)
	if(can_merge(AM, TRUE))
		merge(AM)
	. = ..()

/obj/item/stack/on_attack_hand(mob/user, act_intent = user.a_intent, unarmed_attack_flags)
	if(user.get_inactive_held_item() == src)
		if(zero_amount())
			return
		return change_stack(user,1)
	else
		. = ..()

/obj/item/stack/AltClick(mob/living/user)
	. = ..()
	if(!istype(user) || !user.canUseTopic(src, BE_CLOSE, ismonkey(user)))
		return
	if(is_cyborg)
		return
	else
		if(zero_amount())
			return
		//get amount from user
		var/max = get_amount()
		var/stackmaterial = round(input(user,"How many sheets do you wish to take out of this stack? (Maximum  [max])") as null|num)
		max = get_amount()
		stackmaterial = min(max, stackmaterial)
		if(stackmaterial == null || stackmaterial <= 0 || !user.canUseTopic(src, BE_CLOSE, ismonkey(user)))
			return TRUE
		else
			change_stack(user, stackmaterial)
			to_chat(user, span_notice("You take [stackmaterial] sheets out of the stack"))
		return TRUE

/obj/item/stack/proc/change_stack(mob/user, amount)
	if(!use(amount, TRUE, FALSE))
		return FALSE
	var/obj/item/stack/F = new type(user? user : drop_location(), amount, FALSE)
	. = F
	F.copy_evidences(src)
	if(user)
		if(!user.put_in_hands(F, merge_stacks = FALSE))
			F.forceMove(user.drop_location())
		add_fingerprint(user)
		F.add_fingerprint(user)
	zero_amount()

/obj/item/stack/attackby(obj/item/W, mob/user, params)
	if(can_merge(W, TRUE))
		var/obj/item/stack/S = W
		if(merge(S))
			to_chat(user, span_notice("Your [S.name] stack now contains [S.get_amount()] [S.singular_name]\s."))
	else
		. = ..()

/obj/item/stack/proc/copy_evidences(obj/item/stack/from)
	if(from.blood_DNA)
		blood_DNA = from.blood_DNA.Copy()
	if(from.fingerprints)
		fingerprints = from.fingerprints.Copy()
	if(from.fingerprintshidden)
		fingerprintshidden = from.fingerprintshidden.Copy()
	if(from.fingerprintslast)
		fingerprintslast = from.fingerprintslast

/obj/item/stack/microwave_act(obj/machinery/microwave/M)
	if(istype(M) && M.dirty < 100)
		M.dirty += amount

/*
 * Recipe datum
 */
/datum/stack_recipe
	var/title = "ERROR"
	var/result_type
	var/req_amount = 1
	var/res_amount = 1
	var/max_res_amount = 1
	var/time = 0
	var/one_per_turf = FALSE
	var/on_floor = FALSE
	var/window_checks = FALSE
	var/placement_checks = FALSE
	var/applies_mats = FALSE
	var/trait_booster = null
	var/trait_modifier = 1
	var/skill_threshold = VERY_EASY_CHECK

/datum/stack_recipe/New(title, result_type, req_amount = 1, res_amount = 1, max_res_amount = 1,time = 0, one_per_turf = FALSE, on_floor = FALSE, window_checks = FALSE, placement_checks = FALSE, applies_mats = FALSE, trait_booster = null, trait_modifier = 1, skill_threshold = VERY_EASY_CHECK)


	src.title = title
	src.result_type = result_type
	src.req_amount = req_amount
	src.res_amount = res_amount
	src.max_res_amount = max_res_amount
	src.time = time
	src.one_per_turf = one_per_turf
	src.on_floor = on_floor
	src.window_checks = window_checks
	src.placement_checks = placement_checks
	src.applies_mats = applies_mats
	src.trait_booster = trait_booster
	src.trait_modifier = trait_modifier
	src.skill_threshold = skill_threshold
/*
 * Recipe list datum
 */
/datum/stack_recipe_list
	var/title = "ERROR"
	var/list/recipes

/datum/stack_recipe_list/New(title, recipes)
	src.title = title
	src.recipes = recipes
