/client/proc/mentor_memo()
	set name = "Mentor Memos"
	set category = "Server"
	if(!check_rights(0))
		return
	if(!SSdbcore.IsConnected())
		to_chat(src, span_danger("Failed to establish database connection."))
		return
	var/memotask = input(usr,"Choose task.","Memo") in list("Show","Write","Edit","Remove")
	if(!memotask)
		return
	mentor_memo_output(memotask)

/client/proc/show_mentor_memo()
	set name = "Show Memos"
	set category = "Mentor"
	if(!is_mentor())
		return
	if(!SSdbcore.IsConnected())
		to_chat(src, span_danger("Failed to establish database connection."))
		return
	mentor_memo_output("Show")

/client/proc/mentor_memo_output(task)
	if(!task)
		return
	if(!SSdbcore.IsConnected())
		to_chat(src, span_danger("Failed to establish database connection."))
		return
	switch(task)
		if("Write")
			var/datum/db_query/query_memocheck = SSdbcore.NewQuery(
				"SELECT ckey FROM [format_table_name("mentor_memo")] WHERE ckey = :ckey",
				list("ckey" = ckey)
			)
			if(!query_memocheck.Execute())
				var/err = query_memocheck.ErrorMsg()
				qdel(query_memocheck)
				log_game("SQL ERROR obtaining ckey from memo table. Error : \[[err]\]\n")
				return
			if(query_memocheck.NextRow())
				qdel(query_memocheck)
				to_chat(src, "You already have set a memo.")
				return
			qdel(query_memocheck)
			var/memotext = input(src,"Write your Memo","Memo") as message
			if(!memotext)
				return
			var/timestamp = SQLtime()
			var/datum/db_query/query_memoadd = SSdbcore.NewQuery(
				"INSERT INTO [format_table_name("mentor_memo")] (ckey, memotext, timestamp) VALUES (:ckey, :memotext, :timestamp)",
				list("ckey" = ckey, "memotext" = sanitizeSQL(memotext), "timestamp" = timestamp)
			)
			if(!query_memoadd.Execute())
				var/err = query_memoadd.ErrorMsg()
				qdel(query_memoadd)
				log_game("SQL ERROR adding new memo. Error : \[[err]\]\n")
				return
			log_admin("[key_name(src)] has set a mentor memo: [memotext]")
			message_admins("[key_name_admin(src)] has set a mentor memo:<br>[memotext]")
			qdel(query_memoadd)
		if("Edit")
			var/datum/db_query/query_memolist = SSdbcore.NewQuery("SELECT ckey FROM [format_table_name("mentor_memo")]")
			if(!query_memolist.Execute())
				var/err = query_memolist.ErrorMsg()
				qdel(query_memolist)
				log_game("SQL ERROR obtaining ckey from memo table. Error : \[[err]\]\n")
				return
			var/list/memolist = list()
			while(query_memolist.NextRow())
				var/lkey = query_memolist.item[1]
				memolist += "[lkey]"
			qdel(query_memolist)
			if(!memolist.len)
				to_chat(src, "No memos found in database.")
				return
			var/target_ckey = input(src, "Select whose memo to edit", "Select memo") as null|anything in memolist
			if(!target_ckey)
				return
			var/datum/db_query/query_memofind = SSdbcore.NewQuery(
				"SELECT memotext FROM [format_table_name("mentor_memo")] WHERE ckey = :ckey",
				list("ckey" = target_ckey)
			)
			if(!query_memofind.Execute())
				var/err = query_memofind.ErrorMsg()
				qdel(query_memofind)
				log_game("SQL ERROR obtaining memotext from memo table. Error : \[[err]\]\n")
				return
			if(query_memofind.NextRow())
				var/old_memo = unsanitizeSQL(query_memofind.item[1])
				qdel(query_memofind)
				var/new_memo = input("Input new memo", "New Memo", "[old_memo]", null) as message
				if(!new_memo)
					return
				var/edit_text = "Edited by [ckey] on [SQLtime()] from<br>[old_memo]<br>to<br>[new_memo]<hr>"
				var/datum/db_query/update_query = SSdbcore.NewQuery(
					"UPDATE [format_table_name("mentor_memo")] SET memotext = :memotext, last_editor = :last_editor, edits = CONCAT(IFNULL(edits,''), :edit_text) WHERE ckey = :ckey",
					list("memotext" = sanitizeSQL(new_memo), "last_editor" = ckey, "ckey" = target_ckey, "edit_text" = sanitizeSQL(edit_text))
				)
				if(!update_query.Execute())
					var/err = update_query.ErrorMsg()
					qdel(update_query)
					log_game("SQL ERROR editing memo. Error : \[[err]\]\n")
					return
				if(target_ckey == ckey)
					log_admin("[key_name(src)] has edited their mentor memo from [old_memo] to [new_memo]")
					message_admins("[key_name_admin(src)] has edited their mentor memo from<br>[old_memo]<br>to<br>[new_memo]")
				else
					log_admin("[key_name(src)] has edited [target_ckey]'s mentor memo from [old_memo] to [new_memo]")
					message_admins("[key_name_admin(src)] has edited [target_ckey]'s mentor memo from<br>[old_memo]<br>to<br>[new_memo]")
				qdel(update_query)
			else
				qdel(query_memofind)
		if("Show")
			var/datum/db_query/query_memoshow = SSdbcore.NewQuery("SELECT ckey, memotext, timestamp, last_editor FROM [format_table_name("mentor_memo")]")
			if(!query_memoshow.Execute())
				var/err = query_memoshow.ErrorMsg()
				qdel(query_memoshow)
				log_game("SQL ERROR obtaining ckey, memotext, timestamp, last_editor from memo table. Error : \[[err]\]\n")
				return
			var/output = null
			while(query_memoshow.NextRow())
				var/ckey = query_memoshow.item[1]
				var/memotext = unsanitizeSQL(query_memoshow.item[2])
				var/timestamp = query_memoshow.item[3]
				var/last_editor = query_memoshow.item[4]
				output += "<span class='memo'>Mentor memo by <span class='prefix'>[ckey]</span> on [timestamp]"
				if(last_editor)
					output += "<br><span class='memoedit'>Last edit by [last_editor] <A href='byond://?_src_=holder;mentormemoeditlist=[ckey]'>(Click here to see edit log)</A></span>"
				output += "<br>[memotext]</span><br>"
			qdel(query_memoshow)
			if(!output)
				to_chat(src, "No memos found in database.")
				return
			to_chat(src, output)
		if("Remove")
			var/datum/db_query/query_memodellist = SSdbcore.NewQuery("SELECT ckey FROM [format_table_name("mentor_memo")]")
			if(!query_memodellist.Execute())
				var/err = query_memodellist.ErrorMsg()
				qdel(query_memodellist)
				log_game("SQL ERROR obtaining ckey from memo table. Error : \[[err]\]\n")
				return
			var/list/memolist = list()
			while(query_memodellist.NextRow())
				var/ckey = query_memodellist.item[1]
				memolist += "[ckey]"
			qdel(query_memodellist)
			if(!memolist.len)
				to_chat(src, "No memos found in database.")
				return
			var/target_ckey = input(src, "Select whose mentor memo to delete", "Select mentor memo") as null|anything in memolist
			if(!target_ckey)
				return
			var/datum/db_query/query_memodel = SSdbcore.NewQuery(
				"DELETE FROM [format_table_name("memo")] WHERE ckey = :ckey",
				list("ckey" = target_ckey)
			)
			if(!query_memodel.Execute())
				var/err = query_memodel.ErrorMsg()
				qdel(query_memodel)
				log_game("SQL ERROR removing memo. Error : \[[err]\]\n")
				return
			if(target_ckey == ckey)
				log_admin("[key_name(src)] has removed their mentor memo.")
				message_admins("[key_name_admin(src)] has removed their mentor memo.")
			else
				log_admin("[key_name(src)] has removed [target_ckey]'s mentor memo.")
				message_admins("[key_name_admin(src)] has removed [target_ckey]'s mentor memo.")
