class_name Krampus
extends CharacterBody2D

@export var move_speed:float = 120
@export var glide_time:float = 0.4 #not actually reflective of any unit of time

var cart:ShoppingCart = null

var facing_direction:Vector2 = Vector2.RIGHT
var gliding:bool = false
func _ready() -> void:
	PlayerVariables.outside_movespeed = move_speed
	
#func _exit_tree() -> void:
	#PlayerVariables.previous_position = global_position

func on_attempt_interaction(interaction_target:InteractableArea):
	if (cart != null and !gliding):
		cart.stop_riding()
		cart = null
	
	elif (interaction_target != null):
		if (interaction_target.handler is ShoppingCart):
			gliding = true
			cart = interaction_target.handler
			$Glide_sound.play()
			cart.collision_mask = 10 #layer 2 + 4
			#hardcoded value, if default cart mask changes will not be reflected


func _input(event: InputEvent) -> void:
	if (event.is_action_pressed("attack") and cart == null): #Can't attack while in the cart... for now. Could be fun though
		$Attack.attempt_attack(facing_direction)

	#Just for testing	
	if (event.is_action_pressed("dev1")):
		get_tree().change_scene_to_file("res://sack_world.tscn")


func _physics_process(delta: float) -> void:
	move_speed = PlayerVariables.outside_movespeed
	if (cart != null):
		if gliding:
			var diff = (cart.rider_offset_position.global_position - global_position)
			#PID is probably the ideal solution here
			# but thats way too much effort right now
			# so its just proportional with a minimum
			velocity = (diff/glide_time) + (diff.normalized()*5.0) + (cart.velocity/2.0)
			
			if diff.length() < 50:
				$"Cart Pickup".play()
				cart.start_riding(self)
				gliding = false
				cart.collision_mask = 11 #layer 1 + 2 + 4 hardcoded
			move_and_slide()
			return
		else:
			rotation = cart.rotation - PI/2
			return
		
	var input_direction = Input.get_vector("left", "right", "up", "down")
	
	if (input_direction.length() > 0):
		facing_direction = input_direction
		rotation = input_direction.angle()
	
	velocity = move_speed * input_direction.normalized()

	move_and_slide()
