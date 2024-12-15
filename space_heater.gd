extends "res://Items/pickup_item.gd"

func collect():
	PlayerVariables.snowball_scale *= 0.75;
	super()
