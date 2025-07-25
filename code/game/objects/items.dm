GLOBAL_DATUM_INIT(fire_overlay, /mutable_appearance, mutable_appearance('icons/effects/fire.dmi', "fire"))
GLOBAL_DATUM_INIT(welding_sparks, /mutable_appearance, mutable_appearance('icons/effects/welding_effect.dmi', "welding_sparks", GASFIRE_LAYER, ABOVE_LIGHTING_PLANE))

GLOBAL_VAR_INIT(rpg_loot_items, FALSE)
// if true, everyone item when created will have its name changed to be
// more... RPG-like.

GLOBAL_VAR_INIT(stickpocalypse, FALSE) // if true, all non-embeddable items will be able to harmlessly stick to people when thrown
GLOBAL_VAR_INIT(embedpocalypse, FALSE) // if true, all items will be able to embed in people, takes precedence over stickpocalypse

/obj/item
	name = "item"
	icon = 'icons/obj/items_and_weapons.dmi'
	blocks_emissive = EMISSIVE_BLOCK_GENERIC

	plane = OBJITEM_PLANE

	attack_hand_speed = 0
	attack_hand_is_action = FALSE
	attack_hand_unwieldlyness = 0

	///icon state name for inhand overlays
	var/item_state = null
	///Icon file for left hand inhand overlays
	var/lefthand_file = 'icons/mob/inhands/items_lefthand.dmi'
	///Icon file for right inhand overlays
	var/righthand_file = 'icons/mob/inhands/items_righthand.dmi'

	///Icon file for mob worn overlays.
	///no var for state because it should *always* be the same as icon_state
	var/icon/mob_overlay_icon
	//Forced mob worn layer instead of the standard preferred size.
	var/alternate_worn_layer

	var/icon/anthro_mob_worn_overlay //Version of the above dedicated to muzzles/digitigrade
	var/icon/taur_mob_worn_overlay // Idem but for taurs. Currently only used by suits.

	var/list/alternate_screams = list() //REEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEE

	//Dimensions of the icon file used when this item is worn, eg: hats.dmi
	//eg: 32x32 sprite, 64x64 sprite, etc.
	//allows inhands/worn sprites to be of any size, but still centered on a mob properly
	var/worn_x_dimension = 32
	var/worn_y_dimension = 32
	//Same as above but for inhands, uses the lefthand_ and righthand_ file vars
	var/inhand_x_dimension = 32
	var/inhand_y_dimension = 32

	max_integrity = 200

	obj_flags = NONE
	var/item_flags = NONE

	var/item_color = null //this needs deprecating, soonish

	var/hitsound = null
	/// Sound it makes when it does 0 damage to a target
	var/pokesound = 'sound/weapons/tap.ogg'
	var/usesound = null
	var/throwhitsound = null

	/// Weight class for how much storage capacity it uses and how big it physically is meaning storages can't hold it if their maximum weight class isn't as high as it.
	var/w_class = WEIGHT_CLASS_NORMAL

	/// Volume override for the item, otherwise automatically calculated from w_class.
	var/w_volume

	/// The amount of stamina it takes to swing an item in a normal melee attack do not lie to me and say it's for realism because it ain't. If null it will autocalculate from w_class.
	var/total_mass //Total mass in arbitrary pound-like values. If there's no balance reasons for an item to have otherwise, this var should be the item's weight in pounds.

	/// How long, in deciseconds, this staggers for, if null it will autocalculate from w_class and force. Unlike total mass this supports 0 and negatives.
	var/stagger_force

	var/slot_flags = 0		//This is used to determine on which slots an item can fit.
	var/current_equipped_slot
	pass_flags = PASSTABLE
	pressure_resistance = 4
	var/obj/item/master = null

	var/heat_protection = 0 //flags which determine which body parts are protected from heat. Use the HEAD, CHEST, GROIN, etc. flags. See setup.dm
	var/cold_protection = 0 //flags which determine which body parts are protected from cold. Use the HEAD, CHEST, GROIN, etc. flags. See setup.dm
	var/max_heat_protection_temperature //Set this variable to determine up to which temperature (IN KELVIN) the item protects against heat damage. Keep at null to disable protection. Only protects areas set by heat_protection flags
	var/min_cold_protection_temperature //Set this variable to determine down to which temperature (IN KELVIN) the item protects against cold damage. 0 is NOT an acceptable number due to if(varname) tests!! Keep at null to disable protection. Only protects areas set by cold_protection flags

	var/list/actions //list of /datum/action's that this item has.
	var/list/actions_types //list of paths of action datums to give to the item on New().

	//Since any item can now be a piece of clothing, this has to be put here so all items share it.
	var/flags_inv //This flag is used to determine when items in someone's inventory cover others. IE helmets making it so you can't see glasses, etc.

	var/interaction_flags_item = INTERACT_ITEM_ATTACK_HAND_PICKUP
	//Citadel Edit for digitigrade stuff
	var/mutantrace_variation = NONE //Are there special sprites for specific situations? Don't use this unless you need to.

	var/body_parts_covered = 0 //see setup.dm for appropriate bit flags
	/// The bodyparts *hidden* by the item, in case they should be different from what's covered. For things like open jackets and skimpy raider gear that should be a little bit revealing while still protective. Defaults to body_part_covered if not set
	var/body_parts_hidden
	var/gas_transfer_coefficient = 1 // for leaking gas from turf to mask and vice-versa (for masks right now, but at some point, i'd like to include space helmets)
	var/permeability_coefficient = 1 // for chemicals/diseases
	var/siemens_coefficient = 1 // for electrical admittance/conductance (electrocution checks and shit)
	var/slowdown = 0 // How much clothing is slowing you down. Negative values speeds you up
	var/armour_penetration = 0 //SET BETWEEN 0 and 1, E.G. 0.5 = 50% AP. Now a percentage reduction in armor's increased effective health. DR2 CHANGE
	var/damage_threshold_penetration = 0 // How much DT this thing ignores. Negative values increase the target's effective DT. Cant reduce DT below zero
	var/list/allowed = list() //suit storage stuff.
	var/equip_delay_self = 0 //In deciseconds, how long an item takes to equip; counts only for normal clothing slots, not pockets etc.
	var/equip_delay_other = 20 //In deciseconds, how long an item takes to put on another person
	var/strip_delay = 40 //In deciseconds, how long an item takes to remove from another person
	var/breakouttime = 0
	var/reskinned = FALSE

	var/list/attack_verb //Used in attackby() to say how something was attacked "[x] has been [z.attack_verb] by [y] with [z]"
	var/list/species_exception = null	// list() of species types, if a species cannot put items in a certain slot, but species type is in list, it will be able to wear that item

	var/mob/thrownby = null

	mouse_drag_pointer = MOUSE_ACTIVE_POINTER //the icon to indicate this object is being dragged

	var/list/embedding

	var/flags_cover = 0 //for flags such as GLASSESCOVERSEYES
	var/heat = 0
	///All items with sharpness of SHARP_EDGED or higher will automatically get the butchering component.
	var/sharpness = SHARP_NONE

	var/tool_behaviour = NONE
	var/toolspeed = 1

	/// In tiles, how far this weapon can reach.
	var/max_reach = 1
	/// Minimum distance needed in tiles for the target be reachable by this weapon.
	var/min_reach = 0

	//The list of slots by priority. equip_to_appropriate_slot() uses this list. Doesn't matter if a mob type doesn't have a slot.
	var/list/slot_equipment_priority = null // for default list, see /mob/proc/equip_to_appropriate_slot()

	// Needs to be in /obj/item because corgis can wear a lot of
	// non-clothing items
	var/datum/dog_fashion/dog_fashion = null

	//Tooltip vars
	var/force_string //string form of an item's force. Edit this var only to set a custom force string
	var/last_force_string_check = 0
	var/tip_timer

	var/trigger_guard = TRIGGER_GUARD_NONE

	///Used as the dye color source in the washing machine only (at the moment). Can be a hex color or a key corresponding to a registry entry, see washing_machine.dm
	var/dye_color
	///Whether the item is unaffected by standard dying.
	var/undyeable = FALSE
	///What dye registry should be looked at when dying this item; see washing_machine.dm
	var/dying_key

	//Grinder vars
	var/list/grind_results //A reagent list containing the reagents this item produces when ground up in a grinder - this can be an empty list to allow for reagent transferring only
	var/list/juice_results //A reagent list containing blah blah... but when JUICED in a grinder!


