extends "res://Items/pickup_item.gd"

func collect():
	PlayerVariables.cheer_rate -= 1
	
	#these node references will break with renaming/parenting of scene
	$"../../BGM".bus = "Headphones" 
	$"../../Crowd".bus = "Headphones"
	super()
