extends CharacterBody2D
class_name Player

var dash_buffered:bool = false
@export var sm:StateMachine

@export var character_sprite:Sprite2D

var is_invincible:bool = false
var hurt_period_invincible_duration:float = 2
var hurt_period_invincible_timer:Timer

var hurt_period_sprite_flash_color:Color = Color.RED
var hurt_period_sprite_flash_duration:float = 0.4
var sprite_initial_color:Color


func _ready() -> void:
	hurt_period_sprite_flash_color.a = 0.5
	sprite_initial_color = character_sprite.modulate
	hurt_period_invincible_timer = Timer.new()
	hurt_period_invincible_timer.one_shot = true
	add_child(hurt_period_invincible_timer)
	hurt_period_invincible_timer.timeout.connect(_on_invincible_timer_timeout)
	
	$Camera2D.make_current()

func _on_invincible_timer_timeout():
	is_invincible = false
	character_sprite.modulate = sprite_initial_color


func _process(delta: float) -> void:
	if (is_invincible):
		var current_hurt_period_duration = (hurt_period_invincible_duration - hurt_period_invincible_timer.time_left)
		#We want to flash from initial_color to hurt_period_sprite_flash_color back to initial_color every <hurt_period_sprite_flash_duration> seconds
		#  For example, suppose hurt_period_sprite_flash_duration == 0.4
		#  We want cos(x) to go from 1 to -1, then back to 1, all in 0.4 seconds
		#  So we take the current time t, divide it by 0.4, then multiply by TAU
		#  Plug that into cos(x)
		#  Except instead of osciallating between 1 and -1, we want to oscillate between 1 and 0, so multiply by 0.5 and add 0.5 to the result
		var lerp_amount = 0.5 + (0.5*cos(TAU*(current_hurt_period_duration/hurt_period_sprite_flash_duration)))
		character_sprite.modulate = lerp(sprite_initial_color, hurt_period_sprite_flash_color, lerp_amount)

func _physics_process(delta: float) -> void:
	move_and_slide()


func take_damage(amount:float, kb:Vector2 = Vector2.ZERO):
	if (not is_invincible):
		PlayerVariables.current_health -= amount
		if (hurt_period_invincible_duration > 0):
			is_invincible = true
			hurt_period_invincible_timer.start(hurt_period_invincible_duration)
		#kb velocity += kb
		pass
