/mob/living/Initialize()
	. = ..()
	var/static/list/loc_connections = list(
		COMSIG_ATOM_ENTERED = PROC_REF(on_entered),
	)
	AddElement(/datum/element/connect_loc, loc_connections)

	register_init_signals()
	if(unique_name)
		name = "[name] ([rand(1, 1000)])"
		real_name = name
	var/datum/atom_hud/data/human/medical/advanced/medhud = GLOB.huds[DATA_HUD_MEDICAL_ADVANCED]
	medhud.add_to_hud(src)
	var/datum/atom_hud/data/client/clienthud = GLOB.huds[DATA_HUD_CLIENT]
	clienthud.add_to_hud(src)
	for(var/datum/atom_hud/data/diagnostic/diag_hud in GLOB.huds)
		diag_hud.add_to_hud(src)
	faction += "[REF(src)]"
	GLOB.mob_living_list += src
	clienthud.add_hud_to(src)

/mob/living/prepare_huds()
	..()
	prepare_data_huds()

/mob/living/proc/prepare_data_huds()
	med_hud_set_health()
	med_hud_set_status()

/mob/living/Destroy()
	end_parry_sequence()
	stop_active_blocking()
	if(LAZYLEN(status_effects))
		for(var/s in status_effects)
			var/datum/status_effect/S = s
			if(S.on_remove_on_mob_delete) //the status effect calls on_remove when its mob is deleted
				qdel(S)
			else
				S.be_replaced()
	if(ranged_ability)
		ranged_ability.remove_ranged_ability(src)
	if(buckled)
		buckled.unbuckle_mob(src,force=1)

	remove_from_all_data_huds()
	GLOB.mob_living_list -= src
	QDEL_LIST(diseases)
	return ..()

/mob/living/onZImpact(turf/T, levels)
	if(!isgroundlessturf(T))
		ZImpactDamage(T, levels)
	return ..()

/mob/living/proc/ZImpactDamage(turf/T, levels)
	if(levels <= 2 && HAS_TRAIT(src, TRAIT_FREERUNNING)) //levels is incremented prior to damage proc and is always >= 2
		visible_message(span_danger("[src] slams into [T], rolling as they land and keeping their pace!"),
						span_userdanger("You slam into [T], rolling and keeping your momentum!"))
		adjustBruteLoss(5)
	else
		visible_message(span_danger("[src] crashes into [T] with a sickening noise!"),
						span_userdanger("You crash into [T] with a sickening noise!"))
		adjustBruteLoss((levels * 5) ** 1.5)
		DefaultCombatKnockdown(levels * 50)

/mob/living/proc/OpenCraftingMenu()
	return

//Generic Bump(). Override MobBump() and ObjBump() instead of this.
/mob/living/Bump(atom/A)
	if(..()) //we are thrown onto something
		return
	if(buckled || now_pushing)
		return
	if(ismob(A))
		var/mob/M = A
		if(MobBump(M))
			return
	if(isobj(A))
		var/obj/O = A
		if(ObjBump(O))
			return
	if(ismovable(A))
		var/atom/movable/AM = A
		if(PushAM(AM, move_force))
			return

/mob/living/Bumped(atom/movable/AM)
	..()
	last_bumped = world.time

//Called when we bump onto a mob
/mob/living/proc/MobBump(mob/M)
	//Even if we don't push/swap places, we "touched" them, so spread fire
	spreadFire(M)

	if(now_pushing)
		return TRUE

	var/they_can_move = TRUE
	if(isliving(M))
		var/mob/living/L = M
		they_can_move = CHECK_MOBILITY(L, MOBILITY_MOVE)
		//Also spread diseases
		for(var/thing in diseases)
			var/datum/disease/D = thing
			if(D.spread_flags & DISEASE_SPREAD_CONTACT_SKIN)
				L.ContactContractDisease(D)

		for(var/thing in L.diseases)
			var/datum/disease/D = thing
			if(D.spread_flags & DISEASE_SPREAD_CONTACT_SKIN)
				ContactContractDisease(D)

		//Should stop you pushing a restrained person out of the way
		if(L.pulledby && L.pulledby != src && L.restrained())
			if(!(world.time % 5))
				to_chat(src, span_warning("[L] is restrained, you cannot push past."))
			return 1

		if(L.pulling)
			if(ismob(L.pulling))
				var/mob/P = L.pulling
				if(P.restrained())
					if(!(world.time % 5))
						to_chat(src, span_warning("[L] is restraining [P], you cannot push past."))
					return 1

	//CIT CHANGES START HERE - makes it so resting stops you from moving through standing folks without a short delay
		if(!CHECK_MOBILITY(src, MOBILITY_STAND) && CHECK_MOBILITY(L, MOBILITY_STAND))
			var/origtargetloc = L.loc
			if(!pulledby)
				if(combat_flags & COMBAT_FLAG_ATTEMPTING_CRAWL)
					return TRUE
				if(IS_STAMCRIT(src))
					to_chat(src, span_warning("You're too exhausted to crawl under [L]."))
					return TRUE
				ENABLE_BITFIELD(combat_flags, COMBAT_FLAG_ATTEMPTING_CRAWL)
				visible_message(span_notice("[src] is attempting to crawl under [L]."),
					span_notice("You are now attempting to crawl under [L]."),
					target = L, target_message = span_notice("[src] is attempting to crawl under you."))
				if(!do_after(src, CRAWLUNDER_DELAY, target = src) || CHECK_MOBILITY(src, MOBILITY_STAND))
					DISABLE_BITFIELD(combat_flags, COMBAT_FLAG_ATTEMPTING_CRAWL)
					return TRUE
			var/src_passmob = (pass_flags & PASSMOB)
			pass_flags |= PASSMOB
			Move(origtargetloc)
			if(!src_passmob)
				pass_flags &= ~PASSMOB
			DISABLE_BITFIELD(combat_flags, COMBAT_FLAG_ATTEMPTING_CRAWL)
			return TRUE
	//END OF CIT CHANGES

	if(moving_diagonally)//no mob swap during diagonal moves.
		return 1

	if(!M.buckled && !M.has_buckled_mobs())
		var/mob_swap = FALSE
		var/too_strong = (M.move_resist > move_force) //can't swap with immovable objects unless they help us
		if(!they_can_move) //we have to physically move them
			if(!too_strong)
				mob_swap = TRUE
		else
			if(M.pulledby == src && a_intent == INTENT_GRAB)
				mob_swap = TRUE
			//restrained people act if they were on 'help' intent to prevent a person being pulled from being separated from their puller
			else if((M.restrained() || M.a_intent == INTENT_HELP) && (restrained() || a_intent == INTENT_HELP))
				mob_swap = TRUE
		if(mob_swap)
			//switch our position with M
			if(loc && !loc.Adjacent(M.loc))
				return 1
			now_pushing = 1
			var/oldloc = loc
			var/oldMloc = M.loc


			var/M_passmob = (M.pass_flags & PASSMOB) // we give PASSMOB to both mobs to avoid bumping other mobs during swap.
			var/src_passmob = (pass_flags & PASSMOB)
			M.pass_flags |= PASSMOB
			pass_flags |= PASSMOB

			var/move_failed = FALSE
			if(!M.Move(oldloc) || !Move(oldMloc))
				M.forceMove(oldMloc)
				forceMove(oldloc)
				move_failed = TRUE
			if(!src_passmob)
				pass_flags &= ~PASSMOB
			if(!M_passmob)
				M.pass_flags &= ~PASSMOB

			now_pushing = 0

			if(!move_failed)
				return 1

	//okay, so we didn't switch. but should we push?
	//not if he's not CANPUSH of course
	if(!(M.status_flags & CANPUSH))
		return 1
	if(isliving(M))
		var/mob/living/L = M
		if(HAS_TRAIT(L, TRAIT_PUSHIMMUNE))
			return 1
	//If they're a human, and they're not in help intent, block pushing
	if(ishuman(M) && (M.a_intent != INTENT_HELP))
		return TRUE
	//anti-riot equipment is also anti-push
	for(var/obj/item/I in M.held_items)
		if(!istype(M, /obj/item/clothing))
			if(prob(I.block_chance*2))
				return 1

