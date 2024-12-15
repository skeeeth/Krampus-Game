extends "res://Items/pickup_item.gd"

func collect():
	PlayerVariables.cheer_rate -= 1
	$"../../BGM".bus = "Headphones" #will break with renaming/parenting of scene
	$"../../Crowd".bus = "Headphones"
	super()
