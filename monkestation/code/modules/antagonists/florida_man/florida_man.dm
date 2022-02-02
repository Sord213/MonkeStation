/datum/antagonist/florida_man
	name = "Space Florida Man"
	roundend_category = "Florida Men"
	antagpanel_category = "Florida Man"
	silent = TRUE
	give_objectives = FALSE
	show_to_ghosts = TRUE

/datum/antagonist/florida_man/on_gain()
	forge_objectives()
	. = ..()
	for(var/datum/objective/O in objectives)
		log_objective(owner, O.explanation_text)

/datum/antagonist/florida_man/proc/forge_objectives()
	var/datum/objective/meth = new /datum/objective
	var/list/selected_objective = pick(GLOB.florida_man_base_objectives)

	meth.owner = owner
	if(prob(25))
		meth.explanation_text = "[selected_objective[1]] [pick(GLOB.florida_man_objective_nouns)] [selected_objective[2]], [pick(GLOB.florida_man_objective_suffix)]"
	else
		meth.explanation_text = "[selected_objective[1]] [pick(GLOB.florida_man_objective_nouns)] [selected_objective[2]]."
	objectives += meth

/datum/antagonist/florida_man/greet()
	var/mob/floridian = owner.current
	owner.current.playsound_local(get_turf(owner.current), 'monkestation/sound/ambience/antag/floridaman.ogg',100,0, use_reverb = FALSE)
	to_chat(owner, "<span class='boldannounce'>You are THE Florida Man!\nYou're not quite sure how you got out here in space, but you don't generally bother thinking about things.\n\nYou love methamphetamine!\nYou love wrestling lizards!\nYou love getting drunk!\nYou love sticking it to THE MAN!\nYou don't act with any coherent plan or objective.\nYou don't outright want to destroy the station or murder people, as you have no home to return to.\n\nGo forth, son of Space Florida, and sow chaos!</span>")
	owner.announce_objectives()
	floridian.fully_replace_character_name(null, "Florida Man")
