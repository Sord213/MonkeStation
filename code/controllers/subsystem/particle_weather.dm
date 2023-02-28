SUBSYSTEM_DEF(ParticleWeather)
	name = "Particle Weather"
	flags = SS_BACKGROUND
	wait = 1 SECONDS
	runlevels = RUNLEVEL_GAME
	var/list/elligble_weather = list()
	var/list/elligble_weather_mining = list()
	var/list/elligble_weather_planet = list()

	var/datum/particle_weather/running_weather
	var/datum/particle_weather/running_weather_mining
	var/datum/particle_weather/running_weather_admin
	var/datum/particle_weather/running_weather_planet
	// var/list/next_hit = list() //Used by barometers to know when the next storm is coming

	var/particles/weather/particle_effect
	var/particles/weather/particle_effect_mining
	var/particles/weather/particle_effect_admin
	var/particles/weather/particle_effect_planet //this is a holder for when planet generation is added to supercruise

	var/obj/weather_effect
	var/obj/weather_effect_mining
	var/obj/weather_effect_admin
	var/obj/weather_effect_planet

/datum/controller/subsystem/ParticleWeather/fire()
	// process active weather
	if(running_weather)
		if(running_weather.running)
			running_weather.tick()
			for(var/mob/act_on as anything in GLOB.mob_living_list)
				running_weather.try_weather_act(act_on)
	else
		if(!SSmapping.config.planetary)
			// start random weather
			var/datum/particle_weather/our_event = pickweight(elligble_weather) //possible_weather
			if(our_event)
				run_weather(our_event)
			var/datum/particle_weather/our_event_mining = pickweight(elligble_weather_mining)
			if(our_event_mining)
				run_weather(our_event_mining, type = "Mining")
		else
			var/datum/particle_weather/our_event = pickweight(elligble_weather)
			var/rand_time = rand(0, 6000) + initial(our_event.weather_duration_upper)
			var/random_length = rand(initial(our_event.weather_duration_lower), initial(our_event.weather_duration_upper))
			if(our_event)
				run_weather(our_event, type = "Default", randTime = rand_time, length = random_length)
				run_weather(our_event, type = "Mining", randTime = rand_time, length = random_length)

//This has been mangled - currently only supports 1 weather effect serverwide so I can finish this
/datum/controller/subsystem/ParticleWeather/Initialize(start_timeofday)
	for(var/V in subtypesof(/datum/particle_weather))
		var/datum/particle_weather/W = V
		var/probability = initial(W.probability)
		var/target_trait = initial(W.target_trait)

		if(!SSmapping.config.planetary)
			// any weather with a probability set may occur at random
			if (probability && SSmapping.config.particle_weather[target_trait]) //this handles all stations should probably find a way to use something like this for all z-levels
				LAZYINITLIST(elligble_weather)
				elligble_weather[W] = probability

			for (var/z in SSmapping.levels_by_trait(ZTRAIT_MINING))
				if(SSmapping.level_has_all_traits(z, ZTRAITS_LAVALAND))
					if(!elligble_weather_mining)
						LAZYINITLIST(elligble_weather_mining)
					for(var/weather_type in LAVALAND_WEATHERS)
						var/datum/particle_weather/used_weather = weather_type
						elligble_weather_mining[used_weather] = initial(used_weather.probability)
		else
			if(probability && SSmapping.config.particle_weather[target_trait])
				LAZYINITLIST(elligble_weather)
				elligble_weather[W] = probability
				LAZYINITLIST(elligble_weather_mining)
				elligble_weather_mining[W] = probability

	return ..()

