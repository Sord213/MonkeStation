/datum/particle_weather/radiation_storm
	name = "Radiation Storm"
	desc = "I don't feel so good."
	particleEffectType = /particles/weather/rads

	scale_vol_with_severity = TRUE
	weather_sounds = list(/datum/looping_sound/rad_storm)
	weather_messages = list("Your skin feels tingly", "Your face is melting")

	min_severity = 1
	max_severity = 100
	max_severityChange = 0
	severitySteps = 50
	immunity_type = TRAIT_RADSTORM_IMMUNE
	probability = 1
	target_trait = PARTICLEWEATHER_RADS
