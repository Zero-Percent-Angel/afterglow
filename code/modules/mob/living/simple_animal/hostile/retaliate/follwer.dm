/proc/replace_characters(t,list/repl_chars)
	for(var/char in repl_chars)
		t = replacetext_char(t, char, repl_chars[char])
	return t

/mob/living/simple_animal/hostile/retaliate/talker/follower
	var/list/known_commands = list("stay", "stop", "attack", "follow", "trust")
	var/list/allowed_targets = list() //WHO CAN I KILL D:
	var/retribution = 1 //whether or not they will attack us if we attack them like some kinda dick.
	var/list/heard_list = list("Okay.", "Got it.", "Yep.", "Yup.", "Yes.")
	var/mob/target_mob = null
	var/followingAFriend = FALSE
	var/trust_no_one = FALSE
	var/ordered_attack = FALSE
	var/autoSucceedThreshold = HARD_CHECK
	var/roll_difficulty = DIFFICULTY_NORMAL

/mob/living/simple_animal/hostile/retaliate/talker/follower/dialog_options(mob/talker, display_options)
	var/dat = "" 
	if (!friends.Find(WEAKREF(talker)) && (intimidated.Find(WEAKREF(talker)) || introduced.Find(WEAKREF(talker))))
		dat += "<center><a href='?src=[REF(src)];together=1'>Try to convince them to follow you (Speech - persuade)</a></center>"
	if (friends.Find(WEAKREF(talker)) && !trust_no_one)
		dat += "<center><a href='?src=[REF(src)];only=1'>Convince them to only trust you (Speech - persuade)</a></center>"
		say("Just say who you want me to +follow+, who I can +trust+ or who to +attack+ and I'm on it.")
	return dat

/mob/living/simple_animal/hostile/retaliate/talker/follower/Topic(href, href_list)
	if(href_list["together"])
		usr.say("The wastes are a dangerous place, we should stick together.")
		if (!trust_no_one && !failed.Find(WEAKREF(usr)) && (usr.skill_check(SKILL_SPEECH, autoSucceedThreshold) || usr.skill_roll(SKILL_SPEECH, roll_difficulty) || intimidated.Find(WEAKREF(usr))))
			say("Alright you look like you've got it together. Where to?")
			friends |= WEAKREF(usr)
			if (istype(usr, /mob/living/carbon/human))
				var/mob/living/carbon/human/H = usr
				H.mob_friends |= src
			show_dialog_box(usr, FALSE)
		else
			say("I'll take my chances out here.")
			failed |= WEAKREF(usr)
	if(href_list["only"])
		usr.say("There are lots of people you can't trust out there.")
		if (!failed.Find(WEAKREF(usr)) && (usr.skill_check(SKILL_SPEECH, EXPERT_CHECK) || usr.skill_roll(SKILL_SPEECH, DIFFICULTY_CHALLENGE)))
			say("You're right... we should stick together, just us.")
			trust_no_one = TRUE
			show_dialog_box(usr, FALSE)
		else
			say("No! You're trying to trick me, get lost!")
			failed |= WEAKREF(usr)
			friends -= WEAKREF(usr)
	..(href, href_list)
	
/mob/living/simple_animal/hostile/retaliate/talker/follower/Hear(message, atom/movable/speaker, datum/language/message_language, raw_message, radio_freq, list/spans, message_mode, atom/movable/source)
	. = ..()
	if (friends.Find(WEAKREF(speaker)))
		listen(speaker, raw_message)
	return ..()

/mob/living/simple_animal/hostile/retaliate/talker/follower/proc/listen(var/mob/speaker, var/text)
	for(var/command in known_commands)
		if(findtext(text,command))
			switch(command)
				if("stay")
					if(stay_command(speaker,text)) //find a valid command? Stop. Dont try and find more.
						break
				if("stop")
					if(stop_command(speaker,text))
						break
				if("attack")
					if(attack_command(speaker,text))
						fight_time()
						break
				if("follow")
					if(follow_command(speaker,text))
						if(heard_list && heard_list.len)
							say("[pick(heard_list)]")
						break
				if("trust")
					if(friend_command(speaker,text))
						if(heard_list && heard_list.len)
							say("[pick(heard_list)]")
						break
				else
					misc_command(speaker,text) //for specific commands

	return 1

