//The advanced pea-green monochrome lcd of tomorrow.

GLOBAL_LIST_EMPTY(PDAs)

#define PDA_SCANNER_NONE		0
#define PDA_SCANNER_MEDICAL		1
#define PDA_SCANNER_FORENSICS	2 //unused
#define PDA_SCANNER_REAGENT		3
#define PDA_SCANNER_HALOGEN		4
#define PDA_SCANNER_GAS			5
#define PDA_SPAM_DELAY		    2 MINUTES

//pda icon overlays list defines
#define PDA_OVERLAY_ALERT		1
#define PDA_OVERLAY_SCREEN		2
#define PDA_OVERLAY_ID			3
#define PDA_OVERLAY_ITEM		4
#define PDA_OVERLAY_LIGHT		5
#define PDA_OVERLAY_PAI			6

/obj/item/pda
	name = "\improper Pip-Boy 3000"
	desc = "The RobCo Pip-Boy (Personal Information Processor) is an electronic device. Functionality is determined by a preprogrammed ROM cartridge."
	icon = 'icons/obj/pda.dmi'
	icon_state = "pda"
	item_state = "Pip-boy"
	item_flags = NOBLUDGEON
	w_class = WEIGHT_CLASS_NORMAL
	slot_flags = ITEM_SLOT_ID | ITEM_SLOT_GLOVES
	armor = ARMOR_VALUE_GENERIC_ITEM
	resistance_flags = FIRE_PROOF | ACID_PROOF
	tastes = list("old metal" = 1, "rust" = 1)

	//Main variables
	var/owner = null // String name of owner
	var/default_cartridge = 0 // Access level defined by cartridge
	var/obj/item/cartridge/cartridge = null //current cartridge
	var/mode = 0 //Controls what menu the PDA will display. 0 is hub; the rest are either built in or based on cartridge.
	var/list/overlays_icons = list('icons/obj/pda.dmi' = list("pda-r", "screen_default", "id_overlay", "insert_overlay", "light_overlay", "pai_overlay"))
	var/static/list/standard_overlays_icons = list("pda-r", "blank", "id_overlay", "insert_overlay", "light_overlay", "pai_overlay")
	var/list/current_overlays //set on Initialize.
	var/obj/item/radio/radio = null //the radio inside the pipboy

	//variables exclusively used on 'update_overlays' (which should never be called directly, and 'update_icon' doesn't use args anyway)
	var/new_overlays = FALSE
	var/new_alert = FALSE

	var/font_index = 0 //This int tells DM which font is currently selected and lets DM know when the last font has been selected so that it can cycle back to the first font when "toggle font" is pressed again.
	var/font_mode = "font-family:monospace;" //The currently selected font.
	var/background_color = "#808000" //The currently selected background color.

	#define FONT_MONO "font-family:monospace;"
	#define FONT_SHARE "font-family:\"Share Tech Mono\", monospace;letter-spacing:0px;"
	#define FONT_ORBITRON "font-family:\"Orbitron\", monospace;letter-spacing:0px; font-size:15px"
	#define FONT_VT "font-family:\"VT323\", monospace;letter-spacing:1px;"
	#define MODE_MONO 0
	#define MODE_SHARE 1
	#define MODE_ORBITRON 2
	#define MODE_VT 3

	//Secondary variables
	var/scanmode = PDA_SCANNER_NONE
	var/fon = FALSE //Is the flashlight function on?
	var/f_lum = 2.3 //Luminosity for the flashlight function
	var/f_pow = 0.6 //Power for the flashlight function
	var/f_col = "#FFCC66" //Color for the flashlight function
	var/silent = FALSE //To beep or not to beep, that is the question
	var/toff = FALSE //If TRUE, messenger disabled
	var/tnote = null //Current Texts
	var/last_text //No text spamming
	var/last_everyone //No text for everyone spamming
	var/last_noise //Also no honk spamming that's bad too
	var/ttone = "beep" //The ringtone!
	var/note = "Congratulations, your has chosen the RobCo Pip-Boy 3000 Personal Information Processor! To help with navigation, we have provided the following definitions. North, South, West, East." //Current note in the notepad function
	var/notehtml = ""
	var/notescanned = FALSE // True if what is in the notekeeper was from a paper.
	var/detonatable = TRUE // Can the PDA be blown up?
	var/hidden = FALSE // Is the PDA hidden from the PDA list?
	var/emped = FALSE
	var/equipped = FALSE  //used here to determine if this is the first time its been picked up
	var/allow_emojis = TRUE //if the pda can send emojis and actually have them parsed as such
	var/list/pipsounds = list("modular_coyote/sound/pipsounds/pip1.ogg", "modular_coyote/sound/pipsounds/pip2.ogg", "modular_coyote/sound/pipsounds/pip3.ogg")

	var/obj/item/card/id/id = null //Making it possible to slot an ID card into the PDA so it can function as both.
	var/ownjob = null //related to above

	var/obj/item/paicard/pai = null	// A slot for a personal AI device

	var/datum/picture/picture //Scanned photo

	var/list/contained_item = list(/obj/item/pen, /obj/item/toy/crayon, /obj/item/lipstick, /obj/item/flashlight/pen, /obj/item/clothing/mask/cigarette)
	var/obj/item/inserted_item //Used for pen, crayon, and lipstick insertion or removal. Same as above.
	var/list/overlays_offsets // offsets to use for certain overlays
	var/overlays_x_offset = 0
	var/overlays_y_offset = 0

	var/underline_flag = TRUE //flag for underline

	var/list/blocked_pdas

	var/list/saved_frequencies = list("Common" = FREQ_COMMON)

/obj/item/pda/suicide_act(mob/living/carbon/user)
	var/deathMessage = msg_input(user)
	if (!deathMessage)
		deathMessage = "i ded"
	user.visible_message(span_suicide("[user] is sending a message to the Grim Reaper! It looks like [user.p_theyre()] trying to commit suicide!"))
	tnote += "<i><b>&rarr; To The Grim Reaper:</b></i><br>[deathMessage]<br>"//records a message in their PDA as being sent to the grim reaper
	return BRUTELOSS

/obj/item/pda/examine(mob/user)
	. = ..()
	. += id ? span_notice("Alt-click to remove the id.") : ""
	if(inserted_item && (!isturf(loc)))
		. += span_notice("Ctrl-click to remove [inserted_item].")
	if(LAZYLEN(GLOB.pda_reskins))
		. += span_notice("Ctrl-shift-click it to reskin it.")

/obj/item/pda/Initialize()
	. = ..()
	if(fon)
		set_light(f_lum, f_pow, f_col)

	GLOB.PDAs += src
	if(default_cartridge)
		cartridge = new default_cartridge(src)
	if(inserted_item)
		inserted_item = new inserted_item(src)
	else
		inserted_item =	new /obj/item/pen(src)
	radio = new /obj/item/radio(src)
	radio.name = "pipboy radio"
	new_overlays = TRUE
	update_icon()

/obj/item/pda/CtrlShiftClick(mob/living/user)
	. = ..()
	if(GLOB.pda_reskins && user.canUseTopic(src, BE_CLOSE, NO_DEXTERY))
		reskin_obj(user)

