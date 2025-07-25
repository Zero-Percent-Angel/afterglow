/obj/item/integrated_electronics/analyzer
	name = "circuit analyzer"
	desc = "This tool can scan an assembly and generate code necessary to recreate it in a circuit printer."
	icon = 'icons/obj/assemblies/electronic_tools.dmi'
	icon_state = "analyzer"
	flags_1 = CONDUCT_1
	w_class = WEIGHT_CLASS_SMALL

/obj/item/integrated_electronics/analyzer/afterattack(atom/A, mob/living/user)
	. = ..()
	if(istype(A, /obj/item/electronic_assembly))
		if (!user.skill_check(SKILL_SCIENCE, HARD_CHECK))
			to_chat(user, span_bad("You have no idea how to use this."))
			return
		var/saved = "[A.name] analyzed! On circuit printers with cloning enabled, you may use the code below to clone the circuit:<br><br><code>[SScircuit.save_electronic_assembly(A)]</code>"
		if(saved)
			to_chat(user, span_notice("You scan [A]."))
			user << browse(HTML_SKELETON(saved), "window=circuit_scan;size=500x600;border=1;can_resize=1;can_close=1;can_minimize=1")
		else
			to_chat(user, span_warning("[A] is not complete enough to be encoded!"))
