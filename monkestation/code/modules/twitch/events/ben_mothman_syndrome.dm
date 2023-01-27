/proc/trigger_short_effect()
	var/static/icon/cut_torso_mask = icon('monkestation/icons/effects/displacement_maps.dmi',"Cut1")
	var/static/icon/cut_legs_mask = icon('monkestation/icons/effects/displacement_maps.dmi',"Cut2")
	for(var/mob/player in GLOB.player_list)
		if(ishuman(player) || isobserver(player))
			player.add_filter("Cut_Torso", 1, displacement_map_filter(cut_torso_mask, x = 0, y = 0, size = 4))
			player.add_filter("Cut_Legs", 1, displacement_map_filter(cut_legs_mask, x = 0, y = 0, size = 4))

	return "Ben Mothman Syndrome"
