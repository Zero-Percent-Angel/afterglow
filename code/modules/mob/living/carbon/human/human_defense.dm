/mob/living/carbon/human/getarmor(def_zone, type)
	if(def_zone)
		if(isbodypart(def_zone))
			var/obj/item/bodypart/bp = def_zone
			if(bp.body_part)
				return checkarmor(def_zone, type)
		var/obj/item/bodypart/affecting = get_bodypart(ran_zone(def_zone))
		return checkarmor(affecting, type)
		//If a specific bodypart is targetted, check how that bodypart is protected and return the value.

	var/armorval = 0
	var/organnum = 0
	//If you don't specify a bodypart, it checks ALL your bodyparts for protection, and averages out the values
	for(var/X in bodyparts)
		var/obj/item/bodypart/BP = X
		armorval += checkarmor(BP, type)
		organnum++
	return (armorval/max(organnum, 1))


/mob/living/carbon/human/proc/checkarmor(obj/item/bodypart/def_zone, d_type)
	if(!d_type || !def_zone)
		return 0
	var/protection = 0
	var/list/body_parts = list(head, wear_mask, wear_suit, w_uniform, back, gloves, shoes, belt, s_store, glasses, ears, wear_id, wear_neck) //Everything but pockets. Pockets are l_store and r_store. (if pockets were allowed, putting something armored, gloves or hats for example, would double up on the armor)
	for(var/bp in body_parts)
		if(!bp)
			continue
		if(istype(bp, /obj/item/clothing))
			var/obj/item/clothing/C = bp
			if(C.body_parts_covered & def_zone.body_part)
				protection += C.armor.getRating(d_type)
	protection += physiology.armor.getRating(d_type)
	return protection

///Get all the clothing on a specific body part
/mob/living/carbon/human/proc/clothingonpart(obj/item/bodypart/def_zone)
	var/list/covering_part = list()
	var/list/body_parts = list(head, wear_mask, wear_suit, w_uniform, back, gloves, shoes, belt, s_store, glasses, ears, wear_id, wear_neck) //Everything but pockets. Pockets are l_store and r_store. (if pockets were allowed, putting something armored, gloves or hats for example, would double up on the armor)
	for(var/bp in body_parts)
		if(!bp)
			continue
		if(bp && istype(bp , /obj/item/clothing))
			var/obj/item/clothing/C = bp
			if(C.body_parts_covered & def_zone.body_part)
				covering_part += C
	return covering_part

/mob/living/carbon/human/on_hit(obj/item/projectile/P)
	if(dna && dna.species)
		dna.species.on_hit(P, src)


/mob/living/carbon/human/bullet_act(obj/item/projectile/P, def_zone)
	if(dna && dna.species)
		var/spec_return = dna.species.bullet_act(P, src)
		if(spec_return)
			return spec_return

	if(mind) //martial art stuff
		if(mind.martial_art && mind.martial_art.can_use(src)) //Some martial arts users can deflect projectiles!
			var/martial_art_result = mind.martial_art.on_projectile_hit(src, P, def_zone)
			if(!(martial_art_result == BULLET_ACT_HIT))
				return martial_art_result
	//we got hit, let our friends know we're in danger!
	handle_friends(P.firer)
	return ..()

/mob/living/carbon/human/proc/check_martial_melee_block()
	if(mind)
		if(mind.martial_art && prob(mind.martial_art.block_chance) && mind.martial_art.can_use(src) && in_throw_mode && !incapacitated(FALSE, TRUE))
			return TRUE
	return FALSE

/mob/living/carbon/human/hitby(atom/movable/AM, skipcatch = FALSE, hitpush = TRUE, blocked = FALSE, datum/thrownthing/throwingdatum)
	return dna?.species?.spec_hitby(AM, src) || ..()

/mob/living/carbon/human/grabbedby(mob/living/carbon/user, supress_message = 0)
	if(user == src && pulling && !pulling.anchored && grab_state >= GRAB_AGGRESSIVE && (HAS_TRAIT(src, TRAIT_FAT)) && ismonkey(pulling))
		devour_mob(pulling)
	else
		..()

/mob/living/carbon/human/grippedby(mob/living/user, instant = FALSE)
	//we're getting grabbed! let our friends know we're in danger!
	handle_friends(user)
	if(w_uniform)
		w_uniform.add_fingerprint(user)
	..()


/mob/living/carbon/human/attacked_by(obj/item/I, mob/living/user, attackchain_flags = NONE, damage_multiplier = 1, damage_addition)
	if(!I || !user)
		return 0

	var/obj/item/bodypart/affecting
	if(user == src)
		affecting = get_bodypart(check_zone(user.zone_selected)) //stabbing yourself always hits the right target
	else
		affecting = get_bodypart(ran_zone(user.zone_selected))
	var/target_area = parse_zone(check_zone(user.zone_selected)) //our intended target

	SEND_SIGNAL(I, COMSIG_ITEM_ATTACK_ZONE, src, user, affecting)

	SSblackbox.record_feedback("nested tally", "item_used_for_combat", 1, list("[I.force]", "[I.type]"))
	SSblackbox.record_feedback("tally", "zone_targeted", 1, target_area)

	//we got hit, let our friends know we're in danger!
	handle_friends(user)

	// the attacked_by code varies among species
	return dna.species.spec_attacked_by(I, user, affecting, a_intent, src, attackchain_flags, damage_multiplier, damage_addition)

/mob/living/carbon/human/attack_hulk(mob/living/carbon/human/user, does_attack_animation = FALSE)
	if(user.a_intent == INTENT_HARM)
		. = ..(user, TRUE)
		if(.)
			return
		var/hulk_verb_continous = "smashes"
		var/hulk_verb_simple = "smash"
		if(prob(50))
			hulk_verb_continous = "pummels"
			hulk_verb_simple = "pummel"
		playsound(loc, user.dna.species.attack_sound, 25, 1, -1)
		visible_message(span_danger("[user] [hulk_verb_continous] [src]!"), \
						span_userdanger("[user] [hulk_verb_continous] you!"), null, COMBAT_MESSAGE_RANGE, null, user,
						span_danger("You [hulk_verb_simple] [src]!"))
		apply_damage(15, BRUTE, wound_bonus=10)
		return 1

/mob/living/carbon/human/on_attack_hand(mob/user, act_intent = user.a_intent, unarmed_attack_flags)
	. = ..()
	if(.) //To allow surgery to return properly.
		return
	if(ishuman(user))
		var/mob/living/carbon/human/H = user
		dna.species.spec_attack_hand(H, src, null, act_intent, unarmed_attack_flags)