/obj/item/pda/reskin_obj(mob/M)
	if(!LAZYLEN(GLOB.pda_reskins))
		return
	var/dat = "<b>Reskin options for [name]:</b>"
	for(var/V in GLOB.pda_reskins)
		var/output = icon2html(GLOB.pda_reskins[V], M, icon_state)
		dat += "\n[V]: <span class='reallybig'>[output]</span>"
	to_chat(M, dat)

	var/choice = input(M, "Choose the a reskin for [src]","Reskin Object") as null|anything in GLOB.pda_reskins
	var/new_icon = GLOB.pda_reskins[choice]
	if(QDELETED(src) || isnull(new_icon) || new_icon == icon || !M.canUseTopic(src, BE_CLOSE, FALSE, NO_TK))
		return
	icon = new_icon
	new_overlays = TRUE
	update_icon()
	to_chat(M, "[src] is now skinned as '[choice]'.")

/obj/item/pda/proc/set_new_overlays()
	if(!overlays_offsets || !(icon in overlays_offsets))
		overlays_x_offset = 0
		overlays_y_offset = 0
	else
		var/list/new_offsets = overlays_offsets[icon]
		if(new_offsets)
			overlays_x_offset = new_offsets[1]
			overlays_y_offset = new_offsets[2]
	if(!(icon in overlays_icons))
		current_overlays = standard_overlays_icons
		return
	current_overlays = overlays_icons[icon]

/obj/item/pda/equipped(mob/user, slot)
	. = ..()
	if(equipped || !user.client)
		return
	update_style(user.client)

/obj/item/pda/proc/update_style(client/C)
	background_color = C.prefs.pda_color
	switch(C.prefs.pda_style)
		if(MONO)
			font_index = MODE_MONO
			font_mode = FONT_MONO
		if(SHARE)
			font_index = MODE_SHARE
			font_mode = FONT_SHARE
		if(ORBITRON)
			font_index = MODE_ORBITRON
			font_mode = FONT_ORBITRON
		if(VT)
			font_index = MODE_VT
			font_mode = FONT_VT
		else
			font_index = MODE_MONO
			font_mode = FONT_MONO
	var/pref_skin = GLOB.pda_reskins[C.prefs.pda_skin]
	if(pref_skin && icon != pref_skin)
		icon = pref_skin
		new_overlays = TRUE
		update_icon()
	equipped = TRUE

/obj/item/pda/proc/update_label()
	name = "Pip-Boy 3000-[owner] ([ownjob])" //Name generalisation

/obj/item/pda/GetAccess()
	if(id)
		return id.GetAccess()
	else
		return ..()

/obj/item/pda/GetID()
	return id

/obj/item/pda/RemoveID()
	return do_remove_id()

/obj/item/pda/InsertID(obj/item/inserting_item)
	var/obj/item/card/inserting_id = inserting_item.RemoveID()
	if(!inserting_id)
		return
	insert_id(inserting_id)
	if(id == inserting_id)
		return TRUE
	return FALSE

/obj/item/pda/update_overlays()
	. = ..()
	if(new_overlays)
		set_new_overlays()
	var/screen_state = new_alert ? current_overlays[PDA_OVERLAY_ALERT] : current_overlays[PDA_OVERLAY_SCREEN]
	var/mutable_appearance/overlay = mutable_appearance(icon, screen_state)
	overlay.pixel_x = overlays_x_offset
	overlay.pixel_y = overlays_y_offset
	. += new /mutable_appearance(overlay)
	if(id)
		overlay.icon_state = current_overlays[PDA_OVERLAY_ID]
		. += new /mutable_appearance(overlay)
	if(inserted_item)
		overlay.icon_state = current_overlays[PDA_OVERLAY_ITEM]
		. += new /mutable_appearance(overlay)
	if(fon)
		overlay.icon_state = current_overlays[PDA_OVERLAY_LIGHT]
		. += new /mutable_appearance(overlay)
	if(pai)
		overlay.icon_state = "[current_overlays[PDA_OVERLAY_PAI]][pai.pai ? "" : "_off"]"
		. += overlay
	new_overlays = FALSE
	new_alert = FALSE

/obj/item/pda/MouseDrop(mob/over, src_location, over_location)
	var/mob/M = usr
	if((M == over) && usr.canUseTopic(src, BE_CLOSE, FALSE, NO_TK))
		return attack_self(M)
	return ..()

/obj/item/pda/attack_self_tk(mob/user)
	to_chat(user, span_warning("The PDA's capacitive touch screen doesn't seem to respond!"))
	return

/obj/item/pda/interact(mob/user)
	if(!user.IsAdvancedToolUser())
		to_chat(user, span_warning("You don't have the dexterity to do this!"))
		return
	if(!user.is_literate())
		to_chat(user, span_bad("You can't read, how are you going to work it?"))
		return
	..()

	var/datum/asset/spritesheet/assets = get_asset_datum(/datum/asset/spritesheet/simple/pda)
	assets.send(user)

	var/datum/asset/spritesheet/emoji_s = get_asset_datum(/datum/asset/spritesheet/chat)
	emoji_s.send(user) //Already sent by chat but no harm doing this

	user.set_machine(src)

	var/dat = "<!DOCTYPE html><html><head><style>body {[font_mode] padding: 0; margin: 12px; background-color: #062113; color: #4aed92; line-height: 135%;} h2, h4 {color: #4aed92;} a, button, a:link, a:visited, a:active, .linkOn, .linkOff {color: #4aed92; text-decoration: none; background: #062113; border: none; padding: 1px 4px 1px 4px; margin: 0 2px 0 0; cursor:default;} a:hover {color: #062113; background: #4aed92; border: 1px solid #4aed92} a.white, a.white:link, a.white:visited, a.white:active {color: #4aed92; text-decoration: none; background: #4aed92; border: 1px solid #161616; padding: 1px 4px 1px 4px; margin: 0 2px 0 0; cursor:default;} a.white:hover {color: #062113; background: #4aed92;} .linkOn, a.linkOn:link, a.linkOn:visited, a.linkOn:active, a.linkOn:hover {color: #4aed92; background: #062113; border-color: #062113;} .linkOff, a.linkOff:link, a.linkOff:visited, a.linkOff:active, a.linkOff:hover{color: #4aed92; background: #062113; border-color: #062113;}</style><meta http-equiv='Content-Type' content='text/html; charset=UTF-8'><title>Personal Information Processor</title><link href=\"https://fonts.googleapis.com/css?family=Orbitron|Share+Tech+Mono|VT323\" rel=\"stylesheet\"></head><body bgcolor=\"" + background_color + "\">"
