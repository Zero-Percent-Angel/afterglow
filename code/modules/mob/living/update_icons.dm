//IMPORTANT: Multiple animate() calls do not stack well, so try to do them all at once if you can.
/mob/living/update_transform()
	var/matrix/ntransform = matrix(transform) //aka transform.Copy()
	var/final_pixel_y = pixel_y
	var/changed = 0

	appearance_flags |= PIXEL_SCALE

	if(lying != lying_prev && rotate_on_lying)
		changed++
		ntransform.TurnTo(lying_prev,lying)
		if(lying == 0) //Lying to standing
			final_pixel_y = get_standard_pixel_y_offset()
		else //if(lying != 0)
			if(lying_prev == 0) //Standing to lying
				pixel_y = get_standard_pixel_y_offset()
				final_pixel_y = get_standard_pixel_y_offset(lying)
				if(dir & (EAST|WEST)) //Facing east or west
					setDir(pick(NORTH, SOUTH)) //So you fall on your side rather than your face or ass

	if(resize != RESIZE_DEFAULT_SIZE || resize_width != RESIZE_DEFAULT_SIZE || resize_height != RESIZE_DEFAULT_SIZE)
		changed++
		ntransform.Scale(resize_width * resize, resize_height * resize)
		if (resize_height != RESIZE_DEFAULT_SIZE)
			ntransform.Translate(0, (16 * (resize_height - 1)) - current_height_transform)
			current_height_transform =  16 * (resize_height - 1)
		resize = RESIZE_DEFAULT_SIZE
		resize_height = RESIZE_DEFAULT_SIZE
		resize_width = RESIZE_DEFAULT_SIZE

	if(changed)
		animate(src, transform = ntransform, time = 2, pixel_y = final_pixel_y, easing = EASE_IN|EASE_OUT)
		floating_need_update = TRUE
