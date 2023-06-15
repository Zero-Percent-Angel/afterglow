// Only green GWTB-like outfit for now. Hopefully could be expaned further later.
/obj/effect/spawner/lootdrop/f13/gasmask_goner
	name = "full gas mask working chance"
	loot = list(
		/obj/item/clothing/mask/gas/goner/aesthetic = 8,
		/obj/item/clothing/mask/gas/goner = 2
	)

/obj/effect/spawner/lootdrop/f13/armor/tier1/Initialize(mapload)
	var/list/loot_extra = list(
		/obj/effect/spawner/lootdrop/f13/gasmask_goner
	)
	LAZYADD(loot, loot_extra)
	. = ..()
