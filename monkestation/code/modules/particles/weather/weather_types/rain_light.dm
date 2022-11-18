/datum/particle_weather/rain_gentle
	name = "Rain"
	desc = "Gentle Rain, la la description."
	particleEffectType = /particles/weather/rain

	scale_vol_with_severity = TRUE
	weather_sounds = list(/datum/looping_sound/rain)
	weather_messages = list("The rain cools your skin.")

	min_severity = 1
	max_severity = 10
	max_severityChange = 5
	severitySteps = 5
	immunity_type = TRAIT_RAINSTORM_IMMUNE
	probability = 1
	target_trait = PARTICLEWEATHER_RAIN

//Makes you a little chilly
/datum/particle_weather/rain_gentle/weather_act(mob/living/L)
	L.adjust_bodytemperature(-rand(1,3))