/mob/living/carbon/human/attack_paw(mob/living/carbon/monkey/M)
	if(!M.CheckActionCooldown(CLICK_CD_MELEE))
		return
	M.DelayNextAction()
	var/dam_zone = pick(BODY_ZONE_CHEST, BODY_ZONE_PRECISE_L_HAND, BODY_ZONE_PRECISE_R_HAND, BODY_ZONE_L_LEG, BODY_ZONE_R_LEG)
	var/obj/item/bodypart/affecting = get_bodypart(ran_zone(dam_zone))
	if(!affecting)
		affecting = get_bodypart(BODY_ZONE_CHEST)
	if(M.a_intent == INTENT_HELP)
		return ..() //shaking

	if(M.a_intent == INTENT_DISARM) //Always drop item in hand, if no item, get stunned instead.
		var/obj/item/I = get_active_held_item()
		if(I && dropItemToGround(I))
			playsound(loc, 'sound/weapons/slash.ogg', 25, 1, -1)
			visible_message(span_danger("[M] has disarmed [src]!"), \
					span_userdanger("[M] has disarmed you!"), null, COMBAT_MESSAGE_RANGE, null, M,
					span_danger("You have disarmed [src]!"))
		else if(!M.client || prob(5)) // only natural monkeys get to stun reliably, (they only do it occasionaly)
			playsound(loc, 'sound/weapons/pierce.ogg', 25, 1, -1)
			DefaultCombatKnockdown(100)
			log_combat(M, src, "tackled")
			visible_message(span_danger("[M] has tackled down [src]!"), \
				span_userdanger("[M] has tackled you down!"), null, COMBAT_MESSAGE_RANGE, null, M,
				span_danger("You have tackled [src] down!"))

	if(M.limb_destroyer)
		dismembering_strike(M, affecting.body_zone)

	if(can_inject(M, 1, affecting))//Thick suits can stop monkey bites.
		if(..()) //successful monkey bite, this handles disease contraction.
			var/damage = rand(1, 3)
			apply_damage(damage, BRUTE, affecting, run_armor_check(affecting, "melee"))
		return 1

/mob/living/carbon/human/attack_alien(mob/living/carbon/alien/humanoid/M)
	. = ..()
	if(!.)
		return
	if(M.a_intent == INTENT_HARM)
		if (w_uniform)
			w_uniform.add_fingerprint(M)
		var/damage = prob(90) ? M.meleeSlashHumanPower : 0
		if(!damage)
			playsound(loc, 'sound/weapons/slashmiss.ogg', 50, 1, -1)
			visible_message(span_danger("[M] has lunged at [src]!"), \
				span_userdanger("[M] has lunged at you!"), target = M, \
				target_message = span_danger("You have lunged at [src]!"))
			return 0
		var/obj/item/bodypart/affecting = get_bodypart(ran_zone(M.zone_selected))
		if(!affecting)
			affecting = get_bodypart(BODY_ZONE_CHEST)
		var/armor_block = run_armor_check(affecting, "melee", null, null,10)

		playsound(loc, 'sound/weapons/slice.ogg', 25, 1, -1)
		visible_message(span_danger("[M] has slashed at [src]!"), \
			span_userdanger("[M] has slashed at you!"), target = M, \
			target_message = span_danger("You have slashed at [src]!"))
		log_combat(M, src, "attacked")
		if(!dismembering_strike(M, M.zone_selected)) //Dismemberment successful
			return 1
		apply_damage(damage, BRUTE, affecting, armor_block)

	if(M.a_intent == INTENT_DISARM) //Always drop item in hand, if no item, get stun instead.
		var/obj/item/I = get_active_held_item()
		if(I && dropItemToGround(I))
			playsound(loc, 'sound/weapons/slash.ogg', 25, 1, -1)
			visible_message(span_danger("[M] has disarmed [src]!"), \
					span_userdanger("[M] has disarmed you!"), target = M, \
					target_message = span_danger("You have disarmed [src]!"))
		else
			playsound(loc, 'sound/weapons/pierce.ogg', 25, 1, -1)
			DefaultCombatKnockdown(M.meleeKnockdownPower)
			log_combat(M, src, "tackled")
			visible_message(span_danger("[M] has tackled down [src]!"), \
				span_userdanger("[M] has tackled you down!"), target = M, \
				target_message = span_danger("You have tackled down [src]!"))

/mob/living/carbon/human/attack_larva(mob/living/carbon/alien/larva/L)
	. = ..()
	if(!.) //unsuccessful larva bite.
		return
	var/damage = rand(1, 3)
	if(stat != DEAD)
		L.amount_grown = min(L.amount_grown + damage, L.max_grown)
		var/obj/item/bodypart/affecting = get_bodypart(ran_zone(L.zone_selected))
		if(!affecting)
			affecting = get_bodypart(BODY_ZONE_CHEST)
		var/armor_block = run_armor_check(affecting, "melee")
		apply_damage(damage, BRUTE, affecting, armor_block)


/mob/living/carbon/human/attack_animal(mob/living/simple_animal/M)
	. = ..()
	if(.)
		if (!prob(special_a*4))
			var/damage = .
			if (HAS_TRAIT(src, TRAIT_WILD_HUNTER) && !(M.faction.Find("wastebot") || M.faction.Find("raider") || M.faction.Find("china") || M.faction.Find("raider")))
				damage = damage * 0.2
			var/dam_zone = dismembering_strike(M, pick(BODY_ZONE_CHEST, BODY_ZONE_PRECISE_L_HAND, BODY_ZONE_PRECISE_R_HAND, BODY_ZONE_L_LEG, BODY_ZONE_R_LEG))
			if(!dam_zone) //Dismemberment successful
				return TRUE
			var/obj/item/bodypart/affecting = get_bodypart(ran_zone(dam_zone))
			if(!affecting)
				affecting = get_bodypart(BODY_ZONE_CHEST)
			var/armor = run_armor_check(affecting, "melee", armour_penetration = M.armour_penetration)
			if (!armor && HAS_TRAIT(src, TRAIT_UNARMORED_FIGHTER))
				armor = 35
			var/dt = max(run_armor_check(affecting, "damage_threshold") - M.damage_threshold_penetration_mob, 0)
			apply_damage(damage, M.melee_damage_type, affecting, armor, wound_bonus = M.wound_bonus, bare_wound_bonus = M.bare_wound_bonus, sharpness = M.sharpness, damage_threshold = dt)
		else
			playsound(M, 'sound/weapons/punchmiss.ogg', 25, 1, -1)
			src.visible_message(span_warning("[M]'s attack is dodged by [src]!"), target = M, target_message = span_warning("Your attack was dodged!"))
		handle_friends(M)

/mob/living/carbon/human/attack_slime(mob/living/simple_animal/slime/M)
	. = ..()
	if(!.) //unsuccessful slime attack
		return
	var/damage = rand(5, 25)
	var/wound_mod = -45 // 25^1.4=90, 90-45=45
	if(M.is_adult)
		damage = rand(10, 35)
		wound_mod = -90 // 35^1.4=145, 145-90=55

	var/dam_zone = dismembering_strike(M, pick(BODY_ZONE_HEAD, BODY_ZONE_CHEST, BODY_ZONE_L_ARM, BODY_ZONE_R_ARM, BODY_ZONE_L_LEG, BODY_ZONE_R_LEG))
	if(!dam_zone) //Dismemberment successful
		return 1

	var/obj/item/bodypart/affecting = get_bodypart(ran_zone(dam_zone))
	if(!affecting)
		affecting = get_bodypart(BODY_ZONE_CHEST)
	var/armor_block = run_armor_check(affecting, "melee")
	apply_damage(damage, BRUTE, affecting, armor_block, wound_bonus=wound_mod)

