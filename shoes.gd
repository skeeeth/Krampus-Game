extends "res://Items/pickup_item.gd"

func collect():
	PlayerVariables.outside_movespeed += 30
	PlayerVariables.walkspeed += 35
	super()
