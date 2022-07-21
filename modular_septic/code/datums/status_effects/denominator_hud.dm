/datum/status_effect/denominator_hud
	id = "denom_hud"
	duration = -1
	tick_interval = 2
	alert_type = null

/datum/status_effect/denominator_hud/on_apply()
	. = ..()
	apply_blues()
	RegisterSignal(owner, COMSIG_LIVING_SET_COMBAT_MODE, .proc/check_shotgunner_rage)
	if(HAS_TRAIT(owner, TRAIT_DENOMINATOR_REDSCREEN))
		check_shotgunner_rage()

/datum/status_effect/denominator_hud/on_remove()
	. = ..()
	remove_all()
	UnregisterSignal(owner, COMSIG_LIVING_SET_COMBAT_MODE)

/datum/status_effect/denominator_hud/proc/check_shotgunner_rage(mob/living/source, new_mode, silent = FALSE)
	SIGNAL_HANDLER

	if(owner.combat_mode && owner.client)
		rage_on()
	else
		rage_off()

/datum/status_effect/denominator_hud/proc/apply_reds()
	owner.clear_fullscreen("denominator")
	owner.clear_fullscreen("denominator_blue")
	owner.overlay_fullscreen("denominator_rage", /atom/movable/screen/fullscreen/denominator/red)
	owner.overlay_fullscreen("denominator_red_rage", /atom/movable/screen/fullscreen/color_vision/red/denominator)

/datum/status_effect/denominator_hud/proc/apply_blues()
	owner.clear_fullscreen("denominator_rage")
	owner.clear_fullscreen("denominator_red_rage")
	owner.overlay_fullscreen("denominator", /atom/movable/screen/fullscreen/denominator)
	owner.overlay_fullscreen("denominator_blue", /atom/movable/screen/fullscreen/color_vision/blue/denominator)

/datum/status_effect/denominator_hud/proc/remove_all()
	owner.clear_fullscreen("denominator")
	owner.clear_fullscreen("denominator_blue")
	owner.clear_fullscreen("denominator_rage")
	owner.clear_fullscreen("denominator_red_rage")

/datum/status_effect/denominator_hud/proc/rage_on()
	apply_reds()

/datum/status_effect/denominator_hud/proc/rage_off()
	apply_blues()
