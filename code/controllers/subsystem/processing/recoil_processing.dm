SUBSYSTEM_DEF(recoil_processing)
	wait = 5
	flags = SS_KEEP_TIMING
	runlevels = RUNLEVEL_GAME | RUNLEVEL_POSTGAME
	priority = FIRE_PRIORITY_CALLBACKS
	name = "Recoil Processing"
	var/list/currentrun = list()
	var/list/processing = list()

/datum/controller/subsystem/recoil_processing/stat_entry(msg)
	msg = "P:[length(processing)]"
	return ..()

/datum/controller/subsystem/recoil_processing/fire(resumed = 0)
	if (!resumed)
		src.currentrun = processing.Copy()

	//cache for sanic speed (lists are references anyways)
	var/list/currentrun = src.currentrun

	while (currentrun.len)
		var/mob/living/O = currentrun[currentrun.len]
		currentrun.len--
		if (!O || QDELETED(O))
			processing -= O
			continue
		if (O.stat != DEAD)
			O.calc_recoil()