/mob/living/carbon/human/mech_melee_attack(obj/mecha/M)
	if(M.occupant.a_intent == INTENT_HARM)
		if(HAS_TRAIT(M.occupant, TRAIT_PACIFISM))
			to_chat(M.occupant, span_warning("You don't want to harm other living beings!"))
			return
		M.do_attack_animation(src)
		if(M.damtype == "brute")
			step_away(src,M,15)
		var/obj/item/bodypart/temp = get_bodypart(pick(BODY_ZONE_CHEST, BODY_ZONE_CHEST, BODY_ZONE_CHEST, BODY_ZONE_HEAD))
		if(temp)
			var/update = 0
			var/dmg = rand(M.force/2, M.force)
			var/atom/throw_target = get_edge_target_turf(src, M.dir)
			switch(M.damtype)
				if("brute")
					if(M.force > 40) // durand and other heavy mechas
						src.throw_at(throw_target, rand(1,5), 7)
					else if(M.force >= 25 && CHECK_MOBILITY(src, MOBILITY_STAND)) // lightweight mechas like gygax
						src.throw_at(throw_target, rand(1,3), 7)
					update |= temp.receive_damage(dmg, 0)
				if("fire")
					update |= temp.receive_damage(0, dmg)
				if("tox")
					M.mech_toxin_damage(src)
				else
					return
			playsound(src, M.attacksound, 50, 1)
			if(M.attack_knockdown > 0)
				DefaultCombatKnockdown(M.attack_knockdown)
			if(update)
				update_damage_overlays()
			updatehealth()

		visible_message(span_danger("[M.name] has hit [src]!"), \
						span_userdanger("[M.name] has hit you!"), null, COMBAT_MESSAGE_RANGE, target = M,
						target_message = span_danger("You have hit [src]!"))
		log_combat(M.occupant, src, "attacked", M, "(INTENT: [uppertext(M.occupant.a_intent)]) (DAMTYPE: [uppertext(M.damtype)])")

	else
		..()


/mob/living/carbon/human/ex_act(severity, target, origin)
	if(TRAIT_BOMBIMMUNE in dna.species.species_traits)
		return
	..()
	if (!severity || QDELETED(src))
		return
	var/brute_loss = 0
	var/burn_loss = 0
	var/bomb_armor = getarmor(null, "bomb")

	switch (severity)
		if (EXPLODE_DEVASTATE)
			/*if(bomb_armor < EXPLODE_GIB_THRESHOLD) //gibs the mob if their bomb armor is lower than EXPLODE_GIB_THRESHOLD
				for(var/I in contents)
					var/atom/A = I
					if(!QDELETED(A))
						A.ex_act(severity)
				gib()
				return*/
			brute_loss = 150
			var/atom/throw_target = get_edge_target_turf(src, get_dir(src, get_step_away(src, src)))
			throw_at(throw_target, 200, 4)
			damage_clothes(400 - bomb_armor, BRUTE, "bomb")

		if (EXPLODE_HEAVY)
			brute_loss = 60
			burn_loss = 40
			if(bomb_armor)
				brute_loss = 30*(2 - round(bomb_armor*0.01, 0.05))
				burn_loss = 20*(2 - round(bomb_armor*0.01, 0.05))				//damage gets reduced from 120 to up to 60 combined brute+burn
			damage_clothes(200 - bomb_armor, BRUTE, "bomb")
			if (!istype(ears, /obj/item/clothing/ears/earmuffs))
				adjustEarDamage(30, 120)
			var/atom/throw_target = get_edge_target_turf(src, get_dir(src, get_step_away(src, src)))
			throw_at(throw_target, 50, 4)
			adjustStaminaLoss(brute_loss)

		if(EXPLODE_LIGHT)
			brute_loss = 30
			if(bomb_armor)
				brute_loss = 11*(2 - round(bomb_armor*0.01, 0.05))
			damage_clothes(max(50 - bomb_armor, 0), BRUTE, "bomb")
			if (!istype(ears, /obj/item/clothing/ears/earmuffs))
				adjustEarDamage(15,60)
			Knockdown((100 - (bomb_armor * 3)) / 4)		//30ish bomb armor prevents knockdown entirely
			adjustStaminaLoss(brute_loss / 3)

	take_overall_damage(brute_loss,burn_loss)

	//attempt to dismember bodyparts
	if(severity <= 2 || !bomb_armor)
		var/max_limb_loss = round(4/severity) //so you don't lose four limbs at severity 3.
		for(var/X in bodyparts)
			var/obj/item/bodypart/BP = X
			if(prob(15/severity) && !prob(getarmor(BP, "bomb")) && BP.body_zone != BODY_ZONE_HEAD && BP.body_zone != BODY_ZONE_CHEST)
				BP.brute_dam = BP.max_damage
				BP.dismember()
				max_limb_loss--
				if(!max_limb_loss)
					break


/mob/living/carbon/human/blob_act(obj/structure/blob/B)
	if(stat == DEAD)
		return
	show_message(span_userdanger("The blob attacks you!"))
	var/dam_zone = pick(BODY_ZONE_CHEST, BODY_ZONE_PRECISE_L_HAND, BODY_ZONE_PRECISE_R_HAND, BODY_ZONE_L_LEG, BODY_ZONE_R_LEG)
	var/obj/item/bodypart/affecting = get_bodypart(ran_zone(dam_zone))
	apply_damage(5, BRUTE, affecting, run_armor_check(affecting, "melee"))


///Calculates the siemens coeff based on clothing and species, can also restart hearts.
/mob/living/carbon/human/electrocute_act(shock_damage, source, siemens_coeff = 1, flags = NONE)
	//Calculates the siemens coeff based on clothing. Completely ignores the arguments
	if(flags & SHOCK_TESLA) //I hate this entire block. This gets the siemens_coeff for tesla shocks
		if(gloves && gloves.siemens_coefficient <= 0)
			siemens_coeff -= 0.5
		if(wear_suit)
			if(wear_suit.siemens_coefficient == -1)
				siemens_coeff -= 1
			else if(wear_suit.siemens_coefficient <= 0)
				siemens_coeff -= 0.95
		siemens_coeff = max(siemens_coeff, 0)
	else if(!(flags & SHOCK_NOGLOVES)) //This gets the siemens_coeff for all non tesla shocks
		if(gloves)
			siemens_coeff *= gloves.siemens_coefficient
	siemens_coeff *= physiology.siemens_coeff
	. = ..()
	//Don't go further if the shock was blocked/too weak.
	if(!.)
		return
	//Note we both check that the user is in cardiac arrest and can actually heartattack
	//If they can't, they're missing their heart and this would runtime
	if(undergoing_cardiac_arrest() && can_heartattack() && !(flags & SHOCK_ILLUSION))
		if(shock_damage * siemens_coeff >= 1 && prob(25))
			var/obj/item/organ/heart/heart = getorganslot(ORGAN_SLOT_HEART)
			if(heart.Restart() && stat == CONSCIOUS)
				to_chat(src, span_notice("You feel your heart beating again!"))
	electrocution_animation(40)

