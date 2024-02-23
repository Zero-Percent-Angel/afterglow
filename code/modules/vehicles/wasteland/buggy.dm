//Fallout 13 dune buggy directory

/obj/vehicle/ridden/fuel/motorcycle/buggy
	name = "dune buggy"
	desc = "<i>Ain't no place for fancy cars on the wasteland.<br>No place for classy brands, but nicknames.<br>Only the rusty and trusty death machines.<br>Only fuel and blood.</i>"
	icon = 'icons/fallout/vehicles/medium_vehicles.dmi'
	icon_state = "buggy_dune"
	pixel_x = -17
	pixel_y = -2
	obj_integrity = 600
	max_integrity = 600
	fuel = 800
	max_fuel = 800
	var/list/names = list("Badger", "Bandit", "Desert Punk", "Dune Buddy", "Duster", "Rebel", "Rooster")

/obj/vehicle/ridden/fuel/motorcycle/buggy/New()
	..()
	name = pick(names)

/obj/vehicle/ridden/fuel/motorcycle/buggy/Initialize(mapload)
	. = ..()
	update_icon()

	var/datum/component/riding/D = LoadComponent(/datum/component/riding)
	D.vehicle_move_delay = 0.8
	D.set_riding_offsets(RIDING_OFFSET_ALL, list(TEXT_NORTH = list(0, 0), TEXT_SOUTH = list(1, -3), TEXT_EAST = list(-6, 7), TEXT_WEST = list(2, 7)))
	D.set_vehicle_dir_offsets(NORTH, -16, -16)
	D.set_vehicle_dir_offsets(SOUTH, -16, -16)
	D.set_vehicle_dir_offsets(EAST, -18, 0)
	D.set_vehicle_dir_offsets(WEST, -18, 0)

/obj/item/key/buggy
	name = "car key"
	desc = "A keyring with a small steel key.<br>By the look of the key cuts, it likely belongs to an automobile."
	icon = 'icons/fallout/vehicles/small_vehicles.dmi'

/obj/item/key/buggy/New()
	..()
	icon_state = pick("key-buggy-r","key-buggy-y","key-buggy-g","key-buggy-b")

/obj/item/key/buggy/wheel //I am the man... Who grabs the sun... RIDING TO VALHALLA!
	name = "steering wheel"
	desc = "A vital part of an automobile that is made of metal and decorated with a freaky skull.<br>Oh, what a day... What a lovely day for taking a ride!"
	icon_state = "wheel"

/obj/item/key/buggy/wheel/New()
	..()
	icon_state = "wheel"

/obj/vehicle/ridden/fuel/motorcycle/buggy/olive
	icon_state = "buggy_olive"
	names = list("Bang-Bang", "Bolo", "Dittybopper", "Geardo", "Joe", "Pollywog", "Zoomie")

/obj/vehicle/ridden/fuel/motorcycle/buggy/red
	icon_state = "buggy_red"
	names = list("Crusher", "Grim Reaper", "Meat Grinder", "Mincer", "Reaver", "Ripper", "Ripsaw")

/obj/vehicle/ridden/fuel/motorcycle/buggy/hot
	icon_state = "buggy_hot"
	names = list("Dragon", "Fire And Flames", "Flash", "Igniter", "Heat", "Hot Wheels", "Trailblazer")
