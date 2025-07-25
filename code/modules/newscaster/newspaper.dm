/obj/item/newspaper
	name = "newspaper"
	desc = "An issue of The Courier Mail. A post-war print imitating the style of pre-war tabloids."
	icon = 'icons/obj/bureaucracy.dmi'
	icon_state = "newspaper"
	lefthand_file = 'icons/mob/inhands/misc/books_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/misc/books_righthand.dmi'
	w_class = WEIGHT_CLASS_SMALL
	attack_verb = list("bapped")
	var/screen = 0
	var/pages = 0
	var/curr_page = 0
	var/list/datum/news/feed_channel/news_content = list()
	var/scribble=""
	var/scribble_page = null
	var/wantedAuthor
	var/wantedCriminal
	var/wantedBody
	var/wantedPhoto
	var/creationTime

/obj/item/newspaper/suicide_act(mob/user)
	user.visible_message(span_suicide("[user] is focusing intently on [src]! It looks like [user.p_theyre()] trying to commit sudoku... until [user.p_their()] eyes light up with realization!"))
	user.say(";JOURNALISM IS MY CALLING! EVERYBODY APPRECIATES UNBIASED REPORTI-GLORF", forced="newspaper suicide")
	var/mob/living/carbon/human/H = user
	var/obj/W = new /obj/item/reagent_containers/food/drinks/bottle/whiskey(H.loc)
	playsound(H.loc, 'sound/items/drink.ogg', rand(10,50), 1)
	W.reagents.trans_to(H, W.reagents.total_volume)
	user.visible_message(span_suicide("[user] downs the contents of [W.name] in one gulp! Shoulda stuck to sudoku!"))

	return(TOXLOSS)

/obj/item/newspaper/attack_self(mob/user)
	if(ishuman(user))
		var/mob/living/carbon/human/human_user = user
		var/dat
		pages = 0
		switch(screen)
			if(0) //Cover
				dat+="<DIV ALIGN='center'><B><FONT SIZE=6>The Courier Mail</FONT></B></div>"
				dat+="<DIV ALIGN='center'><FONT SIZE=2>Bringing you the latest from places you never imagined remained habitable.</FONT></div><HR>"
				if(isemptylist(news_content))
					if(wantedAuthor)
						dat+="Contents:<BR><ul><B><FONT COLOR='red'>**</FONT>Important Safety Announcement<FONT COLOR='red'>**</FONT></B> <FONT SIZE=2>\[page [pages+2]\]</FONT><BR></ul>"
					else
						dat+="<I>Other than the title, the rest of the newspaper is unprinted...</I>"
				else
					dat+="Contents:<BR><ul>"
					for(var/datum/news/feed_channel/NP in news_content)
						pages++
					if(wantedAuthor)
						dat+="<B><FONT COLOR='red'>**</FONT>Important Safety Announcement<FONT COLOR='red'>**</FONT></B> <FONT SIZE=2>\[page [pages+2]\]</FONT><BR>"
					var/temp_page=0
					for(var/datum/news/feed_channel/NP in news_content)
						temp_page++
						dat+="<B>[NP.channel_name]</B> <FONT SIZE=2>\[page [temp_page+1]\]</FONT><BR>"
					dat+="</ul>"
				if(scribble_page==curr_page)
					dat+="<BR><I>There is a small scribble near the end of this page... It reads: \"[scribble]\"</I>"
				dat+= "<HR><DIV STYLE='float:right;'><A href='byond://?src=[REF(src)];next_page=1'>Next Page</A></DIV> <div style='float:left;'><A href='byond://?src=[REF(human_user)];mach_close=newspaper_main'>Done reading</A></DIV>"
			if(1) // X channel pages inbetween.
				for(var/datum/news/feed_channel/NP in news_content)
					pages++
				var/datum/news/feed_channel/C = news_content[curr_page]
				dat += "<FONT SIZE=4><B>[C.channel_name]</B></FONT><FONT SIZE=1> \[created by: <FONT COLOR='maroon'>[C.returnAuthor(notContent(C.authorCensorTime))]</FONT>\]</FONT><BR><BR>"
				if(notContent(C.DclassCensorTime))
					dat+="This channel was deemed dangerous to the general welfare of the public and therefore marked with a <B><FONT COLOR='red'>D-Notice</B></FONT>. Its contents were not transferred to the newspaper at the time of printing."
				else
					if(isemptylist(C.messages))
						dat+="No Feed stories stem from this channel..."
					else
						var/i = 0
						for(var/datum/news/feed_message/MESSAGE in C.messages)
							if(MESSAGE.creationTime > creationTime)
								if(i == 0)
									dat+="No Feed stories stem from this channel..."
								break
							if(i == 0)
								dat+="<ul>"
							i++
							dat+="-[MESSAGE.returnBody(notContent(MESSAGE.bodyCensorTime))] <BR>"
							if(MESSAGE.img)
								user << browse_rsc(MESSAGE.img, "tmp_photo[i].png")
								dat+="<img src='tmp_photo[i].png' width = '180'><BR>"
							dat+="<FONT SIZE=1>\[Story by <FONT COLOR='maroon'>[MESSAGE.returnAuthor(notContent(MESSAGE.authorCensorTime))]</FONT>\]</FONT><BR><BR>"
						dat+="</ul>"
				if(scribble_page==curr_page)
					dat+="<BR><I>There is a small scribble near the end of this page... It reads: \"[scribble]\"</I>"
				dat+= "<BR><HR><DIV STYLE='float:left;'><A href='byond://?src=[REF(src)];prev_page=1'>Previous Page</A></DIV> <DIV STYLE='float:right;'><A href='byond://?src=[REF(src)];next_page=1'>Next Page</A></DIV>"
			if(2) //Last page
				for(var/datum/news/feed_channel/NP in news_content)
					pages++
				if(wantedAuthor!=null)
					dat+="<DIV STYLE='float:center;'><FONT SIZE=4><B>Wanted Issue:</B></FONT SIZE></DIV><BR><BR>"
					dat+="<B>Criminal name</B>: <FONT COLOR='maroon'>[wantedCriminal]</FONT><BR>"
					dat+="<B>Description</B>: [wantedBody]<BR>"
					dat+="<B>Photo:</B>: "
					if(wantedPhoto)
						user << browse_rsc(wantedPhoto, "tmp_photow.png")
						dat+="<BR><img src='tmp_photow.png' width = '180'>"
					else
						dat+="None"
				else
					dat+="<I>Apart from some uninteresting classified ads, there's nothing on this page...</I>"
				if(scribble_page==curr_page)
					dat+="<BR><I>There is a small scribble near the end of this page... It reads: \"[scribble]\"</I>"
				dat+= "<HR><DIV STYLE='float:left;'><A href='byond://?src=[REF(src)];prev_page=1'>Previous Page</A></DIV>"
		dat+="<BR><HR><div align='center'>[curr_page+1]</div>"
		human_user << browse(HTML_SKELETON(dat), "window=newspaper_main;size=300x400")
		onclose(human_user, "newspaper_main")
	else
		to_chat(user, "The paper is full of unintelligible symbols!")