/mob/living/carbon/human/emp_act(severity)
	. = ..()
	if(. & EMP_PROTECT_CONTENTS)
		return
	var/informed = FALSE
	if(isrobotic(src))
		apply_status_effect(/datum/status_effect/no_combat_mode/robotic_emp, severity / 20)
	severity *= 0.5
	for(var/obj/item/bodypart/L in src.bodyparts)
		if(L.status == BODYPART_ROBOTIC)
			if(!informed)
				to_chat(src, span_userdanger("You feel a sharp pain as your robotic limbs overload."))
				informed = TRUE
			L.receive_damage(0,severity/10)
			Stun(severity*2)

/mob/living/carbon/human/acid_act(acidpwr, acid_volume, bodyzone_hit)
	var/list/damaged = list()
	var/list/inventory_items_to_kill = list()
	var/acidity = acidpwr * min(acid_volume*0.005, 0.1)
	//HEAD//
	if(!bodyzone_hit || bodyzone_hit == BODY_ZONE_HEAD) //only if we didn't specify a zone or if that zone is the head.
		var/obj/item/clothing/head_clothes = null
		if(glasses)
			head_clothes = glasses
		if(wear_mask)
			head_clothes = wear_mask
		if(wear_neck)
			head_clothes = wear_neck
		if(head)
			head_clothes = head
		if(head_clothes)
			if(!(head_clothes.resistance_flags & UNACIDABLE))
				head_clothes.acid_act(acidpwr, acid_volume)
				update_inv_glasses()
				update_inv_wear_mask()
				update_inv_neck()
				update_inv_head()
			else
				to_chat(src, span_notice("Your [head_clothes.name] protects your head and face from the acid!"))
		else
			. = get_bodypart(BODY_ZONE_HEAD)
			if(.)
				damaged += .
			if(ears)
				inventory_items_to_kill += ears

	//CHEST//
	if(!bodyzone_hit || bodyzone_hit == BODY_ZONE_CHEST)
		var/obj/item/clothing/chest_clothes = null
		if(w_uniform)
			chest_clothes = w_uniform
		if(wear_suit)
			chest_clothes = wear_suit
		if(chest_clothes)
			if(!(chest_clothes.resistance_flags & UNACIDABLE))
				chest_clothes.acid_act(acidpwr, acid_volume)
				update_inv_w_uniform()
				update_inv_wear_suit()
			else
				to_chat(src, span_notice("Your [chest_clothes.name] protects your body from the acid!"))
		else
			. = get_bodypart(BODY_ZONE_CHEST)
			if(.)
				damaged += .
			if(wear_id)
				inventory_items_to_kill += wear_id
			if(r_store)
				inventory_items_to_kill += r_store
			if(l_store)
				inventory_items_to_kill += l_store
			if(s_store)
				inventory_items_to_kill += s_store


	//ARMS & HANDS//
	if(!bodyzone_hit || bodyzone_hit == BODY_ZONE_L_ARM || bodyzone_hit == BODY_ZONE_R_ARM)
		var/obj/item/clothing/arm_clothes = null
		if(gloves)
			arm_clothes = gloves
		if(w_uniform && ((w_uniform.body_parts_covered & HANDS) || (w_uniform.body_parts_covered & ARMS)))
			arm_clothes = w_uniform
		if(wear_suit && ((wear_suit.body_parts_covered & HANDS) || (wear_suit.body_parts_covered & ARMS)))
			arm_clothes = wear_suit

		if(arm_clothes)
			if(!(arm_clothes.resistance_flags & UNACIDABLE))
				arm_clothes.acid_act(acidpwr, acid_volume)
				update_inv_gloves()
				update_inv_w_uniform()
				update_inv_wear_suit()
			else
				to_chat(src, span_notice("Your [arm_clothes.name] protects your arms and hands from the acid!"))
		else
			. = get_bodypart(BODY_ZONE_R_ARM)
			if(.)
				damaged += .
			. = get_bodypart(BODY_ZONE_L_ARM)
			if(.)
				damaged += .


	//LEGS & FEET//
	if(!bodyzone_hit || bodyzone_hit == BODY_ZONE_L_LEG || bodyzone_hit == BODY_ZONE_R_LEG || bodyzone_hit == "feet")
		var/obj/item/clothing/leg_clothes = null
		if(shoes)
			leg_clothes = shoes
		if(w_uniform && ((w_uniform.body_parts_covered & FEET) || (bodyzone_hit != "feet" && (w_uniform.body_parts_covered & LEGS))))
			leg_clothes = w_uniform
		if(wear_suit && ((wear_suit.body_parts_covered & FEET) || (bodyzone_hit != "feet" && (wear_suit.body_parts_covered & LEGS))))
			leg_clothes = wear_suit
		if(leg_clothes)
			if(!(leg_clothes.resistance_flags & UNACIDABLE))
				leg_clothes.acid_act(acidpwr, acid_volume)
				update_inv_shoes()
				update_inv_w_uniform()
				update_inv_wear_suit()
			else
				to_chat(src, span_notice("Your [leg_clothes.name] protects your legs and feet from the acid!"))
		else
			. = get_bodypart(BODY_ZONE_R_LEG)
			if(.)
				damaged += .
			. = get_bodypart(BODY_ZONE_L_LEG)
			if(.)
				damaged += .


	//DAMAGE//
	for(var/obj/item/bodypart/affecting in damaged)
		affecting.receive_damage(acidity, 2*acidity)

		if(affecting.name == BODY_ZONE_HEAD)
			if(prob(min(acidpwr*acid_volume/10, 90))) //Applies disfigurement
				affecting.receive_damage(acidity, 2*acidity)
				emote("scream")
				facial_hair_style = "Shaved"
				hair_style = "Bald"
				update_hair()
				ADD_TRAIT(src, TRAIT_DISFIGURED, TRAIT_GENERIC)

		update_damage_overlays()

	//MELTING INVENTORY ITEMS//
	//these items are all outside of armour visually, so melt regardless.
	if(!bodyzone_hit)
		if(back)
			inventory_items_to_kill += back
		if(belt)
			inventory_items_to_kill += belt

		inventory_items_to_kill += held_items

	for(var/obj/item/I in inventory_items_to_kill)
		I.acid_act(acidpwr, acid_volume)
	return 1

