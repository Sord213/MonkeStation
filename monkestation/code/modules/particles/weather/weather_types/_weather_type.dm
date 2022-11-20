/**
 * Shitty particle weather by Gomble
 * Causes weather to occur on a z level in certain area types
 *
 * The effects of weather occur across an entire z-level. For instance, lavaland has periodic ash storms that scorch most unprotected creatures.
 * Weather always occurs on different z levels at different times, regardless of weather type.
 * Can have custom durations, targets, and can automatically protect indoor areas.
 *
 */


/datum/particle_weather

	// ==== Modify these ====

	/// name of weather
	var/name = "space wind"
	/// description of weather
	var/desc = "Heavy gusts of wind blanket the area, periodically knocking down anyone caught in the open."

	//messages to send at different severities
	var/list/weather_messages = list()

	// Sounds to play at different severities - order from lowest to highest
	var/list/weather_sounds = list()

	//Scale volume with severity - good for if you only have 1 sound
	var/scale_vol_with_severity = FALSE

	//Our particle effect to display - min/max severity effects its wind and count
	var/particles/weather/particle_effectType = /particles/weather/rain


	/// See above - this is the lowest possible duration
	var/weather_duration_lower = 1 MINUTES
	/// See above - this is the highest possible duration
	var/weather_duration_upper = 3 MINUTES

	// Keep this between 1 and 100
	// Gentle rain shouldn't use the max rain wind speed, nor should a storm be a gentle breeze
	var/min_severity = 1
	var/max_severity = 100
	//We will increase or decrease our severity by a random amount up to this value
	//If 0, we will pick a random value between min and max
	var/max_severityChange = 20
	//The number of times we will change our severity over the duration
	var/severitySteps = 5
	/// Used by mobs to prevent them from being affected by the weather
	var/immunity_type = TRAIT_WEATHER_IMMUNE
	/// Weight amongst other eligible weather. If zero, will never happen randomly.
	var/probability = 0

	/// The map weather type to target
	var/target_trait = PARTICLEWEATHER_RAIN

	// ==== Dont modify these ====

	//Times we have stepped severity
	var/severityStepsTaken = 0

	var/running = FALSE

	//Current severity - used for scaling effects, particle appearance, etc.
	var/severity = 0

	/// Whether a barometer can predict when the weather will happen
	var/barometer_predictable = FALSE
	/// For barometers to know when the next storm will hit
	var/next_hit_time = 0

	/// In deciseconds, how long the weather lasts once it begins
	var/weather_duration = 0

	//assoc list of mob=looping_sound
	var/list/currentSounds = list()

	//assoc list of mob=timestamp -> Next time we can send a message
	var/list/messagedMobs = list()

	var/last_message = ""

	var/weather_area

/datum/particle_weather/proc/severityMod()
	return severity / max_severity
/*
* arbitrary effects to run every time the particle_weather SS ticks
* for storms this might be a random chance for lightning, etc.
*/
/datum/particle_weather/proc/tick()
	return

/datum/particle_weather/Destroy()
	for(var/S in currentSounds)
		var/datum/looping_sound/looping_sound = currentSounds[S]
		looping_sound.stop()
		qdel(looping_sound)
	return ..()

/**
 * Starts the actual weather and effects from it
 *
 * Updates area overlays and sends sounds and messages to mobs to notify them
 * Begins dealing effects from weather to mobs in the area
 *
 */
/datum/particle_weather/proc/start(var/weather_level = "Default")
	if(running)
		return //some cheeky git has started you early
	weather_duration = rand(weather_duration_lower, weather_duration_upper)
	running = TRUE
	addtimer(CALLBACK(src, .proc/wind_down), weather_duration)

	weather_area = weather_level
	if(particle_effectType)
		SSParticleWeather.Setparticle_effect(new particle_effectType, weather_level);

	//Always step severity to start
	change_severity()


/datum/particle_weather/proc/change_severity()
	if(!running)
		return
	severityStepsTaken++

	if(max_severityChange == 0)
		severity = rand(min_severity, max_severity)
	else
		var/newSeverity = severity + rand(-max_severityChange,max_severityChange)
		newSeverity = min(max(newSeverity,min_severity), max_severity)
		severity = newSeverity

	switch(weather_area)
		if("Default")
			if(SSParticleWeather.particle_effect)
				SSParticleWeather.particle_effect.animate_severity(severityMod())
		if("Admin")
			if(SSParticleWeather.particle_effect_admin)
				SSParticleWeather.particle_effect_admin.animate_severity(severityMod())
		if("Mining")
			if(SSParticleWeather.particle_effect_mining)
				SSParticleWeather.particle_effect_mining.animate_severity(severityMod())
		if("Planet")
			if(SSParticleWeather.particle_effect_planet)
				SSParticleWeather.particle_effect_planet.animate_severity(severityMod())
	//Send new severity message if the message has changed
	if(last_message != scale_range_pick(min_severity, max_severity, severity, weather_messages))
		messagedMobs = list()

	//Tick on
	if(severityStepsTaken < severitySteps)
		addtimer(CALLBACK(src, .proc/change_severity), weather_duration / severitySteps)


