/datum/particle_weather/dust_storm
	name = "Dust Storm"
	desc = "Can't be good for the eyes."
	particle_effectType = /particles/weather/dust

	scale_vol_with_severity = TRUE
	weather_sounds = list(/datum/looping_sound/dust_storm)
	weather_messages = list("The whipping sand stings your eyes!")

	min_severity = 1
	max_severity = 50
	max_severityChange = 10
	severitySteps = 20
	immunity_type = TRAIT_DUSTSTORM_IMMUNE
	probability = 1
	target_trait = PARTICLEWEATHER_DUST

//Makes you a little chilly
/datum/particle_weather/dust_storm/weather_act(mob/living/L)
	if(ishuman(L))
		var/mob/living/carbon/human/H = L
		var/obj/item/organ/eyes/eyes = H.getorganslot(ORGAN_SLOT_EYES)
		eyes?.applyOrganDamage(severityMod() * rand(1,3) - H.get_eye_protection())