/mob/living/carbon/human/singularity_act()
	var/gain = 20
	if(mind)
		if((mind.assigned_role == "Station Engineer") || (mind.assigned_role == "Chief Engineer") )
			gain = 100
		if(HAS_TRAIT(mind, TRAIT_CLOWN_MENTALITY))
			gain = rand(-300, 300)
	investigate_log("([key_name(src)]) has been consumed by the singularity.", INVESTIGATE_SINGULO) //Oh that's where the clown ended up!
	gib()
	return(gain)

/mob/living/carbon/human/help_shake_act(mob/living/carbon/M)
	if(!istype(M))
		return

	if(health >= 0)
		if(src == M)
			if(has_status_effect(STATUS_EFFECT_CHOKINGSTRAND))
				to_chat(src, span_notice("You attempt to remove the durathread strand from around your neck."))
				if(do_after(src, 35, null, src))
					to_chat(src, span_notice("You succesfuly remove the durathread strand."))
					remove_status_effect(STATUS_EFFECT_CHOKINGSTRAND)
				return
			var/to_send = ""
			visible_message("[src] examines [p_them()]self.", \
				span_notice("You check yourself for injuries."))

			var/list/missing = list(BODY_ZONE_HEAD, BODY_ZONE_CHEST, BODY_ZONE_L_ARM, BODY_ZONE_R_ARM, BODY_ZONE_L_LEG, BODY_ZONE_R_LEG)
			for(var/X in bodyparts)
				var/obj/item/bodypart/LB = X
				missing -= LB.body_zone
				if(LB.is_pseudopart) //don't show injury text for fake bodyparts; ie chainsaw arms or synthetic armblades
					continue
				var/limb_max_damage = LB.max_damage
				var/status = ""
				var/brutedamage = LB.brute_dam
				var/burndamage = LB.burn_dam
				var/bleeddamage = LB.bleed_dam
				if(hallucination)
					if(prob(30))
						brutedamage += rand(30,40)
					if(prob(30))
						burndamage += rand(30,40)

				if(HAS_TRAIT(src, TRAIT_SELF_AWARE))
					status = "[brutedamage] brute, [burndamage] burn, and [bleeddamage] bleed damage"
					if(!brutedamage && !burndamage)
						status = "no damage"

				else
					if(brutedamage > 0)
						status = LB.light_brute_msg
					if(brutedamage > (limb_max_damage*0.4))
						status = LB.medium_brute_msg
					if(brutedamage > (limb_max_damage*0.8))
						status = LB.heavy_brute_msg
					if(brutedamage > 0 && burndamage > 0)
						status += " and "

					if(burndamage > (limb_max_damage*0.8))
						status += LB.heavy_burn_msg
					else if(burndamage > (limb_max_damage*0.2))
						status += LB.medium_burn_msg
					else if(burndamage > 0)
						status += LB.light_burn_msg

					if(status == "")
						status = "OK"
				var/no_damage
				if(status == "OK" || status == "no damage")
					no_damage = TRUE
				to_send += "\t <span class='[no_damage ? "notice" : "warning"]'>Your [LB.name] [HAS_TRAIT(src, TRAIT_SELF_AWARE) ? "has" : "is"] [status].</span>\n"

				for(var/thing in LB.wounds)
					var/datum/wound/W = thing
					var/msg
					switch(W.severity)
						if(WOUND_SEVERITY_TRIVIAL)
							msg = "\t <span class='danger'>Your [LB.name] is suffering [W.a_or_from] [lowertext(W.name)].</span>"
						if(WOUND_SEVERITY_MODERATE)
							msg = "\t <span class='warning'>Your [LB.name] is suffering [W.a_or_from] [lowertext(W.name)]!</span>"
						if(WOUND_SEVERITY_SEVERE)
							msg = "\t <span class='warning'><b>Your [LB.name] is suffering [W.a_or_from] [lowertext(W.name)]!</b></span>"
						if(WOUND_SEVERITY_CRITICAL)
							msg = "\t <span class='warning'><b>Your [LB.name] is suffering [W.a_or_from] [lowertext(W.name)]!!</b></span>"
					to_chat(src, msg)

				for(var/obj/item/I in LB.embedded_objects)
					if(I.isEmbedHarmless())
						to_chat(src, "\t <a href='byond://?src=[REF(src)];embedded_object=[REF(I)];embedded_limb=[REF(LB)]' class='warning'>There is \a [I] stuck to your [LB.name]!</a>")
					else
						to_chat(src, "\t <a href='byond://?src=[REF(src)];embedded_object=[REF(I)];embedded_limb=[REF(LB)]' class='warning'>There is \a [I] embedded in your [LB.name]!</a>")

				if(LB.current_gauze)
					to_chat(src, "\t [span_notice("It is covered with [LB.current_gauze.name]\s.")] <a href='byond://?src=[REF(src)];remove_covering=[TRUE];bandage=[TRUE];limb=[REF(LB)]' class='notice'>(Remove?)</a>")
				if(LB.current_suture)
					to_chat(src, "\t [span_notice("It is stitched with [LB.current_suture.name]\s.")] <a href='byond://?src=[REF(src)];remove_covering=[TRUE];suture=[TRUE];limb=[REF(LB)]' class='notice'>(Remove?)</a>")

			for(var/t in missing)
				to_send += span_boldannounce("Your [parse_zone(t)] is missing!")

			if(is_bleeding())
				var/list/obj/item/bodypart/bleeding_limbs = list()
				for(var/i in bodyparts)
					var/obj/item/bodypart/BP = i
					if(BP.get_bleed_rate(FALSE))
						bleeding_limbs += "[BP.name]"

				//var/num_bleeds = LAZYLEN(bleeding_limbs)
				var/bleed_text = "<span class='danger'>You are bleeding from your "
				bleed_text += english_list(bleeding_limbs)
				/* switch(num_bleeds)
					if(1 to 2)
						bleed_text += " [bleeding_limbs[1].name][num_bleeds == 2 ? " and [bleeding_limbs[2].name]" : ""]"
					if(3 to INFINITY)
						for(var/i in 1 to (num_bleeds - 1))
							var/obj/item/bodypart/BP = bleeding_limbs[i]
							bleed_text += " [BP.name],"
						bleed_text += " and [bleeding_limbs[num_bleeds].name]" */
				bleed_text += "!</span>"
				to_chat(src, bleed_text)
			if(getStaminaLoss())
				if(getStaminaLoss() > 30)
					to_send += span_info("You're completely exhausted. ")
				else
					to_send += span_info("You feel fatigued. ")
			if(HAS_TRAIT(src, TRAIT_SELF_AWARE))
				if(toxloss)
					if(toxloss > 10)
						to_send += span_danger("You feel sick. ")
					else if(toxloss > 20)
						to_send += span_danger("You feel nauseated. ")
					else if(toxloss > 40)
						to_send += span_danger("You feel very unwell! ")
				if(oxyloss)
					if(oxyloss > 10)
						to_send += span_danger("You feel lightheaded. ")
					else if(oxyloss > 20)
						to_send += span_danger("Your thinking is clouded and distant. ")
					else if(oxyloss > 30)
						to_send += span_danger("You're choking! ")

			switch(nutrition)
				if(NUTRITION_LEVEL_FULL to INFINITY)
					to_send += span_info("You're completely stuffed! ")
				if(NUTRITION_LEVEL_WELL_FED to NUTRITION_LEVEL_FULL)
					to_send += span_info("You're well fed! ")
				if(NUTRITION_LEVEL_FED to NUTRITION_LEVEL_WELL_FED)
					to_send += span_info("You're not hungry. ")
				if(NUTRITION_LEVEL_HUNGRY to NUTRITION_LEVEL_FED)
					to_send += span_info("You could use a bite to eat. ")
				if(NUTRITION_LEVEL_STARVING to NUTRITION_LEVEL_HUNGRY)
					to_send += span_info("You feel quite hungry. ")
				if(0 to NUTRITION_LEVEL_STARVING)
					to_send += span_danger("You're starving! ")


			//TODO: Convert these messages into vague messages, thereby encouraging actual dignosis.
			//Compiles then shows the list of damaged organs and broken organs
			var/list/broken = list()
			var/list/damaged = list()
			var/broken_message
			var/damaged_message
			var/broken_plural
			var/damaged_plural
			//Sets organs into their proper list
			for(var/O in internal_organs)
				var/obj/item/organ/organ = O
				if(organ.organ_flags & ORGAN_FAILING)
					if(broken.len)
						broken += ", "
					broken += organ.name
				else if(organ.damage > organ.low_threshold)
					if(damaged.len)
						damaged += ", "
					damaged += organ.name
			//Checks to enforce proper grammar, inserts words as necessary into the list
			if(broken.len)
				if(broken.len > 1)
					broken.Insert(broken.len, "and ")
					broken_plural = TRUE
				else
					var/holder = broken[1]	//our one and only element
					if(holder[length(holder)] == "s")
						broken_plural = TRUE
				//Put the items in that list into a string of text
				for(var/B in broken)
					broken_message += B
				to_chat(src, span_warning(" Your [broken_message] [broken_plural ? "are" : "is"] non-functional!"))
			if(damaged.len)
				if(damaged.len > 1)
					damaged.Insert(damaged.len, "and ")
					damaged_plural = TRUE
				else
					var/holder = damaged[1]
					if(holder[length(holder)] == "s")
						damaged_plural = TRUE
				for(var/D in damaged)
					damaged_message += D
				to_chat(src, span_info("Your [damaged_message] [damaged_plural ? "are" : "is"] hurt."))

			if(roundstart_quirks.len)
				to_send += span_notice("You have these quirks: [get_trait_string()].")

			to_chat(src, to_send)
		else
			if(wear_suit)
				wear_suit.add_fingerprint(M)
			else if(w_uniform)
				w_uniform.add_fingerprint(M)

			..()

