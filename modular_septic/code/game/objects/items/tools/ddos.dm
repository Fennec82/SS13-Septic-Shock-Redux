/obj/item/ddos
	name = "denial of service device"
	desc = "A compact, hastily thrown together circuitboard used to hack into a myriad of electronics.\n\
			A note on the back reads: \
			\"" + span_green("D") + span_yellow("D") + span_green("o") + span_white("S") + " " + \
			span_yellow("N") + span_white("I") + span_yellow("G") + span_white("G") + span_yellow("A") + \ span_green("S") + \
			"\"."
	icon = 'icons/obj/items/2pacalypse.dmi'
	icon_state = "crowbar"
	lefthand_file = 'modular_septic/icons/obj/items/inhands/2pacalypse_lefthand.dmi'
	righthand_file = 'modular_septic/icons/obj/items/inhands/2pacalypse_righthand.dmi'

/obj/item/ddos/examine_more(mob/user)
	var/botnets = rand(1, 100)
	return list(span_big(span_alert("[botnets] BOTNET[botnets == 1 ? "" : "S"] ONLINE")))