/* Our block parry data. Should be set in init, or something if you are using it.
 * This won't be accessed without ITEM_CAN_BLOCK or ITEM_CAN_PARRY so do not set it unless you have to to save memory.
 * If you decide it's a good idea to leave this unset while turning the flags on, you will runtime. Enjoy.
 * If this is set to a path, it'll run get_block_parry_data(path). YOU MUST RUN [get_block_parry_data(this)] INSTEAD OF DIRECTLY ACCESSING!
 */
	var/datum/block_parry_data/block_parry_data

	///Skills vars
	//list of skill PATHS exercised when using this item. An associated bitfield can be set to indicate additional ways the skill is used by this specific item.
	var/list/datum/skill/used_skills
	var/skill_difficulty = THRESHOLD_UNTRAINED //how difficult it's to use this item in general.
	var/skill_gain = DEF_SKILL_GAIN //base skill value gain from using this item.

	//fallout skill stuff
	var/needs_skill_to_operate = FALSE
	var/skill_used_for_operation = null

	var/canMouseDown = FALSE

	var/stiffness = 0 // How much recoil is caused by moving
	var/obscuration = 0 // How much firearm accuracy is decreased

	// HUD action buttons. Only used by guns atm.
	var/list/hud_actions

	var/list/item_upgrades = list()
	var/max_upgrades = 3

	/// extra special transform
	var/matrix/special_transform

	var/will_hit = FALSE

/obj/item/Initialize()

	if(attack_verb)
		attack_verb = typelist("attack_verb", attack_verb)

	. = ..()
	for(var/path in actions_types)
		new path(src)
	actions_types = null

	if(force_string)
		item_flags |= FORCE_STRING_OVERRIDE

	if(!hitsound)
		if(damtype == "fire")
			hitsound = 'sound/items/welder.ogg'
		if(damtype == "brute")
			hitsound = "swing_hit"

	if(used_skills)
		for(var/path in used_skills)
			var/datum/skill/S = GLOB.skill_datums[path]
			LAZYADD(used_skills[path], S.skill_traits)

	if(w_class <= WEIGHT_CLASS_NORMAL) //pulling small items doesn't slow you down much
		drag_delay = 0.05 SECONDS

	if(isnull(body_parts_hidden))
		body_parts_hidden = body_parts_covered

	/// Allows items to preserve their transform when picked up
	if(!special_transform && transform != initial(transform))
		special_transform = transform

/obj/item/Destroy()
	item_flags &= ~DROPDEL	//prevent reqdels
	if(ismob(loc))
		var/mob/m = loc
		m.temporarilyRemoveItemFromInventory(src, TRUE)
	for(var/X in actions)
		qdel(X)
	return ..()

/obj/item/ComponentInitialize()
	. = ..()

	// this proc says it's for initializing components, but we're initializing elements too because it's you and me against the world >:)
	if(!LAZYLEN(embedding))
		if(GLOB.embedpocalypse)
			embedding = EMBED_POINTY
			name = "pointy [name]"
		else if(GLOB.stickpocalypse)
			embedding = EMBED_HARMLESS
			name = "sticky [name]"

	updateEmbedding()

	if(GLOB.rpg_loot_items)
		AddComponent(/datum/component/fantasy)

	if(sharpness && force > 5) //give sharp objects butchering functionality, for consistency
		AddComponent(/datum/component/butchering, 80 * toolspeed)

/obj/item/proc/check_allowed_items(atom/target, not_inside, target_self)
	if(((src in target) && !target_self) || (!isturf(target.loc) && !isturf(target) && not_inside))
		return 0
	else
		return 1

/obj/item/blob_act(obj/structure/blob/B)
	if(B && B.loc == loc)
		qdel(src)

//user: The mob that is suiciding
//damagetype: The type of damage the item will inflict on the user
//BRUTELOSS = 1
//FIRELOSS = 2
//TOXLOSS = 4
//OXYLOSS = 8
//Output a creative message and then return the damagetype done
/obj/item/proc/suicide_act(mob/user)
	return

