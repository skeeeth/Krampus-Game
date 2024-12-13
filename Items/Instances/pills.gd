extends "res://Items/pickup_item.gd"


func collect():
	PlayerVariables.spin_movespeed += 7
	super()
