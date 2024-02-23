GLOBAL_LIST_EMPTY(vault_doors)

/obj/structure/vaultdoor
	name = "vault door 113"
	icon = 'icons/obj/doors/gear.dmi'
	icon_state = "closed"
	density = TRUE
	opacity = 1
	layer = WALL_OBJ_LAYER
	anchored = TRUE

	var/is_busy = FALSE
	var/destroyed = FALSE
	var/isworn = FALSE
	var/is_open = FALSE
	max_integrity = 1000
	resistance_flags = FIRE_PROOF | ACID_PROOF | UNACIDABLE | FREEZE_PROOF  //it's a fucking steel blast door
	armor = list("melee" = 90, "bullet" = 90, "laser" = 90, "energy" = 90, "bomb" = 90, "bio" = 100, "rad" = 100, "fire" = 100, "acid" = 100, "damage_threshold" = 30) //it's a fucking steel door 2.0

/obj/structure/vaultdoor/Initialize()
	. = ..()
	LAZYADD(GLOB.vault_doors, src)

/obj/structure/vaultdoor/Destroy()
	LAZYREMOVE(GLOB.vault_doors, src)
	return ..()

/obj/structure/vaultdoor/blob_act()
	ex_act(4)
	return

/obj/structure/vaultdoor/ex_act(severity, target)
	switch(severity)
		if(1)
			take_damage(rand(250, 350), BRUTE, "bomb", 0)
		if(2)
			take_damage(rand(100, 250), BRUTE, "bomb", 0)
		if(3)
			take_damage(rand(10, 90), BRUTE, "bomb", 0)
	return

/obj/structure/vaultdoor/proc/repair()
	icon_state = "open"
	set_opacity(1)
	src.density = FALSE
	is_busy = FALSE
	is_open = TRUE
	obj_integrity = 50
	destroyed = FALSE
	isworn = FALSE

/obj/structure/vaultdoor/proc/destroy()
	icon_state = "empty"
	set_opacity(0)
	src.density = FALSE
	destroyed = TRUE

/obj/structure/vaultdoor/obj_destruction() //No you can't just shoot it and expect it to break
	destroy()

/obj/structure/vaultdoor/proc/open()
	is_busy = TRUE
	flick("opening", src)
	icon_state = "open"
	playsound(loc, 'sound/f13machines/doorgear_open.ogg', 50, 0, 10)
	sleep(30)
	set_opacity(0)
	src.density = FALSE
	is_busy = FALSE
	is_open = TRUE

/obj/structure/vaultdoor/proc/close()
	is_busy = TRUE
	flick("closing", src)
	icon_state = "closed"
	playsound(loc, 'sound/f13machines/doorgear_close.ogg', 50, 0, 10)
	sleep(30)
	set_opacity(1)
	src.density = TRUE
	is_busy = FALSE
	is_open = FALSE

/obj/structure/vaultdoor/proc/vaultactivate()
	if(destroyed)
		to_chat(usr, span_warning("[src] is broken"))
		return
	if(is_busy)
		to_chat(usr, span_warning("[src] is busy"))
		return
	if(density)
		open()
		return
	close()

/obj/structure/vaultdoor/attackby(obj/item/I, mob/living/user, params)
	add_fingerprint(user)
	if(icon_state == "empty") //Its brok, fix it
		if(istype(I, /obj/item/weldingtool) && user.a_intent == INTENT_HELP)
			if(user.skill_check(SKILL_REPAIR, EXPERT_CHECK, FALSE))
				if(I.use_tool(src, user, 40, volume=50))
					repair()
			else
				to_chat(user, span_warning("You have no idea where to even start with this."))
	if(istype(I, /obj/item/weldingtool) && user.a_intent == INTENT_HELP)
		if(obj_integrity < max_integrity)
			if(!I.tool_start_check(user, amount=0))
				return

			to_chat(user, span_notice("You begin repairing [src]..."))
			if(I.use_tool(src, user, 40, volume=50))
				obj_integrity += user.skill_value(SKILL_REPAIR)
				to_chat(user, span_notice("You repair [src]."))
		else
			to_chat(user, span_warning("[src] is already in good condition!"))
		return