/obj/item/verb/move_to_top()
	set name = "Move To Top"
	set category = "Object"
	set src in oview(1)

	var/mob/living/L = usr
	if(!istype(L) || !isturf(loc) || !CHECK_MOBILITY(L, MOBILITY_USE))
		return

	var/turf/T = loc
	loc = null
	loc = T

/obj/item/examine(mob/user) //This might be spammy. Remove?
	. = ..()

	. += "[gender == PLURAL ? "They are" : "It is"] a [weightclass2text(w_class)] item."

	if(resistance_flags & INDESTRUCTIBLE)
		. += "[src] seems extremely robust! It'll probably withstand anything that could happen to it!"
	else
		if(resistance_flags & LAVA_PROOF)
			. += "[src] is made of an extremely heat-resistant material, it'd probably be able to withstand lava!"
		if(resistance_flags & (ACID_PROOF | UNACIDABLE))
			. += "[src] looks pretty robust! It'd probably be able to withstand acid!"
		if(resistance_flags & FREEZE_PROOF)
			. += "[src] is made of cold-resistant materials."
		if(resistance_flags & FIRE_PROOF)
			. += "[src] is made of fire-retardant materials."

	if(item_flags & (ITEM_CAN_BLOCK | ITEM_CAN_PARRY))
		var/datum/block_parry_data/data = return_block_parry_datum(block_parry_data)
		. += "[src] has the capacity to be used to block and/or parry. <a href='byond://?src=[REF(data)];name=[name];block=[item_flags & ITEM_CAN_BLOCK];parry=[item_flags & ITEM_CAN_PARRY];render=1'>\[Show Stats\]</a>"

	if(!user.research_scanner)
		return

	// Research prospects, including boostable nodes and point values.
	// Deliver to a console to know whether the boosts have already been used.
	var/list/research_msg = list("<font color='purple'>Research prospects:</font> ")
	var/sep = ""
	var/list/boostable_nodes = techweb_item_boost_check(src)
	if (boostable_nodes)
		for(var/id in boostable_nodes)
			var/datum/techweb_node/node = SSresearch.techweb_node_by_id(id)
			if(!node)
				continue
			research_msg += sep
			research_msg += node.display_name
			sep = ", "
	var/list/points = techweb_item_point_check(src)
	if (length(points))
		sep = ", "
		research_msg += techweb_point_display_generic(points)

	if (!sep) // nothing was shown
		research_msg += "None"

	// Extractable materials. Only shows the names, not the amounts.
	research_msg += ".<br><font color='purple'>Extractable materials:</font> "
	if (length(custom_materials))
		sep = ""
		for(var/mat in custom_materials)
			research_msg += sep
			research_msg += CallMaterialName(mat)
			sep = ", "
	else
		research_msg += "None"
	research_msg += "."
	. += research_msg.Join()

/obj/item/interact(mob/user)
	add_fingerprint(user)
	ui_interact(user)

/obj/item/ui_act(action, params)
	add_fingerprint(usr)
	return ..()

/obj/item/on_attack_hand(mob/user, act_intent = user.a_intent, unarmed_attack_flags)
	if(!user)
		return
	if(anchored)
		return
	if(loc == user && current_equipped_slot && current_equipped_slot != SLOT_HANDS)
		if(current_equipped_slot in user.check_obscured_slots())
			to_chat(src, span_warning("You are unable to unequip that while wearing other garments over it!"))
			return FALSE

	if(resistance_flags & ON_FIRE)
		var/mob/living/carbon/C = user
		var/can_handle_hot = FALSE
		if(!istype(C))
			can_handle_hot = TRUE
		else if(C.gloves && (C.gloves.max_heat_protection_temperature > 360))
			can_handle_hot = TRUE
		else if(HAS_TRAIT(C, TRAIT_RESISTHEAT) || HAS_TRAIT(C, TRAIT_RESISTHEATHANDS))
			can_handle_hot = TRUE

		if(can_handle_hot)
			extinguish()
			to_chat(user, span_notice("You put out the fire on [src]."))
		else
			to_chat(user, span_warning("You burn your hand on [src]!"))
			var/obj/item/bodypart/affecting = C.get_bodypart("[(user.active_hand_index % 2 == 0) ? "r" : "l" ]_arm")
			if(affecting && affecting.receive_damage( 0, 5 ))		// 5 burn damage
				C.update_damage_overlays()
			return

	if(acid_level > 20 && ismob(loc))// so we can still remove the clothes on us that have acid.
		var/mob/living/carbon/C = user
		if(istype(C))
			if(!C.gloves || (!(C.gloves.resistance_flags & (UNACIDABLE|ACID_PROOF))))
				to_chat(user, span_warning("The acid on [src] burns your hand!"))
				var/obj/item/bodypart/affecting = C.get_bodypart("[(user.active_hand_index % 2 == 0) ? "r" : "l" ]_arm")
				if(affecting && affecting.receive_damage( 0, 5 ))		// 5 burn damage
					C.update_damage_overlays()

	if(!(interaction_flags_item & INTERACT_ITEM_ATTACK_HAND_PICKUP))		//See if we're supposed to auto pickup.
		return

	//Heavy gravity makes picking up things very slow.
	var/grav = user.has_gravity()
	if(grav > STANDARD_GRAVITY)
		var/grav_power = min(3,grav - STANDARD_GRAVITY)
		to_chat(user,span_notice("You start picking up [src]..."))
		if(!do_mob(user,src,30*grav_power))
			return


	//If the item is in a storage item, take it out
	SEND_SIGNAL(loc, COMSIG_TRY_STORAGE_TAKE, src, user.loc, TRUE)

	if(throwing)
		throwing.finalize(FALSE)
	if(loc == user)
		if(!allow_attack_hand_drop(user) || !user.temporarilyRemoveItemFromInventory(src))
			return

	pickup(user)
	add_fingerprint(user)
	if(!user.put_in_active_hand(src, FALSE, FALSE))
		user.dropItemToGround(src)

/obj/item/proc/allow_attack_hand_drop(mob/user)
	return TRUE

