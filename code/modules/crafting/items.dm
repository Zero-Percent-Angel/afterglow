/obj/item/scrap/research
	name = "strange object"
	desc = "What mysteries could this hold?"
	icon = 'icons/obj/assemblies.dmi'

/obj/item/scrap/research/Initialize()
	. = ..()
	icon_state = pick("shock_kit","armor-igniter-analyzer","infra-igniter0","infra-igniter1","radio-multitool","prox-radio1","radio-radio","timer-multitool0","radio-igniter-tank")
	name = "[pick("broken","twisted","spun","improved","silly","regular","badly made")] [pick("device","object","toy","illegal tech","weapon")]"

/obj/item/metaldetector
	name = "metal detector"
	desc = "Detects burried salvage in a 5 tile radius."
	icon = 'icons/fallout/objects/items.dmi'
	icon_state = "metaldetect"

/obj/item/metaldetector/attack_self(mob/user)
	. = ..()
	var/turf/t = get_turf(src)
	salvage_scan_pulse(t, 5)

/obj/item/metaldetector/proc/salvage_scan_pulse(turf/T, range = world.view)
	var/list/salvage = list()
	for(var/turf/open/indestructible/ground/outside/desert/M in range(range, T))
		if(M.salvage)
			salvage += M
	if(LAZYLEN(salvage))
		for(var/turf/open/indestructible/ground/outside/desert/M in salvage)
			var/obj/effect/temp_visual/detector_overlay/oldC = locate(/obj/effect/temp_visual/detector_overlay) in M
			if(oldC)
				qdel(oldC)
			new /obj/effect/temp_visual/detector_overlay(M)

/obj/effect/temp_visual/detector_overlay
	plane = FULLSCREEN_PLANE
	layer = FLASH_LAYER
	icon = 'icons/effects/ore_visuals.dmi'
	icon_state = "scan"
	appearance_flags = 0 //to avoid having TILE_BOUND in the flags, so that the 480x480 icon states let you see it no matter where you are
	duration = 35
	pixel_x = -224
	pixel_y = -224

/obj/item/components
	name = "crafting items"
	icon = 'icons/fallout/objects/items.dmi'
	icon_state = "blueprint_empty"
	w_class = WEIGHT_CLASS_TINY

/obj/item/blueprint
	name = "crafting blueprint"
	icon = 'icons/fallout/objects/items.dmi'
	icon_state = "blueprint_empty"
	w_class = WEIGHT_CLASS_TINY

/obj/item/prefabs
	name = "crafting prefabs"
	icon = 'icons/fallout/objects/items.dmi'
	icon_state = "blueprint_empty"
	w_class = WEIGHT_CLASS_TINY

/obj/item/stack/prefabs
	name = "crafting prefabs"
	icon = 'icons/fallout/objects/items.dmi'
	icon_state = "blueprint_empty"
	w_class = WEIGHT_CLASS_TINY

//misc blueprints
/obj/item/blueprint/misc
	name = "weapon blueprint"
	desc = "A crafting blueprint for a weapon design."
	icon_state = "blueprint2"

GLOBAL_LIST_INIT(blueprint_fluff, list(
	"iconstates" = list(
		"docs_generic",
		"docs_verified",
		"docs_part",
		"docs_red",
		"docs_blue",
		"scrap_bloodied",
		"bountycardfull",
		"folder_yellow",
		"folder_red",
		"folder_sred",
		"folder_blue",
		"folder_sblue",
		"newspaper",
		"paper_talisman",
		"paper_stack_words",
		"barcode"),
	"prefixes" = list(
		"strange",
		"curious",
		"odd",
		"weird",
		"mysterious",
		"ancient",
		"bizarre",
		"poorly-formatted",
		"singed",
		"grody",
		"illicit",
		"unmentionable",
		"exotic",
		"alluring",
		"attractive",
		"stack of",
		"wad of",
		"pile of",
		"clump of",
		"tangle of",
		"moist",
		"historical",
		"filthy",
		"stapled together",
		"loose",
		"burnt",
		"neatly stacked",
		"large print",
		"unreadable",
		"French",
		"lightly toasted",
		"mummified",
		"fossilized",
		"decayed",
		"mangy",
		"smudged",
		"salvaged",
		"various",
		"assorted",
		"misc",
		"lost",
		"important",
		"useful",
		"well prepared",
		"damp"),
	"suffixes" = list(
		"documents",
		"files",
		"papers",
		"fliers",
		"blueprints",
		"magazine articles",
		"torn-out pages",
		"pictures",
		"photospreads",
		"words",
		"newspapers",
		"scraps",
		"reports",
		"essays",
		"missives",
		"fanfiction exerpts",
		"grandma's recipes",
		"opinion pieces",
		"postcards",
		"codesheets",
		"timesheets",
		"letters",
		"mail",
		"transcripts",
		"tax forms",
		"tax returns",
		"accounting sheets",
		"balance sheets",
		"shopping lists",
		"phonebook pages",
		"comics",
		"poems",
		"stories",
		"letters to the editor",
		"bank statements",
		"scriptures",
		"songs",
		"laundry lists",
		"research results",
		"scientific papers",
		"parking tickets",
		"punchcards")
	))

