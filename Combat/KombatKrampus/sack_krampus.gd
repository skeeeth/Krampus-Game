extends CharacterBody2D
class_name Player

var dash_buffered:bool = false
@export var sm:StateMachine
func _physics_process(delta: float) -> void:
	move_and_slide()

func take_damage(amount:float, kb:Vector2 = Vector2.ZERO):
	PlayerVariables.current_health -= amount
	#kb velocity += kb
	pass