/obj/item/attack_paw(mob/user)
	if(!user)
		return
	if(anchored)
		return
	if(loc == user && current_equipped_slot && current_equipped_slot != SLOT_HANDS)
		if(current_equipped_slot in user.check_obscured_slots())
			to_chat(src, span_warning("You are unable to unequip that while wearing other garments over it!"))
			return FALSE


	SEND_SIGNAL(loc, COMSIG_TRY_STORAGE_TAKE, src, user.loc, TRUE)

	if(throwing)
		throwing.finalize(FALSE)
	if(loc == user)
		if(!user.temporarilyRemoveItemFromInventory(src))
			return

	pickup(user)
	add_fingerprint(user)
	if(!user.put_in_active_hand(src, FALSE, FALSE))
		user.dropItemToGround(src)

/obj/item/attack_alien(mob/user)
	var/mob/living/carbon/alien/A = user

	if(!A.has_fine_manipulation)
		if(src in A.contents) // To stop Aliens having items stuck in their pockets
			A.dropItemToGround(src)
		to_chat(user, span_warning("Your claws aren't capable of such fine manipulation!"))
		return
	attack_paw(A)

/obj/item/attack_ai(mob/user)
	if(istype(src.loc, /obj/item/robot_module))
		//If the item is part of a cyborg module, equip it
		if(!iscyborg(user))
			return
		var/mob/living/silicon/robot/R = user
		if(!R.low_power_mode) //can't equip modules with an empty cell.
			R.activate_module(src)
			R.hud_used.update_robot_modules_display()

/obj/item/proc/GetDeconstructableContents()
	return GetAllContents() - src

// afterattack() and attack() prototypes moved to _onclick/item_attack.dm for consistency

/obj/item/proc/talk_into(mob/M, input, channel, spans, datum/language/language)
	return ITALICS | REDUCE_RANGE

/obj/item/proc/dropped(mob/user)
	SHOULD_CALL_PARENT(TRUE)
	current_equipped_slot = null
	for(var/X in actions)
		var/datum/action/A = X
		A.Remove(user)
	if(item_flags & DROPDEL)
		qdel(src)
	item_flags &= ~IN_INVENTORY
	if(SEND_SIGNAL(src, COMSIG_ITEM_DROPPED,user) & COMPONENT_DROPPED_RELOCATION)
		. = ITEM_RELOCATED_BY_DROPPED
	user?.update_equipment_speed_mods()
	user?.handle_equipment_stiffness()
	remove_hud_actions(user)

// called just as an item is picked up (loc is not yet changed)
/obj/item/proc/pickup(mob/user)
	SHOULD_CALL_PARENT(TRUE)
	SEND_SIGNAL(src, COMSIG_ITEM_PICKUP, user)
	item_flags |= IN_INVENTORY
	add_hud_actions(user)

// called when "found" in pockets and storage items. Returns 1 if the search should end.
/obj/item/proc/on_found(mob/finder)
	return

/obj/item/MouseDrop(atom/over, src_location, over_location, src_control, over_control, params) //Copypaste of /atom/MouseDrop() since this requires code in a very specific spot
	if(!usr || !over)
		return
	if(SEND_SIGNAL(src, COMSIG_MOUSEDROP_ONTO, over, usr) & COMPONENT_NO_MOUSEDROP)	//Whatever is receiving will verify themselves for adjacency.
		return
	if(over == src)
		return usr.client.Click(src, src_location, src_control, params)
	if(SEND_SIGNAL(usr, COMSIG_COMBAT_MODE_CHECK, COMBAT_MODE_ACTIVE) && usr.can_reach(src) && usr.can_reach(over))
		if(!usr.get_active_held_item())
			usr.UnarmedAttack(src, TRUE)
			if(usr.get_active_held_item() == src)
				melee_attack_chain(usr, over)
			usr.FlushCurrentAction()
			return TRUE //returning TRUE as a "is this overridden?" flag
	if(!Adjacent(usr) || !over.Adjacent(usr))
		return // should stop you from dragging through windows

	over.MouseDrop_T(src,usr)
	return

// called after an item is placed in an equipment slot
// user is mob that equipped it
// slot uses the slot_X defines found in setup.dm
// for items that can be placed in multiple slots
// note this isn't called during the initial dressing of a player
/obj/item/proc/equipped(mob/user, slot)
	SHOULD_CALL_PARENT(TRUE)
	. = SEND_SIGNAL(src, COMSIG_ITEM_EQUIPPED, user, slot)
	current_equipped_slot = slot
	if(!(. & COMPONENT_NO_GRANT_ACTIONS))
		for(var/X in actions)
			var/datum/action/A = X
			if(item_action_slot_check(slot, user, A)) //some items only give their actions buttons when in a specific slot.
				A.Grant(user)
	item_flags |= IN_INVENTORY
	user.update_equipment_speed_mods()
	user.handle_equipment_stiffness()
	if(user.get_active_held_item() != src && user.get_inactive_held_item() != src)
		unwield(user)

//Overlays for the worn overlay so you can overlay while you overlay
//eg: ammo counters, primed grenade flashing, etc.
//"icon_file" is used automatically for inhands etc. to make sure it gets the right inhand file
/obj/item/proc/worn_overlays(isinhands = FALSE, icon_file, used_state, style_flags = NONE)
	. = list()
	SEND_SIGNAL(src, COMSIG_ITEM_WORN_OVERLAYS, isinhands, icon_file, used_state, style_flags, .)

//sometimes we only want to grant the item's action if it's equipped in a specific slot.
/obj/item/proc/item_action_slot_check(slot, mob/user, datum/action/A)
	if(slot == SLOT_IN_BACKPACK || slot == SLOT_LEGCUFFED) //these aren't true slots, so avoid granting actions there
		return FALSE
	return TRUE

//the mob M is attempting to equip this item into the slot passed through as 'slot'. Return 1 if it can do this and 0 if it can't.
//if this is being done by a mob other than M, it will include the mob equipper, who is trying to equip the item to mob M. equipper will be null otherwise.
//If you are making custom procs but would like to retain partial or complete functionality of this one, include a 'return ..()' to where you want this to happen.
//Set disable_warning to TRUE if you wish it to not give you outputs.
/obj/item/proc/mob_can_equip(mob/living/M, mob/living/equipper, slot, disable_warning = FALSE, bypass_equip_delay_self = FALSE, clothing_check = FALSE, list/return_warning)
	if(!M)
		return FALSE

	return M.can_equip(src, slot, disable_warning, bypass_equip_delay_self, clothing_check, return_warning)

