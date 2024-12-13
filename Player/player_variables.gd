extends Node

signal health_changed(new)
signal new_item(title,desc,flavor,image)
#shouldn't really be in this script but this is the only autoload for now
signal combat_ended 


var sack_npc_type_counts = {}
#var previous_position:Vector2
var current_health:float = 100:
	set(v):
		current_health = v
		health_changed.emit(v)
var max_hp:float = 100:
	set(v):
		max_hp = v
		health_changed.emit(current_health)
var sack_heal:float = 20
var cheer_rate:float = 0.01#3
var survival_time:float = 20
var walkspeed:float = 200
var dash_multiplier:float = 4

var spin_movespeed:float = 10
var spin_kb:float = 200
var spin_stun:float = 0.4
var spin_scale:float = 1.0

var quick_stun:float = 0.6
var quick_kb:float = 300
var quick_scale:float = 1.0
