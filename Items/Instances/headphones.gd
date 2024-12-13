extends "res://Items/pickup_item.gd"

func collect():
	PlayerVariables.cheer_rate -= 1
	super()