/obj/item/newspaper/proc/notContent(list/L)
	if(!L.len)
		return 0
	for(var/i=L.len;i>0;i--)
		var/num = abs(L[i])
		if(creationTime <= num)
			continue
		else
			if(L[i] > 0)
				return 1
			else
				return 0
	return 0

/obj/item/newspaper/Topic(href, href_list)
	var/mob/living/U = usr
	..()
	if((src in U.contents) || (isturf(loc) && in_range(src, U)))
		U.set_machine(src)
		if(href_list["next_page"])
			if(curr_page == pages+1)
				return //Don't need that at all, but anyway.
			if(curr_page == pages) //We're at the middle, get to the end
				screen = 2
			else
				if(curr_page == 0) //We're at the start, get to the middle
					screen=1
			curr_page++
			playsound(loc, "pageturn", 50, 1)
		else if(href_list["prev_page"])
			if(curr_page == 0)
				return
			if(curr_page == 1)
				screen = 0
			else
				if(curr_page == pages+1) //we're at the end, let's go back to the middle.
					screen = 1
			curr_page--
			playsound(loc, "pageturn", 50, 1)
		if(ismob(loc))
			attack_self(loc)

/obj/item/newspaper/attackby(obj/item/W, mob/user, params)
	if(istype(W, /obj/item/pen))
		if(!user.is_literate())
			to_chat(user, span_notice("You scribble illegibly on [src]!"))
			return
		if(scribble_page == curr_page)
			to_chat(user, span_notice("There's already a scribble in this page... You wouldn't want to make things too cluttered, would you?"))
		else
			var/s = stripped_input(user, "Write something", "Newspaper")
			if (!s)
				return
			if(!user.canUseTopic(src, BE_CLOSE))
				return
			scribble_page = curr_page
			scribble = s
			attack_self(user)
	else
		return ..()