/mob/living/carbon/human/check_self_for_injuries()
	if(stat == DEAD || stat == UNCONSCIOUS)
		return

	visible_message(span_notice("[src] examines [p_them()]self."), \
		span_notice("You check yourself for injuries."))

	var/list/missing = list(BODY_ZONE_HEAD, BODY_ZONE_CHEST, BODY_ZONE_L_ARM, BODY_ZONE_R_ARM, BODY_ZONE_L_LEG, BODY_ZONE_R_LEG)

	for(var/X in bodyparts)
		var/obj/item/bodypart/LB = X
		missing -= LB.body_zone
		if(LB.is_pseudopart) //don't show injury text for fake bodyparts; ie chainsaw arms or synthetic armblades
			continue
		var/limb_max_damage = LB.max_damage
		var/brutedamage = LB.brute_dam
		var/burndamage = LB.burn_dam
		var/bleeddamage = LB.bleed_dam
		if(hallucination)
			if(prob(30))
				brutedamage += rand(30,40)
			if(prob(30))
				burndamage += rand(30,40)

		if(HAS_TRAIT(src, TRAIT_SELF_AWARE))// If whoever's beeing looked at has self-aware, you can see it too
			var/sa_msg = span_notice("[src]'s [LB.name]: ")
			if(brutedamage || burndamage || bleeddamage)
				sa_msg += "<font color='red'>BRUTE: [brutedamage]</font>, \
						<font color='orange'>BURN: [burndamage]</font>, \
						<font color='red'>BLEED: [bleeddamage]</font>"
			else
				sa_msg += span_green("Unharmed.")
			if(LB.is_disabled())
				sa_msg += span_alert(" \[DISABLED!\].")
			to_chat(src, sa_msg)

		else
			var/msg = span_notice("[src]'s [LB.name] is ")
			var/list/damage_words = list()
			if(brutedamage || burndamage || bleeddamage)
				if(brutedamage <= (limb_max_damage*0.4) )
					damage_words += LB.light_brute_msg
				if((limb_max_damage*0.4) < brutedamage && brutedamage <= (limb_max_damage*0.8))
					damage_words += LB.medium_brute_msg
				if((limb_max_damage*0.8) < brutedamage)
					damage_words += LB.heavy_brute_msg
				if(burndamage <= (limb_max_damage*0.4))
					damage_words += LB.light_burn_msg
				if((limb_max_damage*0.4) < burndamage && burndamage <= (limb_max_damage*0.8))
					damage_words += LB.medium_burn_msg
				if((limb_max_damage*0.8) < burndamage)
					damage_words += LB.heavy_burn_msg
				if(bleeddamage <= (limb_max_damage*0.4))
					damage_words += LB.light_bleed_msg
				if((limb_max_damage*0.4) < bleeddamage && bleeddamage <= (limb_max_damage*0.8))
					damage_words += LB.medium_bleed_msg
				if((limb_max_damage*0.8) < bleeddamage)
					damage_words += LB.heavy_bleed_msg
				msg += span_alert(english_list(damage_words))
			else
				msg += span_green("intact")
			if(LB.is_disabled())
				msg += ", and is also [span_alert("disabled")]"
			msg += "."
			to_chat(src, msg)

		for(var/thing in LB.wounds)
			var/datum/wound/W = thing
			switch(W.severity)
				if(WOUND_SEVERITY_TRIVIAL)
					to_chat(src, "\t <span class='danger'>[p_their(TRUE)] [LB.name] is suffering [W.a_or_from] [lowertext(W.name)].</span>")
				if(WOUND_SEVERITY_MODERATE)
					to_chat(src, "\t <span class='warning'>[p_their(TRUE)] [LB.name] is suffering [W.a_or_from] [lowertext(W.name)]!</span>")
				if(WOUND_SEVERITY_SEVERE)
					to_chat(src, "\t <span class='warning'><b>[p_their(TRUE)] [LB.name] is suffering [W.a_or_from] [lowertext(W.name)]!</b></span>")
				if(WOUND_SEVERITY_CRITICAL)
					to_chat(src, "\t <span class='warning'><b>[p_their(TRUE)] [LB.name] is suffering [W.a_or_from] [lowertext(W.name)]!!</b></span>")

		var/has_bleed_wounds = LB.has_bleed_wounds()
		if(LB.current_gauze)
			var/message_bandage = ""
			message_bandage += "It is coated with "
			var/bandaid_max_time = initial(LB.current_gauze.covering_lifespan)
			var/bandaid_time = LB.get_covering_timeleft(COVERING_BANDAGE, COVERING_TIME_TRUE)
			// how much life we have left in these bandages
			if((bandaid_max_time * BANDAGE_GOODLIFE_DURATION) < bandaid_time)
				message_bandage += "fresh "
			if((bandaid_max_time * BANDAGE_MIDLIFE_DURATION) < bandaid_time && bandaid_time <= (bandaid_max_time * BANDAGE_GOODLIFE_DURATION))
				message_bandage += "slightly worn "
			if((bandaid_max_time * BANDAGE_ENDLIFE_DURATION) < bandaid_time && bandaid_time <= (bandaid_max_time * BANDAGE_MIDLIFE_DURATION))
				message_bandage += "badly worn "
			if(bandaid_time <= (bandaid_max_time * BANDAGE_ENDLIFE_DURATION))
				message_bandage += "nearly ruined "
			message_bandage += "[LB.current_gauze.name]"
			if(has_bleed_wounds)
				message_bandage += span_warning(" covering a bleeding wound! ")
			else
				message_bandage += "! "
			message_bandage += "<a href='byond://?src=[REF(src)];remove_covering=[TRUE];bandage=[TRUE];limb=[REF(LB)]' class='notice'>(Remove?)</a>"
			to_chat(src, "\t[span_notice(message_bandage)]")

		if(LB.current_suture)
			var/message_suture
			message_suture += "It is stitched up with "
			var/bandaid_max_time = initial(LB.current_suture.covering_lifespan)
			var/bandaid_time = LB.get_covering_timeleft(COVERING_SUTURE, COVERING_TIME_TRUE)
			// how much life we have left in these bandages
			if((bandaid_max_time * SUTURE_GOODLIFE_DURATION) < bandaid_time)
				message_suture += "sturdy "
			if((bandaid_max_time * BANDAGE_MIDLIFE_DURATION) < bandaid_time && bandaid_time <= (bandaid_max_time * BANDAGE_GOODLIFE_DURATION))
				message_suture += "slightly frayed "
			if((bandaid_max_time * BANDAGE_ENDLIFE_DURATION) < bandaid_time && bandaid_time <= (bandaid_max_time * BANDAGE_MIDLIFE_DURATION))
				message_suture += "badly frayed "
			if(bandaid_time <= (bandaid_max_time * BANDAGE_ENDLIFE_DURATION))
				message_suture += "nearly popped "
			message_suture += "[LB.current_suture.name]"
			if(has_bleed_wounds)
				message_suture += span_warning(" closing a bleeding wound! ")
			else
				message_suture += "! "
			message_suture += "<a href='byond://?src=[REF(src)];remove_covering=[TRUE];suture=[TRUE];limb=[REF(LB)]g' class='notice'>(Remove?)</a>"
			to_chat(src, "\t[span_notice(message_suture)]")

		for(var/obj/item/I in LB.embedded_objects)
			if(I.isEmbedHarmless())
				to_chat(src, "\t <a href='byond://?src=[REF(src)];embedded_object=[REF(I)];embedded_limb=[REF(LB)]' class='warning'>There is \a [I] stuck to your [LB.name]!</a>")
			else
				to_chat(src, "\t <a href='byond://?src=[REF(src)];embedded_object=[REF(I)];embedded_limb=[REF(LB)]' class='warning'>There is \a [I] embedded in your [LB.name]!</a>")