/obj/item/verb/verb_pickup()
	set src in oview(1)
	set category = "Object"
	set name = "Pick up"

	if(usr.incapacitated() || !Adjacent(usr) || usr.lying)
		return

	if(usr.get_active_held_item() == null) // Let me know if this has any problems -Yota
		usr.UnarmedAttack(src)

//This proc is executed when someone clicks the on-screen UI button.
//The default action is attack_self().
//Checks before we get to here are: mob is alive, mob is not restrained, stunned, asleep, resting, laying, item is on the mob.
/obj/item/proc/ui_action_click(mob/user, actiontype)
	attack_self(user)

/obj/item/proc/add_hud_actions(mob/user)
	if(!hud_actions || !user.client)
		return

	update_hud_actions()

	for(var/action in hud_actions)
		user.client.screen |= action

/obj/item/proc/remove_hud_actions(mob/user)
	if(!user)
		return
	if(!hud_actions || !user.client)
		return

	for(var/action in hud_actions)
		user.client.screen -= action

/obj/item/proc/update_hud_actions()
	if(!hud_actions)
		return

	for(var/A in hud_actions)
		var/obj/item/action = A
		action.update_icon()

/obj/item/proc/eyestab(mob/living/carbon/M, mob/living/carbon/user)
	if(HAS_TRAIT(user, TRAIT_PACIFISM))
		to_chat(user, span_warning("You don't want to harm [M]!"))
		return
	if(HAS_TRAIT(user, TRAIT_CLUMSY) && prob(50))
		M = user
	var/is_human_victim = 0
	var/obj/item/bodypart/affecting = M.get_bodypart(BODY_ZONE_HEAD)
	if(ishuman(M))
		if(!affecting) //no head!
			return
		is_human_victim = 1
		var/mob/living/carbon/human/H = M
		if((H.head && H.head.flags_cover & HEADCOVERSEYES) || \
			(H.wear_mask && H.wear_mask.flags_cover & MASKCOVERSEYES) || \
			(H.glasses && H.glasses.flags_cover & GLASSESCOVERSEYES))
			// you can't stab someone in the eyes wearing a mask!
			to_chat(user, span_danger("You're going to need to remove that mask/helmet/glasses first!"))
			return

	if(ismonkey(M))
		var/mob/living/carbon/monkey/Mo = M
		if(Mo.wear_mask && Mo.wear_mask.flags_cover & MASKCOVERSEYES)
			// you can't stab someone in the eyes wearing a mask!
			to_chat(user, span_danger("You're going to need to remove that mask/helmet/glasses first!"))
			return

	if(isalien(M))//Aliens don't have eyes./N     slimes also don't have eyes!
		to_chat(user, span_warning("You cannot locate any eyes on this creature!"))
		return

	if(isbrain(M))
		to_chat(user, span_danger("You cannot locate any organic eyes on this brain!"))
		return

	if(IS_STAMCRIT(user))//CIT CHANGE - makes eyestabbing impossible if you're in stamina softcrit
		to_chat(user, span_danger("You're too exhausted for that."))//CIT CHANGE - ditto
		return //CIT CHANGE - ditto

	src.add_fingerprint(user)

	playsound(loc, src.hitsound, 30, 1, -1)

	user.do_attack_animation(M)

	user.adjustStaminaLossBuffered(10)//CIT CHANGE - makes eyestabbing cost stamina

	if(M != user)
		M.visible_message(span_danger("[user] has stabbed [M] in the eye with [src]!"), \
							span_userdanger("[user] stabs you in the eye with [src]!"))
	else
		user.visible_message( \
			span_danger("[user] has stabbed [user.p_them()]self in the eyes with [src]!"), \
			span_userdanger("You stab yourself in the eyes with [src]!") \
		)
	if(is_human_victim)
		var/mob/living/carbon/human/U = M
		U.apply_damage(7, BRUTE, affecting)

	else
		M.take_bodypart_damage(7)

	SEND_SIGNAL(M, COMSIG_ADD_MOOD_EVENT, "eye_stab", /datum/mood_event/eye_stab)

	log_combat(user, M, "attacked", "[src.name]", "(INTENT: [uppertext(user.a_intent)])")

	var/obj/item/organ/eyes/eyes = M.getorganslot(ORGAN_SLOT_EYES)
	if (!eyes)
		return
	M.adjust_blurriness(3)
	eyes.applyOrganDamage(rand(2,4))
	if(eyes.damage >= 10)
		M.adjust_blurriness(15)
		if(M.stat != DEAD)
			to_chat(M, span_danger("Your eyes start to bleed profusely!"))
		if(!(HAS_TRAIT(M, TRAIT_BLIND) || HAS_TRAIT(M, TRAIT_NEARSIGHT)))
			to_chat(M, span_danger("You become nearsighted!"))
		M.become_nearsighted(EYE_DAMAGE)
		if(prob(50))
			if(M.stat != DEAD)
				if(M.drop_all_held_items())
					to_chat(M, span_danger("You drop what you're holding and clutch at your eyes!"))
			M.adjust_blurriness(10)
			M.Unconscious(20)
			M.DefaultCombatKnockdown(40)
		if (prob(eyes.damage - 10 + 1))
			M.become_blind(EYE_DAMAGE)
			to_chat(M, span_danger("You go blind!"))

/obj/item/clean_blood()
	. = ..()
	if(.)
		if(blood_splatter_icon)
			cut_overlay(blood_splatter_icon)

/obj/item/clothing/gloves/clean_blood()
	. = ..()
	if(.)
		transfer_blood = 0

/obj/item/singularity_pull(S, current_size)
	..()
	if(current_size >= STAGE_FOUR)
		throw_at(S,14,3, spin=0)
	else
		return

