/datum/particle_weather/dust_storm
	name = "Rain"
	desc = "Gentle Rain, la la description."
	particleEffectType = /particles/weather/dust

	scale_vol_with_severity = TRUE
	weather_sounds = list(/datum/looping_sound/dust_storm)
	weather_messages = list("The whipping sand stings your eyes!")

	minSeverity = 1
	maxSeverity = 50
	maxSeverityChange = 10
	severitySteps = 20
	immunity_type = TRAIT_DUSTSTORM_IMMUNE
	probability = 1
	target_trait = PARTICLEWEATHER_DUST

//Makes you a little chilly
/datum/particle_weather/dust_storm/weather_act(mob/living/L)
	if ishuman(L)
		var/mob/living/carbon/human/H = L
		var/obj/item/organ/eyes/eyes = H.getorganslot(ORGAN_SLOT_EYES)
		eyes?.applyOrganDamage(severityMod() * rand(1,3) - H.get_eye_protection())


/datum/particle_weather/radiation_storm
	name = "Rain"
	desc = "Gentle Rain, la la description."
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

/*
//STOLEN
/datum/particle_weather/radiation_storm/weather_act(mob/living/L)
	var/resist = L.getarmor(null)
	if(prob(40))
		if(ishuman(L))
			var/mob/living/carbon/human/H = L
			if(H.dna)
				if(prob(max(0,100-resist)))
					H.random_mutate_unique_identity()
					H.random_mutate_unique_features()
					if(prob(50))
						if(prob(90))
							H.easy_random_mutate(NEGATIVE+MINOR_NEGATIVE)
						else
							H.easy_random_mutate(POSITIVE)
						H.domutcheck()
*/

/datum/particle_weather/rain_gentle
	name = "Rain"
	desc = "Gentle Rain, la la description."
	particleEffectType = /particles/weather/rain

	scale_vol_with_severity = TRUE
	weather_sounds = list(/datum/looping_sound/rain)
	weather_messages = list("The rain cools your skin.")

	minSeverity = 1
	maxSeverity = 10
	maxSeverityChange = 5
	severitySteps = 5
	immunity_type = TRAIT_RAINSTORM_IMMUNE
	probability = 1
	target_trait = PARTICLEWEATHER_RAIN

//Makes you a little chilly
/datum/particle_weather/rain_gentle/weather_act(mob/living/L)
	L.adjust_bodytemperature(-rand(1,3))

/datum/particle_weather/rain_storm
	name = "Rain"
	desc = "Gentle Rain, la la description."
	particleEffectType = /particles/weather/rain

	scale_vol_with_severity = TRUE
	weather_sounds = list(/datum/looping_sound/storm)
	weather_messages = list("The rain cools your skin.", "The storm is really picking up!")

	minSeverity = 4
	maxSeverity = 100
	maxSeverityChange = 50
	severitySteps = 50
	immunity_type = TRAIT_RAINSTORM_IMMUNE
	probability = 1
	target_trait = PARTICLEWEATHER_RAIN

//Makes you a bit chilly
/datum/particle_weather/rain_storm/weather_act(mob/living/L)
	L.adjust_bodytemperature(-rand(3,5))

/datum/particle_weather/snow_gentle
	name = "Rain"
	desc = "Gentle Rain, la la description."
	particleEffectType = /particles/weather/snow

	scale_vol_with_severity = TRUE
	weather_sounds = list(/datum/looping_sound/snow)
	weather_messages = list("It's snowing!","You feel a chill/")

	minSeverity = 1
	maxSeverity = 10
	maxSeverityChange = 5
	severitySteps = 5
	immunity_type = TRAIT_SNOWSTORM_IMMUNE
	probability = 1
	target_trait = PARTICLEWEATHER_SNOW

//Makes you a little chilly
/datum/particle_weather/snow_gentle/weather_act(mob/living/L)
	L.adjust_bodytemperature(-rand(1,3))


