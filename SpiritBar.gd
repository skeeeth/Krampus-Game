extends TextureProgressBar

@export var margin:float
@onready var combat_scene = preload("res://sack_world.tscn")
@export var outside_scene:Node2D
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#position.x = get_viewport_rect().size.x/2.0/get_parent().zoom.x
	#position.x -= margin
	value = max_value
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	value -= delta * PlayerVariables.cheer_rate * 60.0
	if value <= 0.0:
		#could do some kind of transition
		outside_scene.process_mode = Node.PROCESS_MODE_DISABLED
		outside_scene.visible = false
		var combat_instance = combat_scene.instantiate() 
		get_tree().root.add_child(combat_instance)
		visible = false
		await PlayerVariables.combat_ended
		visible = true
		value = max_value
		outside_scene.visible = true
		outside_scene.process_mode = Node.PROCESS_MODE_INHERIT

	pass
