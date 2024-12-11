extends ProgressBar


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	scale.x = 1.0/get_parent().zoom.x
	scale.y = 1.0/get_parent().zoom.y
	position.x = -(get_viewport_rect().size.x/2.0)/get_parent().zoom.x
	position.y = -(get_viewport_rect().size.y/2.0)/get_parent().zoom.y
	
	max_value = PlayerVariables.current_health
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	value = PlayerVariables.current_health
	pass
