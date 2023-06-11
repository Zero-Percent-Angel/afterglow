/proc/job_is_whitelist_locked(jobtitle)
	if(!CONFIG_GET(flag/use_role_whitelist) && (jobtitle in GLOB.command_positions | GLOB.ncr_command_positions | GLOB.bos_command_positions | GLOB.legion_command_positions | GLOB.town_command_positions | GLOB.vault_command_positions | GLOB.ncr_elite_positions | GLOB.bos_elite_positions | GLOB.legion_elite_positions | GLOB.tribe_outlaw_positions))
		return FALSE
	if(!CONFIG_GET(flag/use_role_whitelist) && !(jobtitle in GLOB.command_positions | GLOB.ncr_command_positions | GLOB.bos_command_positions | GLOB.legion_command_positions | GLOB.town_command_positions | GLOB.vault_command_positions | GLOB.ncr_elite_positions | GLOB.bos_elite_positions | GLOB.legion_elite_positions | GLOB.tribe_outlaw_positions))
		return FALSE
	return TRUE

/datum/job/proc/whitelist_locked(client/C, jobname)
	if((C.prefs.job_whitelists[jobname]) || (!CONFIG_GET(flag/use_role_whitelist)))
		return FALSE
	return TRUE


//Get this client's whitelists from the database, if any.
/client/proc/set_job_whitelist_from_db()
	if(!CONFIG_GET(flag/use_role_whitelist))
		return -1
	if(!SSdbcore.Connect())
		return -1
	var/datum/db_query/whitelist_read = SSdbcore.NewQuery(
		"SELECT whitelist FROM [format_table_name("role_whitelist")] WHERE ckey = :ckey",
		list("ckey" = ckey)
	)
	if(!whitelist_read.Execute())
		qdel(whitelist_read)
		return -1
	var/list/play_records = list()
	var/list/whitelists = list()
	while(whitelist_read.NextRow())
		whitelists[whitelist_read.item[1]] = whitelist_read.item[1]  // should create a whitelists["whitelist name"] for each whitelist held by the user

	for(var/rtype in SSjob.name_occupations)    //cycle through all of the jobs and add them to the full list
		play_records[rtype] = rtype

	qdel(whitelist_read)
	
	if(!whitelists["ncr_elite"])							//if they do not have ncr_elite whitelist, remove ncr_elite whitelist positions
		for (var/rtypeWL in GLOB.ncr_elite_positions)
			play_records[rtypeWL] = 0

	if(!whitelists["bos_elite"])					// if they do not have bos_elite whitelist, remove bos_elite whitelist positions
		for(var/rtypeWL in GLOB.bos_elite_positions)
			play_records[rtypeWL] = 0
	
	if(!whitelists["leg_elite"])					// if they do not have leg_elite whitelist, remove leg_elite whitelist positions
		for(var/rtypeWL in GLOB.legion_elite_positions)
			play_records[rtypeWL] = 0

	if(!whitelists["leadership"])					// if they do not have leadership whitelist, remove leadership whitelist positions
		for(var/rtypeWL in GLOB.command_positions)
			play_records[rtypeWL] = 0

	if(!whitelists["leadership_ncr"])					// if they do not have leadership_ncr whitelist, remove leadership_ncr whitelist positions
		for(var/rtypeWL in GLOB.ncr_command_positions)
			play_records[rtypeWL] = 0

	if(!whitelists["leadership_bos"])					// if they do not have leadership_bos whitelist, remove leadership_bos whitelist positions
		for(var/rtypeWL in GLOB.bos_command_positions)
			play_records[rtypeWL] = 0

	if(!whitelists["leadership_legion"])				// if they do not have leadership_leg whitelist, remove leadership_leg whitelist positions
		for(var/rtypeWL in GLOB.legion_command_positions)
			play_records[rtypeWL] = 0

	if(!whitelists["leadership_town"])					// if they do not have leadership_town whitelist, remove leadership_town whitelist positions
		for(var/rtypeWL in GLOB.town_command_positions)
			play_records[rtypeWL] = 0

	if(!whitelists["leadership_vault"])					// if they do not have leadership_legion vault, remove leadership_vault whitelist positions
		for(var/rtypeWL in GLOB.vault_command_positions)
			play_records[rtypeWL] = 0

	if(!whitelists["tribe_outlaw_positions"])
		for(var/rtypeWL in GLOB.tribe_outlaw_positions)
			play_records[rtypeWL] = 0

	//This section is for IF the personh has a whitelist, then it allows them to play the job. For every '!whitelists' entry, you WILL need one of these too.

	if(whitelists["ncr_elite"])
		for(var/rtypeWL in GLOB.ncr_elite_positions)
			play_records[rtypeWL] = rtypeWL

	if(whitelists["bos_elite"])
		for(var/rtypeWL in GLOB.bos_elite_positions)
			play_records[rtypeWL] = rtypeWL

	if(whitelists["leg_elite"])
		for(var/rtypeWL in GLOB.legion_elite_positions)
			play_records[rtypeWL] = rtypeWL

	if(whitelists["leadership"])
		for(var/rtypeWL in GLOB.command_positions)
			play_records[rtypeWL] = rtypeWL
	
	if(whitelists["leadership_ncr"])
		for(var/rtypeWL in GLOB.ncr_command_positions)
			play_records[rtypeWL] = rtypeWL
	
	if(whitelists["leadership_bos"])
		for(var/rtypeWL in GLOB.bos_command_positions)
			play_records[rtypeWL] = rtypeWL
	
	if(whitelists["leadership_legion"])
		for(var/rtypeWL in GLOB.legion_command_positions)
			play_records[rtypeWL] = rtypeWL
	
	if(whitelists["leadership_town"])
		for(var/rtypeWL in GLOB.town_command_positions)
			play_records[rtypeWL] = rtypeWL
	
	if(whitelists["leadership_vault"])
		for(var/rtypeWL in GLOB.vault_command_positions)
			play_records[rtypeWL] = rtypeWL
	
	if(whitelists["tribe_outlaw_positions"])
		for(var/rtypeWL in GLOB.tribe_outlaw_positions)
			play_records[rtypeWL] = 0
	
	/* - Old shit, don't activate this. I'm just too lazy to remove it and keeping it incase I fucked something up. - Rebel0
	
	if(!whitelists["faction_legion"])					// if they do not have faction_legion whitelist, remove faction_legion whitelist positions
		for(var/rtypeWL in GLOB.legion_positions)
			play_records[rtypeWL] = 0

	if(!whitelists["faction_vault"])					// if they do not have faction_vault whitelist, remove faction_vault whitelist positions
		for(var/rtypeWL in GLOB.vault_positions)
			play_records[rtypeWL] = 0

	if(!whitelists["faction_tow"])					// if they do not have faction_vault whitelist, remove faction_vault whitelist positions
		for(var/rtypeWL in GLOB.vault_positions)
			play_records[rtypeWL] = 0

	if(!whitelists["vetranger"])
		for(var/rtypeWL in GLOB.ncr_rangervet_positions)	// if they do not have ranger whitelist, remove ranger whitelist positions
			play_records[rtypeWL] = 0

	if(!whitelists["faction"])							// if they do not have faction whitelist, remove faction whitelist positions This whitelist is for all roles.
		for(var/rtypeWL in GLOB.faction_whitelist_positions)
			play_records[rtypeWL] = 0
	*/

	prefs.job_whitelists = play_records
