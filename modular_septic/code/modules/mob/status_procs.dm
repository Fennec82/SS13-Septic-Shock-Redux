/mob/update_blindness()
	switch(stat)
		if(CONSCIOUS, SOFT_CRIT)
			if(is_blind())
				do_set_blindness(TRUE)
			else
				do_set_blindness(FALSE)
		if(UNCONSCIOUS, HARD_CRIT)
			do_set_blindness(TRUE)
		if(DEAD)
			do_set_blindness(FALSE)

/mob/do_set_blindness(now_blind)
	if(now_blind)
		overlay_fullscreen("blind", /atom/movable/screen/fullscreen/blind)
	else
		clear_fullscreen("blind")
