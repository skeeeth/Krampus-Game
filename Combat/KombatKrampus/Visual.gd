extends Sprite2D
class_name CharacterVisual

var facing_direction:Vector2


func _process(delta: float) -> void:
	#change to setting animations with a real character sprite
	rotation = facing_direction.angle() 
