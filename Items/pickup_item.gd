extends Area2D
class_name Item

@export var item_name:String
@export var description:String
@export var flavor:String

func collect():
	PlayerVariables.new_item.emit(item_name,
			description,
			flavor,
			$Sprite2D.texture)
	
	queue_free()
	pass