/obj/item/blueprint/research
	name = "mysterious blueprint"
	desc = "Some kind of collection of pre-war 'information'. Might be something in here worthwhile to people interested in that kind of thing. <br><br>(grants 5k research points when destructively analyzed)"
	icon ='icons/obj/bureaucracy.dmi'
	icon_state = "docs_generic"

/obj/item/blueprint/research/Initialize()
	. = ..()
	name = "[pick(GLOB.blueprint_fluff["prefixes"])] [pick(GLOB.blueprint_fluff["suffixes"])]"
	icon_state = pick(GLOB.blueprint_fluff["iconstates"])

/obj/item/blueprint/misc/stim
	name = "Stimpack blueprint"
	desc = "Stimpacks"

/obj/item/blueprint/misc/superstims
	name = "Super Stimpack blueprint"
	desc = "Super stims"

//weapon blueprints
/obj/item/blueprint/weapon
	name = "weapon blueprint"
	desc = "A crafting blueprint for a weapon design."
	icon_state = "blueprint1"

/obj/item/advanced_crafting_components
	name = "crafting blueprint"
	icon = 'icons/fallout/objects/crafting.dmi'
	icon_state = "blueprint_empty"
	w_class = WEIGHT_CLASS_TINY

//plasma
/obj/item/advanced_crafting_components/flux
	name = "Flux capacitator"
	desc = "An energy weapon part, a craftsman might want to have this."
	icon_state = "flux"

//lasers
/obj/item/advanced_crafting_components/lenses
	name = "Focused crystal lenses"
	desc = "An energy weapon part, a craftsman might want to have this."
	icon_state = "lenses"

//general energy
/obj/item/advanced_crafting_components/conductors
	name = "Superconductor coil"
	desc = "An energy weapon part, a craftsman might want to have this."
	icon_state = "conductor"

//general ballistics
/obj/item/advanced_crafting_components/receiver
	name = "Advanced modular receiver"
	desc = "A ballistic weapon part, a craftsman might want to have this."
	icon_state = "receiver"

//rifles
/obj/item/advanced_crafting_components/assembly
	name = "Pre-war weapon assembly"
	desc = "A ballistic weapon part, a craftsman might want to have this."
	icon_state = "weapon_parts_1"

//general
/obj/item/advanced_crafting_components/alloys
	name = "Superlight alloys"
	desc = "A general crafting part, a craftsman might want to have this."
	icon_state = "alloys"

//advanced electronics crafting
/obj/item/advanced_crafting_components/p_circuits
	name = "Pristine circuits"
	desc = "Advanced electronic circuits from before the war, a craftsman might want to have this."
	icon_state = "frame"

//salvage
/obj/item/salvage
	name = "salvage"
	icon = 'icons/fallout/objects/items.dmi'
	icon_state = "blueprint_empty"
	w_class = WEIGHT_CLASS_NORMAL
	var/list/Loot = list() //List of items

/obj/item/salvage/proc/make_loot(mob/user, place_to_put_it)
	if(!place_to_put_it || !isturf(place_to_put_it))
		place_to_put_it = get_turf(src) //just dump it on the floor you filthy animal
	// easy repair skill check for first loot roll, standard repair check for +1, +1 if technophreak, and 25% for +1
	var/loot_rolls = (user.skill_check(SKILL_REPAIR, EASY_CHECK)) + (user.skill_check(SKILL_REPAIR)) + (HAS_TRAIT(user, TRAIT_TECHNOPHREAK)) + (prob(25))
	for(var/i in 1 to loot_rolls)
		var/obj/I = pick(src.Loot)
		new I (place_to_put_it)
		stoplag(1)
	qdel(src)

/obj/item/salvage/low
	name = "Pre-war salvage"
	desc = "Some pre-war salvage, it could contain some useful materials if dissasembled using a workbench..."
	icon_state = "salvage"
	Loot = list(/obj/item/stack/crafting/metalparts/five,
				/obj/item/stack/crafting/electronicparts/three,
				/obj/item/stack/sheet/mineral/titanium,
				/obj/item/stack/sheet/metal/ten,
				/obj/item/stack/sheet/cloth/ten,
				/obj/item/stack/sheet/leather/ten,
				/obj/item/stack/sheet/prewar/five,
				/obj/item/stack/crafting/goodparts/five,
				/obj/item/stack/ore/blackpowder/five
				)