//	dat += assets.css_tag()
//	dat += emoji_s.css_tag()
//Removed to fix a pda runtime ~TK


	dat += "<a href='byond://?src=[REF(src)];choice=Refresh'>[PDAIMG(refresh)]Refresh</a>"

	if ((!isnull(cartridge)) && (mode == 0))
		dat += " | <a href='byond://?src=[REF(src)];choice=Eject'>[PDAIMG(eject)]Eject [cartridge]</a>"
	if (mode)
		dat += " | <a href='byond://?src=[REF(src)];choice=Return'>[PDAIMG(menu)]Return</a>"

	/* UNUSED because of the new pipboy look
	if (mode == 0)

		dat += "<div align=\"center\">"
		dat += "<br><a href='byond://?src=[REF(src)];choice=Toggle_Font'>Toggle Font</a>"
		dat += " | <a href='byond://?src=[REF(src)];choice=Change_Color'>Change Color</a>"
		dat += " | <a href='byond://?src=[REF(src)];choice=Toggle_Underline'>Toggle Underline</a>" //underline button

		dat += "</div>"

	dat += "<br>"
	*/

	if (!owner)
		dat += "Warning: No owner information entered.  Please swipe card.<br><br>"
		dat += "<a href='byond://?src=[REF(src)];choice=User'>Enter Custom User</a><br><br>"
		dat += "<a href='byond://?src=[REF(src)];choice=Refresh'>[PDAIMG(refresh)]Retry</a>"
	else
		switch (mode)
			if (0)
				dat += "<h2><center>=======PERSONAL INFORMATION PROCESSOR v.1.2=======</center></h2>"
				dat += "Owner: [owner], [ownjob]<br>"
				dat += "ID: <a href='byond://?src=[REF(src)];choice=Authenticate'>[id ? "[id.registered_name], [id.assignment]" : "----------"]</a><br>"
				dat += "<a href='byond://?src=[REF(src)];choice=UpdateInfo'>[id ? "Update Pip-Boy Info" : ""]</a><br><br>"

				dat += "[STATION_TIME_TIMESTAMP("hh:mm:ss", world.time)]<br>" //:[world.time / 100 % 6][world.time / 100 % 10]"
				dat += "[time2text(world.realtime, "MMM DD")] [GLOB.year_integer]"

				dat += "<br>===========================================<br>"

				dat += "<h4>General Functions</h4>"
				dat += "<ul>"
				dat += "<li><a href='byond://?src=[REF(src)];choice=1'>[PDAIMG(notes)]Notekeeper</a></li>"
				dat += "<li><a href='byond://?src=[REF(src)];choice=2'>[PDAIMG(mail)]Messenger</a></li>"
				dat += "<li><a href='byond://?src=[REF(src)];choice=99'>[PDAIMG(signaler)]Radio</a></li>"

				if (cartridge)
					if (cartridge.access & CART_MANIFEST)
						dat += "<li><a href='byond://?src=[REF(src)];choice=41'>[PDAIMG(notes)]View Crew Manifest</a></li>"
					if(cartridge.access & CART_STATUS_DISPLAY)
						dat += "<li><a href='byond://?src=[REF(src)];choice=42'>[PDAIMG(status)]Set Status Display</a></li>"
					dat += "</ul>"
					if (cartridge.access & CART_ENGINE)
						dat += "<h4>Engineering Functions</h4>"
						dat += "<ul>"
						dat += "<li><a href='byond://?src=[REF(src)];choice=43'>[PDAIMG(power)]Power Monitor</a></li>"
						dat += "</ul>"
					if (cartridge.access & CART_MEDICAL)
						dat += "<h4>Medical Functions</h4>"
						dat += "<ul>"
						dat += "<li><a href='byond://?src=[REF(src)];choice=44'>[PDAIMG(medical)]Medical Records</a></li>"
						dat += "<li><a href='byond://?src=[REF(src)];choice=Medical Scan'>[PDAIMG(scanner)][scanmode == 1 ? "Disable" : "Enable"] Medical Scanner</a></li>"
						dat += "</ul>"
					if (cartridge.access & CART_SECURITY)
						dat += "<h4>Security Functions</h4>"
						dat += "<ul>"
						dat += "<li><a href='byond://?src=[REF(src)];choice=45'>[PDAIMG(cuffs)]Security Records</A></li>"
						dat += "</ul>"
					if(cartridge.access & CART_QUARTERMASTER)
						dat += "<h4>Quartermaster Functions:</h4>"
						dat += "<ul>"
						dat += "<li><a href='byond://?src=[REF(src)];choice=47'>[PDAIMG(crate)]Supply Records</A></li>"
						dat += "<li><a href='byond://?src=[REF(src)];choice=48'>[PDAIMG(crate)]Ore Silo Logs</a></li>"
						dat += "</ul>"
				dat += "</ul>"

				dat += "<h4>Utilities</h4>"
				dat += "<ul>"

				if (cartridge)
					if(cartridge.bot_access_flags)
						dat += "<li><a href='byond://?src=[REF(src)];choice=54'>[PDAIMG(medbot)]Bots Access</a></li>"
					if (cartridge.access & CART_JANITOR)
						dat += "<li><a href='byond://?src=[REF(src)];choice=49'>[PDAIMG(bucket)]Custodial Locator</a></li>"
					if (istype(cartridge.radio))
						dat += "<li><a href='byond://?src=[REF(src)];choice=40'>[PDAIMG(signaler)]Signaler System</a></li>"
					if (cartridge.access & CART_NEWSCASTER)
						dat += "<li><a href='byond://?src=[REF(src)];choice=53'>[PDAIMG(notes)]Newscaster Access </a></li>"
					if (cartridge.access & CART_REAGENT_SCANNER)
						dat += "<li><a href='byond://?src=[REF(src)];choice=Reagent Scan'>[PDAIMG(reagent)][scanmode == 3 ? "Disable" : "Enable"] Reagent Scanner</a></li>"
					if (cartridge.access & CART_ENGINE)
						dat += "<li><a href='byond://?src=[REF(src)];choice=Halogen Counter'>[PDAIMG(reagent)][scanmode == 4 ? "Disable" : "Enable"] Halogen Counter</a></li>"
					if (cartridge.access & CART_ATMOS)
						dat += "<li><a href='byond://?src=[REF(src)];choice=Gas Scan'>[PDAIMG(reagent)][scanmode == 5 ? "Disable" : "Enable"] Gas Scanner</a></li>"
					if (cartridge.access & CART_REMOTE_DOOR)
						dat += "<li><a href='byond://?src=[REF(src)];choice=Toggle Door'>[PDAIMG(rdoor)]Toggle Remote Door</a></li>"
					if (cartridge.access & CART_DRONEPHONE)
						dat += "<li><a href='byond://?src=[REF(src)];choice=Drone Phone'>[PDAIMG(dronephone)]Drone Phone</a></li>"
				dat += "<li><a href='byond://?src=[REF(src)];choice=3'>[PDAIMG(atmos)]Atmospheric Scan</a></li>"
				dat += "<li><a href='byond://?src=[REF(src)];choice=Light'>[PDAIMG(flashlight)][fon ? "Disable" : "Enable"] Flashlight</a></li>"
				if (pai)
					if(pai.loc != src)
						pai = null
						update_icon()
					else
						dat += "<li><a href='byond://?src=[REF(src)];choice=pai;option=1'>pAI Device Configuration</a></li>"
						dat += "<li><a href='byond://?src=[REF(src)];choice=pai;option=2'>Eject pAI Device</a></li>"
				dat += "</ul>"

			if (1)
				dat += "<h4>[PDAIMG(notes)] Notekeeper V2.2</h4>"
				dat += "<a href='byond://?src=[REF(src)];choice=Edit'>Edit</a><br>"
				if(notescanned)
					dat += "(This is a scanned image, editing it may cause some text formatting to change.)<br>"
				dat += "<HR><font face=\"[PEN_FONT]\">[(!notehtml ? note : notehtml)]</font>"

			if (2)
				dat += "<h4>[PDAIMG(mail)] RobCo Messenger V3.9.6</h4>"
				dat += "<a href='byond://?src=[REF(src)];choice=Toggle Ringer'>[PDAIMG(bell)]Ringer: [silent == 1 ? "Off" : "On"]</a> | "
				dat += "<a href='byond://?src=[REF(src)];choice=Toggle Messenger'>[PDAIMG(mail)]Send / Receive: [toff == 1 ? "Off" : "On"]</a> | "
				dat += "<a href='byond://?src=[REF(src)];choice=Ringtone'>[PDAIMG(bell)]Set Ringtone</a> | "
				dat += "<a href='byond://?src=[REF(src)];choice=21'>[PDAIMG(mail)]Messages</a><br>"

				if(cartridge)
					dat += cartridge.message_header()

				dat += "<h4>[PDAIMG(menu)] Detected Pip-Boys</h4>"

				dat += "<ul>"
				var/count = 0

				if (!toff)
					for (var/obj/item/pda/P in sortNames(get_viewable_pdas()))
						if (P == src)
							continue
						if(P.owner in blocked_pdas)
							dat += "<li><a href='byond://?src=[REF(src)];choice=unblock_pda;target=[P.owner]'>(BLOCKED - CLICK TO UNBLOCK) [P.owner] - ([P.ownjob])</a>"
						else
							dat += "<li><a href='byond://?src=[REF(src)];choice=Message;target=[REF(P)]'>[P.owner] - ([P.ownjob])</a>"
						if(cartridge)
							dat += cartridge.message_special(P)
						dat += "</li>"
						count++
				dat += "</ul>"
				if (count == 0)
					dat += "None detected.<br>"
				else if(cartridge && cartridge.spam_enabled)
					dat += "<a href='byond://?src=[REF(src)];choice=MessageAll'>Send To All</a>"

			if(21)
				dat += "<h4>[PDAIMG(mail)] SpaceMessenger V3.9.6</h4>"
				dat += "<a href='byond://?src=[REF(src)];choice=Clear'>[PDAIMG(blank)]Clear Messages</a>"

				dat += "<h4>[PDAIMG(mail)] Messages</h4>"

				dat += tnote
				dat += "<br>"

			if (3)
				dat += "<h4>[PDAIMG(atmos)] Atmospheric Readings</h4>"

				var/turf/T = user.loc
				if (isnull(T))
					dat += "Unable to obtain a reading.<br>"
				else
					var/datum/gas_mixture/environment = T.return_air()

					var/pressure = environment.return_pressure()
					var/total_moles = environment.total_moles()

					dat += "Air Pressure: [round(pressure,0.1)] kPa<br>"

					if (total_moles)
						for(var/id in environment.get_gases())
							var/gas_level = environment.get_moles(id)/total_moles
							if(gas_level > 0)
								dat += "[GLOB.gas_data.names[id]]: [round(gas_level*100, 0.01)]%<br>"

					dat += "Temperature: [round(environment.return_temperature()-T0C)]&deg;C<br>"
				dat += "<br>"

			if (4)
				dat += "<h4>Radio settings</h4>"

				dat += "Microphone: <a href='byond://?src=[REF(src)];rmictoggle=1'>[radio.broadcasting?"Engaged":"Disengaged"]</a><br>"
				dat += "Speaker: <a href='byond://?src=[REF(src)];rspktoggle=1'>[radio.listening?"Engaged":"Disengaged"]</a><br>"
				dat += "Music: <a href='byond://?src=[REF(src)];rmsctoggle=1'>[radio.tuned_in?"Engaged":"Disengaged"]</a><br>"
				dat += "Frequency:<br>"
				dat += "<a href='byond://?src=[REF(src)];rfreq=-10'>-</a>"
				dat += "<a href='byond://?src=[REF(src)];rfreq=-2'>-</a>"
				dat += "[format_frequency(radio.frequency)]"
				dat += "<a href='byond://?src=[REF(src)];rfreq=2'>+</a>"
				dat += "<a href='byond://?src=[REF(src)];rfreq=10'>+</a>"
				dat += " | <a href='byond://?src=[REF(src)];rsavefreq=[radio.frequency]'>Save Frequency</a><br><br>"

				if(saved_frequencies)
					dat += "<b>Saved Frequencies</b>"
					dat += "<ul>"
					for(var/freq in saved_frequencies)
						dat += "<li><a href='byond://?src=[REF(src)];rloadfreq=[saved_frequencies[freq]]'>[freq] ([format_frequency(saved_frequencies[freq])])</a>"
						dat += " (<a href='byond://?src=[REF(src)];rdelfreq=[saved_frequencies[freq]]'>Delete</a> | <a href='byond://?src=[REF(src)];rrenfreq=[saved_frequencies[freq]]'>Rename</a>)</li>"
					dat += "</ul>"

			else//Else it links to the cart menu proc. Although, it really uses menu hub 4--menu 4 doesn't really exist as it simply redirects to hub.
				dat += cartridge.generate_menu()

	dat += "</body></html>"

	if (underline_flag)
		dat = replacetext(dat, "text-decoration:none", "text-decoration:underline")
	if (!underline_flag)
		dat = replacetext(dat, "text-decoration:underline", "text-decoration:none")

	//user << browse(HTML_SKELETON(dat), "window=pda;size=600x500;border=1;can_resize=1;can_minimize=0")
	var/datum/browser/popup = new(user, "pda", "", 600, 500)
	popup.set_content(dat)
	popup.open(FALSE)
	//onclose(user, "pda", src)