/mob/living/get_photo_description(obj/item/camera/camera)
	var/list/mob_details = list()
	var/list/holding = list()
	var/len = length(held_items)
	if(len)
		for(var/obj/item/I in held_items)
			if(!holding.len)
				holding += "They are holding \a [I]"
			else if(held_items.Find(I) == len)
				holding += ", and \a [I]."
			else
				holding += ", \a [I]"
	holding += "."
	mob_details += "You can also see [src] on the photo[health < (maxHealth * 0.75) ? ", looking a bit hurt":""][holding ? ". [holding.Join("")]":"."]."
	return mob_details.Join("")

//Called when we bump onto an obj
/mob/living/proc/ObjBump(obj/O)
	return

//Called when we want to push an atom/movable
/mob/living/proc/PushAM(atom/movable/AM, force = move_force)
	if(now_pushing)
		return TRUE
	if(moving_diagonally)// no pushing during diagonal moves.
		return TRUE
	if(!client && (mob_size < MOB_SIZE_SMALL))
		return
	now_pushing = TRUE
	var/t = get_dir(src, AM)
	var/push_anchored = FALSE
	if((AM.move_resist * MOVE_FORCE_CRUSH_RATIO) <= force)
		if(move_crush(AM, move_force, t))
			push_anchored = TRUE
	if((AM.move_resist * MOVE_FORCE_FORCEPUSH_RATIO) <= force)			//trigger move_crush and/or force_push regardless of if we can push it normally
		if(force_push(AM, move_force, t, push_anchored))
			push_anchored = TRUE
	if((AM.anchored && !push_anchored) || (force < (AM.move_resist * MOVE_FORCE_PUSH_RATIO)))
		now_pushing = FALSE
		return
	if (istype(AM, /obj/structure/window))
		var/obj/structure/window/W = AM
		if(W.fulltile)
			for(var/obj/structure/window/win in get_step(W,t))
				now_pushing = FALSE
				return
	if(pulling == AM)
		stop_pulling()
	var/current_dir
	if(isliving(AM))
		current_dir = AM.dir
	if(AM.Move(get_step(AM.loc, t), t, glide_size))
		Move(get_step(loc, t), t)
	if(current_dir)
		AM.setDir(current_dir)
	now_pushing = FALSE

/mob/living/start_pulling(atom/movable/AM, state, force = pull_force, supress_message = FALSE)
	if(!AM || !src)
		return FALSE
	if(!(AM.can_be_pulled(src, state, force)))
		return FALSE
	if(throwing || incapacitated())
		return FALSE

	AM.add_fingerprint(src)

	// If we're pulling something then drop what we're currently pulling and pull this instead.
	if(pulling)
		// Are we trying to pull something we are already pulling? Then just stop here, no need to continue.
		if(AM == pulling)
			return
		stop_pulling()

	DelayNextAction(CLICK_CD_GRABBING)

	if(AM.pulledby)
		if(!supress_message)
			AM.pulledby.visible_message(span_danger("[src] has pulled [AM] from [AM.pulledby]'s grip."),
				span_danger("[src] has pulled [AM] from your grip."), target = src,
				target_message = span_danger("You have pulled [AM] from [AM.pulledby]'s grip."))
		log_combat(AM, AM.pulledby, "pulled from", src)
		AM.pulledby.stop_pulling() //an object can't be pulled by two mobs at once.

	pulling = AM
	AM.pulledby = src
	if(!supress_message)
		playsound(src.loc, 'sound/weapons/thudswoosh.ogg', 50, 1, -1)
	update_pull_hud_icon()

	if(ismob(AM))
		var/mob/M = AM

		log_combat(src, M, "grabbed", addition="passive grab")
		if(!supress_message && !(iscarbon(AM) && HAS_TRAIT(src, TRAIT_STRONG_GRABBER)))
			visible_message(span_warning("[src] has grabbed [M][(zone_selected == "l_arm" || zone_selected == "r_arm")? " by [M.p_their()] hands":" passively"]!"),
				span_warning("You have grabbed [M][(zone_selected == "l_arm" || zone_selected == "r_arm")? " by [M.p_their()] hands":" passively"]!"), target = M,
				target_message = span_warning("[src] has grabbed you[(zone_selected == "l_arm" || zone_selected == "r_arm")? " by your hands":" passively"]!"))
		if(!iscarbon(src))
			M.LAssailant = null
		else
			M.LAssailant = WEAKREF(usr)
		if(isliving(M))
			var/mob/living/L = M
			//Share diseases that are spread by touch
			for(var/thing in diseases)
				var/datum/disease/D = thing
				if(D.spread_flags & DISEASE_SPREAD_CONTACT_SKIN)
					L.ContactContractDisease(D)

			for(var/thing in L.diseases)
				var/datum/disease/D = thing
				if(D.spread_flags & DISEASE_SPREAD_CONTACT_SKIN)
					ContactContractDisease(D)

			if(iscarbon(L))
				var/mob/living/carbon/C = L
				if(HAS_TRAIT(src, TRAIT_STRONG_GRABBER))
					C.grippedby(src)

			update_pull_movespeed()

		set_pull_offsets(M, state)

/mob/living/proc/set_pull_offsets(mob/living/M, grab_state = GRAB_PASSIVE)
	if(M.buckled || SEND_SIGNAL(M, COMSIG_COMBAT_MODE_CHECK, COMBAT_MODE_ACTIVE))
		return //don't make them change direction or offset them if they're buckled into something or in combat mode.
	var/offset = 0
	switch(grab_state)
		if(GRAB_PASSIVE)
			offset = GRAB_PIXEL_SHIFT_PASSIVE
		if(GRAB_AGGRESSIVE)
			offset = GRAB_PIXEL_SHIFT_AGGRESSIVE
		if(GRAB_NECK)
			offset = GRAB_PIXEL_SHIFT_NECK
		if(GRAB_KILL)
			offset = GRAB_PIXEL_SHIFT_NECK
	M.setDir(get_dir(M, src))
	switch(M.dir)
		if(NORTH)
			animate(M, pixel_x = 0, pixel_y = offset, 3)
		if(SOUTH)
			animate(M, pixel_x = 0, pixel_y = -offset, 3)
		if(EAST)
			if(M.lying == 270) //update the dragged dude's direction if we've turned
				M.lying = 90
				M.update_transform() //force a transformation update, otherwise it'll take a few ticks for update_mobility() to do so
				M.lying_prev = M.lying
			animate(M, pixel_x = offset, pixel_y = 0, 3)
		if(WEST)
			if(M.lying == 90)
				M.lying = 270
				M.update_transform()
				M.lying_prev = M.lying
			animate(M, pixel_x = -offset, pixel_y = 0, 3)

