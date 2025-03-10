// Navigation beacon for AI robots
// No longer exists on the radio controller, it is managed by a global list.

/obj/item/navbeacon //Monkstation edit start
	icon = 'icons/obj/objects.dmi'
	icon_state = "navbeacon0"
	name = "navigation beacon"
	desc = "A radio beacon used for bot navigation."
	custom_price = 15
	materials = list(/datum/material/iron=100, /datum/material/glass=50)
	usesound = 'sound/items/deconstruct.ogg'  //Monkstation edit end

/obj/machinery/navbeacon

	icon = 'icons/obj/objects.dmi'
	icon_state = "navbeacon0-f"
	name = "navigation beacon"
	desc = "A radio beacon used for bot navigation."
	level = 1		// underfloor
	layer = UNDER_CATWALK
	max_integrity = 500
	armor = list("melee" = 70, "bullet" = 70, "laser" = 70, "energy" = 70, "bomb" = 0, "bio" = 0, "rad" = 0, "fire" = 80, "acid" = 80, "stamina" = 0)

	var/open = FALSE		// true if cover is open
	var/locked = TRUE		// true if controls are locked
	var/freq = FREQ_NAV_BEACON
	var/location = ""	// location response text
	var/list/codes		// assoc. list of transponder codes
	var/codes_txt = ""	// codes as set on map: "tag1;tag2" or "tag1=value;tag2=value"

	req_one_access = list(ACCESS_ENGINE, ACCESS_ROBOTICS)

/obj/machinery/navbeacon/Initialize()
	. = ..()

	set_codes()

	var/turf/T = loc
	hide(T.intact)
	if(codes["patrol"])
		if(!GLOB.navbeacons["[z]"])
			GLOB.navbeacons["[z]"] = list()
		GLOB.navbeacons["[z]"] += src //Register with the patrol list!
	if(codes["delivery"])
		GLOB.deliverybeacons += src
		GLOB.deliverybeacontags += location

/obj/machinery/navbeacon/Destroy()
	if (GLOB.navbeacons["[z]"])
		GLOB.navbeacons["[z]"] -= src //Remove from beacon list, if in one.
	GLOB.deliverybeacons -= src
	return ..()

/obj/machinery/navbeacon/onTransitZ(old_z, new_z)
	if (GLOB.navbeacons["[old_z]"])
		GLOB.navbeacons["[old_z]"] -= src
	if (GLOB.navbeacons["[new_z]"])
		GLOB.navbeacons["[new_z]"] += src
	..()


// set the transponder codes assoc list from codes_txt
/obj/machinery/navbeacon/proc/set_codes()

	codes = new() //Monkestation edit start

	if(!codes_txt)
		return //Monkstation edit end

	var/list/entries = splittext(codes_txt, ";")	// entries are separated by semicolons

	for(var/e in entries)
		var/index = findtext(e, "=")		// format is "key=value"
		if(index)
			var/key = copytext(e, 1, index)
			var/val = copytext(e, index + length(e[index]))
			codes[key] = val
		else
			codes[e] = "1"


// called when turf state changes
// hide the object if turf is intact
/obj/machinery/navbeacon/hide(intact)
	invisibility = intact ? INVISIBILITY_MAXIMUM : 0
	update_icon()

// update the icon_state
/obj/machinery/navbeacon/update_icon()
	var/state="navbeacon[open]"

	if(invisibility)
		icon_state = "[state]-f"	// if invisible, set icon to faded version
									// in case revealed by T-scanner
	else
		icon_state = "[state]"

/obj/machinery/navbeacon/attackby(obj/item/I, mob/user, params)
	var/turf/T = loc
	if(T.intact)
		return		// prevent intraction when T-scanner revealed

	if(I.tool_behaviour == TOOL_SCREWDRIVER)
		open = !open

		user.visible_message("[user] [open ? "opens" : "closes"] the beacon's cover.", "<span class='notice'>You [open ? "open" : "close"] the beacon's cover.</span>")

		update_icon()

	else if(I.tool_behaviour == TOOL_WRENCH) //Monkstation edit start
		to_chat(user, "<span class='notice'>You detach \the [src] from the floor.</span>")
		I.play_tool_sound(src)
		new /obj/item/navbeacon( T )
		qdel(src) //Monkstation edit end

	else if (istype(I, /obj/item/card/id)||istype(I, /obj/item/pda))
		if(open)
			if (src.allowed(user))
				src.locked = !src.locked
				to_chat(user, "<span class='notice'>Controls are now [src.locked ? "locked" : "unlocked"].</span>")
			else
				to_chat(user, "<span class='danger'>Access denied.</span>")
			updateDialog()
		else
			to_chat(user, "<span class='warning'>You must open the cover first!</span>")
	else
		return ..()

