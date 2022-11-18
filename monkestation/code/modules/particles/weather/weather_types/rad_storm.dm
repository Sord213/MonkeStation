/datum/particle_weather/radiation_storm
	name = "Radiation Storm"
	desc = "I don't feel so good."
	particleEffectType = /particles/weather/rads

	scale_vol_with_severity = TRUE
	weather_sounds = list(/datum/looping_sound/rad_storm)
	weather_messages = list("Your skin feels tingly", "Your face is melting")

	minSeverity = 1
	maxSeverity = 100
	maxSeverityChange = 0
	severitySteps = 50
	immunity_type = TRAIT_RADSTORM_IMMUNE
	probability = 1
	target_trait = PARTICLEWEATHER_RADS