/mob/living/proc/reset_pull_offsets(mob/living/M, override)
	if(!override && M.buckled)
		return
	animate(M, pixel_x = 0, pixel_y = 0, 1)

//mob verbs are a lot faster than object verbs
//for more info on why this is not atom/pull, see examinate() in mob.dm
/mob/living/verb/pulled(atom/movable/AM as mob|obj in oview(1))
	set name = "Pull"
	set category = "Object"

	if(istype(AM) && Adjacent(AM))
		start_pulling(AM)
	else
		stop_pulling()

/mob/living/stop_pulling()
	if(ismob(pulling))
		reset_pull_offsets(pulling)
	..()
	update_pull_movespeed()
	update_pull_hud_icon()

/mob/living/verb/stop_pulling1()
	set name = "Stop Pulling"
	set category = "IC"
	stop_pulling()

//same as above
/mob/living/pointed(atom/A as mob|obj|turf in fov_view())
	if(incapacitated())
		return FALSE
	if(HAS_TRAIT(src, TRAIT_DEATHCOMA))
		return FALSE
	if(!..())
		return FALSE
	visible_message("<b>[src]</b> points at [A].", span_notice("You point at [A]."))
	return TRUE

/mob/living/verb/succumb()
	set name = "Succumb"
	set category = "IC"
	if (InCritical())
		log_message("Has succumbed to death while in [InFullCritical() ? "hard":"soft"] critical with [round(health, 0.1)] points of health!", LOG_ATTACK)
		adjustOxyLoss(health - HEALTH_THRESHOLD_DEAD)
		updatehealth()
		to_chat(src, span_notice("You have given up life and succumbed to death."))
		death()

/mob/living/verb/lookup()
	set name = "Look Up"
	set category = "IC"
	if(src.incapacitated())
		to_chat(src, span_warning("You can't look up right now!"))
	var/turf/T = SSmapping.get_turf_above(get_turf(src))
	if(!istype(T, /turf/open/transparent/openspace))
		if(istype(T, /turf/open) || istype(T, /turf/closed))
			to_chat(src, span_notice("You look up at the ceiling. You can see ceiling."))
		return
	else
		src.reset_perspective(T)
		RegisterSignal(src, COMSIG_MOB_CLIENT_CHANGE_VIEW, PROC_REF(stop_looking_up)) //no binos/scops
		RegisterSignal(src, COMSIG_MOVABLE_MOVED, PROC_REF(stop_looking_up))
		RegisterSignal(src, COMSIG_LIVING_STATUS_KNOCKDOWN, PROC_REF(stop_looking_up))
		RegisterSignal(src, COMSIG_LIVING_STATUS_PARALYZE, PROC_REF(stop_looking_up))
		RegisterSignal(src, COMSIG_LIVING_STATUS_UNCONSCIOUS, PROC_REF(stop_looking_up))
		RegisterSignal(src, COMSIG_LIVING_STATUS_SLEEP, PROC_REF(stop_looking_up))

/mob/living/proc/stop_looking_up()
	reset_perspective(null)
	UnregisterSignal(src, list(COMSIG_LIVING_STATUS_PARALYZE, COMSIG_LIVING_STATUS_UNCONSCIOUS, COMSIG_LIVING_STATUS_SLEEP, COMSIG_LIVING_STATUS_KNOCKDOWN, COMSIG_MOVABLE_MOVED, COMSIG_MOB_CLIENT_CHANGE_VIEW))


/mob/living/incapacitated(ignore_restraints = FALSE, ignore_grab = FALSE, check_immobilized = FALSE)
	if(stat || IsUnconscious() || IsStun() || IsParalyzed() || (combat_flags & COMBAT_FLAG_HARD_STAMCRIT) || (check_immobilized && IsImmobilized()) || (!ignore_restraints && restrained(ignore_grab)))
		return TRUE

/mob/living/canUseStorage()
	if (get_num_arms() <= 0)
		return FALSE
	return TRUE

/mob/living/proc/InCritical()
	return (health <= crit_threshold && (stat == SOFT_CRIT || stat == UNCONSCIOUS))

/mob/living/proc/InFullCritical()
	return (health <= HEALTH_THRESHOLD_FULLCRIT && stat == UNCONSCIOUS)

//This proc is used for mobs which are affected by pressure to calculate the amount of pressure that actually
//affects them once clothing is factored in. ~Errorage
/mob/living/proc/calculate_affecting_pressure(pressure)
	return pressure


/mob/living/proc/adjustBodyTemp(actual, desired, incrementboost)
	var/temperature = actual
	var/difference = abs(actual-desired)	//get difference
	var/increments = difference/10 //find how many increments apart they are
	var/change = increments*incrementboost	// Get the amount to change by (x per increment)

	// Too cold
	if(actual < desired)
		temperature += change
		if(actual > desired)
			temperature = desired
	// Too hot
	if(actual > desired)
		temperature -= change
		if(actual < desired)
			temperature = desired
	return temperature



/mob/living/proc/getMaxHealth()
	return maxHealth

/mob/living/proc/setMaxHealth(newMaxHealth)
	maxHealth = newMaxHealth

// MOB PROCS //END

/mob/living/proc/mob_sleep()
	set name = "Sleep"
	set category = "IC"

	if(IsSleeping())
		to_chat(src, span_notice("You are already sleeping."))
		return
	else
		if(alert(src, "You sure you want to sleep for a while?", "Sleep", "Yes", "No") == "Yes")
			SetSleeping(400) //Short nap

/mob/proc/get_contents()

/*CIT CHANGE - comments out lay_down proc to be modified in modular_citadel
/mob/living/proc/lay_down()
	set name = "Rest"
	set category = "IC"

	resting = !resting
	to_chat(src, span_notice("You are now [resting ? "resting" : "getting up"]."))
	update_canmove()
*/

/mob/living/proc/surrender()
	set name = "Surrender"
	set category = "IC"

	var/mob/living/M
	if(CHECK_MOBILITY(M, MOBILITY_STAND))
		if(!lying)
			lay_down()

		Knockdown(200)
		Paralyze(200)
		visible_message("<span class='big bold'>[src] surrenders!</span>")
		playsound(loc, 'sound/f13effects/surrender1.ogg', 80, 1)

//Recursive function to find everything a mob is holding. Really shitty proc tbh.
/mob/living/get_contents()
	var/list/ret = list()
	ret |= contents						//add our contents
	for(var/i in ret.Copy())			//iterate storage objects
		var/atom/A = i
		SEND_SIGNAL(A, COMSIG_TRY_STORAGE_RETURN_INVENTORY, ret)
	for(var/obj/item/folder/F in ret.Copy())		//very snowflakey-ly iterate folders
		ret |= F.contents
	return ret

// Living mobs use can_inject() to make sure that the mob is not syringe-proof in general.
/mob/living/proc/can_inject(mob/user, error_msg, target_zone, penetrate_thick = FALSE, bypass_immunity = FALSE)
	return TRUE

/mob/living/is_injectable(allowmobs = TRUE)
	return (allowmobs && reagents && can_inject())

/mob/living/is_drawable(allowmobs = TRUE)
	return (allowmobs && reagents && can_inject())

/mob/living/proc/get_organ_target()
	var/mob/shooter = src
	var/t = shooter.zone_selected
	if ((t in list( BODY_ZONE_PRECISE_EYES, BODY_ZONE_PRECISE_MOUTH )))
		t = BODY_ZONE_HEAD
	var/def_zone = ran_zone(t)
	return def_zone


