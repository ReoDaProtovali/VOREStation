
/client/New()
	..()
	dir = NORTH

/client/verb/spinleft()
	set name = "Spin View CCW"
	set category = "OOC.Game"
	dir = turn(dir, 90)

/client/verb/spinright()
	set name = "Spin View CW"
	set category = "OOC.Game"
	dir = turn(dir, -90)
