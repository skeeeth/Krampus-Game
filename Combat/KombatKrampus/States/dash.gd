extends State

@export var body : CharacterBody2D
@export var dash_speed:float = 800
@export var dash_duration:float = 0.33
@export var steer_strength:float = 0.01
@onready var visual_scene = preload("res://Combat/dash_startup.tscn")
var elapsed = 0
func enter():
	elapsed = 0
	body.dash_buffered = false
	#could maybe have some windup here
	body.velocity = body.velocity.normalized() * dash_speed
	#var slow = create_tween()
	#slow.tween_property(body,"velocity",Vector2.ZERO,dash_duration)
	#go_back.tween_callback(emit_signal.bind(
			#"transitioned",self,"Walk")).set_delay(dash_duration)
	var new_vis = visual_scene.instantiate()
	body.add_sibling(new_vis)
	new_vis.position = body.position
	new_vis.rotation = body.velocity.angle()
	pass
	
func exit():
	pass
	
func update(_delta):
	elapsed += _delta
	if elapsed > dash_duration:
		transitioned.emit(self,"Walk")
	#if body.velocity.length_squared() < 10:
		#transitioned.emit(self,"Walk")
	pass

func physics_update(_delta):
	var input_vector = Input.get_vector("left","right","up","down")
	if input_vector:
		var target_angle = lerp_angle(body.velocity.angle(),input_vector.angle(),steer_strength)
		body.velocity = Vector2.from_angle(target_angle) * body.velocity.length()
	pass

func _input(event: InputEvent) -> void:
	if !get_parent().currentState == self: return
	
	if event.is_action_pressed("attack"):
		transitioned.emit(self,"Windup")