/mob/living/proc/updatehealth()
	if(status_flags & GODMODE)
		return
	health = maxHealth - getOxyLoss() - getToxLoss() - getFireLoss() - getBruteLoss() - getCloneLoss()
	staminaloss = getStaminaLoss()
	update_stat()
	med_hud_set_health()
	med_hud_set_status()

//proc used to ressuscitate a mob
/mob/living/proc/revive(full_heal = FALSE, admin_revive = FALSE)
	SEND_SIGNAL(src, COMSIG_LIVING_REVIVE, full_heal, admin_revive)
	if(full_heal)
		fully_heal(admin_revive)
	if(stat == DEAD && can_be_revived()) //in some cases you can't revive (e.g. no brain)
		GLOB.dead_mob_list -= src
		GLOB.alive_mob_list += src
		suiciding = 0
		set_stat(UNCONSCIOUS) //the mob starts unconscious
		if(!eye_blind)
			blind_eyes(1)
		updatehealth() //then we check if the mob should wake up.
		update_sight()
		clear_alert("not_enough_oxy")
		reload_fullscreen()
		. = 1
		if(mind)
			for(var/S in mind.spell_list)
				var/obj/effect/proc_holder/spell/spell = S
				spell.updateButtonIcon()

//proc used to remove all immobilisation effects + reset stamina
/mob/living/proc/remove_CC(should_update_mobility = TRUE)
	SetAllImmobility(0, FALSE)
	setStaminaLoss(0)
	SetUnconscious(0, FALSE)
	if(should_update_mobility)
		update_mobility()

//proc used to completely heal a mob.
/mob/living/proc/fully_heal(admin_revive = FALSE)
	restore_blood()
	setToxLoss(0, 0) //zero as second argument not automatically call updatehealth().
	setOxyLoss(0, 0)
	setCloneLoss(0, 0)
	setStaminaLoss(0, 0)
	SetUnconscious(0, FALSE)
	set_disgust(0)
	SetAllImmobility(0, FALSE)
	SetSleeping(0, FALSE)
	radiation = 0
	set_nutrition(NUTRITION_LEVEL_FED + 50)
	bodytemperature = BODYTEMP_NORMAL
	set_blindness(0)
	set_blurriness(0)
	cure_nearsighted()
	cure_blind()
	cure_husk()
	hallucination = 0
	heal_overall_damage(INFINITY, INFINITY, INFINITY, FALSE, FALSE, TRUE, INFINITY) //heal brute and burn dmg on both organic and robotic limbs, and update health right away.
	ExtinguishMob()
	fire_stacks = 0
	confused = 0
	update_mobility()
	update_movespeed()
	//Heal all organs
	if(iscarbon(src))
		var/mob/living/carbon/C = src
		if(C.internal_organs)
			for(var/organ in C.internal_organs)
				var/obj/item/organ/O = organ
				O.setOrganDamage(0)

//proc called by revive(), to check if we can actually ressuscitate the mob (we don't want to revive him and have him instantly die again)
/mob/living/proc/can_be_revived()
	. = 1
	if(health <= HEALTH_THRESHOLD_DEAD)
		return 0

/mob/living/proc/update_damage_overlays()
	return

/mob/living/proc/on_entered(atom/movable/AM)
	SIGNAL_HANDLER
	for(var/i in get_equipped_items())
		var/obj/item/item = i
		SEND_SIGNAL(item, COMSIG_ITEM_WEARERCROSSED, AM)

/mob/living/proc/makeTrail(turf/target_turf, turf/start, direction)
	if(!has_gravity() || !isturf(start) || !blood_volume)
		return
	var/blood_exists = locate(/obj/effect/decal/cleanable/trail_holder) in start

	var/trail_type = getTrail()
	if(!trail_type)
		return

	var/brute_ratio = round(getBruteLoss() / maxHealth, 0.1)
	if(get_blood(TRUE) < max(BLOOD_VOLUME_NORMAL*(1 - brute_ratio * 0.25), 0))//don't leave trail if blood volume below a threshold
		return

	var/bleed_amount = bleedDragAmount()
	blood_volume = max(blood_volume - bleed_amount, 0) 					//that depends on our brute damage.
	var/newdir = get_dir(target_turf, start)
	if(newdir != direction)
		newdir = newdir | direction
		if(newdir == (NORTH|SOUTH))
			newdir = NORTH
		else if(newdir == (EAST|WEST))
			newdir = EAST
	if((newdir in GLOB.cardinals) && (prob(50)))
		newdir = turn(get_dir(target_turf, start), 180)
	if(!blood_exists)
		new /obj/effect/decal/cleanable/trail_holder(start, get_static_viruses())

	for(var/obj/effect/decal/cleanable/trail_holder/TH in start)
		if((!(newdir in TH.existing_dirs) || trail_type == "trails_1" || trail_type == "trails_2") && TH.existing_dirs.len <= 16) //maximum amount of overlays is 16 (all light & heavy directions filled)
			TH.existing_dirs += newdir
			TH.add_overlay(image('icons/effects/blood.dmi', trail_type, dir = newdir))
			TH.transfer_mob_blood_dna(src)

/mob/living/carbon/human/makeTrail(turf/T)
	if((NOBLOOD in dna.species.species_traits) || !is_bleeding() || bleedsuppress)
		return
	..()

///Returns how much blood we're losing from being dragged a tile, from [mob/living/proc/makeTrail]
/mob/living/proc/bleedDragAmount()
	var/brute_ratio = round(getBruteLoss() / maxHealth, 0.1)
	return max(1, brute_ratio * 2)

/mob/living/carbon/bleedDragAmount()
	var/bleed_amount = 0
	for(var/i in all_wounds)
		var/datum/wound/iter_wound = i
		bleed_amount += iter_wound.drag_bleed_amount()
	return bleed_amount

/mob/living/proc/getTrail()
	if(getBruteLoss() < 300)
		return pick("ltrails_1", "ltrails_2")
	else
		return pick("trails_1", "trails_2")

/mob/living/experience_pressure_difference(pressure_difference, direction, pressure_resistance_prob_delta = 0)
	if(buckled)
		return
	if(client && client.move_delay >= world.time + world.tick_lag*2)
		pressure_resistance_prob_delta -= 30

	var/list/turfs_to_check = list()

	if(has_limbs)
		var/turf/T = get_step(src, angle2dir(dir2angle(direction)+90))
		if (T)
			turfs_to_check += T

		T = get_step(src, angle2dir(dir2angle(direction)-90))
		if(T)
			turfs_to_check += T

		for(var/t in turfs_to_check)
			T = t
			if(T.density)
				pressure_resistance_prob_delta -= 20
				continue
			for (var/atom/movable/AM in T)
				if (AM.density && AM.anchored)
					pressure_resistance_prob_delta -= 20
					break
	if(!force_moving)
		..(pressure_difference, direction, pressure_resistance_prob_delta)

/mob/living/can_resist()
	return CheckResistCooldown() && CHECK_MOBILITY(src, MOBILITY_RESIST)

/// Resist verb for attempting to get out of whatever is restraining your motion. Gives you resist clickdelay if do_resist() returns true.
/mob/living/verb/resist()
	set name = "Resist"
	set category = "IC"

	if(!can_resist())
		return

	if(do_resist())
		MarkResistTime()
		DelayNextAction(CLICK_CD_RESIST)

