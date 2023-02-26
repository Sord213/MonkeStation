/datum/particle_weather/ash_storm
	name = "Ash Storm"
	desc = "Can't be good for the eyes."
	particle_effectType = /particles/weather/ash

	scale_vol_with_severity = TRUE
	weather_sounds = list(/datum/looping_sound/active_outside_ashstorm)
	weather_messages = list("The whipping sand stings your eyes!")

	min_severity = 1
	max_severity = 50
	max_severityChange = 10
	severitySteps = 20
	immunity_type = TRAIT_ASHSTORM_IMMUNE
	probability = 1
	target_trait = PARTICLEWEATHER_ASH

/datum/particle_weather/ash_storm/start(var/weather_level)
	. = ..()
	var/used_source
	switch(weather_level)
		if("Default")
			used_source = WEATHER_RENDER_TARGET
		if("Mining")
			used_source = WEATHER_MINING_RENDER_TARGET
		if("ADMIN")
			used_source = WEATHER_ADMIN_RENDER_TARGET
		if("Planet")
			used_source = WEATHER_PLANETOID_RENDER_TARGET

	uses_filter = TRUE
	var/obj/holder = SSParticleWeather.return_particle_emitter(weather_level)
	if(holder)
		holder.add_filter("outline", 1, list(type = "outline", size = 3,  color = "#726967"))
		holder.add_filter("bloom", 2 , list(type = "bloom", threshold = rgb(48, 30, 48), size = 10, offset = 4, alpha = 180))
		holder.filters += filter(type="alpha", render_source=used_source)
/datum/particle_weather/ash_storm/weather_act(mob/living/L)
	. = .. ()
	L.adjustFireLoss(4)
