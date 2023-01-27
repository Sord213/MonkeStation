/proc/twitch_request_handler(input)
	var/list/string_list = splittext(input, ":")
	switch(string_list[2])
		if("TESTING")
			message_admins("TWITCH TESTING INPUT TRIGGERED")
		else
			return