/datum/particle_weather/snow_storm
	name = "Rain"
	desc = "Gentle Rain, la la description."
	particleEffectType = /particles/weather/snow

	scale_vol_with_severity = TRUE
	weather_sounds = list(/datum/looping_sound/snow)
	weather_messages = list("You feel a chill/", "The cold wind is freezing you to the bone", "How can a man who is warm, understand a man who is cold?")

	minSeverity = 40
	maxSeverity = 100
	maxSeverityChange = 50
	severitySteps = 50
	immunity_type = TRAIT_SNOWSTORM_IMMUNE
	probability = 1
	target_trait = PARTICLEWEATHER_SNOW

//Makes you a lot little chilly
/datum/particle_weather/snow_storm/weather_act(mob/living/L)
	L.adjust_bodytemperature(-rand(5,15))

#define THUNDER_SOUND pick('sound/effects/thunder/thunder1.ogg', 'sound/effects/thunder/thunder2.ogg', 'sound/effects/thunder/thunder3.ogg', 'sound/effects/thunder/thunder4.ogg', \
			'sound/effects/thunder/thunder5.ogg', 'sound/effects/thunder/thunder6.ogg', 'sound/effects/thunder/thunder7.ogg', 'sound/effects/thunder/thunder8.ogg', 'sound/effects/thunder/thunder9.ogg', \
			'sound/effects/thunder/thunder10.ogg')
/datum/particle_weather/thunder_storm
	name = "Thunder Storm"
	desc = "Don't get struck."
	particleEffectType = /particles/weather/rain

	scale_vol_with_severity = TRUE
	weather_sounds = list(/datum/looping_sound/storm)
	weather_messages = list("The rain cools your skin.", "The storm is really picking up!")

	minSeverity = 4
	maxSeverity = 100
	maxSeverityChange = 50
	severitySteps = 50
	immunity_type = TRAIT_RAINSTORM_IMMUNE
	probability = 1
	target_trait = PARTICLEWEATHER_RAIN
	var/thunder_chance = 4
	var/lightning_in_progress = FALSE

//Makes you a bit chilly
/datum/particle_weather/thunder_storm/weather_act(mob/living/L)
	L.adjust_bodytemperature(-rand(3,5))

/datum/particle_weather/thunder_storm/tick(mob/living/L)
	if(prob(thunder_chance))
		do_thunder()

/datum/particle_weather/thunder_storm/proc/do_thunder()
	if(lightning_in_progress)
		return
	lightning_in_progress = TRUE
	addtimer(CALLBACK(src, .proc/end_thunder), 4 SECONDS)
	addtimer(CALLBACK(src, .proc/do_thunder_sound), 1 SECONDS)
	for(var/mob/living/carbon/human/affected_human as anything in GLOB.player_list)
		affected_human.overlay_fullscreen("thunder", /atom/movable/screen/fullscreen/thunder)

/datum/particle_weather/thunder_storm/proc/do_thunder_sound()
	var/picked_sound = THUNDER_SOUND
	for(var/mob/living/player as anything in GLOB.player_list)
		SEND_SOUND(player, sound(picked_sound, volume = (can_weather_effect(player) ? 65 : 35)))


/datum/particle_weather/thunder_storm/proc/end_thunder()
	if(QDELETED(src))
		return
	if(!lightning_in_progress)
		return
	lightning_in_progress = FALSE
	for(var/mob/living/carbon/human/affected_human as anything in GLOB.player_list)
		affected_human.overlay_fullscreen("thunder")


/atom/movable/screen/fullscreen/thunder
	icon_state = "thunder"
	layer = FLOAT_LAYER
	plane = WEATHER_EFFECT_PLANE

/atom/movable/screen/fullscreen/thunder/Initialize(mapload)
	. = ..()
	filters += filter(type="alpha", render_source=WEATHER_RENDER_TARGET)
	animate(src, alpha=0, time = 4 SECONDS)

#undef THUNDER_SOUND