/// The actual proc for resisting. Return TRUE to give CLICK_CD_RESIST clickdelay.
/mob/living/proc/do_resist()
	set waitfor = FALSE			// some of these sleep.
	SEND_SIGNAL(src, COMSIG_LIVING_RESIST, src)
	//resisting grabs (as if it helps anyone...)
	// only works if you're not cuffed.
	if(!restrained(ignore_grab = TRUE) && pulledby)
		var/old_gs = pulledby.grab_state
		attempt_resist_grab(FALSE)
		// Return as we should only resist one thing at a time. Give clickdelay if the grab wasn't passive.
		return old_gs? TRUE : FALSE

	// unbuckling yourself. stops the chain if you try it.
	if(buckled)
		log_combat(src, buckled, "resisted buckle")
		return resist_buckle()

	//Breaking out of a container (Locker, sleeper, cryo...)
	if(isobj(loc))
		var/obj/C = loc
		C.container_resist(src)
		// This shouldn't give clickdelays sometime (e.g. going out of a mech/unwelded and unlocked locker/disposals bin/etc) but there's so many overrides that I am not going to bother right now.
		return TRUE

	if(CHECK_MOBILITY(src, MOBILITY_MOVE))
		if(on_fire)
			resist_fire() //stop, drop, and roll
			// Give clickdelay
			return TRUE

	if(resting) //cit change - allows resisting out of resting
		resist_a_rest() // ditto
		// DO NOT GIVE CLCIKDELAY - resist_a_rest() handles spam prevention. Somewhat.
		return FALSE

	if(CHECK_MOBILITY(src, MOBILITY_USE) && resist_embedded()) //Citadel Change for embedded removal memes - requires being able to use items.
		// DO NOT GIVE DEFAULT CLICKDELAY - This is a combat action.
		DelayNextAction(CLICK_CD_MELEE)
		return FALSE

	resist_restraints() //trying to remove cuffs.
	// DO NOT GIVE CLICKDELAY
	return FALSE

/// Proc to resist a grab. moving_resist is TRUE if this began by someone attempting to move. Return FALSE if still grabbed/failed to break out. Use this instead of resist_grab() directly.
/mob/proc/attempt_resist_grab(moving_resist, forced, log = TRUE)
	if(!pulledby)	//not being grabbed
		return TRUE
	var/old_gs = pulledby.grab_state		//how strong the grab is
	var/old_pulled = pulledby
	var/success = do_resist_grab(moving_resist, forced)
	if(log)
		log_combat(src, old_pulled, "[success? "successfully broke free of" : "failed to resist"] a grab of strength [old_gs][moving_resist? " (moving)":""][forced? " (forced)":""]")
	return success

/*!
 * Proc that actually does the grab resisting. Return TRUE if successful. Does not check that a grab exists! Use attempt_resist_grab() instead of this in general!
 * Forced is if something other than the user mashing movement keys/pressing resist button did it, silent is if it makes messages (like "attempted to resist" and "broken free").
 * Forced does NOT force success!
 */
/mob/proc/do_resist_grab(moving_resist, forced, silent = FALSE)
	return FALSE

/mob/living/do_resist_grab(moving_resist, forced, silent = FALSE)
	. = ..()
	if(pulledby.grab_state > GRAB_PASSIVE)
		if(CHECK_MOBILITY(src, MOBILITY_RESIST) && prob((src.skill_value(SKILL_UNARMED)*30)/(pulledby.grab_state*pulledby.skill_value(SKILL_UNARMED))))
			pulledby.visible_message(span_danger("[src] has broken free of [pulledby]'s grip!"),
				span_danger("[src] has broken free of your grip!"), target = src,
				target_message = span_danger("You have broken free of [pulledby]'s grip!"))
			pulledby.stop_pulling()
			return TRUE
		else if(moving_resist && client) //we resisted by trying to move // this is a horrible system and whoever thought using client instead of mob is okay is not an okay person
			client.move_delay = world.time + 20
		pulledby.visible_message(span_danger("[src] resists against [pulledby]'s grip!"),
			span_danger("[src] resists against your grip!"), target = src,
			target_message = span_danger("You resist against [pulledby]'s grip!"))
	else
		pulledby.stop_pulling()
		return TRUE

/mob/living/proc/resist_buckle()
	buckled?.user_unbuckle_mob(src,src)

/mob/living/proc/resist_fire()
	return

/mob/living/proc/resist_restraints()
	return

/mob/living/proc/get_visible_name()
	return name

/mob/living/update_gravity(has_gravity,override = 0)
	. = ..()
	if(!SSticker.HasRoundStarted())
		return
	if(has_gravity)
		if(has_gravity == 1)
			clear_alert("gravity")
		else
			if(has_gravity >= GRAVITY_DAMAGE_TRESHOLD)
				throw_alert("gravity", /obj/screen/alert/veryhighgravity)
			else
				throw_alert("gravity", /obj/screen/alert/highgravity)
	else
		throw_alert("gravity", /obj/screen/alert/weightless)
	if(!override && !is_flying())
		INVOKE_ASYNC(src, TYPE_PROC_REF(/atom/movable, float), !has_gravity)

/mob/living/float(on)
	if(throwing)
		return
	var/fixed = 0
	if(anchored || (buckled && buckled.anchored))
		fixed = 1
	if(on && !(movement_type & FLOATING) && !fixed)
		animate(src, pixel_y = pixel_y + 2, time = 10, loop = -1)
		sleep(10)
		animate(src, pixel_y = pixel_y - 2, time = 10, loop = -1)
		setMovetype(movement_type | FLOATING)
	else if(((!on || fixed) && (movement_type & FLOATING)))
		animate(src, pixel_y = get_standard_pixel_y_offset(lying), time = 10)
		setMovetype(movement_type & ~FLOATING)

// The src mob is trying to strip an item from someone
// Override if a certain type of mob should be behave differently when stripping items (can't, for example)
/mob/living/stripPanelUnequip(obj/item/what, mob/who, where)
	if(HAS_TRAIT(what, TRAIT_NODROP))
		to_chat(src, span_warning("You can't remove \the [what.name], it appears to be stuck!"))
		return
	var/strip_mod = 1
	var/strip_silence = FALSE
	if (ishuman(src)) //carbon doesn't actually wear gloves
		var/mob/living/carbon/C = src
		var/obj/item/clothing/gloves/g = C.gloves
		if (istype(g))
			strip_mod = g.strip_mod
			strip_silence = g.strip_silence
	if(!strip_silence)
		who.visible_message(span_danger("[src] tries to remove [who]'s [what.name]."), \
					span_userdanger("[src] tries to remove your [what.name]."), target = src,
					target_message = span_danger("You try to remove [who]'s [what.name]."))
		what.add_fingerprint(src)
		if(ishuman(who))
			var/mob/living/carbon/human/victim_human = who
			if(victim_human.key && !victim_human.client) // AKA braindead
				if(victim_human.stat <= SOFT_CRIT && LAZYLEN(victim_human.afk_thefts) <= AFK_THEFT_MAX_MESSAGES)
					var/list/new_entry = list(list(src.name, "tried unequipping your [what]", world.time))
					LAZYADD(victim_human.afk_thefts, new_entry)
	else
		to_chat(src,span_notice("You try to remove [who]'s [what.name]."))
		what.add_fingerprint(src)
	if(do_mob(src, who, round(what.strip_delay / strip_mod), ignorehelditem = TRUE))
		if(what && Adjacent(who))
			if(islist(where))
				var/list/L = where
				if(what == who.get_item_for_held_index(L[2]))
					if(who.dropItemToGround(what))
						if(!put_in_hands(what))
							what.forceMove(drop_location())
						log_combat(src, who, "stripped [what] off")
			if(what == who.get_item_by_slot(where))
				if(who.dropItemToGround(what))
					if(!can_hold_items() || !put_in_hands(what))
						what.forceMove(drop_location())
					log_combat(src, who, "stripped [what] off")

	if(Adjacent(who)) //update inventory window
		who.show_inv(src)
	else
		src << browse(null,"window=mob[REF(who)]")

	who.update_equipment_speed_mods() // Updates speed in case stripped speed affecting item
	who.handle_equipment_stiffness()

