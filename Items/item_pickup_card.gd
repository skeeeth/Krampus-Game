extends PanelContainer
class_name ItemCard

var title:String
var image:Texture2D
var description:String
var flavor:String

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$MarginContainer/VBoxContainer/Label.text = title
	$MarginContainer/VBoxContainer/VBoxContainer/TextureRect.texture = image
	$MarginContainer/VBoxContainer/Label2.text = description
	$MarginContainer/VBoxContainer/Label3.text = flavor
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
	#pass
