/datum/wires/smoke_machine
	holder_type = /obj/machinery/smoke_machine
	proper_name = "smoke_machine"
	req_knowledge = JOB_SKILL_EXPERT

/datum/wires/smoke_machine/New(atom/holder)
	wires = list(
		WIRE_ACTIVATE
	)
	add_duds(1)
	..()

/datum/wires/smoke_machine/interactable(mob/user)
	var/obj/machinery/smoke_machine/A = holder
	if(A.panel_open)
		return TRUE

/datum/wires/smoke_machine/get_status()
	var/obj/machinery/smoke_machine/A = holder
	var/list/status = list()
	status += "The red light is [A.on ? "on" : "off"]."
	return status

/datum/wires/smoke_machine/on_pulse(wire)
	var/obj/machinery/smoke_machine/A = holder
	switch(wire)
		if(WIRE_ACTIVATE)
			A.on = !A.on

/datum/wires/smoke_machine/on_cut(wire, mend)
	var/obj/machinery/smoke_machine/A = holder
	switch(wire)
		if(WIRE_ACTIVATE)
			A.on = FALSE

