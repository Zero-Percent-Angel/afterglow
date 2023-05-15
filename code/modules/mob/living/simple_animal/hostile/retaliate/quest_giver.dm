/mob/living/simple_animal/hostile/retaliate/talker/quest_giver
	var/list/possible_quests = list()
	var/list/cooldown = list()
	var/generate_find_item = FALSE
	var/generate_kill_person = FALSE
	var/generate_kill_animal = FALSE
	var/myplace = null
	var/my_original_loc = null
	var/list/active_quests = list()
	var/list/completed_quests = list()
	var/walking = FALSE

/mob/living/simple_animal/hostile/retaliate/talker/quest_giver/Initialize()
	. = ..()
	myplace = get_turf(src)
	my_original_loc = loc
	if (gender == FEMALE)
		icon_state = "WasterG_Gun"
	else
		icon_state = "WasterM_Gun"

/mob/living/simple_animal/hostile/retaliate/talker/quest_giver/handle_automated_movement()
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

/mob/living/simple_animal/hostile/retaliate/talker/quest_giver/basic
	name = "Wastelander"
	desc = "A wastelander, just trying to survive, this one seems to have an extra agenda though."
	icon = 'icons/fallout/mobs/humans/fallout_npc.dmi'
	icon_state = "WasterG_Neutral"
	icon_living = "WasterG_Neutral"
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
	maxHealth = 100
	health = 100
	harm_intent_damage = 5
	melee_damage_lower = 10
	melee_damage_upper = 15
	attack_verb_continuous = "punches"
	attack_verb_simple = "punch"
	attack_sound = 'sound/weapons/punch1.ogg'
	faction = list()
	a_intent = INTENT_HARM
	atmos_requirements = list("min_oxy" = 5, "max_oxy" = 0, "min_tox" = 0, "max_tox" = 1, "min_co2" = 0, "max_co2" = 5, "min_n2" = 0, "max_n2" = 0)
	unsuitable_atmos_damage = 15
	status_flags = CANPUSH
	search_objects = 1
	vision_range = 9
	rapid = 2
	retreat_distance = 3
	minimum_distance = 5
	casingtype = /obj/item/ammo_casing/c9mm
	projectiletype = /obj/item/projectile/bullet/c9mm/improvised
	projectilesound = 'sound/weapons/gunshot_smg.ogg'
	loot = list(/obj/item/gun/ballistic/automatic/hobo/destroyer)
	generate_find_item = TRUE
	generate_kill_person = TRUE
	generate_kill_animal = TRUE

/datum/quest
	var/quest_name = "A quest"
	var/quest_description = "Would you kindly do this thing for me?"
	var/quest_id = ""
	var/reward_amount = 10
	var/list/quest_things = list()
	var/list/secondary_quest_things = list(/mob/living/simple_animal/hostile/raider/quest, /mob/living/simple_animal/hostile/raider/ranged/quest)
	var/obj/item/quest/choosen_quest_thing = null
	var/choosen_quest_thing_to_spawn_in = null
	var/obj/effect/landmark/questing/quest_landmark = null

/datum/quest/kill/guy
	quest_things = list()
	secondary_quest_things = list()
	reward_amount = PRICE_ABOVE_EXPENSIVE

/datum/quest/kill_player
	quest_things = list()

/datum/quest/kill_player/New(quest_name, obj/effect/landmark/questing/quest_landmark, mob, reward_amount = 0)
	src.quest_name = quest_name
	src.quest_landmark = quest_landmark
	quest_description = quest_landmark.location_description
	src.choosen_quest_thing = mob
	if (reward_amount)
		src.reward_amount = reward_amount

/datum/quest/kill/animal
	quest_things = list()
	reward_amount = PRICE_EXPENSIVE

/datum/quest/kill/New(quest_name, obj/effect/landmark/questing/quest_landmark, reward_amount = 0)
	choosen_quest_thing_to_spawn_in = pick(secondary_quest_things)
	..()

/datum/quest/recover_item
	quest_things = list()
	reward_amount = PRICE_ALMOST_EXPENSIVE

/datum/quest/New(quest_name, obj/effect/landmark/questing/quest_landmark, reward_amount = 0)
	src.quest_name = quest_name
	src.quest_landmark = quest_landmark
	quest_description = quest_landmark.location_description
	src.choosen_quest_thing = pick(quest_things)
	quest_id = random_string(10, GLOB.alphabet)
	if (secondary_quest_things.len == 0)
		src.choosen_quest_thing_to_spawn_in = choosen_quest_thing
	if (reward_amount)
		src.reward_amount = reward_amount

/datum/quest/proc/spawn_quest()
	var/obj/item/quest/quest_item = new choosen_quest_thing(quest_landmark.loc)
	quest_item.quest_id = quest_id
	if(istype(choosen_quest_thing_to_spawn_in, /mob/living/simple_animal))
		var/mob/living/simple_animal/spawned_mob = new choosen_quest_thing_to_spawn_in(quest_landmark.loc)
		spawned_mob.transferItemToLoc(quest_item, src, TRUE)
		return spawned_mob
	return quest_item

