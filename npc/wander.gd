extends State

@export var parent : Enemy
var direction:Vector2
#@export var speed:float = 10.0;
@export var duration:float = 0.1
func enter():
	direction = Vector2.from_angle(randf_range(0,TAU))
	await get_tree().create_timer(duration).timeout
	transitioned.emit(self, "Idle")
	pass
	
func exit():
	pass
	
func update(_delta):
	pass

func physics_update(_delta):
	parent.position += direction * parent.base_speed
	pass