//returns a list of everybody we wanna do stuff with.
/mob/living/simple_animal/hostile/retaliate/talker/follower/proc/get_targets_by_name(var/text, var/filter_friendlies = 0)
	var/list/possible_targets = hearers(src,10)
	. = list()
	for(var/mob/M in possible_targets)
		var/found = 0
		if(findtext(text, "[M]"))
			found = 1
		else
			var/list/parsed_name = splittext(replace_characters(lowertext(html_decode("[M]")),list("-"=" ", "."=" ", "," = " ", "'" = " ")), " ") //this big MESS is basically 'turn this into words, no punctuation, lowercase so we can check first name/last name/etc'
			for(var/a in parsed_name)
				if(a == "the" || length(a) < 2) //get rid of shit words.
					continue
				if(findtext(text,"[a]"))
					found = 1
					break
		if(found)
			. += WEAKREF(M)

/mob/living/simple_animal/hostile/retaliate/talker/follower/proc/attack_command(var/mob/speaker,var/text)
	target_mob = null //want me to attack something? Well I better forget my old target.
	walk_to(src,0)
	followingAFriend = FALSE
	stop_automated_movement = 0
	if(text == "attack" || findtext(text,"everyone") || findtext(text,"anybody") || findtext(text, "somebody") || findtext(text, "someone")) //if its just 'attack' then just attack anybody, same for if they say 'everyone', somebody, anybody. Assuming non-pickiness.
		allowed_targets = list("everyone")//everyone? EVERYONE
		return 1

	allowed_targets += get_targets_by_name(text)
	if(heard_list && heard_list.len)
		say("[pick(heard_list)]")
	return allowed_targets.len != 0

/mob/living/simple_animal/hostile/retaliate/talker/follower/proc/stay_command(var/mob/speaker,var/text)
	target_mob = null
	followingAFriend = FALSE
	stop_automated_movement = 1
	walk_to(src,0)
	if(heard_list && heard_list.len)
		say("[pick(heard_list)]")
	return 1

/mob/living/simple_animal/hostile/retaliate/talker/follower/proc/stop_command(var/mob/speaker,var/text)
	allowed_targets = list()
	followingAFriend = FALSE
	ordered_attack = FALSE
	LoseTarget()
	walk_to(src,0)
	target_mob = null //gotta stop SOMETHIN
	stop_automated_movement = 0
	if(heard_list && heard_list.len)
		say("[pick(heard_list)]")
	return 1

/mob/living/simple_animal/hostile/retaliate/talker/follower/proc/follow_command(var/mob/speaker,var/text)
	//we can assume 'stop following' is handled by stop_command
	if(findtext(text,"me"))
		target_mob = speaker //this wont bite me in the ass later.
		return 1
	var/list/targets = get_targets_by_name(text)
	if(targets.len > 1 || !targets.len) //CONFUSED. WHO DO I FOLLOW?
		return 0
	target_mob = targets[1] //YEAH GOOD IDEA
	return 1

/mob/living/simple_animal/hostile/retaliate/talker/follower/proc/friend_command(var/mob/speaker,var/text)
	//we can assume 'stop following' is handled by stop_command
	var/list/targets = get_targets_by_name(text)
	if(targets.len > 1 || !targets.len) //CONFUSED. WHO DO I FOLLOW?
		return 0
	friends |= WEAKREF(targets[1]) //YEAH GOOD IDEA
	return 1

/mob/living/simple_animal/hostile/retaliate/talker/follower/proc/misc_command(var/mob/speaker,var/text)
	return 0

/mob/living/simple_animal/hostile/retaliate/talker/follower/proc/follow_target()
	stop_automated_movement = 1
	ordered_attack = FALSE
	if(!target_mob)
		return
	walk_to(src, target_mob, 1, move_to_delay)
	followingAFriend = TRUE

/mob/living/simple_animal/hostile/retaliate/talker/follower/CheckFriendlyFire(atom/A)
	if(check_friendly_fire)
		for(var/turf/T in getline(src,A)) // Not 100% reliable but this is faster than simulating actual trajectory
			for(var/mob/living/L in T)
				if(L == src || L == A)
					continue
				if(friends.Find(WEAKREF(L)))
					return TRUE
		return ..()

/mob/living/simple_animal/hostile/retaliate/talker/follower/Retaliate()
	var/list/around = view(vision_range, src)

	for(var/atom/movable/A in around)
		if(A == src)
			continue
		if(isliving(A))
			var/mob/living/M = A
			if(!friends.Find(WEAKREF(M)))
				enemies |= WEAKREF(M)
		else if(ismecha(A))
			var/obj/mecha/M = A
			if(M.occupant && !friends.Find(WEAKREF(M.occupant)))
				enemies |= WEAKREF(M)
				enemies |= WEAKREF(M.occupant)

	for(var/mob/living/simple_animal/hostile/retaliate/H in around)
		if(faction_check_mob(H) && !attack_same && !H.attack_same)
			H.enemies |= enemies
	return 0


