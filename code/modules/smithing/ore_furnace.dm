/obj/structure/ore_furnace
	name = "ore furnace"
	desc = "A furnace for smelting raw ores into their refined versions."
	icon = 'icons/fallout/objects/crafting/blacksmith.dmi'
	icon_state = "furnace0"
	density = TRUE
	anchored = TRUE
	var/debug = FALSE //debugging only
	var/working = FALSE
	var/fueluse = 0.5
	var/obj/item/stack/ore/currentOre = null
	light_system = MOVABLE_LIGHT
	light_range = 2
	light_power = 0.75
	light_color = LIGHT_COLOR_FIRE
	light_on = FALSE

/obj/structure/ore_furnace/Initialize()
	. = ..()
	create_reagents(250, TRANSPARENT)
	START_PROCESSING(SSobj, src)

/obj/structure/ore_furnace/Destroy()
	STOP_PROCESSING(SSobj, src)
	return ..()

/obj/structure/ore_furnace/process()
	if(istype(currentOre) && working && reagents.remove_reagent(/datum/reagent/fuel, fueluse))
		if (currentOre.amount)
			currentOre.amount -= 1
			if (prob(95))
				new currentOre.refined_type(loc)
			else
				visible_message(span_warning("The ore was too impure, releasing a puff of smoke from the furnace."))
		else
			qdel(currentOre)
			currentOre = null
			working = FALSE
			set_light_on(FALSE)	

/obj/structure/ore_furnace/attackby(obj/item/I, mob/user)
	if(istype(I, /obj/item/stack/ore))
		var/obj/item/stack/ore/notsword = I
		if(has_fuel(notsword.amount))
			if(!working)
				working = TRUE
				set_light_on(TRUE)
				if(icon_state == "furnace0")
					icon_state = "furnace1"
				to_chat(user, "You insert the [notsword] into the [src].")
				if (notsword.refined_type)
					currentOre = notsword
					user.transferItemToLoc(I, src)
				else
					to_chat(user, "The [notsword] is incinerated to ashes in the [src].")
					qdel(notsword)
					working = FALSE
					set_light_on(FALSE)
					icon_state = "furnace0"

			else
				to_chat(user, "The furnace is busy working!")
		else
			to_chat(user, "The furnace does not have enough fuel left to smelt that amount!")
	else
		. = ..()

/obj/structure/ore_furnace/proc/has_fuel(amount)
	return reagents.has_reagent(/datum/reagent/fuel, amount * fueluse)

/obj/structure/ore_furnace/wrench_act(mob/living/user, obj/item/I)
	..()
	default_unfasten_wrench(user, I, 5)
	return TRUE

/obj/structure/ore_furnace/attackby(obj/item/W, mob/user, params)
	if(W.reagents)
		W.reagents.trans_to(src, 250)
	else
		return ..()

/obj/structure/ore_furnace/plunger_act(obj/item/plunger/P, mob/living/user, reinforced)
	to_chat(user, "<span class='notice'>You start furiously plunging [name].")
	if(do_after(user, 30, target = src))
		to_chat(user, "<span class='notice'>You finish plunging the [name].")
		reagents.reaction(get_turf(src), TOUCH) //splash on the floor
		reagents.clear_reagents()
