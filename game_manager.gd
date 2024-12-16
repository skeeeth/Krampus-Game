extends Node

var sack_world_instance = null
@export var store_contents:Node

@export var screen_cover:CanvasLayer

@export var npc_spawner:NPCSpawner

@export var dialogue_system:Dialoguesystem

@export var cheer_bar:CheerBar
@export var store_only_ui:CanvasLayer
@export var out_cam: Camera2D

@onready var combat_scene = preload("res://sack_world.tscn")
@export var krampus:Krampus

@export var bgm_player:AudioStreamPlayer

var respawning:bool = false
var transitioning:bool = false

func _ready():
	dialogue_system.dialogue_finished.connect(_on_dialogue_finished)
	dialogue_system.dialogue_started.connect(_on_dialogue_started)
	npc_spawner.finished_spawning.connect(_on_finished_spawning_npcs_initial)
	cheer_bar.cheer_bar_filled.connect(_switch_to_sack)
	PlayerVariables.combat_fading.connect(_on_combat_fading)
	PlayerVariables.player_died.connect(_on_player_death)
	
	store_contents.process_mode = Node.PROCESS_MODE_DISABLED
	bgm_player.process_mode = Node.PROCESS_MODE_ALWAYS
	dialogue_system.play_entered_store_dialogue()

func _on_finished_spawning_npcs_initial():
	screen_cover.visible = false


func _switch_to_sack():
	store_contents.process_mode = Node.PROCESS_MODE_DISABLED
	#store_contents.visible = false
	store_only_ui.visible = false
	
	sack_world_instance = combat_scene.instantiate() 
	sack_world_instance.position = krampus.global_position
	sack_world_instance.target = krampus
	get_tree().root.add_child(sack_world_instance)
	
	var shrink = create_tween()
	shrink.tween_property(krampus,"scale",Vector2(0.2,0.2),0.3)
	
	npc_spawner.delete_npcs()


func _on_player_death():
	print("On player death happened!!!")
	
	PlayerVariables.modify_sack_npc_type_counts(NPC.NPCType.Guard, -2)
	PlayerVariables.modify_sack_npc_type_counts(NPC.NPCType.NiceKid, -5)
	PlayerVariables.modify_sack_npc_type_counts(NPC.NPCType.NaughtyKid, -2)
	
	respawning = true
	screen_cover.visible = true
	
	#some kids got out!
	npc_spawner.delete_npcs()
	
	_switch_to_store()
	
	store_contents.process_mode = Node.PROCESS_MODE_DISABLED
	if (sack_world_instance != null):
		sack_world_instance.queue_free()
		
	PlayerVariables.current_health = PlayerVariables.max_hp
	
	dialogue_system.play_respawn_dialogue()


func _on_combat_fading():
	if (!respawning):
		_switch_to_store()


func _switch_to_store():
	cheer_bar.value = 0
	npc_spawner.spawn_all_npcs()
	
	out_cam.make_current()
	store_only_ui.visible = true
	store_contents.visible = true
	krampus.process_mode = Node.PROCESS_MODE_WHEN_PAUSED
	
	var grow = create_tween()
	grow.tween_property(krampus,"scale",Vector2.ONE,1.5);
	krampus.process_mode = Node.PROCESS_MODE_INHERIT
	store_contents.process_mode = Node.PROCESS_MODE_INHERIT
	

func _on_dialogue_started():
	if (sack_world_instance != null):
		sack_world_instance.process_mode = Node.PROCESS_MODE_DISABLED
	else:
		store_contents.process_mode = Node.PROCESS_MODE_DISABLED

func _on_dialogue_finished():
	bgm_player.process_mode = Node.PROCESS_MODE_INHERIT
	respawning = false
	screen_cover.visible = false
	if (sack_world_instance != null):
		sack_world_instance.process_mode = Node.PROCESS_MODE_INHERIT
	else:
		store_contents.process_mode = Node.PROCESS_MODE_INHERIT