/obj/item/pda/proc/Boop()
	playsound(src, pick(pipsounds), 40, 1)

/obj/item/pda/Topic(href, href_list)
	..()
	var/mob/living/U = usr
	//Looking for master was kind of pointless since PDAs don't appear to have one.

	if(usr.canUseTopic(src, BE_CLOSE, FALSE, NO_TK, FALSE) && !href_list["close"])
		add_fingerprint(U)
		U.set_machine(src)

		if(href_list["choice"])

			switch(href_list["choice"])

//BASIC FUNCTIONS===================================

				if("Refresh")//Refresh, goes to the end of the proc.
					if (!silent)
						Boop()
				if ("User")
					owner = input(U, "Enter your desired username.", "Username") as null|text
					ownjob = input(U, "Enter your desired role.", "Role") as null|text
					Boop()
				if ("Toggle_Font")
					//CODE REVISION 2
					font_index = (font_index + 1) % 4

					switch(font_index)
						if (MODE_MONO)
							font_mode = FONT_MONO
						if (MODE_SHARE)
							font_mode = FONT_SHARE
						if (MODE_ORBITRON)
							font_mode = FONT_ORBITRON
						if (MODE_VT)
							font_mode = FONT_VT
					if (!silent)
						Boop()

				if ("Change_Color")
					var/new_color = input("Please enter a color name or hex value (Default is \'#808000\').",background_color)as color
					background_color = new_color
					if (!silent)
						Boop()

				if ("Toggle_Underline")
					underline_flag = !underline_flag
					if (!silent)
						Boop()

				if("Return")//Return
					if(mode<=9)
						mode = 0
					else
						mode = round(mode/10)
						if(mode==4 || mode == 5)//Fix for cartridges. Redirects to hub.
							mode = 0
					if (!silent)
						Boop()

				if ("Authenticate")//Checks for ID
					id_check(U)

				if("UpdateInfo")
					ownjob = id.assignment
					if(istype(id, /obj/item/card/id/syndicate))
						owner = id.registered_name
					update_label()
					if (!silent)
						playsound(src, 'sound/machines/terminal_processing.ogg', 15, 1)
					addtimer(CALLBACK(GLOBAL_PROC, GLOBAL_PROC_REF(playsound), src, 'sound/machines/terminal_success.ogg', 15, 1), 13)

				if("Eject")//Ejects the cart, only done from hub.
					if (!isnull(cartridge))
						U.put_in_hands(cartridge)
						to_chat(U, span_notice("You remove [cartridge] from [src]."))
						scanmode = PDA_SCANNER_NONE
						cartridge.host_pda = null
						cartridge = null
						update_icon()
					if (!silent)
						playsound(src, 'sound/machines/terminal_eject_disc.ogg', 50, 1)