/obj/item/throw_impact(atom/hit_atom, datum/thrownthing/throwingdatum)
	if(hit_atom && !QDELETED(hit_atom))
		SEND_SIGNAL(src, COMSIG_MOVABLE_IMPACT, hit_atom, throwingdatum)
		if(get_temperature() && isliving(hit_atom))
			var/mob/living/L = hit_atom
			L.IgniteMob()
		var/itempush = 1
		if(w_class < 4)
			itempush = 0 //too light to push anything
		if(isliving(hit_atom)) //Living mobs handle hit sounds differently.
			var/volume = get_volume_by_throwforce_and_or_w_class()
			if (throwforce > 0)
				if (throwhitsound)
					playsound(hit_atom, throwhitsound, volume, TRUE, -1)
				else if(hitsound)
					playsound(hit_atom, hitsound, volume, TRUE, -1)
				else
					playsound(hit_atom, 'sound/weapons/genhit.ogg',volume, TRUE, -1)
			else
				playsound(hit_atom, 'sound/weapons/throwtap.ogg', 1, volume, -1)

		return hit_atom.hitby(src, 0, itempush, throwingdatum=throwingdatum)

/obj/item/throw_at(atom/target, range, speed, mob/thrower, spin=1, diagonals_first = 0, datum/callback/callback, force, messy_throw = TRUE)
	thrownby = thrower
	callback = CALLBACK(src, PROC_REF(after_throw), callback, (spin && messy_throw)) //replace their callback with our own
	. = ..(target, range, speed, thrower, spin, diagonals_first, callback, force)

/obj/item/proc/after_throw(datum/callback/callback, messy_throw)
	if (callback) //call the original callback
		. = callback.Invoke()
	throw_speed = initial(throw_speed) //explosions change this.
	item_flags &= ~IN_INVENTORY
	if(messy_throw)
		var/matrix/M = matrix(transform)
		M.Turn(rand(-170, 170))
		transform = M
		pixel_x = rand(-8, 8)
		pixel_y = rand(-8, 8)

/obj/item/proc/remove_item_from_storage(atom/newLoc) //please use this if you're going to snowflake an item out of a obj/item/storage
	if(!newLoc)
		return FALSE
	if(SEND_SIGNAL(loc, COMSIG_CONTAINS_STORAGE))
		return SEND_SIGNAL(loc, COMSIG_TRY_STORAGE_TAKE, src, newLoc, TRUE)
	return FALSE

/obj/item/proc/get_belt_overlay() //Returns the icon used for overlaying the object on a belt
	return mutable_appearance('icons/obj/clothing/belt_overlays.dmi', icon_state)

/obj/item/proc/get_worn_belt_overlay(icon_file)
	return

/obj/item/proc/update_slot_icon()
	if(!ismob(loc))
		return
	var/mob/owner = loc
	var/flags = slot_flags
	if(flags & ITEM_SLOT_OCLOTHING)
		owner.update_inv_wear_suit()
	if(flags & ITEM_SLOT_ICLOTHING)
		owner.update_inv_w_uniform()
	if(flags & ITEM_SLOT_GLOVES)
		owner.update_inv_gloves()
	if(flags & ITEM_SLOT_EYES)
		owner.update_inv_glasses()
	if(flags & ITEM_SLOT_EARS)
		owner.update_inv_ears()
	if(flags & ITEM_SLOT_MASK)
		owner.update_inv_wear_mask()
	if(flags & ITEM_SLOT_HEAD)
		owner.update_inv_head()
	if(flags & ITEM_SLOT_FEET)
		owner.update_inv_shoes()
	if(flags & ITEM_SLOT_ID)
		owner.update_inv_wear_id()
	if(flags & ITEM_SLOT_BELT)
		owner.update_inv_belt()
	if(flags & ITEM_SLOT_BACK)
		owner.update_inv_back()
	if(flags & ITEM_SLOT_NECK)
		owner.update_inv_neck()

/obj/item/proc/get_temperature()
	return heat

/obj/item/proc/get_sharpness()
	return sharpness

/obj/item/proc/get_dismemberment_chance(obj/item/bodypart/affecting)
	if(affecting.can_dismember(src))
		if((sharpness || damtype == BURN) && w_class >= WEIGHT_CLASS_NORMAL && force >= 10)
			. = force * (affecting.get_damage() / affecting.max_damage)

/obj/item/proc/get_dismember_sound()
	if(damtype == BURN)
		. = 'sound/weapons/sear.ogg'
	else
		. = pick('sound/misc/desceration-01.ogg', 'sound/misc/desceration-02.ogg', 'sound/misc/desceration-03.ogg')

/obj/item/proc/open_flame(flame_heat=700)
	var/turf/location = loc
	if(ismob(location))
		var/mob/M = location
		var/success = FALSE
		if(src == M.get_item_by_slot(SLOT_WEAR_MASK))
			success = TRUE
		if(success)
			location = get_turf(M)
	if(isturf(location))
		location.hotspot_expose(flame_heat, 1)

/obj/item/proc/ignition_effect(atom/A, mob/user)
	if(get_temperature())
		. = span_notice("[user] lights [A] with [src].")
	else
		. = ""

/obj/item/hitby(atom/movable/AM, skipcatch, hitpush, blocked, datum/thrownthing/throwingdatum)
	return

/obj/item/attack_hulk(mob/living/carbon/human/user)
	return 0

/obj/item/attack_animal(mob/living/simple_animal/M)
	if (obj_flags & CAN_BE_HIT)
		return ..()
	return 0

/obj/item/mech_melee_attack(obj/mecha/M)
	return 0

/obj/item/burn()
	if(!QDELETED(src))
		var/turf/T = get_turf(src)
		var/ash_type = /obj/effect/decal/cleanable/ash
		if(w_class == WEIGHT_CLASS_HUGE || w_class == WEIGHT_CLASS_GIGANTIC)
			ash_type = /obj/effect/decal/cleanable/ash/large
		var/obj/effect/decal/cleanable/ash/A = new ash_type(T)
		A.desc += "\nLooks like this used to be \an [name] some time ago."
		..()

/obj/item/acid_melt()
	if(!QDELETED(src))
		var/turf/T = get_turf(src)
		var/obj/effect/decal/cleanable/molten_object/MO = new(T)
		MO.pixel_x = rand(-16,16)
		MO.pixel_y = rand(-16,16)
		MO.desc = "Looks like this was \an [src] some time ago."
		..()

/obj/item/proc/microwave_act(obj/machinery/microwave/M)
	SEND_SIGNAL(src, COMSIG_ITEM_MICROWAVE_ACT, M)
	if(istype(M) && M.dirty < 100)
		M.dirty++