/mob/living/carbon/human/examine_more(mob/user)
	. = ..()

	var/list/missing = list(BODY_ZONE_HEAD, BODY_ZONE_CHEST, BODY_ZONE_L_ARM, BODY_ZONE_R_ARM, BODY_ZONE_L_LEG, BODY_ZONE_R_LEG)

	for(var/X in bodyparts)
		var/obj/item/bodypart/LB = X
		missing -= LB.body_zone
		if(LB.is_pseudopart) //don't show injury text for fake bodyparts; ie chainsaw arms or synthetic armblades
			continue
		var/limb_max_damage = LB.max_damage
		var/brutedamage = LB.brute_dam
		var/burndamage = LB.burn_dam
		var/bleeddamage = LB.bleed_dam
		if(hallucination)
			if(prob(30))
				brutedamage += rand(30,40)
			if(prob(30))
				burndamage += rand(30,40)

		if(HAS_TRAIT(src, TRAIT_SELF_AWARE))// If whoever's beeing looked at has self-aware, you can see it too
			var/sa_msg = span_notice("[src]'s [LB.name]: ")
			if(brutedamage || burndamage || bleeddamage)
				sa_msg += "<font color='red'>BRUTE: [brutedamage]</font>, \
						<font color='orange'>BURN: [burndamage]</font>, \
						<font color='red'>BLEED: [bleeddamage]</font>"
			else
				sa_msg += span_green("Unharmed.")
			if(LB.is_disabled())
				sa_msg += span_alert(" \[DISABLED!\].")
			. += sa_msg

		else
			var/msg = "[src]'s [LB.name] is "
			var/list/damage_words = list()
			if(brutedamage || burndamage || bleeddamage)
				if(brutedamage <= (limb_max_damage*0.4))
					damage_words += LB.light_brute_msg
				if((limb_max_damage*0.4) < brutedamage && brutedamage <= (limb_max_damage*0.8))
					damage_words += LB.medium_brute_msg
				if((limb_max_damage*0.8) <= brutedamage)
					damage_words += LB.heavy_brute_msg
				if(burndamage <= (limb_max_damage*0.4))
					damage_words += LB.light_burn_msg
				if((limb_max_damage*0.4) < burndamage && burndamage <= (limb_max_damage*0.8))
					damage_words += LB.medium_burn_msg
				if((limb_max_damage*0.8) <= burndamage)
					damage_words += LB.heavy_burn_msg
				if(bleeddamage <= (limb_max_damage*0.4))
					damage_words += LB.light_bleed_msg
				if((limb_max_damage*0.4) < bleeddamage && bleeddamage <= (limb_max_damage*0.8))
					damage_words += LB.medium_bleed_msg
				if((limb_max_damage*0.8) <= bleeddamage)
					damage_words += LB.heavy_bleed_msg
				msg += english_list(damage_words)
			else
				msg += "intact"
			if(LB.is_disabled())
				msg += ", and is also disabled"
			msg += "."
			. += span_notice(msg)

		for(var/thing in LB.wounds)
			var/datum/wound/W = thing
			switch(W.severity)
				if(WOUND_SEVERITY_TRIVIAL)
					. += "\t <span class='danger'>[p_their(TRUE)] [LB.name] is suffering [W.a_or_from] [lowertext(W.name)].</span>"
				if(WOUND_SEVERITY_MODERATE)
					. += "\t <span class='warning'>[p_their(TRUE)] [LB.name] is suffering [W.a_or_from] [lowertext(W.name)]!</span>"
				if(WOUND_SEVERITY_SEVERE)
					. += "\t <span class='warning'><b>[p_their(TRUE)] [LB.name] is suffering [W.a_or_from] [lowertext(W.name)]!</b></span>"
				if(WOUND_SEVERITY_CRITICAL)
					. += "\t <span class='warning'><b>[p_their(TRUE)] [LB.name] is suffering [W.a_or_from] [lowertext(W.name)]!!</b></span>"

		var/has_bleed_wounds = LB.has_bleed_wounds()
		if(LB.current_gauze)
			var/message_bandage = ""
			message_bandage += "It is coated with "
			var/bandaid_max_time = initial(LB.current_gauze.covering_lifespan)
			var/bandaid_time = LB.get_covering_timeleft(COVERING_BANDAGE, COVERING_TIME_TRUE)
			// how much life we have left in these bandages
			if((bandaid_max_time * BANDAGE_GOODLIFE_DURATION) < bandaid_time)
				message_bandage += "fresh "
			if((bandaid_max_time * BANDAGE_MIDLIFE_DURATION) < bandaid_time && bandaid_time <= (bandaid_max_time * BANDAGE_GOODLIFE_DURATION))
				message_bandage += "slightly worn "
			if((bandaid_max_time * BANDAGE_ENDLIFE_DURATION) < bandaid_time && bandaid_time <= (bandaid_max_time * BANDAGE_MIDLIFE_DURATION))
				message_bandage += "badly worn "
			if(bandaid_time <= (bandaid_max_time * BANDAGE_ENDLIFE_DURATION))
				message_bandage += "nearly ruined "
			message_bandage += "[LB.current_gauze.name]"
			if(has_bleed_wounds)
				message_bandage += span_warning(" covering a bleeding wound! ")
			else
				message_bandage += "! "
			message_bandage += "<a href='byond://?src=[REF(src)];remove_covering=[TRUE];bandage=[TRUE];limb=[REF(LB)];other_doer=[REF(user)]' class='notice'>(Remove?)</a>"
			. += "\t[span_notice(message_bandage)]"

		if(LB.current_suture)
			var/message_suture
			message_suture += "It is stitched up with "
			var/bandaid_max_time = initial(LB.current_suture.covering_lifespan)
			var/bandaid_time = LB.get_covering_timeleft(COVERING_SUTURE, COVERING_TIME_TRUE)
			// how much life we have left in these bandages
			if((bandaid_max_time * BANDAGE_GOODLIFE_DURATION) < bandaid_time)
				message_suture += "sturdy "
			if((bandaid_max_time * BANDAGE_MIDLIFE_DURATION) < bandaid_time && bandaid_time <= (bandaid_max_time * BANDAGE_GOODLIFE_DURATION))
				message_suture += "slightly frayed "
			if((bandaid_max_time * BANDAGE_ENDLIFE_DURATION) < bandaid_time && bandaid_time <= (bandaid_max_time * BANDAGE_MIDLIFE_DURATION))
				message_suture += "badly frayed "
			if(bandaid_time <= (bandaid_max_time * BANDAGE_ENDLIFE_DURATION))
				message_suture += "nearly popped "
			message_suture += "[LB.current_suture.name]"
			if(has_bleed_wounds)
				message_suture += span_warning(" closing a bleeding wound! ")
			else
				message_suture += "! "
			message_suture += "<a href='byond://?src=[REF(src)];remove_covering=[TRUE];suture=[TRUE];limb=[REF(LB)];other_doer=[REF(user)]' class='notice'>(Remove?)</a>"
			. += "\t[span_notice(message_suture)]"

