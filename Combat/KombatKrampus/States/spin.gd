extends State

@export var body : CharacterBody2D
@export var movespeed:float = 10
@export var base_duration:float = 2.0
@onready var sprite: AnimatedSprite2D = $"../../SpinAttack"
@onready var hitbox: Area2D = $"../../SpinHitbox"

func enter():
	var exit = create_tween()
	exit.tween_callback(emit_signal.bind("transitioned",
			self,"Walk")).set_delay($"../Windup".charge + base_duration)
		
	sprite.visible = true
	sprite.play("Startup")
	await sprite.animation_finished
	hitbox.monitoring = true
	sprite.play("Loop")

func exit():
	sprite.visible = false
	hitbox.monitoring = false
	sprite.stop()
	pass
	
func update(_delta):
	pass

func physics_update(_delta):
	var input_vector = Input.get_vector("left","right","up","down").normalized()
	body.velocity += input_vector * movespeed;


func _on_spin_attack_animation_looped() -> void:
	hitbox.monitoring = !hitbox.monitoring