/obj/item/salvage/tool
	name = "Pre-war tool salvage"
	desc = "Some tools meshed together. It could contain working tools or other useful items if dissasembled using a workbench..."
	icon_state = "toolsalvage"
	Loot = list(/obj/item/weldingtool/advanced,
				/obj/item/crowbar/hightech,
				/obj/item/screwdriver/hightech,
				/obj/item/wrench/hightech,
				/obj/item/wirecutters/hightech,
				/obj/item/multitool/advanced)

/obj/item/salvage/high
	name = "Advanced pre-war salvage"
	desc = "Some advanced pre-war salvage, it could contain some useful materials if dissasembled using a workbench..."
	icon_state = "goodsalvage"
	Loot = list(/obj/item/advanced_crafting_components/receiver,
				/obj/item/advanced_crafting_components/assembly,
				/obj/item/advanced_crafting_components/alloys,
				/obj/item/advanced_crafting_components/conductors,
				/obj/item/advanced_crafting_components/lenses,
				/obj/item/advanced_crafting_components/flux,
				/obj/item/blueprint/research)

/obj/item/pa_kit
	name = "servo repair kit"
	desc = "These appear to be used for repairing powerarmor sets..."
	icon = 'icons/obj/assemblies.dmi'
	icon_state = "radio-multitool"

/obj/item/pa_kit/attackby(obj/item/W, mob/user, params)
	. = ..()
	if(istype(W, /obj/item/gun/ballistic/shotgun))
		to_chat(usr, "You can't improve [W.name]...")
		return
	if(istype(W, /obj/item/gun/ballistic))
		to_chat(usr, "You can't improve [W.name]...")
		return
	if(istype(W, /obj/item/gun/energy))
		to_chat(usr, "You can't improve [W.name]...")
		return
	if(istype(W, /obj/item/clothing/suit/armor/heavy/salvaged_pa/))
		parmor(W, user)
		return
	if(istype(W, /obj/item/clothing/head/helmet/f13/heavy/salvaged_pa))
		pahat(W, user)
		return
	if(istype(W, /obj/item/clothing/suit/armor))
		to_chat(usr, "You can't improve [W.name]...")
		return

/obj/item
	var/tinkered = 0
	var/untinkerable = FALSE

/obj/item/pa_kit/proc/parmor(obj/item/W, mob/user)
	var/obj/item/clothing/suit/armor/f13/power_armor/A = W
	//upgrades basic salvaged PA to full PA.
	//You either need 140 combined or 120 and technophreak to repair t45d.
	if (((user.skill_value(SKILL_REPAIR) + user.skill_value(SKILL_SCIENCE)) >= 140) || ((user.skill_value(SKILL_REPAIR) + user.skill_value(SKILL_SCIENCE)) >= 120 && (HAS_TRAIT(user, TRAIT_TECHNOPHREAK))))
		if(istype(A,/obj/item/clothing/suit/armor/heavy/salvaged_pa/t45d))
			new /obj/item/clothing/suit/armor/power_armor/t45d(user.loc)
			qdel(A)
			qdel(src)
			return
	//You either need 160 combined or 140 and technophreak to repair t51b.
	if (((user.skill_value(SKILL_REPAIR) + user.skill_value(SKILL_SCIENCE)) >= 160) || ((user.skill_value(SKILL_REPAIR) + user.skill_value(SKILL_SCIENCE)) >= 140 && (HAS_TRAIT(user, TRAIT_TECHNOPHREAK))))
		if(istype(A,/obj/item/clothing/suit/armor/heavy/salvaged_pa/t51b))
			new /obj/item/clothing/suit/armor/power_armor/t51b(user.loc)
			qdel(A)
			qdel(src)
			return
	to_chat(usr, "You have no idea how you would restore [W.name]...")

/obj/item/pa_kit/proc/pahat(obj/item/W, mob/user)
	var/obj/item/clothing/head/helmet/f13/power_armor/H = W
	//servo kits are not destroyed on repairing helmets
	if (((user.skill_value(SKILL_REPAIR) + user.skill_value(SKILL_SCIENCE)) >= 140) || ((user.skill_value(SKILL_REPAIR) + user.skill_value(SKILL_SCIENCE)) >= 120 && (HAS_TRAIT(user, TRAIT_TECHNOPHREAK))))
		if(istype(H,/obj/item/clothing/head/helmet/f13/heavy/salvaged_pa/t45d))
			new /obj/item/clothing/head/helmet/f13/power_armor/t45d(user.loc)
			qdel(H)
			return
	if (((user.skill_value(SKILL_REPAIR) + user.skill_value(SKILL_SCIENCE)) >= 160) || ((user.skill_value(SKILL_REPAIR) + user.skill_value(SKILL_SCIENCE)) >= 140 && (HAS_TRAIT(user, TRAIT_TECHNOPHREAK))))
		if(istype(H, /obj/item/clothing/head/helmet/f13/heavy/salvaged_pa/t51b))
			new /obj/item/clothing/head/helmet/f13/power_armor/t51b(user.loc)
			qdel(H)
			return
	to_chat(usr, "You have no idea how you would restore [W.name]...")