// The src mob is trying to place an item on someone
// Override if a certain mob should be behave differently when placing items (can't, for example)
/mob/living/stripPanelEquip(obj/item/what, mob/who, where)
	what = src.get_active_held_item()
	if(what && HAS_TRAIT(what, TRAIT_NODROP))
		to_chat(src, span_warning("You can't put \the [what.name] on [who], it's stuck to your hand!"))
		return
	if(what)
		var/list/where_list
		var/final_where

		if(islist(where))
			where_list = where
			final_where = where[1]
		else
			final_where = where

		if(!what.mob_can_equip(who, src, final_where, TRUE, TRUE))
			to_chat(src, span_warning("\The [what.name] doesn't fit in that place!"))
			return

		if(ishuman(who))
			var/mob/living/carbon/human/victim_human = who
			if(victim_human.key && !victim_human.client) // AKA braindead
				if(victim_human.stat <= SOFT_CRIT && LAZYLEN(victim_human.afk_thefts) <= AFK_THEFT_MAX_MESSAGES)
					var/list/new_entry = list(list(src.name, "tried equipping you with [what]", world.time))
					LAZYADD(victim_human.afk_thefts, new_entry)

		who.visible_message(span_notice("[src] tries to put [what] on [who]."),
			span_notice("[src] tries to put [what] on you."), target = src,
			target_message = span_notice("You try to put [what] on [who]."))
		if(do_mob(src, who, what.equip_delay_other))
			if(what && Adjacent(who) && what.mob_can_equip(who, src, final_where, TRUE, TRUE))
				if(temporarilyRemoveItemFromInventory(what))
					if(where_list)
						if(!who.put_in_hand(what, where_list[2]))
							what.forceMove(get_turf(who))
					else
						who.equip_to_slot(what, where, TRUE)

/mob/living/singularity_pull(S, current_size)
	..()
	if(current_size >= STAGE_SIX)
		throw_at(S, 14, 3, src, TRUE)
	else
		step_towards(src,S)

/mob/living/proc/do_jitter_animation(jitteriness)
	var/amplitude = min(4, (jitteriness/100) + 1)
	var/pixel_x_diff = rand(-amplitude, amplitude)
	var/pixel_y_diff = rand(-amplitude/3, amplitude/3)
	var/final_pixel_x = get_standard_pixel_x_offset(lying)
	var/final_pixel_y = get_standard_pixel_y_offset(lying)
	animate(src, pixel_x = pixel_x + pixel_x_diff, pixel_y = pixel_y + pixel_y_diff , time = 2, loop = 6)
	animate(pixel_x = final_pixel_x , pixel_y = final_pixel_y , time = 2)
	floating_need_update = TRUE

/mob/living/proc/get_temperature(datum/gas_mixture/environment)
	var/loc_temp = environment ? environment.return_temperature() : T0C
	if(isobj(loc))
		var/obj/oloc = loc
		var/obj_temp = oloc.return_temperature()
		if(obj_temp != null)
			loc_temp = obj_temp
	else if(isspaceturf(get_turf(src)))
		var/turf/heat_turf = get_turf(src)
		loc_temp = heat_turf.return_temperature()
	return loc_temp

/mob/living/proc/get_standard_pixel_x_offset(lying = 0)
	return initial(pixel_x)

/mob/living/proc/get_standard_pixel_y_offset(lying = 0)
	return initial(pixel_y)

/mob/living/cancel_camera()
	..()
	cameraFollow = null

/mob/living/proc/can_track(mob/living/user)
	//basic fast checks go first. When overriding this proc, I recommend calling ..() at the end.
	var/turf/T = get_turf(src)
	if(!T)
		return 0
	if(is_centcom_level(T.z)) //dont detect mobs on centcom
		return 0
	if(is_away_level(T.z))
		return 0
	if(user != null && src == user)
		return 0
	if(invisibility || alpha == 0)//cloaked
		return 0
	if(digitalcamo || digitalinvis)
		return 0

	// Now, are they viewable by a camera? (This is last because it's the most intensive check)
	if(!near_camera(src))
		return 0

	return 1

//used in datum/reagents/reaction() proc
/mob/living/proc/get_permeability_protection(list/target_zones)
	return 0

/mob/living/proc/harvest(mob/living/user) //used for extra objects etc. in butchering
	return

/mob/living/canUseTopic(atom/movable/M, be_close=FALSE, no_dextery=FALSE, no_tk=FALSE)
	if(incapacitated())
		to_chat(src, span_warning("You can't do that right now!"))
		return FALSE
	if(be_close && !in_range(M, src))
		to_chat(src, span_warning("You are too far away!"))
		return FALSE
	if(!no_dextery)
		to_chat(src, span_warning("You don't have the dexterity to do this!"))
		return FALSE
	return TRUE

/mob/living/proc/can_use_guns(obj/item/G)//actually used for more than guns!
	if(G.trigger_guard != TRIGGER_GUARD_ALLOW_ALL && !IsAdvancedToolUser())
		to_chat(src, span_warning("You don't have the dexterity to do this!"))
		return FALSE
	return TRUE

/mob/living/proc/update_stamina()
	return

/mob/living/carbon/alien/update_stamina()
	return

/mob/living/proc/owns_soul()
	if(mind)
		return mind.soulOwner == mind
	return TRUE

/mob/living/proc/return_soul()
	hellbound = 0
	if(mind)
		var/datum/antagonist/devil/devilInfo = mind.soulOwner.has_antag_datum(/datum/antagonist/devil)
		if(devilInfo)//Not sure how this could be null, but let's just try anyway.
			devilInfo.remove_soul(mind)
		mind.soulOwner = mind

/mob/living/proc/has_bane(banetype)
	var/datum/antagonist/devil/devilInfo = is_devil(src)
	return devilInfo && banetype == devilInfo.bane

/mob/living/proc/check_weakness(obj/item/weapon, mob/living/attacker)
	if(mind && mind.has_antag_datum(/datum/antagonist/devil))
		return check_devil_bane_multiplier(weapon, attacker)
	return 1

/mob/living/proc/check_acedia()
	if(mind && mind.has_objective(/datum/objective/sintouched/acedia))
		return TRUE
	return FALSE

/mob/living/throw_at(atom/target, range, speed, mob/thrower, spin=1, diagonals_first = 0, datum/callback/callback, force = MOVE_FORCE_STRONG, gentle = FALSE, quickstart = TRUE)
	stop_pulling()
	. = ..()

// Called when we are hit by a bolt of polymorph and changed
// Generally the mob we are currently in is about to be deleted
/mob/living/proc/wabbajack_act(mob/living/new_mob)
	new_mob.name = real_name
	new_mob.real_name = real_name

	if(mind)
		mind.transfer_to(new_mob)
	else
		transfer_ckey(new_mob)

	for(var/para in hasparasites())
		var/mob/living/simple_animal/hostile/guardian/G = para
		G.summoner = new_mob
		G.Recall()
		to_chat(G, span_holoparasite("Your summoner has changed form!"))