/obj/item/proc/on_mob_death(mob/living/L, gibbed)

/obj/item/proc/grind_requirements(obj/machinery/reagentgrinder/R) //Used to check for extra requirements for grinding an object
	return TRUE

/obj/item/proc/reset_transform() //Used to check for extra requirements for grinding an object
	if(special_transform)
		transform = special_transform
	else
		transform = initial(transform)

//Called BEFORE the object is ground up - use this to change grind results based on conditions
//Use "return -1" to prevent the grinding from occurring
/obj/item/proc/on_grind()

/obj/item/proc/on_juice()

/obj/item/proc/set_force_string()
	switch(force)
		if(0 to 4)
			force_string = "very low"
		if(4 to 7)
			force_string = "low"
		if(7 to 10)
			force_string = "medium"
		if(10 to 11)
			force_string = "high"
		if(11 to 20) //12 is the force of a toolbox
			force_string = "robust"
		if(20 to 25)
			force_string = "very robust"
		else
			force_string = "exceptionally robust"
	last_force_string_check = force

/obj/item/proc/openTip(location, control, params, user)
	if(last_force_string_check != force && !(item_flags & FORCE_STRING_OVERRIDE))
		set_force_string()
	if(!(item_flags & FORCE_STRING_OVERRIDE))
		openToolTip(user,src,params,title = name,content = "[desc]<br>[force ? "<b>Force:</b> [force_string]" : ""]",theme = "")
	else
		openToolTip(user,src,params,title = name,content = "[desc]<br><b>Force:</b> [force_string]",theme = "")

/obj/item/MouseEntered(location, control, params)
	if((item_flags & IN_INVENTORY) && usr.client.prefs.enable_tips && !QDELETED(src))
		var/timedelay = usr.client.prefs.tip_delay/100
		var/user = usr
		tip_timer = addtimer(CALLBACK(src, PROC_REF(openTip), location, control, params, user), timedelay, TIMER_STOPPABLE)//timer takes delay in deciseconds, but the pref is in milliseconds. dividing by 100 converts it.

/obj/item/MouseExited(location,control,params)
	SEND_SIGNAL(src, COMSIG_ITEM_MOUSE_EXIT, location, control, params)
	deltimer(tip_timer)//delete any in-progress timer if the mouse is moved off the item before it finishes
	closeToolTip(usr)

/obj/item/MouseEntered(location,control,params)
	SEND_SIGNAL(src, COMSIG_ITEM_MOUSE_ENTER, location, control, params)

// Called when a mob tries to use the item as a tool.
// Handles most checks.
/obj/item/proc/use_tool(atom/target, mob/living/user, delay, amount=0, volume=0, datum/callback/extra_checks, skill_gain_mult = STD_USE_TOOL_MULT)
	// No delay means there is no start message, and no reason to call tool_start_check before use_tool.
	// Run the start check here so we wouldn't have to call it manually.
	if(!delay && !tool_start_check(user, amount))
		return

	if(needs_skill_to_operate)
		delay *= (200 - user.skill_value(skill_used_for_operation))/100

	delay *= toolspeed

	// Play tool sound at the beginning of tool usage.
	play_tool_sound(target, volume)

	if(delay)
		if(user.mind && used_skills)
			delay = user.mind.item_action_skills_mod(src, delay, skill_difficulty, SKILL_USE_TOOL, null, FALSE)

		// Create a callback with checks that would be called every tick by do_after.
		var/datum/callback/tool_check = CALLBACK(src, PROC_REF(tool_check_callback), user, amount, extra_checks)

		if(ismob(target))
			if(!do_mob(user, target, delay, extra_checks=tool_check))
				return

		else
			if(!do_after(user, delay, target=target, extra_checks=tool_check))
				return
	else
		// Invoke the extra checks once, just in case.
		if(extra_checks && !extra_checks.Invoke())
			return

	// Use tool's fuel, stack sheets or charges if amount is set.
	if(amount && !use(amount))
		return

	// Play tool sound at the end of tool usage,
	// but only if the delay between the beginning and the end is not too small
	if(delay >= MIN_TOOL_SOUND_DELAY)
		play_tool_sound(target, volume)


	if(user.mind && used_skills && skill_gain_mult)
		var/gain = skill_gain + delay/SKILL_GAIN_DELAY_DIVISOR
		for(var/skill in used_skills)
			if(!(SKILL_TRAINING_TOOL in used_skills[skill]))
				continue
			var/datum/skill/S = GLOB.skill_datums[skill]
			user.mind.auto_gain_experience(skill, gain*skill_gain_mult*S.item_skill_gain_multi)

	return TRUE

// Called before use_tool if there is a delay, or by use_tool if there isn't.
// Only ever used by welding tools and stacks, so it's not added on any other use_tool checks.
/obj/item/proc/tool_start_check(mob/living/user, amount=0)
	return tool_use_check(user, amount)

// A check called by tool_start_check once, and by use_tool on every tick of delay.
/obj/item/proc/tool_use_check(mob/living/user, amount)
	return !amount

// Generic use proc. Depending on the item, it uses up fuel, charges, sheets, etc.
// Returns TRUE on success, FALSE on failure.
/obj/item/proc/use(used)
	return !used

// Plays item's usesound, if any.
/obj/item/proc/play_tool_sound(atom/target, volume=50)
	if(target && usesound && volume)
		var/played_sound = usesound

		if(islist(usesound))
			played_sound = pick(usesound)

		playsound(target, played_sound, volume, 1)

// Used in a callback that is passed by use_tool into do_after call. Do not override, do not call manually.
/obj/item/proc/tool_check_callback(mob/living/user, amount, datum/callback/extra_checks)
	return tool_use_check(user, amount) && (!extra_checks || extra_checks.Invoke())

// Returns a numeric value for sorting items used as parts in machines, so they can be replaced by the rped
/obj/item/proc/get_part_rating()
	return 0

/obj/item/doMove(atom/destination)
	if (ismob(loc))
		var/mob/M = loc
		var/hand_index = M.get_held_index_of_item(src)
		if(hand_index)
			M.held_items[hand_index] = null
			M.update_inv_hands()
			if(M.client)
				M.client.screen -= src
			layer = initial(layer)
			plane = initial(plane)
			appearance_flags &= ~NO_CLIENT_COLOR
			dropped(M)
	return ..()

