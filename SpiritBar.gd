extends ProgressBar

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	value += delta * PlayerVariables.cheer_rate
	if value >= 100.0:
		#could do some kind of transition
		get_tree().change_scene_to_file("res://sack_world.tscn")
	pass
