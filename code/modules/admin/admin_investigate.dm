/atom/proc/investigate_log(message, subject)
	if(!message || !subject)
		return
	var/F = wrap_file("[GLOB.log_directory]/[subject].html")
	WRITE_FILE(F, "<small>[TIME_STAMP("hh:mm:ss", FALSE)] [REF(src)] ([x],[y],[z])</small> || [src] [message]<br>")

/client/proc/investigate_show()
	set name = "Investigate"
	set category = "Admin.Game"
	if(!holder)
		return

	var/list/investigates = list(INVESTIGATE_DESTROYED,INVESTIGATE_RCD, INVESTIGATE_RESEARCH, INVESTIGATE_EXONET, INVESTIGATE_PORTAL, INVESTIGATE_SINGULO, INVESTIGATE_WIRES, INVESTIGATE_TELESCI, INVESTIGATE_GRAVITY, INVESTIGATE_RECORDS, INVESTIGATE_CARGO, INVESTIGATE_SUPERMATTER, INVESTIGATE_ATMOS, INVESTIGATE_EXPERIMENTOR, INVESTIGATE_BOTANY, INVESTIGATE_HALLUCINATIONS, INVESTIGATE_RADIATION, INVESTIGATE_CIRCUIT, INVESTIGATE_NANITES, INVESTIGATE_CRYOGENICS)

	var/list/logs_present = list("notes, memos, watchlist")
	var/list/logs_missing = list("---")

	for(var/subject in investigates)
		var/temp_file = wrap_file("[GLOB.log_directory]/[subject].html")
		if(fexists(temp_file))
			logs_present += subject
		else
			logs_missing += "[subject] (empty)"

	var/list/combined = sortList(logs_present) + sortList(logs_missing)

	var/selected = input("Investigate what?", "Investigate") as null|anything in combined

	if(!(selected in combined) || selected == "---")
		return

	selected = replacetext(selected, " (empty)", "")

	if(selected == "notes, memos, watchlist" && check_rights(R_ADMIN))
		browse_messages()
		return

	var/F = wrap_file("[GLOB.log_directory]/[selected].html")
	if(!fexists(F))
		to_chat(src, span_danger("No [selected] logfile was found."), confidential = TRUE)
		return
	src << browse(HTML_SKELETON(F),"window=investigate[selected];size=800x300")