/mob/living/simple_animal/hostile/retaliate/talker/follower/bullet_act(var/obj/item/projectile/P, var/def_zone)
	..()
	target_mob = null
	if (friends.Find(WEAKREF(P.firer)))
		friends -= WEAKREF(P.firer)

/mob/living/simple_animal/hostile/retaliate/talker/follower/attackby(var/obj/item/O, var/mob/user)
	..()
	target_mob = null
	if(friends.Find(WEAKREF(user)))
		friends -= WEAKREF(user)

/mob/living/simple_animal/hostile/retaliate/talker/follower/hitby(atom/movable/AM, skipcatch, hitpush = TRUE, blocked = FALSE, datum/thrownthing/throwingdatum)//Standardization and logging -Sieve
	..()
	target_mob = null
	if(ismob(throwingdatum.thrower))
		if(friends.Find(WEAKREF(throwingdatum.thrower)))
			friends -= WEAKREF(throwingdatum.thrower)

/mob/living/simple_animal/hostile/retaliate/talker/follower/proc/fight_time()
	if (allowed_targets.len)
		if (allowed_targets[1] == "everyone")
			ordered_attack = TRUE
			Retaliate()
			allowed_targets = list()
		else
			enemies |= allowed_targets
			allowed_targets = list()

/mob/living/simple_animal/hostile/retaliate/talker/follower/handle_automated_movement()
	if(istype(target_mob) && !followingAFriend)
		follow_target()
	else if (!followingAFriend)
		. = ..()

/mob/living/simple_animal/hostile/retaliate/talker/follower/basic
	name = "Jeff"
	desc = "An officer part of Nanotrasen's private security force."
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
	icon_state = "nanotrasenrangedsmg"
	icon_living = "nanotrasenrangedsmg"
	vision_range = 9
	rapid = 3
	retreat_distance = 3
	minimum_distance = 5
	casingtype = /obj/item/ammo_casing/c9mm
	projectiletype = /obj/item/projectile/bullet/c9mm
	projectilesound = 'sound/weapons/gunshot_smg.ogg'
	loot = list(/obj/item/gun/ballistic/automatic/autopipe,
				/obj/effect/mob_spawn/human/corpse/nanotrasensoldier)

/mob/living/simple_animal/hostile/retaliate/talker/follower/faction
	var/list/enemy_factions = list()
	var/myplace = null
	var/my_original_loc = null
	var/return_to_post = FALSE
	speak_chance = 8
	var/waiting_ticks = 0
	var/combat_ticks = 0

/mob/living/simple_animal/hostile/retaliate/talker/follower/faction/bullet_act(var/obj/item/projectile/P, var/def_zone)
	..()
	target_mob = null
	enemies |= WEAKREF(P.firer)
	var/list/around = view(vision_range, src)
	for(var/mob/living/simple_animal/hostile/retaliate/H in around)
		if(faction_check_mob(H) && !attack_same && !H.attack_same)
			H.enemies |= enemies
	
/mob/living/simple_animal/hostile/retaliate/talker/follower/faction/attackby(var/obj/item/O, var/mob/user)
	..()
	target_mob = null
	enemies |= WEAKREF(user)
	var/list/around = view(vision_range, src)
	for(var/mob/living/simple_animal/hostile/retaliate/H in around)
		if(faction_check_mob(H) && !attack_same && !H.attack_same)
			H.enemies |= enemies

/mob/living/simple_animal/hostile/retaliate/talker/follower/faction/Retaliate()
	if (ordered_attack)
		var/list/around = view(src, vision_range)
		for(var/atom/movable/A in around)
			if(A == src)
				continue
			if(isliving(A))
				var/mob/living/M = A
				if(faction_check_mob(M) && attack_same || !faction_check_mob(M))
					enemies |= WEAKREF(M)
			else if(ismecha(A))
				var/obj/mecha/M = A
				if(M.occupant)
					enemies |= WEAKREF(M)
					enemies |= WEAKREF(M.occupant)
		for(var/mob/living/simple_animal/hostile/retaliate/H in around)
			if(faction_check_mob(H) && !attack_same && !H.attack_same)
				H.enemies |= enemies
		return 0
	else
		return 0

/mob/living/simple_animal/hostile/retaliate/talker/follower/faction/Initialize(mapload)
	myplace = get_turf(src)
	my_original_loc = loc
	..()