/obj/effect/landmark/questing
	var/location_description = "I honestly ain't sure where what you're looking for might be."

/obj/effect/landmark/questing/people/Initialize()
	. = ..()
	GLOB.quest_people_spawns_list += src
	
/obj/effect/landmark/questing/animals/Initialize()
	. = ..()
	GLOB.quest_animal_spawns_list += src

/obj/effect/landmark/questing/item/Initialize()
	. = ..()
	GLOB.quest_item_spawns_list += src

/obj/item/quest
	name = "A quest item"
	var/quest_id = ""

/obj/item/quest/New(loc, our_id)
	quest_id = our_id
	..()

/mob/living/simple_animal/hostile/retaliate/talker/quest_giver/dialog_options(mob/talker, display_options)
	var/dat = ""
	if (introduced.Find(WEAKREF(talker)) && !active_quests.Find(WEAKREF(talker)) && cooldown[WEAKREF(talker)] < world.time)
		if (possible_quests.len == 0)
			if (generate_kill_animal)
				possible_quests += new /datum/quest/kill/animal("do you have any animals to hunt?", pick(GLOB.quest_animal_spawns_list))
			if (generate_kill_person)
				possible_quests += new /datum/quest/kill/guy("do you know of any wastelanders who have a bounty?", pick(GLOB.quest_people_spawns_list))
			if (generate_find_item)
				possible_quests += new /datum/quest/recover_item("do you need anything to be found?", pick(GLOB.quest_item_spawns_list))
		if (possible_quests.len > 0)
			for (var/datum/quest/qu in possible_quests)
				dat += "<center><a href='?src=[REF(src)];quest=[qu.quest_id]'>[qu.quest_name]</a></center>"
	else if (active_quests.Find(WEAKREF(talker)))
		var/datum/quest/qu = active_quests[WEAKREF(talker)]
		dat += "<center><a href='?src=[REF(src)];hand=[qu.quest_id]'>I have that item here in my hand.</a></center>"
	return dat

/mob/living/simple_animal/hostile/retaliate/talker/quest_giver/Topic(href, href_list)
	..()
	if(href_list["quest"])
		var/choosen_quest_id = href_list["quest"]
		for (var/datum/quest/q in possible_quests)
			if (q.quest_id == choosen_quest_id)
				var/the_thing = q.spawn_quest()
				usr.say("[q.quest_name].")
				say("Yea, I do.")
				say("[the_thing].")
				say("You'll find [the_thing], [q.quest_description].")
				active_quests[WEAKREF(usr)] = q
				possible_quests -= q
	if(href_list["hand"])
		say("Alright, let me take a look.")
		evaluate_held_item(usr)

/mob/living/simple_animal/hostile/retaliate/talker/quest_giver/proc/evaluate_held_item(mob/interacter)
	if (istype(interacter, /mob/living/carbon))
		var/mob/living/carbon/user = interacter
		var/obj/item_in_hand = user.get_active_held_item()
		var/say_the_line = 1
		if (item_in_hand == null)
			say("You ain't holding anything.")
			return
		if (istype(item_in_hand, /obj/item/quest))
			var/obj/item/quest/quest_it = item_in_hand
			var/datum/quest/the_quest = active_quests[user]
			if (the_quest.quest_id == quest_it.quest_id)
				var/obj/item/stack/f13Cash/C = new /obj/item/stack/f13Cash/caps
				C.add(the_quest.reward_amount - 1)
				C.forceMove(user.loc)
				qdel(item_in_hand)
				user.put_in_active_hand(C)
				say("Here are your caps.")
		else
			say("Clearly that isn't what I want.")

/mob/living/simple_animal/hostile/raider/ranged/quest/death(gibbed)
	for(var/obj/I in contents)
		src.dropItemToGround(I)
	. = ..()

/mob/living/simple_animal/hostile/raider/quest/death(gibbed)
	for(var/obj/I in contents)
		src.dropItemToGround(I)
	. = ..()

/mob/living/simple_animal/hostile/raider/quest/Initialize()
	. = ..()
	if (gender == MALE)
		name = capitalize(pick(GLOB.first_names_male)) + " " + capitalize(pick(GLOB.last_names))
	else
		name = capitalize(pick(GLOB.first_names_female)) + " " + capitalize(pick(GLOB.last_names))

/mob/living/simple_animal/hostile/raider/ranged/quest/Initialize()
	. = ..()
	if (gender == MALE)
		name = capitalize(pick(GLOB.first_names_male)) + " " + capitalize(pick(GLOB.last_names))
	else
		name = capitalize(pick(GLOB.first_names_female)) + " " + capitalize(pick(GLOB.last_names))
