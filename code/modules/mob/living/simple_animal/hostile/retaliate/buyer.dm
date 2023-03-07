/mob/living/simple_animal/hostile/retaliate/talker/buyer 
	var/myplace = null
	var/my_original_loc = null
	var/walking = FALSE


/mob/living/simple_animal/hostile/retaliate/talker/trader/dialog_options(mob/talker, display_options)
	var/dat = ""
	if (!broken_trust.Find(WEAKREF(talker)) && !enemies.Find(WEAKREF(talker)) && !failed.Find(WEAKREF(talker)))
		dat += "<center><a href='?src=[REF(src)];trade=1'>Ask if \he will buy your held item.</a></center>"
	return dat