/mob/living/carbon/human/damage_clothes(damage_amount, damage_type = BRUTE, damage_flag = 0, def_zone)
	if(damage_type != BRUTE && damage_type != BURN)
		return
	damage_amount *= 0.5 //0.5 multiplier for balance reason, we don't want clothes to be too easily destroyed
	var/list/torn_items = list()

	//HEAD//
	if(!def_zone || def_zone == BODY_ZONE_HEAD)
		var/obj/item/clothing/head_clothes = null
		if(glasses)
			head_clothes = glasses
		if(wear_mask)
			head_clothes = wear_mask
		if(wear_neck)
			head_clothes = wear_neck
		if(head)
			head_clothes = head
		if(head_clothes)
			torn_items += head_clothes
		else if(ears)
			torn_items += ears

	//CHEST//
	if(!def_zone || def_zone == BODY_ZONE_CHEST)
		var/obj/item/clothing/chest_clothes = null
		if(w_uniform)
			chest_clothes = w_uniform
		if(wear_suit)
			chest_clothes = wear_suit
		if(chest_clothes)
			torn_items += chest_clothes

	//ARMS & HANDS//
	if(!def_zone || def_zone == BODY_ZONE_L_ARM || def_zone == BODY_ZONE_R_ARM)
		var/obj/item/clothing/arm_clothes = null
		if(gloves)
			arm_clothes = gloves
		if(w_uniform && ((w_uniform.body_parts_covered & HANDS) || (w_uniform.body_parts_covered & ARMS)))
			arm_clothes = w_uniform
		if(wear_suit && ((wear_suit.body_parts_covered & HANDS) || (wear_suit.body_parts_covered & ARMS)))
			arm_clothes = wear_suit
		if(arm_clothes)
			torn_items |= arm_clothes

	//LEGS & FEET//
	if(!def_zone || def_zone == BODY_ZONE_L_LEG || def_zone == BODY_ZONE_R_LEG)
		var/obj/item/clothing/leg_clothes = null
		if(shoes)
			leg_clothes = shoes
		if(w_uniform && ((w_uniform.body_parts_covered & FEET) || (w_uniform.body_parts_covered & LEGS)))
			leg_clothes = w_uniform
		if(wear_suit && ((wear_suit.body_parts_covered & FEET) || (wear_suit.body_parts_covered & LEGS)))
			leg_clothes = wear_suit
		if(leg_clothes)
			torn_items |= leg_clothes

	for(var/obj/item/I in torn_items)
		I.take_damage(damage_amount, damage_type, damage_flag, 0)


/mob/living/carbon/human/proc/handle_friends(mob/our_attacker)
	for (var/mob/l in mob_friends)
		if (src != our_attacker)
			if (istype(l, /mob/living/simple_animal/hostile/retaliate/talker))
				var/mob/living/simple_animal/hostile/retaliate/talker/talk = l
				talk.handle_enemy(our_attacker)
