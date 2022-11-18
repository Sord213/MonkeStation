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

	min_severity = 4
	max_severity = 100
	max_severityChange = 50
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
