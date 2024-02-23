/obj/item/underwear
	name = "underwear"
	desc = "Underwear to cover yourself up with."
	icon = 'icons/mob/clothing/underwear.dmi'
	var/bottom = FALSE
	var/top = FALSE
	var/sock = FALSE
	var/undie = ""


/obj/item/underwear/New(loc, icon_undies, bots = 0, tops = 0, socks = 0)
	. = ..()
	var/datum/sprite_accessory/underwear/B
	if (bots)
		B = GLOB.underwear_list[icon_undies]
	if (tops)
		B = GLOB.undershirt_list[icon_undies]
	if (socks)
		B = GLOB.socks_list[icon_undies]
	icon_state = B.icon_state
	undie = icon_undies
	bottom = bots
	top = tops
	sock = socks
	update_icon()

/obj/item/underwear/attack(mob/living/M, mob/living/user, attackchain_flags, damage_multiplier)
	if (icon_state && icon_state != "" && istype(M, /mob/living/carbon/human))
		var/mob/living/carbon/human/H = M
		if (bottom)
			if(H.lower_body_exposed() && H.underwear == "Nude")
				H.underwear = undie
				H.update_body(TRUE)
				qdel(src)
		if (top)
			if(H.upper_body_exposed() && H.undershirt == "Nude")
				H.undershirt = undie
				H.update_body(TRUE)
				qdel(src)
		if (sock)
			if(H.shoes == null && H.socks == "Nude")
				H.socks = undie
				H.update_body(TRUE)
				qdel(src)


