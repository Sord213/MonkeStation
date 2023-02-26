/datum/buildmode_mode/weather_brush
	key = "weatherbrush"

/datum/buildmode_mode/weather_brush/show_help(client/c)
	to_chat(c, "<span class='notice'>***********************************************************</span>")
	to_chat(c, "<span class='notice'>Left Mouse Button        = Add Weather Area</span")
	to_chat(c, "<span class='notice'>Right Mouse Button       = Remove Weather Area</span>")

/datum/buildmode_mode/weather_brush/handle_click(client/c, params, obj/object)
	var/list/pa = params2list(params)
	var/left_click = pa.Find("left")
	var/right_click = pa.Find("right")

	if(istype(object,/turf) && left_click)
		var/turf/T = object
		var/atom/movable/outdoor_effect/holder = new
		var/mutable_appearance/MA = new /mutable_appearance()
		MA.blend_mode   	  = BLEND_OVERLAY
		MA.icon 			  = 'monkestation/icons/effects/weather_overlay.dmi'
		MA.icon_state 		  = "weather_overlay"
		MA.plane			  = WEATHER_OVERLAY_PLANE_ADMIN /* we put this on a lower level than lighting so we dont multiply anything */
		MA.invisibility 	  = INVISIBILITY_LIGHTING

		holder.overlays += MA
		T.admin_effect = holder
		T.vis_contents += T.admin_effect

		log_admin("Weather Painter Mode: [key_name(c)] added a weather overlay at [AREACOORD(T)]")
		return
	else if(istype(object,/turf) && right_click)
		var/turf/T = object
		if(!T.admin_effect)
			return
		T.vis_contents -= T.admin_effect
		qdel(T.admin_effect)
		log_admin("Weather Painter Mode: [key_name(c)] removed a weather overlay at [AREACOORD(object)]")