//MENU FUNCTIONS===================================

				if("0")//Hub
					mode = 0
					if (!silent)
						Boop()
				if("1")//Notes
					mode = 1
					if (!silent)
						Boop()
				if("2")//Messenger
					mode = 2
					if (!silent)
						Boop()
				if("99")//Radio
					mode = 4
					if(!silent)
						Boop()
				if("21")//Read messeges
					mode = 21
					if (!silent)
						Boop()
				if("3")//Atmos scan
					mode = 3
					if (!silent)
						Boop()
				if("4")//Redirects to hub
					mode = 0
					if (!silent)
						Boop()



//MAIN FUNCTIONS===================================

				if("Light")
					toggle_light()

				if("Medical Scan")
					if(scanmode == PDA_SCANNER_MEDICAL)
						scanmode = PDA_SCANNER_NONE
					else if((!isnull(cartridge)) && (cartridge.access & CART_MEDICAL))
						scanmode = PDA_SCANNER_MEDICAL
					if (!silent)
						Boop()

				if("Reagent Scan")
					if(scanmode == PDA_SCANNER_REAGENT)
						scanmode = PDA_SCANNER_NONE
					else if((!isnull(cartridge)) && (cartridge.access & CART_REAGENT_SCANNER))
						scanmode = PDA_SCANNER_REAGENT
					if (!silent)
						Boop()

				if("Halogen Counter")
					if(scanmode == PDA_SCANNER_HALOGEN)
						scanmode = PDA_SCANNER_NONE
					else if((!isnull(cartridge)) && (cartridge.access & CART_ENGINE))
						scanmode = PDA_SCANNER_HALOGEN
					if (!silent)
						Boop()

				if("Honk")
					if ( !(last_noise && world.time < last_noise + 20) )
						playsound(src, 'sound/items/bikehorn.ogg', 50, 1)
						last_noise = world.time

				if("Trombone")
					if ( !(last_noise && world.time < last_noise + 20) )
						playsound(src, 'sound/misc/sadtrombone.ogg', 50, 1)
						last_noise = world.time

				if("Gas Scan")
					if(scanmode == PDA_SCANNER_GAS)
						scanmode = PDA_SCANNER_NONE
					else if((!isnull(cartridge)) && (cartridge.access & CART_ATMOS))
						scanmode = PDA_SCANNER_GAS
					if (!silent)
						Boop()

				if("Drone Phone")
					var/alert_s = input(U,"Alert severity level","Ping Drones",null) as null|anything in list("Low","Medium","High","Critical")
					var/area/A = get_area(U)
					if(A && alert_s && !QDELETED(U))
						var/msg = span_boldnotice("NON-DRONE PING: [U.name]: [alert_s] priority alert in [A.name]!")
						_alert_drones(msg, TRUE, U)
						to_chat(U, msg)
						if (!silent)
							Boop()


//NOTEKEEPER FUNCTIONS===================================

				if ("Edit")
					var/n = stripped_multiline_input(U, "Please enter message", name, note)
					if (in_range(src, U) && loc == U)
						if (mode == 1 && n)
							note = n
							notehtml = parsemarkdown(n, U)
							notescanned = FALSE
					else
						U << browse(null, "window=pda")
						return

//MESSENGER FUNCTIONS===================================

				if("Toggle Messenger")
					toff = !toff
				if("Toggle Ringer")//If viewing texts then erase them, if not then toggle silent status
					silent = !silent
				if("Clear")//Clears messages
					tnote = null
				if("Ringtone")
					var/t = stripped_input(U, "Please enter new ringtone", name, ttone, 20)
					if(in_range(src, U) && loc == U && t)
						if(SEND_SIGNAL(src, COMSIG_PDA_CHANGE_RINGTONE, U, t) & COMPONENT_STOP_RINGTONE_CHANGE)
							U << browse(null, "window=pda")
							return
						else
							ttone = t
					else
						U << browse(null, "window=pda")
						return
				if("Message")
					create_message(U, locate(href_list["target"]))

				if("MessageAll")
					send_to_all(U)

				if("toggle_block")
					toggle_blocking(usr, href_list["target"])

				if("block_pda")
					block_pda(usr, href_list["target"])

				if("unblock_pda")
					unblock_pda(usr, href_list["target"])

				if("cart")
					if(cartridge)
						cartridge.special(U, href_list)
					else
						U << browse(null, "window=pda")
						return

//SYNDICATE FUNCTIONS===================================

				if("Toggle Door")
					if(cartridge && cartridge.access & CART_REMOTE_DOOR)
						for(var/obj/machinery/door/poddoor/M in GLOB.machines)
							if(M.id == cartridge.remote_door_id)
								if(M.density)
									M.open()
								else
									M.close()

//pAI FUNCTIONS===================================
				if("pai")
					switch(href_list["option"])
						if("1")		// Configure pAI device
							pai.attack_self(U)
						if("2")		// Eject pAI device
							var/turf/T = get_turf(loc)
							if(T)
								pai.forceMove(T)

//LINK FUNCTIONS===================================

				else//Cartridge menu linking
					mode = max(text2num(href_list["choice"]), 0)

