/proc/trigger_macho_effect()
	for(var/mob/player in GLOB.player_list)
		if(ishuman(player) || isobserver(player))
			player.add_filter("macho", 1, displacement_map_filter(icon=icon('monkestation/icons/effects/displacement_maps.dmi', "macho"), size=9))
			addtimer(player, CALLBACK(GLOBAL_PROC, .proc/end_macho_effect), 10 MINUTES)
	return "Macho Men"

/proc/end_macho_effect(atom/source)
	source.remove_filter("macho")
