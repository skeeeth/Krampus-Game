extends State

@export var body : CharacterBody2D
@export var movespeed:float = 220
@export var vis:CharacterVisual
var dash_buffered:bool

func enter():
	pass
	
func exit():
	dash_buffered = false
	pass
	
func update(_delta):
	pass

func physics_update(_delta):
	var input_vector = Input.get_vector("left","right","up","down").normalized()
	if input_vector:
		body.velocity = input_vector * movespeed;
		vis.facing_direction = input_vector
		if body.dash_buffered:
			transitioned.emit(self,"Dash")
	else:
		body.velocity = Vector2.ZERO
	pass

func _input(event: InputEvent) -> void:
	if !get_parent().currentState == self: return
	
	if event.is_action_pressed("interact"):
		if body.velocity.length() > 0:
			transitioned.emit(self,"Dash")
		else:
			body.dash_buffered = true
	if event.is_action_pressed("attack"):
		body.velocity = Vector2.ZERO
		transitioned.emit(self,"Windup")
		
