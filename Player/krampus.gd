class_name Krampus
extends CharacterBody2D

@export var move_speed:float = 120

var cart:ShoppingCart = null

var facing_direction:Vector2 = Vector2.RIGHT

func _ready() -> void:
	global_position = PlayerVariables.previous_position
	
func _exit_tree() -> void:
	PlayerVariables.previous_position = global_position

func on_attempt_interaction(interaction_target:InteractableArea):
	if (cart != null):
		cart.stop_riding()
		cart = null
	
	elif (interaction_target != null):
		if (interaction_target.handler is ShoppingCart):
			cart = interaction_target.handler
			cart.start_riding(self)


func _input(event: InputEvent) -> void:
	if (event.is_action_pressed("attack") and cart == null): #Can't attack while in the cart... for now. Could be fun though
		$Attack.attempt_attack(facing_direction)

	#Just for testing	
	if (event.is_action_pressed("dev1")):
		get_tree().change_scene_to_file("res://sack_world.tscn")


func _physics_process(delta: float) -> void:
	if (cart != null):
		rotation = cart.rotation - PI/2
		return
		
	var input_direction = Input.get_vector("left", "right", "up", "down")
	
	if (input_direction.length() > 0):
		facing_direction = input_direction
		rotation = input_direction.angle()
	
	velocity = move_speed * input_direction.normalized()
	
	move_and_slide()
