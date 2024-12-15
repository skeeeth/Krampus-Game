extends Area2D
class_name Item

@export var item_name:String
@export var description:String
@export var flavor:String

func _draw() -> void:
	draw_circle(Vector2.ZERO,25,Color.BLACK,false)
	draw_circle(Vector2.ZERO,25,Color(0.7,0.7,0.7,0.3))

func collect():
	PlayerVariables.new_item.emit(item_name,
			description,
			flavor,
			$Sprite2D.texture)
	
	queue_free()
	pass
