SUBSYSTEM_DEF(waster_spawn)
	name = "NPC Waster Spawn"
	wait = 20 MINUTES
	var/successful_firing = 0
	var/allowed_firings = 90
	var/chance_of_fire = 80
	var/silence = FALSE
	var/list/legion_done = list()


/datum/controller/subsystem/waster_spawn/fire(resumed = 0)
	if(times_fired <= 0)
		message_admins("The npc waster spawner has fired.")
		log_game("The npc waster spawner has fired.")
		return
	if(successful_firing >= allowed_firings)
		message_admins("The npc waster spawner has been disabled, maximum amount of wasters spawned.")
		log_game("The npc waster spawner has been disabled, maximum amount of wasters spawned.")
		can_fire = FALSE
		return
	if(!prob(chance_of_fire))
		CHECK_TICK
		legion_takeover()
		return
	successful_firing++
	addtimer(CALLBACK(src, PROC_REF(spawn_waster)), 10 SECONDS)

/datum/controller/subsystem/waster_spawn/proc/spawn_waster()
	var/list/possible_positions = list()
	for(var/obj/effect/landmark/npc_wastelander_spawn_position/S in GLOB.landmarks_list)
		possible_positions += S
	var/obj/effect/landmark/npc_wastelander_spawn_position/choosen = pick(possible_positions)
	var/mob/living/simple_animal/hostile/retaliate/talker/follower/basic/ourboy = new /mob/living/simple_animal/hostile/retaliate/talker/follower/basic(choosen.loc)
	message_admins("Spawned: [ourboy] at [ADMIN_COORDJMP(choosen)]")
	log_game("Spawned: [ourboy] at [ourboy.loc]")

/datum/controller/subsystem/waster_spawn/proc/legion_takeover()
	var/list/possible_positions = list()
	for(var/obj/effect/landmark/legion_attack/S in GLOB.landmarks_list)
		possible_positions += S
	possible_positions.RemoveAll(legion_done)
	if (possible_positions.len)
		var/obj/effect/landmark/legion_attack/choosen = pick(possible_positions)
		if (choosen.id)
			for (var/obj/effect/landmark/legion_attack/M in possible_positions)
				if (M.id == choosen.id)
					do_legion_take_over(M)
					legion_done += M
		else
			do_legion_take_over(choosen)
			legion_done += choosen

/datum/controller/subsystem/waster_spawn/proc/do_legion_take_over(obj/effect/landmark/legion_attack/choosen)
	for (var/mob/living/carbon/human/human in oview(9, choosen))
		if (human.stat != DEAD)
			return
	// do legion spawn here
	new /mob/living/simple_animal/hostile/retaliate/talker/follower/faction/warner/legion_guard(choosen.loc)
	new /mob/living/simple_animal/hostile/retaliate/talker/follower/faction/warner/legion_guard(choosen.loc)
	new /mob/living/simple_animal/hostile/retaliate/talker/follower/faction/warner/legion_guard/melee(choosen.loc)
	new /mob/living/simple_animal/hostile/retaliate/talker/follower/faction/warner/legion_guard/melee(choosen.loc)
	new /mob/living/simple_animal/hostile/retaliate/talker/follower/faction/warner/legion_guard/melee(choosen.loc)
	var/mob/living/simple_animal/hostile/retaliate/talker/follower/faction/legion_guard/decanus/d = new /mob/living/simple_animal/hostile/retaliate/talker/follower/faction/legion_guard/decanus(choosen.loc)
	//announce
	d.rad = new /obj/item/radio(d)
	if (!silence)
		d.rad.talk_into(d, pick(d.phrases) + choosen.phrase, FREQ_COMMON)
		silence = TRUE
	addtimer(CALLBACK(src, PROC_REF(unmute)), 10 SECONDS)
	message_admins("Spawned: A legion event at [ADMIN_COORDJMP(choosen)]")
	log_game("Spawned: A legion event at at [choosen.loc]")
	return TRUE

/datum/controller/subsystem/waster_spawn/proc/unmute()
	silence = FALSE
