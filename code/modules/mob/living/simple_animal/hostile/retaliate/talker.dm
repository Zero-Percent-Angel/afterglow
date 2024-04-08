/mob/living/simple_animal/hostile/retaliate/talker
	will_talk = TRUE
	var/list/broken_trust = list()
	var/list/introduced = list()
	var/list/failed = list()
	var/list/intimidated = list()
	var/intimidation_difficulty = DIFFICULTY_NORMAL
	var/randomise_name = TRUE
	var/use_custom_names = FALSE
	var/list/custom_first_names = list()
	var/list/custom_last_names = list()
	var/agressive_to_everyone_on_attack = FALSE
	var/mob/target_mob = null
	desc = "Just someone out in the wastes trying to survive."

/mob/living/simple_animal/hostile/retaliate/talker/basic
	name = "Nanotrasen Private Security Officer"
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
	faction = list("nanotrasenprivate")
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


/mob/living/simple_animal/hostile/retaliate/talker/Retaliate()
	if (agressive_to_everyone_on_attack)
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

/mob/living/simple_animal/hostile/retaliate/talker/attacked_by(obj/item/I, mob/living/user, attackchain_flags = NONE, damage_multiplier = 1, damage_addition)
	var/user_ref = WEAKREF(user)
	if(!friends.Find(user_ref))
		enemies |= user_ref
	toggle_ai(AI_ON)
	..()
	target_mob = null
	if (friends.Find(user_ref))
		friends -= user_ref
		say("You bastard...")

/mob/living/simple_animal/hostile/retaliate/talker/bullet_act(obj/item/projectile/P, def_zone)
	var/user_ref = WEAKREF(P.firer)
	if(!friends.Find(user_ref))
		enemies |= user_ref
	toggle_ai(AI_ON)
	..()
	target_mob = null
	if (friends.Find(user_ref))
		friends -= user_ref
		say("Friendly fire!")

/mob/living/simple_animal/hostile/retaliate/talker/attack_animal(mob/user)
	var/user_ref = WEAKREF(user)
	if(!friends.Find(user_ref))
		enemies |= user_ref
	toggle_ai(AI_ON)
	..()
	target_mob = null


/mob/living/simple_animal/hostile/retaliate/talker/handle_automated_action()
	..()
	if (!enemies.len)
		toggle_ai(AI_IDLE)

/mob/living/simple_animal/hostile/retaliate/talker/on_attack_hand(mob/living/carbon/human/M)
	if (M.a_intent != INTENT_HELP)
		var/user_ref = WEAKREF(M)
		target_mob = null
		if(!friends.Find(user_ref))
			enemies |= user_ref
		toggle_ai(AI_ON)
		say("You bastard...")
	return ..()

/mob/living/simple_animal/hostile/retaliate/talker/proc/handle_enemy(mob/maybe_enemy)
	enemies += WEAKREF(maybe_enemy)

/mob/living/simple_animal/hostile/retaliate/talker/Initialize()
	. = ..()
	if (randomise_name)
		if (use_custom_names)
			name = capitalize(pick(custom_first_names)) + " " + capitalize(pick(custom_last_names))
		else
			if (gender == MALE)
				name = capitalize(pick(GLOB.first_names_male)) + " " + capitalize(pick(GLOB.last_names))
			else
				name = capitalize(pick(GLOB.first_names_female)) + " " + capitalize(pick(GLOB.last_names))


/mob/living/simple_animal/hostile/retaliate/talker/talk_to(mob/talker)
	face_atom(talker)
	if (enemies.Find(WEAKREF(talker)))
		if(!broken_trust.Find(WEAKREF(talker)) && talker.skill_roll(SKILL_SPEECH))
			say("Alright.... But shoot me again and there will be trouble.")
			enemies -= WEAKREF(talker)
			broken_trust |= WEAKREF(talker)
		else
			say("Fight me or run- I don't trust you for nothin.")
	else
		show_dialog_box(talker)

/mob/living/simple_animal/hostile/retaliate/talker/proc/show_dialog_box(mob/talker, say_hello = TRUE)
	var/datum/browser/popup = new(talker, name, name, 400, 500)
	var/dat = dialog(talker, say_hello)
	popup.set_content(dat)
	popup.open()

/mob/living/simple_animal/hostile/retaliate/talker/proc/dialog(mob/talker, say_hello = TRUE)
	var/reply_name = "Stranger"
	var/we_introduced = FALSE
	if (introduced.Find(WEAKREF(talker)))
		reply_name = talker.name
		we_introduced = TRUE
	var/dat = ""
	if (!failed.Find(talker))
		dat +=  "Hello [reply_name]."
	else
		dat +=  "Oh, you again. What do you want?"
	if (say_hello)
		say(dat)
	if(!we_introduced)
		dat += "<center><a href='?src=[REF(src)];introduce=1'>Introduce yourself</a></center>"
	if(!friends.Find(WEAKREF(talker)) && !intimidated.Find(WEAKREF(talker)) && !failed.Find(WEAKREF(talker)))
		dat += "<center><a href='?src=[REF(src)];stare=1'>Remain silent and stare. (Speech - Intimidate)</a></center>"
	dat += dialog_options(talker, we_introduced || intimidated.Find(WEAKREF(talker)))
	return dat

/mob/living/simple_animal/hostile/retaliate/talker/proc/dialog_options(mob/talker, display_options)
	return ""


/mob/living/simple_animal/hostile/retaliate/talker/Topic(href, href_list)
	if(href_list["introduce"])
		usr.say("My name is [usr.name].")
		introduced |= WEAKREF(usr)
		say("Pleased to meet you, [usr.name].")
		show_dialog_box(usr, FALSE)
	if(href_list["stare"])
		usr.emote("stare")
		introduced |= WEAKREF(usr)
		if (!failed.Find(WEAKREF(usr)) && usr.skill_roll(SKILL_SPEECH, intimidation_difficulty))
			say("Right... Can I help you?")
			intimidated |= WEAKREF(usr)
		else
			emote("stare")
			failed |= WEAKREF(usr)
		show_dialog_box(usr, FALSE)