//RADIO FUNCTIONS
		if(href_list["rmictoggle"])
			radio.broadcasting = !radio.broadcasting
			Boop()

		if(href_list["rspktoggle"])
			radio.listening = !radio.listening
			Boop()

		if(href_list["rmsctoggle"])
			radio.tuned_in = !radio.tuned_in
			Boop()

		if(href_list["rfreq"])
			var/new_frequency = (radio.frequency + text2num(href_list["rfreq"]))
			if (!radio.freerange || (radio.frequency < MIN_FREE_FREQ || radio.frequency > MAX_FREE_FREQ))
				new_frequency = sanitize_frequency(new_frequency)
			radio.set_frequency(new_frequency)
			Boop()

		if (href_list["rsavefreq"])
			var/frequency = href_list["rsavefreq"]
			frequency = text2num(frequency)
			var/found = FALSE
			for(var/freq in saved_frequencies)
				if(saved_frequencies[freq] == frequency)
					found = TRUE
					break
			if(found)
				to_chat(U, span_notice("ERROR: Frequency already saved."))
			else
				var/frequency_name = stripped_input(U, "Please enter a name for the frequency", name, "", 20)
				if (frequency_name)
					if (frequency_name in saved_frequencies)
						to_chat(U, span_notice("ERROR: Frequency with that name already saved."))
					else
						saved_frequencies[frequency_name] = frequency
			Boop()

		if (href_list["rloadfreq"])
			var/loaded_frequency = href_list["rloadfreq"]
			loaded_frequency = sanitize_frequency(text2num(loaded_frequency))
			radio.set_frequency(loaded_frequency)
			Boop()

		if (href_list["rrenfreq"])
			var/renamed_frequency = href_list["rrenfreq"]
			renamed_frequency = text2num(renamed_frequency)
			var/frequency_name = stripped_input(U, "Please enter a new name for the frequency", name, "", 20)
			if (frequency_name)
				for(var/freq in saved_frequencies)
					if(saved_frequencies[freq] == renamed_frequency)
						saved_frequencies -= freq
				saved_frequencies[frequency_name] = renamed_frequency
			Boop()

		if (href_list["rdelfreq"])
			var/deleted_frequency = href_list["rdelfreq"]
			deleted_frequency = text2num(deleted_frequency)
			for(var/freq in saved_frequencies)
				if(saved_frequencies[freq] == deleted_frequency)
					saved_frequencies -= freq
			Boop()

	else//If not in range, can't interact or not using the pda.
		U.unset_machine()
		U << browse(null, "window=pda")
		return

//EXTRA FUNCTIONS===================================

	if (mode == 2 || mode == 21)//To clear message overlays.
		update_icon()

	if(U.machine == src && href_list["skiprefresh"]!="1")//Final safety.
		attack_self(U)//It auto-closes the menu prior if the user is not in range and so on.
	else
		U.unset_machine()
		U << browse(null, "window=pda")
	return

/obj/item/pda/proc/remove_id(mob/user)
	if(hasSiliconAccessInArea(user) || !user.canUseTopic(src, BE_CLOSE, FALSE, NO_TK))
		return
	do_remove_id(user)

/obj/item/pda/proc/do_remove_id(mob/user)
	if(!id)
		return
	if(user)
		user.put_in_hands(id)
		to_chat(user, span_notice("You remove the ID from the [name]."))
	else
		id.forceMove(get_turf(src))

	. = id
	id = null
	update_icon()

	if(ishuman(loc))
		var/mob/living/carbon/human/H = loc
		if(H.wear_id == src)
			H.sec_hud_set_ID()

/obj/item/pda/proc/msg_input(mob/living/U = usr)
	var/t = stripped_input(U, "Please enter message", name)
	if (!t || toff)
		return
	if(!U.canUseTopic(src, BE_CLOSE, FALSE, NO_TK, FALSE))
		return
	if(emped)
		t = Gibberish(t, 100)
	return t

/obj/item/pda/proc/send_message(mob/living/user, list/obj/item/pda/targets, everyone)
	var/message = msg_input(user)
	if(!message || !targets.len)
		return
	if((last_text && world.time < last_text + 10) || (everyone && last_everyone && world.time < last_everyone + PDA_SPAM_DELAY))
		return
	if(prob(1))
		message += "\nSent from my PDA"
	// Send the signal
	var/list/string_targets = list()
	var/list/string_blocked
	for(var/obj/item/pda/P in targets)
		if(owner in P.blocked_pdas)
			LAZYADD(string_blocked, P.owner)
			continue
		if(P.owner && P.ownjob)  // != src is checked by the UI
			string_targets += "[P.owner] ([P.ownjob])"
	if(string_blocked)
		string_blocked = english_list(string_blocked)
		to_chat(user, span_warning("[icon2html(src, user)] The following recipients have blocked your message: [string_blocked]."))
	for (var/obj/machinery/computer/message_monitor/M in targets)
		// In case of "Reply" to a message from a console, this will make the
		// message be logged successfully. If the console is impersonating
		// someone by matching their name and job, the reply will reach the
		// impersonated PDA.
		string_targets += "[M.customsender] ([M.customjob])"
	if (!string_targets.len)
		return

	var/datum/signal/subspace/pda/signal = new(src, list(
		"name" = "[owner]",
		"job" = "[ownjob]",
		"message" = message,
		"targets" = string_targets,
		"emojis" = allow_emojis
	))
	if (picture)
		signal.data["photo"] = picture
	signal.send_to_receivers()

	// If it didn't reach, note that fact
	if (!signal.data["done"])
		to_chat(user, span_notice("ERROR: Server isn't responding."))
		if (!silent)
			playsound(src, 'sound/machines/terminal_error.ogg', 15, 1)
		return

	var/target_text = signal.format_target()
	if(allow_emojis)
		message = emoji_parse(message)//already sent- this just shows the sent emoji as one to the sender in the to_chat
		signal.data["message"] = emoji_parse(signal.data["message"])
	// Log it in our logs
	tnote += "<i><b>&rarr; To [target_text]:</b></i><br>[signal.format_message()]<br>"
	// Show it to ghosts
	var/ghost_message = "<span class='name'>[owner] </span><span class='game say'>Pip-Boy 3000 Message</span> --> <span class='name'>[target_text]</span>: <span class='message'>[signal.format_message()]</span>"
	for(var/i in GLOB.dead_mob_list)
		var/mob/M = i
		if(QDELETED(M))
			continue
		if(user != M && istype(user) && isliving(M) && M.client && M.z == user.z && get_dist(user,M) < 6)
			var/mob/living/ML = M
			if(ML.enabled_combat_indicator)
				to_chat(ML, "<span class='notice'>[user] taps quietly on [src].")
		if(M?.client && M.client.prefs.chat_toggles & CHAT_GHOSTPDA)
			to_chat(M, "[FOLLOW_LINK(M, user)] [ghost_message]")
	to_chat(user, span_info("Message sent to [target_text]: \"[message]\""))
	// Log in the talk log
	user.log_talk(message, LOG_PDA, tag="PDA: [initial(name)] to [target_text] (BLOCKED:[string_blocked])")
	if (!silent)
		playsound(src, 'modular_coyote/sound/pipsounds/pipmsgsend.ogg', 30, 1)
	// Reset the photo
	picture = null
	last_text = world.time
	if (everyone)
		last_everyone = world.time

