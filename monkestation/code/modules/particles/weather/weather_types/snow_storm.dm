/datum/particle_weather/snow_storm
	name = "Snow Storm"
	desc = "It's blizzarding out here"
	particleEffectType = /particles/weather/snow

	scale_vol_with_severity = TRUE
	weather_sounds = list(/datum/looping_sound/snow)
	weather_messages = list("You feel a chill/", "The cold wind is freezing you to the bone", "How can a man who is warm, understand a man who is cold?")

	min_severity = 40
	max_severity = 100
	max_severityChange = 50
	severitySteps = 50
	immunity_type = TRAIT_SNOWSTORM_IMMUNE
	probability = 1
	target_trait = PARTICLEWEATHER_SNOW

//Makes you a lot little chilly
/datum/particle_weather/snow_storm/weather_act(mob/living/L)
	L.adjust_bodytemperature(-rand(5,15))
