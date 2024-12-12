extends State

@export var parent : Enemy
@export var throw_strength:float
@export var damage:float
@export var cast_time:float
@export var inaccuracy:float
@export var snowball_size:float
@onready var snowball_scene = preload("res://Combat/snowball.tscn")
var snowball:Node2D
var thrown:bool = false
func enter():
	print("Snowball Start")
	thrown = false
	snowball = snowball_scene.instantiate()
	var start_snowball = snowball
	snowball.damage = damage
	
	var grow = create_tween()
	grow.tween_property(snowball,"size",snowball_size,cast_time)
	
	#var throw_angle = lerp_angle(parent.diff.angle(),-parent.diff.angle(),inaccuracy)
	#snowball.direction = Vector2.from_angle(throw_angle)
	
	snowball.global_position = parent.global_position
	parent.add_sibling(snowball)
	
	await get_tree().create_timer(cast_time).timeout
	#throw snowball if it still exists and is from the same attack
	if snowball != null and snowball == start_snowball:
		var throw_angle = lerp_angle(parent.diff.angle(),-parent.diff.angle(),inaccuracy)
		snowball.direction = Vector2.from_angle(throw_angle)
		snowball.monitoring = true
		snowball.speed = throw_strength
		thrown = true
	
	transitioned.emit(self,"Wander")
	print("Snowball finished")
	
func exit():
	#do not throw snowball if stun cancels throwing
	if !thrown:
		var shrink = create_tween()
		shrink.tween_property(snowball,"size",0,0.1)
		snowball = null
	pass
	
func update(_delta):
	pass

func physics_update(_delta):
	pass
