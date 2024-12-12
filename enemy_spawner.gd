extends Node2D

var combat_guard_scene = preload("res://npc/combat_guard.tscn")
var combat_kid_scene = preload("res://npc/combat_kid.tscn")


var npc_type_to_enemy_scene = { NPC.NPCType.Guard : combat_guard_scene,
								NPC.NPCType.Kid : combat_kid_scene}

func _ready() -> void:
	for npc_type in npc_type_to_enemy_scene:
		var num_npcs_of_that_type_in_sack = PlayerVariables.sack_npc_type_counts[npc_type]
		if (num_npcs_of_that_type_in_sack != null):
			for i in range(num_npcs_of_that_type_in_sack):
				_spawn_enemy(npc_type_to_enemy_scene[npc_type])
				

func _spawn_enemy(enemy_scene):
	var distance_from_origin = randf_range(30, 300)
	var enemy_instance = enemy_scene.instantiate()
	enemy_instance.global_position = Vector2(350, 350) + Vector2.RIGHT.rotated(randf_range(0, TAU)) * distance_from_origin
	print("Spawning an enemy at this location: " + str(enemy_instance.global_position))
	add_child(enemy_instance)
