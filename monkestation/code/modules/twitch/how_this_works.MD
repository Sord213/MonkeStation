This uses a twitch bot that sends whatever scopes its looking on to the servers ip. The server than takes it and converts it to readable stuff and than runs whatever.

IE if set to handle donations on the bots side it will send a packet something like

[config_key]_TWITCH_INPUT:[source]:[from_this_user]:[optional]

than it gets converted to a list input and checked against a switch statement ie

if(SUB)
	message_world(string_list[3] just subscribed on twitch!)
