extends State
class_name Idle

@export var max_wait:float = 1.0
@export var parent : Enemy
@export var beeline_state:State

@export_category("Ranges")
@export var retreat_range:float = 500
@export var attack_range:float = 800
@export var wander_range:float = 0 #set to less than attack_range to always seek
var next_wait:float = 1.0

func _ready() -> void:
	var fuzz = 0.25
	retreat_range *= randf_range(1.0-fuzz,1.0 + fuzz)
	attack_range *= randf_range(1.0-fuzz,1.0 + fuzz)
	wander_range *= randf_range(1.0-fuzz,1.0 + fuzz)

func enter():
	print("Idle Started")
	await get_tree().create_timer(next_wait).timeout
	next_wait = randf_range(0.05,max_wait)
	
	#Set next state based on distance
	var dist = parent.diff.length()
	if dist < retreat_range:
		beeline_state.direction = -1.0
		transitioned.emit(self,"Beeline")
	elif dist < attack_range:
		transitioned.emit(self,"Attack")
		#Attack Named node may have different scripts in different scenes
	elif dist < wander_range:
		transitioned.emit(self,"Wander")
	else:
		#Seek
		beeline_state.direction = 1.0
		transitioned.emit(self,"Beeline")

	print("Idle Finished")

func exit():
	pass
	
func update(_delta):
	pass

func physics_update(_delta):
	pass
