/mob/living/carbon/human/proc/do_bad_drug_interaction(datum/reagent/drug_one, datum/reagent/drug_two)
	vomit()
	Dizzy(10)
	blur_eyes(10)
	blind_eyes(5)
	adjustToxLoss(15)
	var/rng = rand(1, 160)

	//Vomit fit
	if (rng < 21)
		to_chat(src, span_danger("You feel deathly ill."))
		addtimer(CALLBACK(src, .proc/vomit), 5 SECONDS)
		addtimer(CALLBACK(src, .proc/vomit), 10 SECONDS)
		addtimer(CALLBACK(src, .proc/vomit), 15 SECONDS)

	//addiction
	else if (rng < 40)
		for(var/datum/reagent/rea in reagents.addiction_list)
			if(rea.type != drug_one.type)
				var/datum/reagent/r = new drug_one.type()
				reagents.addiction_list.Add(r)
				r.on_addiction_start(src)
			else if(rea.type != drug_two.type && drug_two.interferes > 0 && drug_two.addiction_threshold)
				var/datum/reagent/r = new drug_two.type()
				reagents.addiction_list.Add(r)
				r.on_addiction_start(src)

	//stiff legs
	else if (rng < 60)
		to_chat(src, span_danger("You feel slow and sluggish."))
		add_movespeed_modifier(/datum/movespeed_modifier/bad_trip)
		addtimer(CALLBACK(src, .proc/remove_movespeed_modifier, /datum/movespeed_modifier/bad_trip), 60 SECONDS)

	//painful damage
	else if (rng < 80)
		to_chat(src, span_danger("Your skin gets nasty and painful bruises under it."))
		adjustBruteLoss(20, include_roboparts = FALSE)
	else if (rng < 100)
		to_chat(src, span_danger("Your skin starts to peel away in a place it's very painful!"))
		var/obj/item/bodypart/bod = pick(bodyparts)
		bod.receive_damage(30, wound_bonus = 50, bare_wound_bonus = 50, sharpness = SHARP_EDGED)
	else if (rng < 120)
		to_chat(src, span_danger("Your skin gets nasty and painful blisters."))
		adjustFireLoss(50, include_roboparts = FALSE)

	//sleep time
	else if (rng < 140)
		to_chat(src, span_danger("You suddenly pass out."))
		AdjustUnconscious(30, TRUE, TRUE)
		adjustStaminaLossBuffered(150)

	//stam damage
	else
		to_chat(src, span_danger("You feel extremely exhausted."))
		adjustStaminaLossBuffered(150)

