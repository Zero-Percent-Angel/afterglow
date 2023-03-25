SUBSYSTEM_DEF(waster_spawn)
	name = "NPC Waster Spawn"
	wait = 10 MINUTES
	var/successful_firing = 0
	var/allowed_firings = 90
	var/chance_of_fire = 80 


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
		return
	successful_firing++
	addtimer(CALLBACK(src, .proc/spawn_waster), 10 SECONDS)

/datum/controller/subsystem/waster_spawn/proc/spawn_waster()
	var/list/possible_positions = list()
	for(var/obj/effect/landmark/npc_wastelander_spawn_position/S in GLOB.landmarks_list)
		possible_positions += S
	var/obj/effect/landmark/npc_wastelander_spawn_position/choosen = pick(possible_positions)
	var/mob/living/simple_animal/hostile/retaliate/talker/follower/basic/ourboy = new /mob/living/simple_animal/hostile/retaliate/talker/follower/basic(choosen.loc)
	message_admins("Spawned: [ourboy] at [ADMIN_COORDJMP(choosen)]")
	log_game("Spawned: [ourboy] at [ourboy.loc]")
