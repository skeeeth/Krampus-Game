extends Node

signal health_changed(new)
signal new_item(title,desc,flavor,image)
signal sack_contents_changed()

signal player_died()

#shouldn't really be in this script but this is the only autoload for now
signal combat_fading
signal combat_ended

var sack_npc_type_counts = {NPC.NPCType.NiceKid : 0,
							NPC.NPCType.NaughtyKid : 0,
							NPC.NPCType.Guard : 0}

var current_health:float = 100:
	set(v):
		current_health = v
		health_changed.emit(v)
		if (v <= 0):
			player_died.emit()
var max_hp:float = 100:
	set(v):
		max_hp = v
		health_changed.emit(current_health)
var sack_heal:float = 20
var cheer_rate:float = 5
var survival_time:float = 25
var walkspeed:float = 500#200
var dash_multiplier:float = 1.8#4

var spin_movespeed:float = 10
var spin_kb:float = 200
var spin_stun:float = 0.4
var spin_scale:float = 1.0

var quick_stun:float = 0.6
var quick_kb:float = 300
var quick_scale:float = 1.0

var outside_movespeed:float = 300

var snowball_scale:float = 1.0

var naughty_kids_nabbed:int
var naughty_nab_sound:AudioStream = preload("res://Sounds/bell2.mp3")
var other_nab_sound = preload("res://Sounds/click_001.ogg")

func modify_sack_npc_type_counts(npc_type:NPC.NPCType, delta:int):
	if (npc_type == NPC.NPCType.Guard):
		print("Nabbed a guard")
	var current_count = sack_npc_type_counts[npc_type]
	sack_npc_type_counts[npc_type] = max(0, current_count + delta)
	
	if (sack_npc_type_counts[NPC.NPCType.NaughtyKid] == 20):
		get_tree().change_scene_to_file("res://victory_screen.tscn")
	
	sack_contents_changed.emit()
	

func kid_nabbed(is_naughty):
	var sound = AudioStreamPlayer.new()
	add_child(sound)
	
	if (is_naughty):
		naughty_kids_nabbed += 1
		sound.stream = naughty_nab_sound
	else:
		sound.stream = other_nab_sound

	sound.volume_db = 2.0
	create_tween().tween_callback(sound.play).set_delay(randf_range(0,0.075));
	await  sound.finished
	sound.queue_free()
	