/obj/item/pda/proc/receive_message(datum/signal/subspace/pda/signal)
	tnote += "<i><b>&larr; From <a href='byond://?src=[REF(src)];choice=Message;target=[REF(signal.source)]'>[signal.data["name"]]</a> ([signal.data["job"]]):</b></i> <a href='byond://?src=[REF(src)];choice=toggle_block;target=[signal.data["name"]]'>(BLOCK/UNBLOCK)</a><br>[signal.format_message()]<br>"
	if (!silent)
		playsound(src, 'modular_coyote/sound/pipsounds/pipmsgget.ogg', 80, 1)
		audible_message("[icon2html(src, hearers(src))] *[ttone]*", null, 3)
	//Search for holder of the PDA.
	var/mob/living/L = null
	if(loc && isliving(loc))
		L = loc
	//Maybe they are a pAI!
	else
		L = get(src, /mob/living/silicon)

	if(L && L.stat != UNCONSCIOUS)
		var/hrefstart
		var/hrefend
		if (isAI(L))
			hrefstart = "<a href='byond://?src=[REF(L)];track=[html_encode(signal.data["name"])]'>"
			hrefend = "</a>"

		var/inbound_message = signal.format_message()
		if(signal.data["emojis"] == TRUE)//so will not parse emojis as such from pdas that don't send emojis
			inbound_message = emoji_parse(inbound_message)

		to_chat(L, "[icon2html(src)] <b>Message from [hrefstart][signal.data["name"]] ([signal.data["job"]])[hrefend], </b>[inbound_message] (<a href='byond://?src=[REF(src)];choice=Message;skiprefresh=1;target=[REF(signal.source)]'>Reply</a>) (<a href='byond://?src=[REF(src)];choice=toggle_block;target=[signal.data["name"]]'>BLOCK/UNBLOCK</a>)")

	new_alert = TRUE
	update_icon(TRUE)

/obj/item/pda/proc/send_to_all(mob/living/U)
	if (last_everyone && world.time < last_everyone + PDA_SPAM_DELAY)
		to_chat(U,span_warning("Send To All function is still on cooldown."))
		return
	send_message(U,get_viewable_pdas(), TRUE)

/obj/item/pda/proc/create_message(mob/living/U, obj/item/pda/P)
	send_message(U,list(P))

/obj/item/pda/proc/toggle_blocking(mob/user, target)
	if(target in blocked_pdas)
		unblock_pda(user, target)
	else
		block_pda(user, target)

/obj/item/pda/proc/block_pda(mob/user, target)
	to_chat(user, span_notice("[icon2html(src, user)] [target] blocked from messages. Use the messenger PDA list to unblock."))
	LAZYOR(blocked_pdas, target)

/obj/item/pda/proc/unblock_pda(mob/user, target)
	to_chat(user, span_notice("[icon2html(src, user)] [target] unblocked from messages."))
	LAZYREMOVE(blocked_pdas, target)

/obj/item/pda/AltClick(mob/user)
	. = ..()
	if(id)
		remove_id(user)
		playsound(src, 'sound/machines/terminal_eject_disc.ogg', 50, 1)
	else
		remove_pen(user)
		playsound(src, 'sound/machines/button4.ogg', 50, 1)
	return TRUE

/obj/item/pda/CtrlClick(mob/user)
	..()

	if(isturf(loc)) //stops the user from dragging the PDA by ctrl-clicking it.
		return

	remove_pen(user)

/obj/item/pda/verb/verb_toggle_light()
	set category = "Object"
	set name = "Toggle Flashlight"

	toggle_light()

/obj/item/pda/verb/verb_remove_id()
	set category = "Object"
	set name = "Eject ID"
	set src in usr

	if(id)
		remove_id(usr)
	else
		to_chat(usr, span_warning("This PDA does not have an ID in it!"))

/obj/item/pda/verb/verb_remove_pen()
	set category = "Object"
	set name = "Remove Pen"
	set src in usr

	remove_pen()

/obj/item/pda/proc/toggle_light()
	if(hasSiliconAccessInArea(usr) || !usr.canUseTopic(src, BE_CLOSE))
		return
	if(fon)
		fon = FALSE
		set_light(0)
		playsound(src, "modular_coyote/sound/pipsounds/piplightoff.ogg", 50, 1)
	else if(f_lum)
		fon = TRUE
		set_light(f_lum, f_pow, f_col)
		playsound(src, "modular_coyote/sound/pipsounds/piplighton.ogg", 50, 1)
	update_icon()

/obj/item/pda/proc/remove_pen()

	if(hasSiliconAccessInArea(usr) || !usr.canUseTopic(src, BE_CLOSE, FALSE, NO_TK))
		return

	if(inserted_item)
		usr.put_in_hands(inserted_item)
		to_chat(usr, span_notice("You remove [inserted_item] from [src]."))
		inserted_item = null
		update_icon()
	else
		to_chat(usr, span_warning("This PDA does not have a pen in it!"))

//trying to insert or remove an id
/obj/item/pda/proc/id_check(mob/user, obj/item/card/id/I)
	if(!I)
		if(id && (src in user.contents))
			remove_id(user)
			return TRUE
		else
			var/obj/item/card/id/C = user.get_active_held_item()
			if(istype(C))
				I = C

	if(I?.registered_name)
		if(!user.transferItemToLoc(I, src))
			return FALSE
		insert_id(I, user)
		update_icon()
		playsound(src, 'sound/machines/button.ogg', 50, 1)
	return TRUE

/obj/item/pda/proc/insert_id(obj/item/card/id/inserting_id, mob/user)
	var/obj/old_id = id
	id = inserting_id
	if(ishuman(loc))
		var/mob/living/carbon/human/human_wearer = loc
		if(human_wearer.wear_id == src)
			human_wearer.sec_hud_set_ID()
	if(old_id)
		if(user)
			user.put_in_hands(old_id)
		else
			old_id.forceMove(get_turf(src))

// access to status display signals
/obj/item/pda/attackby(obj/item/C, mob/user, params)
	if(istype(C, /obj/item/cartridge) && !cartridge)
		if(!user.transferItemToLoc(C, src))
			return
		cartridge = C
		cartridge.host_pda = src
		to_chat(user, span_notice("You insert [cartridge] into [src]."))
		update_icon()
		playsound(src, 'sound/machines/button.ogg', 50, 1)

	else if(istype(C, /obj/item/card/id))
		var/obj/item/card/id/idcard = C
		if(!idcard.registered_name)
			to_chat(user, span_warning("\The [src] rejects the ID!"))
			if (!silent)
				playsound(src, 'sound/machines/terminal_error.ogg', 15, 1)
			return

		if(!owner)
			owner = idcard.registered_name
			ownjob = idcard.assignment
			update_label()
			to_chat(user, span_notice("Card scanned."))
			if (!silent)
				playsound(src, 'sound/machines/terminal_success.ogg', 15, 1)
		else
			//Basic safety check. If either both objects are held by user or PDA is on ground and card is in hand.
			if(((src in user.contents) || (isturf(loc) && in_range(src, user))) && (C in user.contents))
				if(!id_check(user, idcard))
					return
				to_chat(user, span_notice("You put the ID into \the [src]'s slot."))
				updateSelfDialog()//Update self dialog on success.
			return	//Return in case of failed check or when successful.
		updateSelfDialog()//For the non-input related code.
	else if(istype(C, /obj/item/paicard) && !pai)
		if(!user.transferItemToLoc(C, src))
			return
		pai = C
		to_chat(user, span_notice("You slot \the [C] into [src]."))
		update_icon()
		updateUsrDialog()
	else if(is_type_in_list(C, contained_item)) //Checks if there is a pen
		if(inserted_item)
			to_chat(user, span_warning("There is already \a [inserted_item] in \the [src]!"))
			return ..()
		else
			if(!user.transferItemToLoc(C, src))
				return
			to_chat(user, span_notice("You slide \the [C] into \the [src]."))
			inserted_item = C
			update_icon()
			playsound(src, 'sound/machines/button.ogg', 50, 1)

	else if(istype(C, /obj/item/photo))
		var/obj/item/photo/P = C
		picture = P.picture
		to_chat(user, span_notice("You scan \the [C]."))
	else
		return ..()

