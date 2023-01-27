/proc/twitch_request_handler(input)
	var/list/string_list = splittext(input, ":")
	switch(string_list[2])
		if("WHISPER")
			handle_whisper(string_list)

///whispering is for debugging and shouldn't actually be used in a live environment
/proc/handle_whisper(list/given_list)
	message_admins("[given_list[3]] was whispered by [given_list[4]]: [given_list[5]]")