/datum/controller/subsystem/ParticleWeather/proc/run_weather(datum/particle_weather/weather_datum_type, force = 0, type, randTime, length = 0)
	var/datum/particle_weather/weather_setter

	switch(type)
		if("Default")
			if(running_weather)
				if(force)
					running_weather.end()
				else
					return
		if("Mining")
			if(running_weather_mining)
				if(force)
					running_weather_mining.end()
				else
					return
		if("Planet")
			if(running_weather_mining)
				if(force)
					running_weather_planet.end()
				else
					return

		if("Admin")
			if(running_weather_admin)
				if(force)
					running_weather_admin.end()
				else
					return

	if (istext(weather_datum_type))
		for (var/V in subtypesof(/datum/particle_weather))
			var/datum/particle_weather/W = V
			if (initial(W.name) == weather_datum_type)
				weather_datum_type = V
				break
	if (!ispath(weather_datum_type, /datum/particle_weather))
		CRASH("run_weather called with invalid weather_datum_type: [weather_datum_type || "null"]")

	weather_setter = new weather_datum_type()

	if(force)
		weather_setter.start(type)
	else
		if(!randTime)
			randTime = rand(0, 6000) + initial(weather_setter.weather_duration_upper)
		addtimer(CALLBACK(weather_setter, /datum/particle_weather/proc/start, type, length), randTime, TIMER_UNIQUE|TIMER_STOPPABLE) //Around 0-10 minutes between weathers

	switch(type)
		if("Default")
			running_weather = weather_setter
		if("Mining")
			running_weather_mining = weather_setter
		if("Planet")
			running_weather_planet = weather_setter
		if("Admin")
			running_weather_admin = weather_setter

/datum/controller/subsystem/ParticleWeather/proc/make_eligible(possible_weather)
	elligble_weather = possible_weather
// 	next_hit = null

/datum/controller/subsystem/ParticleWeather/proc/getweatherEffect()
	var/list/effects_to_return = list()
	if(!weather_effect)
		weather_effect = new /obj()
		weather_effect.particles = particle_effect
		weather_effect.filters += filter(type="alpha", render_source=WEATHER_RENDER_TARGET)
		weather_effect.mouse_opacity = MOUSE_OPACITY_TRANSPARENT
	effects_to_return |= weather_effect
	if(!weather_effect_admin)
		weather_effect_admin = new /obj()
		weather_effect_admin.particles = particle_effect_admin
		weather_effect_admin.filters += filter(type="alpha", render_source=WEATHER_ADMIN_RENDER_TARGET)
		weather_effect_admin.mouse_opacity = MOUSE_OPACITY_TRANSPARENT
	effects_to_return |= weather_effect_admin
	if(!weather_effect_mining)
		weather_effect_mining = new /obj()
		weather_effect_mining.particles = particle_effect_mining
		weather_effect_mining.filters += filter(type="alpha", render_source=WEATHER_MINING_RENDER_TARGET)
		weather_effect_mining.mouse_opacity = MOUSE_OPACITY_TRANSPARENT
	effects_to_return |= weather_effect_mining
	if(!weather_effect_planet)
		weather_effect_planet = new /obj()
		weather_effect_planet.particles = particle_effect_planet
		weather_effect_planet.filters += filter(type="alpha", render_source=WEATHER_PLANETOID_RENDER_TARGET)
		weather_effect_planet.mouse_opacity = MOUSE_OPACITY_TRANSPARENT
	effects_to_return |= weather_effect_planet
	return effects_to_return
/datum/controller/subsystem/ParticleWeather/proc/Setparticle_effect(particles/P, var/weather_level = "Default")
	switch(weather_level)
		if("Default")
			particle_effect = P
			weather_effect.particles = particle_effect
		if("Mining")
			particle_effect_mining = P
			weather_effect_mining.particles = particle_effect_mining
		if("Admin")
			particle_effect_admin = P
			weather_effect_admin.particles = particle_effect_admin
		if("Planet")
			particle_effect_planet = P
			weather_effect_planet.particles = particle_effect_planet

/datum/controller/subsystem/ParticleWeather/proc/stopWeather(var/weather_type)
	switch(weather_type)
		if("Default")
			QDEL_NULL(running_weather)
			QDEL_NULL(particle_effect)
		if("Mining")
			QDEL_NULL(running_weather_mining)
			QDEL_NULL(particle_effect_mining)
		if("Admin")
			QDEL_NULL(running_weather_admin)
			QDEL_NULL(particle_effect_admin)
		if("Planet")
			QDEL_NULL(running_weather_planet)
			QDEL_NULL(particle_effect_planet)

/datum/controller/subsystem/ParticleWeather/proc/return_particle_emitter(var/weather_type)
	switch(weather_type)
		if("Default")
			return weather_effect
		if("Mining")
			return weather_effect_mining
		if("Admin")
			return weather_effect_admin
		if("Planet")
			return weather_effect_planet
