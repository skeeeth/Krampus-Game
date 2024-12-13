extends State

@export var body : CharacterBody2D
var movespeed:float = 0
@export var base_duration:float = 1.2
@onready var sprite: AnimatedSprite2D = $"../../SpinAttack"
@onready var hitbox: AttackHitbox = $"../../SpinHitbox"

func _ready() -> void:
	movespeed = PlayerVariables.spin_movespeed
	hitbox.strength = PlayerVariables.spin_kb
	hitbox.stun_duration = PlayerVariables.spin_stun
	sprite.scale *= PlayerVariables.spin_scale
	hitbox.scale *= PlayerVariables.spin_scale

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