//ß íå õî÷ó ïåðåäåëûâàòü ýòî äåðüìî  - Google translate tells me that from Russian to english this is "Do not move your arms around this way." so dont.





/obj/machinery/doorButtons/vaultButton
	name = "vault access"
	icon = 'icons/obj/lever.dmi'
	icon_state = "lever0"
	anchored = TRUE
	density = TRUE
	resistance_flags = FIRE_PROOF | ACID_PROOF | UNACIDABLE | FREEZE_PROOF | INDESTRUCTIBLE

/obj/machinery/doorButtons/vaultButton/proc/activate()
	for(var/obj/structure/vaultdoor/vdoor in world)
		vdoor.vaultactivate()

/obj/machinery/doorButtons/vaultButton/attackby(obj/item/weapon/W, mob/user, params)
	activate()

/obj/machinery/doorButtons/vaultButton/attack_hand(mob/user)
	activate()
	message_admins("[ADMIN_LOOKUPFLW(user)] pressed the vault door button at [ADMIN_VERBOSEJMP(user.loc)].")

/obj/machinery/doorButtons/vaultButton/external
	name = "external vault access"
	var/password = "nochance"
	var/list/failures = list()
	var/is_busy = FALSE

/obj/machinery/doorButtons/vaultButton/external/Initialize(mapload)
	. = ..()
	password = random_string(8, GLOB.alphabet)

/obj/machinery/doorButtons/vaultButton/external/attackby(obj/item/weapon/W, mob/user, params)
	return

/obj/machinery/doorButtons/vaultButton/external/attack_hand(mob/user)
	message_admins("[ADMIN_LOOKUPFLW(user)] is attempting to get into the vault at [ADMIN_VERBOSEJMP(user.loc)].")
	if (ask_for_pass(user))
		activate()


/obj/machinery/doorButtons/vaultButton/external/proc/ask_for_pass(mob/user)
	var/hack = input(user, "Do you wish to hack or guess the password?", "Hack") in list("Hack", "Guess")
	if (get_dist(user, src) > 1)
		return
	if (hack == "Guess")
		var/guess = stripped_input(user,"Enter the password:", "Password", "")
		if(guess == password)
			return TRUE
		return FALSE
	else
		if (!user.skill_check(SKILL_SCIENCE, EXPERT_CHECK))
			to_chat(user, span_warning("You have no idea how to hack this."))
			return
		if (!is_busy)
			is_busy = TRUE
			if(!failures.Find(WEAKREF(user)) && do_after(user, 10 SECONDS, target = src) && user.skill_roll_evil(SKILL_SCIENCE, DIFFICULTY_EXPERT))
				user.visible_message(span_good("[user] hacks the door!"), span_good("Got it!"))
				is_busy = FALSE
				return TRUE
			else
				failures |= WEAKREF(user)
				user.visible_message(span_warning("[user] fails to hack the door!"), span_warning("Dang, looks like it's locked itself down from me."))
				is_busy = FALSE
				return FALSE


//new vault door button
/obj/machinery/doorButtons/wornvaultButton
	name = "worn vault access"
	icon = 'icons/obj/lever.dmi'
	icon_state = "lever0"
	anchored = TRUE
	density = TRUE
	resistance_flags = FIRE_PROOF | ACID_PROOF | UNACIDABLE | FREEZE_PROOF | INDESTRUCTIBLE

/obj/machinery/doorButtons/wornvaultButton/proc/activate()
	for(var/obj/structure/vaultdoor/vdoor in world)
		if(vdoor.isworn == TRUE)
			vdoor.vaultactivate()

/obj/machinery/doorButtons/wornvaultButton/attackby(obj/item/weapon/W, mob/user, params)
	activate()

/obj/machinery/doorButtons/wornvaultButton/attack_hand(mob/user)
	activate()
