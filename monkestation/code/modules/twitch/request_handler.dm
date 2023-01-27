/proc/twitch_request_handler(input)
	var/list/string_list = splittext(input, ":")
	switch(string_list[2])
		if("SUB_NORMAL")
			handle_non_gift(string_list)
		if("SUB_GIFT")
			handle_gift_sub(string_list)
		if("BIT_RECIEVED")
			handle_bit_donation(string_list)

/proc/handle_non_gift(list/data)
	message_admins("[data[3]] just subscribed, they have been subscribed for [data[4]] months!")
	return

/proc/handle_gift_sub(list/data)
	if(data[4] == "Anonymous")
		message_admins("[data[3]] was just gifted a sub anonymously!")
	else
		message_admins("[data[3]] was just gifted a sub by [data[4]]")
	return

/proc/handle_bit_donation(list/data)
	var/amount_donated = text2num(data[4])
	var/triggered_effect
	switch(amount_donated)
		if(100 to 1000) //small effect
			triggered_effect = small_effect()
		if(1001 to 2500)//medium effect
			triggered_effect = medium_effect()
		if(2501 to INFINITY)//large effects
			triggered_effect = large_effect()
	if(data[3] == "Anonymous")
		message_admins("Someone just donated [data[4]] bits anonymously, triggering [triggered_effect]!")
	else
		message_admins("[data[3]] just donated [data[4]] bits, they have donated [data[5]] bits in total, triggering [triggered_effect].")
	return

/proc/small_effect()
	var/returning_text
	switch(rand(1, 1)) /// change the last number to the amount of effects
		/*
		if(1)
			returning_text = trigger_macho_effect()
		*/
		if(1)
			returning_text = trigger_short_effect()
	return returning_text

/proc/medium_effect()

/proc/large_effect()
