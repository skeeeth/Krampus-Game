extends Control

var max_value:float
var value:float
#@onready var label =$label
@export var label:Label

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	label.text = "Health:%3.0f/%3.0f" %  [PlayerVariables.current_health,PlayerVariables.max_hp]
	#scale.x = 1.0/get_parent().zoom.x
	#scale.y = 1.0/get_parent().zoom.y
	#position.x = -(get_viewport_rect().size.x/2.0)
	#position.y = -(get_viewport_rect().size.y/2.0)
	
	#max_value = PlayerVariables.max_hp
	PlayerVariables.health_changed.connect(_on_health_changed)
	pass # Replace with function body.


func _on_health_changed(new):
	label.text = "Health:%3.0f/%3.0f" %  [PlayerVariables.current_health,PlayerVariables.max_hp]
	pass
