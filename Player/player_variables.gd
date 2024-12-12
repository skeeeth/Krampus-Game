extends Node

signal health_changed(new)

#shouldn't really be in this script but this is the only autoload for now
signal combat_ended 


var sack_npc_type_counts = {}
var previous_position:Vector2
var current_health:float = 100:
	set(v):
		current_health = v
		health_changed.emit(v)
var max_hp:float = 100:
	set(v):
		max_hp = v
		health_changed.emit(current_health)
var sack_heal:float = 20
var cheer_rate:float = 5
var survival_time:float = 20