/mob/living/rad_act(amount)
	. = ..()

	if(!amount || (amount < RAD_MOB_SKIN_PROTECTION))
		return
	if(HAS_TRAIT(src, TRAIT_75_RAD_RESIST))
		return

	amount -= RAD_BACKGROUND_RADIATION // This will always be at least 1 because of how skin protection is calculated

	if(HAS_TRAIT(src, TRAIT_75_RAD_RESIST))
		amount *= 0.25
	else if(HAS_TRAIT(src, TRAIT_50_RAD_RESIST))
		amount *= 0.5

	var/blocked = getarmor(null, "rad")
	apply_effect((amount*RAD_MOB_COEFFICIENT)/max(1, (radiation**2)*RAD_OVERDOSE_REDUCTION), EFFECT_IRRADIATE, blocked)
	if(HAS_TRAIT(src,TRAIT_RADIMMUNE)) //prevents you from being burned by rads if radimmune but you can still accumulate
		return
	if(amount > RAD_BURN_THRESHOLD)
		apply_damage((amount-RAD_BURN_THRESHOLD)/RAD_BURN_THRESHOLD, BURN, null, blocked)


/mob/living/anti_magic_check(magic = TRUE, holy = FALSE, chargecost = 1, self = FALSE)
	. = ..()
	if(.)
		return
	if((magic && HAS_TRAIT(src, TRAIT_ANTIMAGIC)) || (holy && HAS_TRAIT(src, TRAIT_HOLY)))
		return src

/mob/living/proc/fakefireextinguish()
	return

/mob/living/proc/fakefire()
	return



//Mobs on Fire
/mob/living/proc/IgniteMob()
	if(fire_stacks > 0 && !on_fire)
		on_fire = 1
		visible_message(span_warning("[src] catches fire!"), \
						span_userdanger("You're set on fire!"))
		new/obj/effect/dummy/lighting_obj/moblight/fire(src)
		throw_alert("fire", /obj/screen/alert/fire)
		update_fire()
		SEND_SIGNAL(src, COMSIG_LIVING_IGNITED,src)
		return TRUE
	return FALSE

/mob/living/proc/ExtinguishMob()
	if(on_fire)
		on_fire = 0
		fire_stacks = 0
		for(var/obj/effect/dummy/lighting_obj/moblight/fire/F in src)
			qdel(F)
		clear_alert("fire")
		SEND_SIGNAL(src, COMSIG_CLEAR_MOOD_EVENT, "on_fire")
		SEND_SIGNAL(src, COMSIG_LIVING_EXTINGUISHED, src)
		update_fire()

/mob/living/proc/adjust_fire_stacks(add_fire_stacks) //Adjusting the amount of fire_stacks we have on person
	fire_stacks = clamp(fire_stacks + add_fire_stacks, -20, 20)
	if(on_fire && fire_stacks <= 0)
		ExtinguishMob()

//Share fire evenly between the two mobs
//Called in MobBump() and Crossed()
/mob/living/proc/spreadFire(mob/living/L)
	if(!istype(L))
		return
	var/L_old_on_fire = L.on_fire

	if(on_fire) //Only spread fire stacks if we're on fire
		fire_stacks /= 2
		L.fire_stacks += fire_stacks
		if(L.IgniteMob())
			log_game("[key_name(src)] bumped into [key_name(L)] and set them on fire")

	if(L_old_on_fire) //Only ignite us and gain their stacks if they were onfire before we bumped them
		L.fire_stacks /= 2
		fire_stacks += L.fire_stacks
		IgniteMob()

//Mobs on Fire end