/obj/item/throw_at(atom/target, range, speed, mob/thrower, spin=TRUE, diagonals_first = FALSE, datum/callback/callback)
	if (HAS_TRAIT(src, TRAIT_NODROP))
		return
	return ..()

/// Get an item's volume that it uses when being stored.
/obj/item/proc/get_w_volume()
	// if w_volume is 0 you fucked up anyways lol
	return w_volume || AUTO_SCALE_VOLUME(w_class)

/obj/item/proc/embedded(atom/embedded_target)
	return

/obj/item/proc/unembedded()
	if(item_flags & DROPDEL)
		QDEL_NULL(src)
		return TRUE

/**
 * Sets our slowdown and updates equipment slowdown of any mob we're equipped on.
 */
/obj/item/proc/set_slowdown(new_slowdown)
	slowdown = new_slowdown
	if(CHECK_BITFIELD(item_flags, IN_INVENTORY))
		var/mob/living/L = loc
		if(istype(L))
			L.update_equipment_speed_mods()

/obj/item/vv_edit_var(var_name, var_value)
	. = ..()
	if(var_name == NAMEOF(src, slowdown))
		set_slowdown(var_value)			//don't care if it's a duplicate edit as slowdown'll be set, do it anyways to force normal behavior.
/**
 * Does the current embedding var meet the criteria for being harmless? Namely, does it explicitly define the pain multiplier and jostle pain mult to be 0? If so, return true.
 *
 */
/obj/item/proc/isEmbedHarmless()
	if(embedding)
		return !isnull(embedding["pain_mult"]) && !isnull(embedding["jostle_pain_mult"]) && embedding["pain_mult"] == 0 && embedding["jostle_pain_mult"] == 0

///In case we want to do something special (like self delete) upon failing to embed in something, return true
/obj/item/proc/failedEmbed()
	if(item_flags & DROPDEL)
		QDEL_NULL(src)
		return TRUE

/**



 * tryEmbed() is for when you want to try embedding something without dealing with the damage + hit messages of calling hitby() on the item while targetting the target.



 *



 * Really, this is used mostly with projectiles with shrapnel payloads, from [/datum/element/embed/proc/checkEmbedProjectile], and called on said shrapnel. Mostly acts as an intermediate between different embed elements.



 *



 * Arguments:



 * * target- Either a body part, a carbon, or a closed turf. What are we hitting?



 * * forced- Do we want this to go through 100%?



 */



/obj/item/proc/tryEmbed(atom/target, forced=FALSE, silent=FALSE)



	if(!isbodypart(target) && !iscarbon(target) && !isclosedturf(target))



		return



	if(!forced && !LAZYLEN(embedding))



		return







	if(SEND_SIGNAL(src, COMSIG_EMBED_TRY_FORCE, target, forced, silent))



		return TRUE



	failedEmbed()







///For when you want to disable an item's embedding capabilities (like transforming weapons and such), this proc will detach any active embed elements from it.



/obj/item/proc/disableEmbedding()



	SEND_SIGNAL(src, COMSIG_ITEM_DISABLE_EMBED)



	return




/obj/item/proc/get_head_speechspans(mob/living/carbon/user) //we need this all the way back here for reasons
	return


///For when you want to add/update the embedding on an item. Uses the vars in [/obj/item/embedding], and defaults to config values for values that aren't set. Will automatically detach previous embed elements on this item.



/obj/item/proc/updateEmbedding()
	if(!LAZYLEN(embedding))
		return

	AddElement(/datum/element/embed,\
		embed_chance = (!isnull(embedding["embed_chance"]) ? embedding["embed_chance"] : EMBED_CHANCE),\
		fall_chance = (!isnull(embedding["fall_chance"]) ? embedding["fall_chance"] : EMBEDDED_ITEM_FALLOUT),\
		pain_chance = (!isnull(embedding["pain_chance"]) ? embedding["pain_chance"] : EMBEDDED_PAIN_CHANCE),\
		pain_mult = (!isnull(embedding["pain_mult"]) ? embedding["pain_mult"] : EMBEDDED_PAIN_MULTIPLIER),\
		remove_pain_mult = (!isnull(embedding["remove_pain_mult"]) ? embedding["remove_pain_mult"] : EMBEDDED_UNSAFE_REMOVAL_PAIN_MULTIPLIER),\
		rip_time = (!isnull(embedding["rip_time"]) ? embedding["rip_time"] : EMBEDDED_UNSAFE_REMOVAL_TIME),\
		ignore_throwspeed_threshold = (!isnull(embedding["ignore_throwspeed_threshold"]) ? embedding["ignore_throwspeed_threshold"] : FALSE),\
		impact_pain_mult = (!isnull(embedding["impact_pain_mult"]) ? embedding["impact_pain_mult"] : EMBEDDED_IMPACT_PAIN_MULTIPLIER),\
		jostle_chance = (!isnull(embedding["jostle_chance"]) ? embedding["jostle_chance"] : EMBEDDED_JOSTLE_CHANCE),\
		jostle_pain_mult = (!isnull(embedding["jostle_pain_mult"]) ? embedding["jostle_pain_mult"] : EMBEDDED_JOSTLE_PAIN_MULTIPLIER),\
		pain_stam_pct = (!isnull(embedding["pain_stam_pct"]) ? embedding["pain_stam_pct"] : EMBEDDED_PAIN_STAM_PCT),\
		embed_chance_turf_mod = (!isnull(embedding["embed_chance_turf_mod"]) ? embedding["embed_chance_turf_mod"] : EMBED_CHANCE_TURF_MOD),\
		projectile_payload = embedding["projectile_payload"])
	return TRUE

/obj/item/proc/get_held_item_speechspans(mob/living/carbon/user)
	return

/obj/item/throwing_star/proc/throwingweapondraw(obj/item/throwing_star/T, mob/living/user)
	user.visible_message(span_danger("[user] grabs \a [T]!"))
	user.SetThrowDelay(6)
	user.log_message("[user] pulled a [T]", INDIVIDUAL_ATTACK_LOG)

/obj/item/proc/refresh_upgrades()
	return

