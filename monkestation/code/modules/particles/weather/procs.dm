/client/proc/run_particle_weather()
	set category = "Admin.Events"
	set name = "Run Particle Weather"
	set desc = "Triggers a particle weather"

	if(!holder)
		return

	var/weather_type = input("Choose a weather", "Weather")  as null|anything in sort_list(subtypesof(/datum/particle_weather), /proc/cmp_typepaths_asc)
	if(!weather_type)
		return
	var/list/types = list("Default", "Mining", "Admin", "Planet")
	var/weather_area = input("Choose the level the weather will play on", "Weather") as null|anything in types
	if(!weather_area)
		return
	SSparticle_weather.run_weather(weather_type, TRUE, weather_area)

	message_admins("[key_name_admin(usr)] started weather of type [weather_type].")
	log_admin("[key_name(usr)] started weather of type [weather_type].")
	SSblackbox.record_feedback("tally", "admin_verb", 1, "Run Particle Weather")

/client/proc/force_aurora()
	set category = "Admin.Events"
	set name = "Force Aurora "
	set desc = "Forces Aurora effect"

	if(!holder)
		return

	for (var/atom/movable/screen/fullscreen/lighting_backdrop/Sunlight/SP in SSoutdoor_effects.sunlighting_planes)
		SSoutdoor_effects.force_aurora(SP)
