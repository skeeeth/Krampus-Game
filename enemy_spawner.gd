extends Node2D

var combat_guard_scene = preload("res://npc/combat_guard.tscn")
var naughty_combat_kid_scene = preload("res://npc/combat_kid.tscn")
var nice_combat_kid_scene = preload("res://npc/nice_combat_kid.tscn")


var npc_type_to_enemy_scene = { NPC.NPCType.Guard : combat_guard_scene,
								NPC.NPCType.NaughtyKid : naughty_combat_kid_scene,
								NPC.NPCType.NiceKid : nice_combat_kid_scene}

func _ready() -> void:
	for npc_type in npc_type_to_enemy_scene:
		if PlayerVariables.sack_npc_type_counts.has(npc_type):
			var num_npcs_of_that_type_in_sack = PlayerVariables.sack_npc_type_counts[npc_type]
			if (num_npcs_of_that_type_in_sack != null):
				for i in range(num_npcs_of_that_type_in_sack):
					_spawn_enemy(npc_type_to_enemy_scene[npc_type])
	#for npc_type in PlayerVariables.sack_npc_type_counts:
		#var num_npcs_of_that_type_in_sack = npc_type
		#if (num_npcs_of_that_type_in_sack != null):
			#for i in range(num_npcs_of_that_type_in_sack):
				#_spawn_enemy(npc_type_to_enemy_scene[npc_type])

func _spawn_enemy(enemy_scene):
	var distance_from_origin = randf_range(200, 2000)
	var enemy_instance = enemy_scene.instantiate()
	enemy_instance.position = Vector2.RIGHT.rotated(randf_range(0, TAU)) * distance_from_origin
	print("Spawning an enemy at this location: " + str(enemy_instance.global_position))
	add_child(enemy_instance)
