extends Area2D


func _physics_process(delta: float) -> void:
	rotation += TAU*0.5*delta
