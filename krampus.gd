class_name Krampus
extends CharacterBody2D

@export var move_speed:float = 120

var cart:ShoppingCart = null


func on_attempt_interaction(interaction_target:InteractableArea):
	if (cart != null):
		cart.stop_riding()
		cart = null
	
	elif (interaction_target != null):
		if (interaction_target.handler is ShoppingCart):
			cart = interaction_target.handler
			cart.start_riding(self)


func _physics_process(delta: float) -> void:
	if (cart != null):
		return
		
	var input_direction = Input.get_vector("left", "right", "up", "down")
	velocity = move_speed * input_direction.normalized()
	move_and_slide()