/mob/living/simple_animal/hostile/retaliate/talker/follower/faction/dialog_options(mob/talker, display_options)
	var/dat = "" 
	if (faction_check_mob(talker))
		dat += "<center><a href='?src=[REF(src)];post=1'>Order them back to thier post</a></center>"
	return dat


/mob/living/simple_animal/hostile/retaliate/talker/follower/faction/Hear(message, atom/movable/speaker, datum/language/message_language, raw_message, radio_freq, list/spans, message_mode, atom/movable/source)
	. = ..()
	if (faction_check_mob(speaker))
		listen(speaker, raw_message)
	return ..()

/mob/living/simple_animal/hostile/retaliate/talker/follower/faction/Topic(href, href_list)
	if(href_list["post"])
		usr.say("Return to your post.")
		if (faction_check_mob(usr))
			say("[pick(heard_list)]")
			ordered_attack = FALSE
			walk_to(src, myplace, 0 , move_to_delay)
			stop_automated_movement = 1
			return_to_post = TRUE
	..(href, href_list)


/mob/living/simple_animal/hostile/retaliate/talker/follower/faction/handle_automated_action()
	CHECK_TICK
	if (!enemies.len)
		ordered_attack = FALSE
		toggle_ai(AI_IDLE)
	else
		if (combat_ticks > 5)
			combat_ticks = 0
			var/clear_the_list = 0
			for(var/datum/weakref/en_ref in enemies)
				var/mob/living/ene = en_ref.resolve()
				if (istype(ene) && (ene.health <= 0 || faction_check_mob(ene)))
					clear_the_list = 1
			if (clear_the_list)
				enemies.Cut()
		else
			combat_ticks++
	return ..()


/mob/living/simple_animal/hostile/retaliate/talker/follower/faction/handle_automated_movement()
	CHECK_TICK
	if (return_to_post)
		if (pulledby)
			pulledby.stop_pulling()
			walk_to(src, myplace, 0 , move_to_delay)
		if (loc == my_original_loc)
			return_to_post = FALSE
			stop_automated_movement = 0
			walk_to(src,0)
			waiting_ticks = 0
		if (waiting_ticks > 4)
			return_to_post = FALSE
			stop_automated_movement = FALSE
			waiting_ticks = 0
			walk_to(src,0)
		waiting_ticks++
	else
		if (!followingAFriend && (get_dist(loc, my_original_loc) > 5) && !stop_automated_movement)
			walk_to(src, myplace, 0 , move_to_delay)
			return_to_post = TRUE
			stop_automated_movement = TRUE
		else
			for (var/mob/living/A in oview(vision_range, targets_from)) //mob/dead/observers arent possible targets
				if (faction_check(enemy_factions, A.faction) && A.health > 0)
					if (A.sneaking && (A.skill_check(SKILL_SNEAK, sneak_detection_threshold) || A.skill_roll(SKILL_SNEAK, sneak_roll_modifier)))
						to_chat(A, span_notice("[name] has not spotted you."))
					else
						enemies |= WEAKREF(A)
				if (enemies.len)
					toggle_ai(AI_ON)
			..()

