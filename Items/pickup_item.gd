extends Area2D
class_name Item

@export var item_name:String
@export var description:String
@export var flavor:String

# Called when the node enters the scene tree for the first time.
#func _ready() -> void:
	#pass # Replace with function body.
#
#
## Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
	#pass

func collect():
	queue_free()
	pass
