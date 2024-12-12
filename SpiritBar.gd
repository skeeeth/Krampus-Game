extends TextureProgressBar

@export var margin:float
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	position.x = get_viewport_rect().size.x/2.0/get_parent().zoom.x
	position.x -= margin
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	value -= delta * PlayerVariables.cheer_rate * 60.0
	if value <= 0.0:
		#could do some kind of transition
		get_tree().change_scene_to_file("res://sack_world.tscn")
	pass