/obj/item/pda/attack(mob/living/carbon/C, mob/living/user)
	if(istype(C))
		switch(scanmode)

			if(PDA_SCANNER_MEDICAL)
				C.visible_message(span_alert("[user] has analyzed [C]'s vitals!"))
				healthscan(user, C, 1)
				add_fingerprint(user)

			if(PDA_SCANNER_HALOGEN)
				C.visible_message(span_warning("[user] has analyzed [C]'s radiation levels!"))

				user.show_message(span_notice("Analyzing Results for [C]:"))
				if(C.radiation)
					user.show_message("\green Radiation Level: \black [C.radiation]")
				else
					user.show_message(span_notice("No radiation detected."))

/obj/item/pda/afterattack(atom/A as mob|obj|turf|area, mob/user, proximity)
	. = ..()
	if(!proximity)
		return
	switch(scanmode)
		if(PDA_SCANNER_REAGENT)
			if(!isnull(A.reagents))
				if(A.reagents.reagent_list.len > 0)
					var/reagents_length = A.reagents.reagent_list.len
					to_chat(user, span_notice("[reagents_length] chemical agent[reagents_length > 1 ? "s" : ""] found."))
					for (var/re in A.reagents.reagent_list)
						to_chat(user, span_notice("\t [re]"))
				else
					to_chat(user, span_notice("No active chemical agents found in [A]."))
			else
				to_chat(user, span_notice("No significant chemical agents found in [A]."))

		if(PDA_SCANNER_GAS)
			A.analyzer_act(user, src)

	if (!scanmode && istype(A, /obj/item/paper) && owner)
		var/obj/item/paper/PP = A
		if (!PP.info)
			to_chat(user, span_warning("Unable to scan! Paper is blank."))
			return
		notehtml = PP.info
		note = replacetext(notehtml, "<BR>", "\[br\]")
		note = replacetext(note, "<li>", "\[*\]")
		note = replacetext(note, "<ul>", "\[list\]")
		note = replacetext(note, "</ul>", "\[/list\]")
		note = html_encode(note)
		notescanned = TRUE
		to_chat(user, span_notice("Paper scanned. Saved to PDA's notekeeper.") )


/obj/item/pda/proc/explode() //This needs tuning.
	if(!detonatable)
		return
	var/turf/T = get_turf(src)

	if (ismob(loc))
		var/mob/M = loc
		M.show_message(span_userdanger("Your [src] explodes!"), MSG_VISUAL, span_warning("You hear a loud *pop*!"), MSG_AUDIBLE)
	else
		visible_message(span_danger("[src] explodes!"), span_warning("You hear a loud *pop*!"))

	if(T)
		T.hotspot_expose(700,125)
		if(istype(cartridge, /obj/item/cartridge/virus/syndicate))
			explosion(T, -1, 1, 3, 4)
		else
			explosion(T, -1, -1, 2, 3)
	qdel(src)
	return

/obj/item/pda/Destroy()
	GLOB.PDAs -= src
	if(istype(id))
		QDEL_NULL(id)
	if(istype(cartridge))
		QDEL_NULL(cartridge)
	if(istype(pai))
		QDEL_NULL(pai)
	if(istype(inserted_item))
		QDEL_NULL(inserted_item)
	return ..()

//AI verb and proc for sending PDA messages.

/mob/living/silicon/ai/proc/cmd_send_pdamesg(mob/user)
	var/list/plist = list()
	var/list/namecounts = list()

	if(aiPDA.toff)
		to_chat(user, "Turn on your receiver in order to send messages.")
		return

	for (var/obj/item/pda/P in get_viewable_pdas())
		if (P == src)
			continue
		else if (P == aiPDA)
			continue

		plist[avoid_assoc_duplicate_keys(P.owner, namecounts)] = P

	var/c = input(user, "Please select a PDA") as null|anything in sortList(plist)

	if (!c)
		return

	var/selected = plist[c]

	if(aicamera.stored.len)
		var/add_photo = input(user,"Do you want to attach a photo?","Photo","No") as null|anything in list("Yes","No")
		if(add_photo=="Yes")
			var/datum/picture/Pic = aicamera.selectpicture(user)
			aiPDA.picture = Pic

	if(incapacitated())
		return

	aiPDA.create_message(src, selected)


/mob/living/silicon/ai/verb/cmd_toggle_pda_receiver()
	set category = "AI Commands"
	set name = "PDA - Toggle Sender/Receiver"
	if(usr.stat == DEAD)
		return //won't work if dead
	if(!isnull(aiPDA))
		aiPDA.toff = !aiPDA.toff
		to_chat(usr, span_notice("PDA sender/receiver toggled [(aiPDA.toff ? "Off" : "On")]!"))
	else
		to_chat(usr, "You do not have a PDA. You should make an issue report about this.")

/mob/living/silicon/ai/verb/cmd_toggle_pda_silent()
	set category = "AI Commands"
	set name = "PDA - Toggle Ringer"
	if(usr.stat == DEAD)
		return //won't work if dead
	if(!isnull(aiPDA))
		//0
		aiPDA.silent = !aiPDA.silent
		to_chat(usr, span_notice("PDA ringer toggled [(aiPDA.silent ? "Off" : "On")]!"))
	else
		to_chat(usr, "You do not have a PDA. You should make an issue report about this.")

/mob/living/silicon/ai/proc/cmd_show_message_log(mob/user)
	if(incapacitated())
		return
	if(!isnull(aiPDA))
		var/HTML = "<html><head><meta http-equiv='Content-Type' content='text/html; charset=UTF-8'><title>AI PDA Message Log</title></head><body>[aiPDA.tnote]</body></html>"
		user << browse(HTML_SKELETON(HTML), "window=log;size=400x444;border=1;can_resize=1;can_close=1;can_minimize=0")
	else
		to_chat(user, "You do not have a PDA. You should make an issue report about this.")


// Pass along the pulse to atoms in contents, largely added so pAIs are vulnerable to EMP
/obj/item/pda/emp_act(severity)
	. = ..()
	if (!(. & EMP_PROTECT_CONTENTS))
		for(var/atom/A in src)
			A.emp_act(severity)
	if (!(. & EMP_PROTECT_SELF))
		emped += 1
		spawn(2 * severity)
			emped -= 1

/proc/get_viewable_pdas()
	. = list()
	// Returns a list of PDAs which can be viewed from another PDA/message monitor.
	for(var/obj/item/pda/P in GLOB.PDAs)
		if(!P.owner || P.toff || P.hidden)
			continue
		. += P


#undef PDA_SCANNER_NONE
#undef PDA_SCANNER_MEDICAL
#undef PDA_SCANNER_FORENSICS
#undef PDA_SCANNER_REAGENT
#undef PDA_SCANNER_HALOGEN
#undef PDA_SCANNER_GAS
#undef PDA_SPAM_DELAY

#undef PDA_OVERLAY_ALERT
#undef PDA_OVERLAY_SCREEN
#undef PDA_OVERLAY_ID
#undef PDA_OVERLAY_ITEM
#undef PDA_OVERLAY_LIGHT
#undef PDA_OVERLAY_PAI