/mob/living/simple_animal/hostile/retaliate/talker/follower/faction/ncr_trooper
	name = "Trooper"
	desc = "Just another trooper on patrol for the NCR."
	icon = 'icons/fallout/mobs/humans/fallout_npc.dmi'
	icon_state = "ncr_trooper"
	icon_living = "ncr_trooper"
	icon_dead = null
	del_on_death = TRUE
	icon_gib = "gib"
	turns_per_move = 5
	response_help_continuous = "pokes"
	response_help_simple = "poke"
	response_disarm_continuous = "shoves"
	response_disarm_simple = "shove"
	response_harm_continuous = "hits"
	response_harm_simple = "hit"
	speed = 0
	stat_attack = CONSCIOUS
	ranged_cooldown_time = 10
	ranged = TRUE
	robust_searching = TRUE
	healable = TRUE
	maxHealth = 120
	health = 120
	harm_intent_damage = 5
	melee_damage_lower = 10
	melee_damage_upper = 15
	attack_verb_continuous = "punches"
	attack_verb_simple = "punch"
	attack_sound = 'sound/weapons/punch1.ogg'
	faction = list(FACTION_NCR)
	enemy_factions = list(FACTION_LEGION, "hostile", "ant")
	a_intent = INTENT_HARM
	atmos_requirements = list("min_oxy" = 5, "max_oxy" = 0, "min_tox" = 0, "max_tox" = 1, "min_co2" = 0, "max_co2" = 5, "min_n2" = 0, "max_n2" = 0)
	unsuitable_atmos_damage = 15
	status_flags = CANPUSH
	search_objects = 1
	vision_range = 9
	rapid = 0
	retreat_distance = 3
	minimum_distance = 5
	projectiletype = /obj/item/projectile/bullet/a556/simple
	projectilesound = 'sound/f13weapons/varmint_rifle.ogg'
	casingtype = /obj/item/ammo_casing/a556
	projectile_sound_properties = list(
		SP_VARY(FALSE),
		SP_VOLUME(RIFLE_LIGHT_VOLUME),
		SP_VOLUME_SILENCED(RIFLE_LIGHT_VOLUME * SILENCED_VOLUME_MULTIPLIER),
		SP_NORMAL_RANGE(RIFLE_LIGHT_RANGE),
		SP_NORMAL_RANGE_SILENCED(SILENCED_GUN_RANGE),
		SP_IGNORE_WALLS(TRUE),
		SP_DISTANT_SOUND(RIFLE_LIGHT_DISTANT_SOUND),
		SP_DISTANT_RANGE(RIFLE_LIGHT_RANGE_DISTANT)
	)
	speak = list("Patrolling the Mojave almost makes you wish for a nuclear winter.", "When I got this assignment I was hoping there would be more gambling.", "It's been a long tour, all I can think about now is going back home.", "You know, if you were serving, you'd probably be halfway to general by now.", "You oughtta think about enlisting. We need you here.")
	speak_emote = list("says")
	loot = list(/obj/effect/mob_spawn/human/corpse/ncr)


/mob/living/simple_animal/hostile/retaliate/talker/follower/faction/legion_guard
	name = "Legion Guard"
	desc = "A recruit legionary."
	icon = 'icons/fallout/mobs/humans/fallout_npc.dmi'
	icon_state = "legion_prime"
	icon_living = "legion_prime"
	icon_dead = null
	del_on_death = TRUE
	gender = MALE
	icon_gib = "gib"
	turns_per_move = 5
	response_help_continuous = "pokes"
	response_help_simple = "poke"
	response_disarm_continuous = "shoves"
	response_disarm_simple = "shove"
	response_harm_continuous = "hits"
	response_harm_simple = "hit"
	speed = 0
	stat_attack = CONSCIOUS
	ranged = TRUE
	robust_searching = TRUE
	healable = TRUE
	maxHealth = 120
	health = 120
	harm_intent_damage = 5
	melee_damage_lower = 10
	melee_damage_upper = 15
	attack_verb_continuous = "punches"
	attack_verb_simple = "punch"
	attack_sound = 'sound/weapons/punch1.ogg'
	faction = list(FACTION_LEGION)
	enemy_factions = list(FACTION_NCR, "hostile", "supermutant", "scorched", "ant")
	a_intent = INTENT_HARM
	atmos_requirements = list("min_oxy" = 5, "max_oxy" = 0, "min_tox" = 0, "max_tox" = 1, "min_co2" = 0, "max_co2" = 5, "min_n2" = 0, "max_n2" = 0)
	unsuitable_atmos_damage = 15
	status_flags = CANPUSH
	search_objects = 1
	vision_range = 9
	retreat_distance = 3
	minimum_distance = 5
	speak = list("Ave, true to Caesar.", "True to Caesar.", "Ave, Amicus.", "The new slave girls are quite beautiful.", "Give me cause, Profligate.", "Degenerates like you belong on a cross.")
	speak_emote = list("says")
	projectiletype = /obj/item/projectile/bullet/a762/sport/simple
	projectilesound = 'sound/f13weapons/hunting_rifle.ogg'
	casingtype = /obj/item/ammo_casing/a762/sport
	projectile_sound_properties = list(
		SP_VARY(FALSE),
		SP_VOLUME(RIFLE_MEDIUM_VOLUME),
		SP_VOLUME_SILENCED(RIFLE_MEDIUM_VOLUME * SILENCED_VOLUME_MULTIPLIER),
		SP_NORMAL_RANGE(RIFLE_MEDIUM_RANGE),
		SP_NORMAL_RANGE_SILENCED(SILENCED_GUN_RANGE),
		SP_IGNORE_WALLS(TRUE),
		SP_DISTANT_SOUND(RIFLE_MEDIUM_DISTANT_SOUND),
		SP_DISTANT_RANGE(RIFLE_MEDIUM_RANGE_DISTANT)
	)
	loot = list(/obj/effect/mob_spawn/human/corpse/legion)
