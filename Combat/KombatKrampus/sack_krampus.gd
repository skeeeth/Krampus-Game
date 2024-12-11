extends CharacterBody2D

var dash_buffered:bool = false

func _physics_process(delta: float) -> void:
	move_and_slide()
