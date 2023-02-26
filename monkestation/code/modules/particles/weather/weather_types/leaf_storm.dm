/datum/particle_weather/leaf_storm
	name = "Leaf Storm"
	desc = "I love fall."
	particle_effectType = /particles/weather/leaf

	scale_vol_with_severity = TRUE
	weather_messages = list("Your smell the autumn winds", "You feel crisp leaves against your skin.")

	min_severity = 1
	max_severity = 100
	max_severityChange = 0
	severitySteps = 50
	probability = 1
	target_trait = PARTICLEWEATHER_LEAF
