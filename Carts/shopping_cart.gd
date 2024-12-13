class_name ShoppingCart
extends CharacterBody2D


var rider = null

@export var linear_acceleration:float = 45
@export var linear_friction:float = 0.2
@export var maximum_linear_speed = 180
@export var angular_acceleration:float = 9
@export var angular_friction:float = 3
@export var maximum_angular_speed = 1.4
@export var kickoff_speed = 1.5
var angular_speed:float = 0
@onready var rider_offset_position = $RiderOffsetPosition

'''
func on_player_interaction(player:Krampus):
	if (rider == player):
		rider = null
		collision_mask = enable_bit(collision_mask, 0) #Enable collisions with player. Argument is 0 for layer 1
	else:
		rider = player
		collision_mask = disable_bit(collision_mask, 0) #Disable collisions with player. Argument is 0 for layer 1
'''


func start_riding(new_rider):
	rider = new_rider
	velocity = velocity + (-transform.y.normalized() * kickoff_speed);
	_physics_process(1.0/60.0)
	set_collision_mask_value(1, 0)

func stop_riding():
	rider = null
	set_collision_mask_value(1, 1)
	

func _physics_process(delta: float) -> void:
	var vertical_input:float = 0
	var horizontal_input:float = 0
	
	if (rider != null):
		vertical_input = Input.get_axis("down", "up")
		horizontal_input = Input.get_axis("left", "right")
	
	var new_linear_speed = _update_speed(velocity.length(), vertical_input*linear_acceleration, linear_friction, delta, maximum_linear_speed)	
	angular_speed = _update_speed(angular_speed, angular_acceleration*horizontal_input, angular_friction, delta, maximum_angular_speed)
	
	transform = transform.rotated_local(delta * angular_speed)
	
	velocity = -transform.y.normalized() * new_linear_speed
	move_and_slide()
	
	if (rider != null):
		rider.global_position = $RiderOffsetPosition.global_position


func _update_speed(initial_speed, acceleration, friction, delta, maximum_speed) -> float:
	#Apply acceleration
	var new_speed = initial_speed + (acceleration*delta)
	
	#Apply friction
	var new_speed_abs = abs(new_speed)
	new_speed_abs -= (new_speed_abs * friction * delta)
	new_speed_abs = clampf(new_speed_abs, 0, maximum_speed)
	
	return sign(new_speed) * new_speed_abs

'''
func _on_interactable_area_interacted(interactor) -> void:
	if (rider == null):
		start_riding(interactor)
	else:
		stop_riding()
'''