// used by secbot and monkeys Crossed
/mob/living/proc/knockOver(mob/living/carbon/C)
	if(C.key) //save us from monkey hordes
		C.visible_message("<span class='warning'>[pick( \
						"[C] dives out of [src]'s way!", \
						"[C] stumbles over [src]!", \
						"[C] jumps out of [src]'s path!", \
						"[C] trips over [src] and falls!", \
						"[C] topples over [src]!", \
						"[C] leaps out of [src]'s way!")]</span>")
	C.DefaultCombatKnockdown(40)

/mob/living/ConveyorMove()
	if((movement_type & FLYING) && !stat)
		return
	..()

/mob/living/can_be_pulled()
	return ..() && !(buckled && buckled.buckle_prevents_pull)

/mob/living/proc/AddAbility(obj/effect/proc_holder/A)
	if(!A)
		return
	abilities.Add(A)
	A.on_gain(src)
	if(A.has_action)
		A.action.Grant(src)

/mob/living/proc/RemoveAbility(obj/effect/proc_holder/A)
	if(!A)
		return
	abilities.Remove(A)
	A.on_lose(src)
	if(A.action)
		A.action.Remove(src)

/mob/living/proc/add_abilities_to_panel()
	var/list/L = list()
	for(var/obj/effect/proc_holder/A in abilities)
		L[++L.len] = list("[A.panel]",A.get_panel_text(),A.name,"[REF(A)]")
	return L

/mob/living/lingcheck()
	if(mind)
		var/datum/antagonist/changeling/changeling = mind.has_antag_datum(/datum/antagonist/changeling)
		if(changeling)
			if(changeling.changeling_speak)
				return LINGHIVE_LING
			return LINGHIVE_OUTSIDER
	if(mind && mind.linglink)
		return LINGHIVE_LINK
	return LINGHIVE_NONE

/mob/living/MouseDrop(mob/over)
	. = ..()
	var/mob/living/user = usr
	if(!istype(over) || !istype(user))
		return
	if(!over.Adjacent(src) || (user != src) || !canUseTopic(over))
		return

/mob/living/proc/get_static_viruses() //used when creating blood and other infective objects
	if(!LAZYLEN(diseases))
		return
	var/list/datum/disease/result = list()
	for(var/datum/disease/D in diseases)
		var/static_virus = D.Copy()
		result += static_virus
	return result

/mob/living/reset_perspective(atom/A)
	if(..())
		update_sight()
		if(client.eye && client.eye != src)
			var/atom/AT = client.eye
			AT.get_remote_view_fullscreens(src)
		else
			clear_fullscreen("remote_view", 0)
		update_pipe_vision()

/mob/living/update_mouse_pointer()
	..()
	if (client && ranged_ability && ranged_ability.ranged_mousepointer)
		client.mouse_pointer_icon = ranged_ability.ranged_mousepointer

/mob/living/vv_edit_var(var_name, var_value)
	switch(var_name)
		if (NAMEOF(src, maxHealth))
			if (!isnum(var_value) || var_value <= 0)
				return FALSE
		if(NAMEOF(src, stat))
			if((stat == DEAD) && (var_value < DEAD))//Bringing the dead back to life
				GLOB.dead_mob_list -= src
				GLOB.alive_mob_list += src
			if((stat < DEAD) && (var_value == DEAD))//Kill he
				GLOB.alive_mob_list -= src
				GLOB.dead_mob_list += src
		if(NAMEOF(src, health)) //this doesn't work. gotta use procs instead.
			return FALSE
	. = ..()
	switch(var_name)
		if(NAMEOF(src, eye_blind))
			set_blindness(var_value)
		if(NAMEOF(src, eye_blurry))
			set_blurriness(var_value)
		if(NAMEOF(src, maxHealth))
			updatehealth()
		if(NAMEOF(src, resize))
			update_transform()
		if(NAMEOF(src, lighting_alpha))
			sync_lighting_plane_alpha()

/mob/living/proc/do_adrenaline(
			stamina_boost = 150,
			put_on_feet = TRUE,
			clamp_unconscious_to = 0,
			clamp_immobility_to = 0,
			reset_misc = TRUE,
			healing_chems = list(/datum/reagent/medicine/inaprovaline = 3, /datum/reagent/medicine/synaptizine = 10, /datum/reagent/medicine/regen_jelly = 10, /datum/reagent/medicine/stimulants = 10),
			message = span_boldnotice("You feel a surge of energy!"),
			stamina_buffer_boost = 0,				//restores stamina buffer rather than just health
			scale_stamina_loss_recovery,			//defaults to null. if this is set, restores loss * this stamina. make sure it's a fraction.
			stamina_loss_recovery_bypass = 0		//amount of stamina loss to ignore during calculation
		)
	to_chat(src, message)
	if(AmountSleeping() > clamp_unconscious_to)
		SetSleeping(clamp_unconscious_to)
	if(AmountUnconscious() > clamp_unconscious_to)
		SetUnconscious(clamp_unconscious_to)
	HealAllImmobilityUpTo(clamp_immobility_to)
	adjustStaminaLoss(min(0, -stamina_boost))
	adjustStaminaLossBuffered(min(0, -stamina_buffer_boost))
	if(scale_stamina_loss_recovery)
		adjustStaminaLoss(min(-((getStaminaLoss() - stamina_loss_recovery_bypass) * scale_stamina_loss_recovery), 0))
	if(put_on_feet)
		set_resting(FALSE, TRUE, FALSE)
	if(reset_misc)
		stuttering = 0
	updatehealth()
	update_stamina()
	update_mobility()
	if(healing_chems)
		reagents.add_reagent_list(healing_chems)

/mob/living/canface()
	return ..() && CHECK_MOBILITY(src, MOBILITY_MOVE)

/mob/living/proc/set_gender(ngender = NEUTER, silent = FALSE, update_icon = TRUE, forced = FALSE)
	if(forced || (!ckey || client?.prefs.cit_toggles & (ngender == FEMALE ? FORCED_FEM : FORCED_MASC)))
		gender = ngender
		return TRUE
	return FALSE

/mob/living/vv_get_header()
	. = ..()
	var/refid = REF(src)
	. += {"
		<br><font size='1'>[VV_HREF_TARGETREF_1V(refid, VV_HK_BASIC_EDIT, "[ckey || "no ckey"]", NAMEOF(src, ckey))] / [VV_HREF_TARGETREF_1V(refid, VV_HK_BASIC_EDIT, "[real_name || "no real name"]", NAMEOF(src, real_name))]</font>
		<br><font size='1'>
			BRUTE:<font size='1'><a href='byond://?_src_=vars;[HrefToken()];mobToDamage=[refid];adjustDamage=brute' id='brute'>[getBruteLoss()]</a>
			FIRE:<font size='1'><a href='byond://?_src_=vars;[HrefToken()];mobToDamage=[refid];adjustDamage=fire' id='fire'>[getFireLoss()]</a>
			TOXIN:<font size='1'><a href='byond://?_src_=vars;[HrefToken()];mobToDamage=[refid];adjustDamage=toxin' id='toxin'>[getToxLoss()]</a>
			OXY:<font size='1'><a href='byond://?_src_=vars;[HrefToken()];mobToDamage=[refid];adjustDamage=oxygen' id='oxygen'>[getOxyLoss()]</a>
			CLONE:<font size='1'><a href='byond://?_src_=vars;[HrefToken()];mobToDamage=[refid];adjustDamage=clone' id='clone'>[getCloneLoss()]</a>
			BRAIN:<font size='1'><a href='byond://?_src_=vars;[HrefToken()];mobToDamage=[refid];adjustDamage=brain' id='brain'>[getOrganLoss(ORGAN_SLOT_BRAIN)]</a>
			STAMINA:<font size='1'><a href='byond://?_src_=vars;[HrefToken()];mobToDamage=[refid];adjustDamage=stamina' id='stamina'>[getStaminaLoss()]</a>
		</font>
	"}



/mob/living/set_stat(new_stat)
	. = ..()
	if(isnull(.))
		return
	update_mobility()


/mob/living/verb/give(mob/living/target in (view(1) - usr))
	set category = "IC"
	set name = "Give"
	do_give(target)


/mob/living/proc/do_give(mob/living/target)
	if(incapacitated() || !Adjacent(target))
		return

	if(INTERACTING_WITH(src, target))
		to_chat(src, span_warning("You are already interacting with [target]."))
		return

	if(!target.can_hold_items())
		to_chat(src, span_warning("[target] does not have the ability to hold items."))
		return

	var/obj/item/gift = get_active_held_item()
	if(!gift)
		gift = get_inactive_held_item()
		if(!gift)
			to_chat(src, span_warning("You don't have anything in your hands to give."))
			return

	if(SEND_SIGNAL(target, COMSIG_COMBAT_MODE_CHECK, COMBAT_MODE_ACTIVE))
		to_chat(src, span_warning("[target] is too busy fighting!"))
		return

	if(target.incapacitated())
		to_chat(src, span_warning("[target] is in no condition to handle items!"))
		return

	if(!gift.mob_can_equip(target, src, SLOT_HANDS, TRUE, TRUE))
		to_chat(src, span_warning("[target] is unable to receive \a [gift] right now."))
		return

	to_chat(src, span_notice("You offer \a [gift] to [target] ."))

	START_INTERACTING_WITH(src, target)
	var/target_answer = alert(target, "[src] wants to give you \a [gift]. Will you accept it?", "An offer you can't refuse", "Accept", "Visibly reject", "Quietly ignore")
	STOP_INTERACTING_WITH(src, target)

	if(QDELING(src) || QDELETED(target) || QDELETED(gift) || incapacitated() || target.incapacitated() || !target.can_hold_items())
		return

	switch(target_answer)
		if("Accept")
			if(!Adjacent(target))
				to_chat(src, span_warning("[target] is out of range."))
				to_chat(target, span_warning("\The [src] is out of range."))
				return
		if("Visibly reject")
			if(!Adjacent(target))
				to_chat(src, span_warning("[target] is out of range."))
				to_chat(target, span_warning("\The [src] is out of range."))
				return
			target.visible_message("<b>[target]</b> visibly rejects [src]'s offer of \a [gift].")
			return
		else
			if(!Adjacent(target))
				to_chat(src, span_warning("[target] is out of range."))
				return
			to_chat(src, span_notice("[target] does not seem interested in receiving \a [gift] at the moment."))
			return

	if(!is_holding(gift))
		to_chat(src, span_warning("[target] would accept receiving \a [gift], if you were still offering it."))
		to_chat(target, span_warning("\The [src] seems to have given up on passing \the [gift] to you."))
		return

	if(!gift.mob_can_equip(target, src, SLOT_HANDS, TRUE, TRUE))
		to_chat(src, span_warning("[target] is unable to receive \a [gift] right now."))
		to_chat(target, span_warning("\The [src] seems to have given up on passing \the [gift] to you."))
		return

	if(!temporarilyRemoveItemFromInventory(gift))
		visible_message(span_notice("[src] tries to hand over [gift] but it's stuck to them...."))
		return

	target.put_in_hands(gift)
	visible_message(
		"<b>[src]</b> hands [target] \a [gift].",
		span_notice("You give \the [target] a [gift].")
		)


/mob/living/proc/update_water()
	return
