extends AnimatedSprite2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	play("default")
	await animation_finished
	queue_free()
	pass # Replace with function body.
