/turf/return_screentip(mob/user, params)
	if(flags_1 & NO_SCREENTIPS_1)
		return ""
	if(user.z != src.z)
		return SCREENTIP_OPENSPACE("OPEN SPACE")
	else
		return SCREENTIP_TURF(uppertext(name))

/turf/handle_fall(mob/faller)
	if(faller.mob_has_gravity())
		playsound(src, "modular_septic/sound/effects/collapse[rand(1,5)].wav", 50, TRUE)
	SEND_SIGNAL(src, COMSIG_TURF_MOB_FALL, faller)

/turf/handle_atom_del(atom/deleting_atom)
	. = ..()
	if(deleting_atom.opacity && shadowcasting_overlays)
		update_shadowcasting_overlays()

/turf/air_update_turf(update = FALSE, remove = FALSE)
	. = ..()
	liquid_update_turf()

/turf/proc/update_shadowcasting_overlays()
	// Clean up old list before making a new one
	shadowcasting_overlays = list()

	// Handles almost every edge case there is.
	var/view_range = 11
	var/list/image/new_triangles = list()
	//turfs that are visible and not hidden by byond's internal shadowcasting system
	var/list/shadowcast_visible = list()
	for(var/turf/turf_in_view in oview(view_range))
		shadowcast_visible[turf_in_view] = TRUE
	//turfs that have already had their shadowcasting calculated
	var/list/shadowcast_considered = list()

	//turfs in a favorable order to consider shadowcasting
	var/list/turfs_ordered = list()
	for(var/I as anything in 1 to view_range+1)
		for(var/J as anything in 1 to I)
			turfs_ordered += locate(src.x + I - J, src.y - J, src.z)
			turfs_ordered += locate(src.x - I + J, src.y + J, src.z)
			turfs_ordered += locate(src.x + J, src.y + I - J, src.z)
			turfs_ordered += locate(src.x - J, src.y - I + J, src.z)

	// triangles that are on the same x or same y as us
	var/list/low_triangles = list()

	for(var/turf/ordered_turf in turfs_ordered)
		//ordered turf could be null
		if(!ordered_turf || shadowcast_considered[ordered_turf] || !shadowcast_visible[ordered_turf])
			continue
		var/opaque_turf = ordered_turf.opacity
		if(!opaque_turf)
			for(var/atom/atom_in_contents in ordered_turf)
				if(atom_in_contents.opacity)
					opaque_turf = TRUE
					break
		if(!opaque_turf)
			continue
		var/difference_x = (ordered_turf.x - src.x)
		var/difference_y = (ordered_turf.y - src.y)
		var/difference_pixel_x = difference_x*32
		var/difference_pixel_y = difference_y*32
		var/sign_x = (difference_pixel_x >= 0) ? 1 : -1
		var/sign_y = (difference_pixel_y >= 0) ? 1 : -1
		var/same_x = (difference_x == 0)
		var/same_y = (difference_y == 0)
		var/sum_differences = abs(difference_x) + abs(difference_y)
		var/u_dir = (difference_pixel_y >= 0) ? NORTH : SOUTH
		var/r_dir = (difference_pixel_x >= 0) ? EAST : WEST
		var/width = 0
		var/height = 0
		//same_x and same_y at the same time will never happen
		if(same_x || same_y)
			width = 1
			height = 1
			if(same_x)
				var/turf/nearby_turf = get_step(ordered_turf, EAST)
				var/nearby_opacity = nearby_turf?.opacity
				if(nearby_turf && !nearby_opacity)
					for(var/atom/atom_in_contents in nearby_turf)
						if(atom_in_contents.opacity)
							nearby_opacity = TRUE
							break
				while(nearby_turf && nearby_opacity && abs(nearby_turf.x - src.x)<(view_range+1))
					shadowcast_considered[nearby_turf] = TRUE
					width++
					nearby_turf = get_step(nearby_turf, EAST)
					nearby_opacity = nearby_turf?.opacity
					if(nearby_turf && !nearby_opacity)
						for(var/atom/atom_in_contents in nearby_turf)
							if(atom_in_contents.opacity)
								nearby_opacity = TRUE
								break
				nearby_turf = get_step(ordered_turf, WEST)
				nearby_opacity = nearby_turf?.opacity
				if(nearby_turf && !nearby_opacity)
					for(var/atom/atom_in_contents in nearby_turf)
						if(atom_in_contents.opacity)
							nearby_opacity = TRUE
							break
				while(nearby_turf && nearby_opacity && abs(nearby_turf.x - src.x)<(view_range+1))
					shadowcast_considered[nearby_turf] = TRUE
					width++
					difference_pixel_x -= world.icon_size
					nearby_turf = get_step(nearby_turf, EAST)
					nearby_opacity = nearby_turf?.opacity
					if(nearby_turf && !nearby_opacity)
						for(var/atom/atom_in_contents in nearby_turf)
							if(atom_in_contents.opacity)
								nearby_opacity = TRUE
								break
				var/y_dir = (difference_y > 0) ? SOUTH : NORTH
				nearby_turf = get_step(ordered_turf, y_dir)
				nearby_opacity = nearby_turf?.opacity
				if(nearby_turf)
					if(!nearby_opacity)
						for(var/atom/atom_in_contents in nearby_turf)
							if(atom_in_contents.opacity)
								nearby_opacity = TRUE
								break
					if(nearby_opacity)
						continue
				y_dir = (difference_pixel_y > 0) ? NORTH : SOUTH
				nearby_turf = ordered_turf
				while(nearby_turf && abs(nearby_turf.y - src.y))
					shadowcast_considered[nearby_turf] = TRUE
					nearby_turf = get_step(nearby_turf, u_dir)
			else
				var/turf/nearby_turf = get_step(ordered_turf, NORTH)
				var/nearby_opacity = nearby_turf?.opacity
				if(nearby_turf && !nearby_opacity)
					for(var/atom/atom_in_contents in nearby_turf)
						if(atom_in_contents.opacity)
							nearby_opacity = TRUE
							break
				while(nearby_turf && nearby_opacity && abs(nearby_turf.y - src.y)<(view_range+1))
					shadowcast_considered[nearby_turf] = TRUE
					height++
					nearby_turf = get_step(nearby_turf, NORTH)
					nearby_opacity = nearby_turf?.opacity
					if(nearby_turf && !nearby_opacity)
						for(var/atom/atom_in_contents in nearby_turf)
							if(atom_in_contents.opacity)
								nearby_opacity = TRUE
								break
				nearby_turf = get_step(ordered_turf, SOUTH)
				nearby_opacity = nearby_turf?.opacity
				if(nearby_turf && !nearby_opacity)
					for(var/atom/atom_in_contents in nearby_turf)
						if(atom_in_contents.opacity)
							nearby_opacity = TRUE
							break
				while(nearby_turf && nearby_opacity && abs(nearby_turf.y - src.y)<(view_range+1))
					shadowcast_considered[nearby_turf] = TRUE
					height++
					difference_pixel_y -= world.icon_size
					nearby_turf = get_step(nearby_turf, SOUTH)
					nearby_opacity = nearby_turf?.opacity
					if(nearby_turf && !nearby_opacity)
						for(var/atom/atom_in_contents in nearby_turf)
							if(atom_in_contents.opacity)
								nearby_opacity = TRUE
								break
				var/x_dir = (difference_x > 0) ? WEST : EAST
				nearby_turf = get_step(ordered_turf, x_dir)
				nearby_opacity = nearby_turf?.opacity
				if(nearby_turf)
					if(!nearby_opacity)
						for(var/atom/atom_in_contents in nearby_turf)
							if(atom_in_contents.opacity)
								nearby_opacity = TRUE
								break
					if(nearby_opacity)
						continue
				x_dir = difference_pixel_x > 0 ? EAST : WEST
				nearby_turf = ordered_turf
				while(nearby_turf && abs(nearby_turf.x - src.x))
					shadowcast_considered[nearby_turf] = TRUE
					nearby_turf = get_step(nearby_turf, x_dir)
		else
			var/turf/nearby_turf = ordered_turf
			var/nearby_opacity = nearby_turf?.opacity
			while(nearby_turf && nearby_opacity && abs(nearby_turf.x - src.x)<(view_range+1))
				shadowcast_considered[nearby_turf] = TRUE
				width++
				nearby_turf = get_step(nearby_turf, r_dir)
				if(nearby_turf && !nearby_opacity)
					for(var/atom/atom_in_contents in nearby_turf)
						if(atom_in_contents.opacity)
							nearby_opacity = TRUE
							break
			nearby_turf = ordered_turf
			while(nearby_turf && nearby_opacity && abs(nearby_turf.y - src.y)<(view_range+1))
				shadowcast_considered[nearby_turf] = TRUE
				height++
				nearby_turf = get_step(nearby_turf, u_dir)
				if(nearby_turf && !nearby_opacity)
					for(var/atom/atom_in_contents in nearby_turf)
						if(atom_in_contents.opacity)
							nearby_opacity = TRUE
							break

		var/top = difference_pixel_y-(sign_y*world.icon_size/2)+(sign_y*world.icon_size*height)
		var/bottom = difference_pixel_y-(sign_y*world.icon_size/2)
		var/left = difference_pixel_x-(sign_x*world.icon_size/2)
		var/right = difference_pixel_x-(sign_x*world.icon_size/2)+(sign_x*world.icon_size*width)

		var/fac = world.icon_size/sum_differences
		if(same_y)
			low_triangles += new /datum/triangle(left, top, left, bottom, left*fac, bottom*fac)
			low_triangles += new /datum/triangle(left*fac,top*fac,left,top,left*fac,bottom*fac)
		else if(same_x)
			low_triangles += new /datum/triangle(right, bottom, left, bottom, left*fac, bottom*fac)
			low_triangles += new /datum/triangle(left*fac,bottom*fac,right,bottom,right*fac,bottom*fac)
		else
			new_triangles += make_triangle_image(right,top,left,top,left*fac,top*fac)
			new_triangles += make_triangle_image(right,top,right,bottom,right*fac,bottom*fac)
			new_triangles += make_triangle_image(left*fac,top*fac,right,top,right*fac,bottom*fac)

	for(var/datum/triangle/triangle_datum as anything in low_triangles)
		new_triangles += make_triangle_image(triangle_datum.x1,triangle_datum.y1,triangle_datum.x2,triangle_datum.y2,triangle_datum.x3,triangle_datum.y3)
		//we no longer need this triangle datum, clean it up
		qdel(triangle_datum)

	shadowcasting_overlays = new_triangles