/obj/item/navbeacon/attackby(obj/item/I, mob/user, params) //Monkstation edit start
	var/turf/T = loc

	if(locate(/obj/machinery/navbeacon) in T)
		to_chat(user, "<span class='warning'>There's already a navigation beacon at that position!</span>")
		return

	if(!isplatingturf(T))
		to_chat(user, "<span class='warning'>The beacon must be placed underneath floor tiles!</span>")
		return

	if(I.tool_behaviour == TOOL_WRENCH)
		to_chat(user, "<span class='notice'>You attach \the [src] to the floor.</span>")
		I.play_tool_sound(src)
		new /obj/machinery/navbeacon( T )
		qdel(src) //Monkstation edit end

/obj/machinery/navbeacon/attack_ai(mob/user)
	interact(user, 1)

/obj/machinery/navbeacon/attack_paw()
	return

/obj/machinery/navbeacon/ui_interact(mob/user)
	. = ..()
	var/ai = isAI(user)
	var/turf/T = loc
	if(T.intact)
		return		// prevent intraction when T-scanner revealed

	if(!open && !ai)	// can't alter controls if not open, unless you're an AI
		to_chat(user, "<span class='warning'>The beacon's control cover is closed!</span>")
		return


	var/t

	if(locked && !ai)
		t = {"<TT><B>Navigation Beacon</B><HR><BR>
<i>(swipe card to unlock controls)</i><BR>
Location: [location ? location : "(none)"]</A><BR>
Transponder Codes:<UL>"}

		for(var/key in codes)
			t += "<LI>[key] ... [codes[key]]"
		t+= "<UL></TT>"

	else

		t = {"<TT><B>Navigation Beacon</B><HR><BR>
<i>(swipe card to lock controls)</i><BR>

<HR>
Location: <A href='byond://?src=[REF(src)];locedit=1'>[location ? location : "None"]</A><BR>
Transponder Codes:<UL>"}

		for(var/key in codes)
			t += "<LI>[key] ... [codes[key]]"
			t += "	<A href='byond://?src=[REF(src)];edit=1;code=[key]'>Edit</A>"
			t += "	<A href='byond://?src=[REF(src)];delete=1;code=[key]'>Delete</A><BR>"
		t += "	<A href='byond://?src=[REF(src)];add=1;'>Add New</A><BR>"
		t+= "<UL></TT>"

	var/datum/browser/popup = new(user, "navbeacon", "Navigation Beacon", 300, 400)
	popup.set_content(t)
	popup.open()
	return

/obj/machinery/navbeacon/Topic(href, href_list)
	if(..())
		return
	if(open && !locked)
		usr.set_machine(src)

		if(href_list["locedit"])
			var/newloc = stripped_input(usr, "Enter New Location", "Navigation Beacon", location)
			if(newloc)
				if(codes["delivery"]) //Monkstation edit
					GLOB.deliverybeacontags -= location //Monkstation edit
				location = newloc
				if(codes["delivery"]) //Monkstation edit
					GLOB.deliverybeacontags += location //Monkstation edit
				updateDialog()

		else if(href_list["edit"])
			var/codekey = href_list["code"]

			var/newkey = stripped_input(usr, "Enter Transponder Code Key", "Navigation Beacon", codekey)
			if(!newkey)
				return

			var/codeval = codes[codekey]
			var/newval = stripped_input(usr, "Enter Transponder Code Value", "Navigation Beacon", codeval)
			if(!newval)
				newval = codekey
				return

			codes.Remove(codekey)
			codes[newkey] = newval

			if(codes) //Monkestation edit start
				if(codes["patrol"])
					if(!GLOB.navbeacons["[z]"])
						GLOB.navbeacons["[z]"] = list()
					GLOB.navbeacons["[z]"] += src //Register with the patrol list!
				else
					GLOB.navbeacons["[z]"] -= src
				if(codes["delivery"])
					GLOB.deliverybeacons += src
					GLOB.deliverybeacontags += location
				else
					GLOB.deliverybeacons -= src
					GLOB.deliverybeacontags -= location //Monkestation edit end

			updateDialog()

		else if(href_list["delete"])
			var/codekey = href_list["code"]
			codes.Remove(codekey)
			if(!codes["patrol"]) //Monkestation edit start
				GLOB.navbeacons["[z]"] -= src
			if(!codes["delivery"])
				GLOB.deliverybeacons -= src
				GLOB.deliverybeacontags -= location
			updateDialog() //Monkstation edit end

		else if(href_list["add"])

			var/newkey = stripped_input(usr, "Enter New Transponder Code Key", "Navigation Beacon")
			if(!newkey)
				return

			var/newval = stripped_input(usr, "Enter New Transponder Code Value", "Navigation Beacon")
			if(!newval)
				newval = "1"
				return

			if(!codes)
				codes = new()

			codes[newkey] = newval

			if(codes["patrol"]) //Monkstation edit start
				if(!GLOB.navbeacons["[z]"])
					GLOB.navbeacons["[z]"] = list()
				GLOB.navbeacons["[z]"] += src //Register with the patrol list!
			if(codes["delivery"])
				GLOB.deliverybeacons += src
				GLOB.deliverybeacontags += location //Monkstation edit end
			updateDialog()
