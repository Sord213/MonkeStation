/datum/particle_weather/snow_gentle
	name = "Light Snow"
	desc = "Gives off a holiday feel."
	particle_effectType = /particles/weather/snow

	scale_vol_with_severity = TRUE
	weather_sounds = list(/datum/looping_sound/snow)
	weather_messages = list("It's snowing!","You feel a chill/")

	min_severity = 1
	max_severity = 10
	max_severityChange = 5
	severitySteps = 5
	immunity_type = TRAIT_SNOWSTORM_IMMUNE
	probability = 1
	target_trait = PARTICLEWEATHER_SNOW

//Makes you a little chilly
/datum/particle_weather/snow_gentle/weather_act(mob/living/L)
	L.adjust_bodytemperature(-rand(1,3))