/**
 * Weather enters the winding down phase, stops effects
 *
 * Updates areas to be in the winding down phase
 * Sends sounds and messages to mobs to notify them
 *
 */
/datum/particle_weather/proc/wind_down()
	severity = 0
	if(SSParticleWeather.particle_effect)
		SSParticleWeather.particle_effect.animate_severity(severityMod())

		//Wait for the last particle to fade, then qdel yourself
		addtimer(CALLBACK(src, .proc/end), SSParticleWeather.particle_effect.lifespan + SSParticleWeather.particle_effect.fade)



/**
 * Fully ends the weather
 *
 * Effects no longer occur and particles are wound down
 * Removes weather from processing completely
 *
 */
/datum/particle_weather/proc/end()
	running = FALSE
	SSParticleWeather.stopWeather(weather_area)


/**
 * Returns TRUE if the living mob can hear the weather (you might be immune, but you get to listen to the pitter patter)
 */
/datum/particle_weather/proc/can_weather(mob/living/mob_to_check)
	var/turf/mob_turf = get_turf(mob_to_check)

	if(!mob_turf)
		return

	if(!mob_turf.outdoor_effect || mob_turf.outdoor_effect.weatherproof)
		return

	return TRUE

/**
 * Returns TRUE if the living mob can be affected by the weather
 */
/datum/particle_weather/proc/can_weather_effect(mob/living/mob_to_check)

	//If mob is not in a turf
	var/turf/mob_turf = get_turf(mob_to_check)
	var/atom/loc_to_check = mob_to_check.loc
	while(loc_to_check != mob_turf)
		if((immunity_type && HAS_TRAIT(loc_to_check, immunity_type)) || HAS_TRAIT(loc_to_check, TRAIT_WEATHER_IMMUNE))
			return
		loc_to_check = loc_to_check.loc

	return TRUE

/**
 * Try to do weather effects - if we can hear sound, play it
 * If we are affected by weather (i.e damage), do effect and send severity message
 */
/datum/particle_weather/proc/try_weather_act(mob/living/L)
	if(can_weather(L))
		weather_sound_effect(L)
		if(can_weather_effect(L))
			weather_act(L)
			if(!messagedMobs[L] || world.time > messagedMobs[L])
				weather_message(L) //Try not to spam
	else
		stop_weather_sound_effect(L)
		messagedMobs[L] = 0 //resend a message next time they go outside

//Overload with weather effects
/datum/particle_weather/proc/weather_act(mob/living/L)
	return

//Not using looping_sounds properly. somebody smart should fix this
/datum/particle_weather/proc/weather_sound_effect(mob/living/L)
	var/datum/looping_sound/currentSound = currentSounds[L]
	if(currentSound)
		//SET VOLUME
		if(scale_vol_with_severity)
			currentSound.volume = initial(currentSound.volume) * severityMod()
		if(!currentSound.loop_started) //don't restart already playing sounds
			currentSound.start()
		return
	var/tempSound = scale_range_pick(min_severity, max_severity, severity, weather_sounds)
	if(tempSound)
		currentSound = new tempSound(L, FALSE, TRUE, FALSE, CHANNEL_WEATHER)
		currentSounds[L] = currentSound
		//SET VOLUME
		if(scale_vol_with_severity)
			currentSound.volume = initial(currentSound.volume) * severityMod()
		currentSound.start()

/datum/particle_weather/proc/stop_weather_sound_effect(mob/living/L)
	var/datum/looping_sound/currentSound = currentSounds[L]
	if(currentSound)
		currentSound.stop()


/datum/particle_weather/proc/weather_message(mob/living/L)
	messagedMobs[L] = world.time + 30 SECONDS //Chunky delay - this spams otherwise - Severity changes and going indoors resets this timer
	last_message = scale_range_pick(min_severity, max_severity, severity, weather_messages)
	if(last_message)
		to_chat(L, last_message)
