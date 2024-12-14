extends State

@export var hitbox : AttackHitbox
@export var pivot:Node2D
@export var sprite:AnimatedSprite2D
@export var character:CharacterVisual
@export var body:CharacterBody2D
@export var movespeed:float = 200
var last_direction_input:Vector2 = Vector2.ZERO
var dash_input:bool = false

func _ready() -> void:
	hitbox.strength = PlayerVariables.quick_kb
	hitbox.stun_duration = PlayerVariables.quick_stun
	pivot.scale *= PlayerVariables.quick_scale

func enter():
	$"Attack Swishes".play()
	last_direction_input = Vector2.ZERO
	pivot.rotation = character.rotation
	hitbox.override_direction = character.facing_direction
	hitbox.monitoring = true
	
	sprite.visible = true
	sprite.play("default")
	await sprite.animation_finished
	transitioned.emit(self,"Walk")
	sprite.visible = false
	hitbox.monitoring = false
	pass
	
func exit():
	#dash_input = false
	pass
	
func update(_delta):
	var input_vector = Input.get_vector("left","right","up","down").normalized()
	if input_vector:
		last_direction_input = input_vector
		#if sprite.frame <= 2:
			#pivot.rotation = input_vector.angle()
			#hitbox.override_direction = input_vector
		
		
	if last_direction_input and body.dash_buffered:
		body.velocity = last_direction_input
		transitioned.emit(self,"Dash")
	pass

func physics_update(_delta):
	pass

func _input(event: InputEvent) -> void:
	if !get_parent().currentState == self: return
	
	if event.is_action_pressed("interact"):
		body.dash_buffered = true
		#if last_direction_input and body.dash_buffered:
			#body.velocity = last_direction_input
			#transitioned.emit(self,"Dash")
