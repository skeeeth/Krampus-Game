class_name CheerBar
extends TextureProgressBar

signal cheer_bar_filled

@export var margin:float
@export var krampus:Krampus
@onready var combat_scene = preload("res://sack_world.tscn")
@export var outside_scene:Node2D
@export var out_cam: Camera2D

@export var store_only_elements:CanvasLayer

@export var npc_spawner:NPCSpawner



# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#position.x = get_viewport_rect().size.x/2.0/get_parent().zoom.x
	#position.x -= margin
	value = 0#max_value
	pass # Replace with function body.




# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if (value < max_value):
		value += delta * PlayerVariables.cheer_rate * 60.0
	
	if (value >= max_value):
		cheer_bar_filled.emit()
	
	'''
	if process_mode == Node.PROCESS_MODE_ALWAYS:
		return
	if value >= max_value:
		$Transition.play()
		process_mode = Node.PROCESS_MODE_ALWAYS
		outside_scene.process_mode = Node.PROCESS_MODE_DISABLED
		#outside_scene.visible = false
		var combat_instance = combat_scene.instantiate() 
		combat_instance.position = krampus.global_position
		combat_instance.target = krampus
		get_tree().root.add_child(combat_instance)
		var shrink = create_tween()
		shrink.tween_property(krampus,"scale",Vector2(0.2,0.2),0.3)
		store_only_elements.visible = false
		
		npc_spawner.delete_npcs()
		
		await PlayerVariables.combat_fading
		
		npc_spawner.spawn_all_npcs()
		
		out_cam.make_current()
		store_only_elements.visible = true
		value = 0
		outside_scene.visible = true
		krampus.process_mode = Node.PROCESS_MODE_WHEN_PAUSED
		await  PlayerVariables.combat_ended
		var grow = create_tween()
		grow.tween_property(krampus,"scale",Vector2.ONE,1.5);
		#await grow.finished
		krampus.process_mode = Node.PROCESS_MODE_INHERIT
		process_mode = Node.PROCESS_MODE_INHERIT
		outside_scene.process_mode = Node.PROCESS_MODE_INHERIT
	'''
	pass
