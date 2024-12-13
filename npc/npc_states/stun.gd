extends State

@export var parent : Node
var previous_state:State

func enter():
	$"../../StunSprite".visible = true
	pass
	
func exit():
	$"../../StunSprite".visible = false
	pass
	
func update(_delta):
	pass

func physics_update(_delta):
	pass
