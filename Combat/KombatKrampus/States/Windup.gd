extends State
class_name Windup
@export var spin_threshold:float = 1.2
@export var damping:float = 0.98
@export var movespeed:float = 10
@export var body:CharacterBody2D
var entry_speed:float
var charge:float = 0.0
func enter():
	charge = 0.0
	$"../../Pull".emitting = true
	pass
	
func exit():
	$"../../Pull".emitting = false
	pass
	
func update(_delta):
	charge += _delta
	pass

func physics_update(_delta):
	var input_vector = Input.get_vector("left","right","up","down").normalized()
	if input_vector:
		body.velocity += input_vector * movespeed;
	
	body.velocity *= damping

func _input(event: InputEvent) -> void:
	if !get_parent().currentState == self: return
	
	if event.is_action_released("attack"):
		if charge > spin_threshold:
			transitioned.emit(self,"Spin")
		else:
			transitioned.emit(self,"Quick")
	if event. is_action("interact"):
		$"../..".dash_buffered = true
