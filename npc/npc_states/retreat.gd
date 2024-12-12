extends State

@export var parent : Enemy
@export var idle_state: Idle
var direction:float = 1.0
var target_distance:float = 0
func enter():
	target_distance = randf_range(idle_state.retreat_range,idle_state.attack_range)
	pass
	
func exit():
	pass
	
func update(_delta):
	parent.position += parent.diff.normalized() * parent.base_speed * direction
	if direction < 0:
		if parent.diff.length() > idle_state.retreat_range*1.1:
			transitioned.emit(self,"Idle")
	else:
		if parent.diff.length() < target_distance:
			idle_state.next_wait = 0.0
			transitioned.emit(self,"Idle")
	pass

func physics_update(_delta):
	pass
