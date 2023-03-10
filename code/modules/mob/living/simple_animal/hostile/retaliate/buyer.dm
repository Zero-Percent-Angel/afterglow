/mob/living/simple_animal/hostile/retaliate/talker/buyer 
	var/myplace = null
	var/my_original_loc = null
	var/walking = FALSE
	var/default_price = PRICE_BELOW_NORMAL
	intimidation_difficulty = DIFFICULTY_CHALLENGE
	var/list/buys_list = list()


/mob/living/simple_animal/hostile/retaliate/talker/buyer/Initialize(mapload)
	myplace = get_turf(src)
	my_original_loc = loc
	setup_buys()
	..()

/mob/living/simple_animal/hostile/retaliate/talker/buyer/proc/setup_buys()
	if (!buys_list.len)
		buys_list += GLOB.loot_prewar_costume
		buys_list += GLOB.loot_medical_drug
		buys_list += GLOB.loot_craft_basic
		buys_list += GLOB.loot_craft_advanced
		buys_list += GLOB.loot_medical_medicine
		buys_list += GLOB.loot_t1_armor
		buys_list += GLOB.loot_t2_armor
		buys_list += GLOB.loot_t3_armor
		buys_list += GLOB.loot_t4_armor
		buys_list += GLOB.loot_t5_armor
		buys_list += GLOB.loot_t1_melee
		buys_list += GLOB.loot_t2_melee
		buys_list += GLOB.loot_t3_melee
		buys_list += GLOB.loot_t4_melee
		buys_list += GLOB.loot_t5_melee
		buys_list += GLOB.loot_t1_range
		buys_list += GLOB.loot_t2_range
		buys_list += GLOB.loot_t3_range
		buys_list += GLOB.loot_t4_range
		buys_list += GLOB.loot_t5_range

/mob/living/simple_animal/hostile/retaliate/talker/buyer/handle_automated_movement()
	if (my_original_loc != loc)
		if (pulledby)
			pulledby.stop_pulling()
			walk_to(src, myplace, 0 , move_to_delay)
		if (!walking)
			walking = TRUE
			walk_to(src, myplace, 0 , move_to_delay)
	else
		walk_to(src, 0)
		walking = FALSE
		..()

/mob/living/simple_animal/hostile/retaliate/talker/buyer/dialog_options(mob/talker, display_options)
	var/dat = ""
	if (!broken_trust.Find(WEAKREF(talker)) && !enemies.Find(WEAKREF(talker)) && !failed.Find(WEAKREF(talker)))
		dat += "<center><a href='?src=[REF(src)];trade=1'>Ask if \he will buy your held item.</a></center>"
	return dat


/mob/living/simple_animal/hostile/retaliate/talker/buyer/Topic(href, href_list)
	if(href_list["trade"])
		say("Alright, let me take a look.")
		evaluate_held_item(usr)
	..()

/mob/living/simple_animal/hostile/retaliate/talker/buyer/proc/evaluate_held_item(mob/interacter)
	if (istype(interacter, /mob/living/carbon))
		var/mob/living/carbon/user = interacter
		var/obj/item_in_hand = user.get_active_held_item()
		var/say_the_line = 1
		if (item_in_hand == null)
			say("You ain't holding anything.")
			return
		for (var/the_loot in buys_list)
			var/calc_price = item_in_hand.custom_price ? item_in_hand.custom_price : default_price
			calc_price = round((calc_price * ((35 + user.skill_value(SKILL_BARTER))/100)))
			if (intimidated.Find(WEAKREF(user)))
				calc_price += PRICE_CHEAP
			if (istype(item_in_hand, the_loot))
				say("Suppose I could make you an offer for that... how bouts [num2text(calc_price)] caps for it?")
				var/our_answer = input(user, "Do you accept the offer of: [num2text(calc_price)] caps?", "Trade agreement") in list("Yes", "No")
				if (our_answer == "Yes")
					if (get_dist(src, user) <= 1)
						qdel(item_in_hand)
						say("Pleasure doing business with you.")
						var/obj/item/stack/f13Cash/C = new /obj/item/stack/f13Cash/caps
						C.add(calc_price - 1)
						C.forceMove(user.loc)
						user.put_in_active_hand(C)
						return
					else
						say("Why don't you come over a little closer and we can make that deal?")
						return
				else
					say("Real shame that.")
					say_the_line = 0
		if (say_the_line)
			say("I ain't interested in buying that.")


/mob/living/simple_animal/hostile/retaliate/talker/buyer/basic
	name = "Bob the Trader"
	desc = "A trader who buys items."
	icon = 'icons/mob/simple_human.dmi'
	icon_state = "nanotrasen"
	icon_living = "nanotrasen"
	icon_dead = null
	del_on_death = TRUE
	icon_gib = "syndicate_gib"
	turns_per_move = 5
	response_help_continuous = "pokes"
	response_help_simple = "poke"
	response_disarm_continuous = "shoves"
	response_disarm_simple = "shove"
	response_harm_continuous = "hits"
	response_harm_simple = "hit"
	speed = 0
	stat_attack = CONSCIOUS
	ranged_cooldown_time = 22
	ranged = TRUE
	robust_searching = TRUE
	healable = TRUE
	maxHealth = 300
	health = 300
	mob_armor = ARMOR_VALUE_DEATHCLAW_MOTHER
	harm_intent_damage = 5
	melee_damage_lower = 10
	melee_damage_upper = 15
	attack_verb_continuous = "punches"
	attack_verb_simple = "punch"
	attack_sound = 'sound/weapons/punch1.ogg'
	faction = list("trader")
	a_intent = INTENT_HARM
	atmos_requirements = list("min_oxy" = 5, "max_oxy" = 0, "min_tox" = 0, "max_tox" = 1, "min_co2" = 0, "max_co2" = 5, "min_n2" = 0, "max_n2" = 0)
	unsuitable_atmos_damage = 15
	status_flags = CANPUSH
	search_objects = 1
	icon_state = "nanotrasenrangedsmg"
	icon_living = "nanotrasenrangedsmg"
	vision_range = 9
	rapid = 3
	retreat_distance = 3
	minimum_distance = 5
	casingtype = /obj/item/ammo_casing/c9mm
	projectiletype = /obj/item/projectile/bullet/c46x30mm
	projectilesound = 'sound/weapons/gunshot_smg.ogg'
	loot = list(/obj/item/gun/ballistic/automatic/autopipe,
				/obj/effect/mob_spawn/human/corpse/nanotrasensoldier)
