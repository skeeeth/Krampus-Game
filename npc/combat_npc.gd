extends Area2D
class_name Enemy

## Called when the node enters the scene tree for the first time.
#func _ready() -> void:
	#pass # Replace with function body.
#
#
## Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
	#pass

func take_knockback(dir:Vector2,strength:float, stun_duration:float = -1.0):
	var kb = create_tween()
	kb.tween_property(self,"position",position+dir.normalized()*strength,0.15);
