/datum/particle_weather/rain_storm
	name = "Rain Storm"
	desc = "A heavy storm"
	particleEffectType = /particles/weather/rain

	scale_vol_with_severity = TRUE
	weather_sounds = list(/datum/looping_sound/storm)
	weather_messages = list("The rain cools your skin.", "The storm is really picking up!")

	min_severity = 4
	max_severity = 100
	max_severityChange = 50
	severitySteps = 50
	immunity_type = TRAIT_RAINSTORM_IMMUNE
	probability = 1
	target_trait = PARTICLEWEATHER_RAIN

//Makes you a bit chilly
/datum/particle_weather/rain_storm/weather_act(mob/living/L)
	L.adjust_bodytemperature(-rand(3,5))
