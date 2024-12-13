extends CanvasLayer

#@onready var progress_bar: ProgressBar = $ProgressBar
@onready var timer: Label = $Timer_Container/Timer
var time:float = 30.0
@export var transition_time:float = 2.0
@export var lens: ColorRect
var fading:bool = false
#@onready var bg: TextureRect = $"../bg"
@onready var bg: Sprite2D = $"../bg"
@onready var player: Player = $"../SackKrampus"

@export var world:Node2D
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	time = PlayerVariables.survival_time
	#$Timer_Container.position.y = -get_viewport_rect().size.y/2.0
	lens.size = lens.get_viewport_rect().size
	lens.position = -lens.get_viewport_rect().size/2.0
	#bg.size = lens.size
	#bg.global_position = lens.global_position
	#make_current()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	time -= delta
	timer.text = "  %2.2f" %time
	if time < 0:
		PlayerVariables.current_health += PlayerVariables.sack_heal
		PlayerVariables.current_health = clamp(
				PlayerVariables.current_health,0,PlayerVariables.max_hp)
		#fade_out()
	#if time < transition_time:
		if !fading:
			fade_out()
		else:
				player.position = Vector2.ZERO
				player.velocity = Vector2.ZERO
	
#dont actually like how this looks so disabled for now
func fade_out():
	fading = true
	var transition = create_tween()
	bg.region_rect.size = lens.size


	#bg.global_position = lens.global_position
	#tween_method can only interpolate on on the first argument of a callable
	# so I have to make a callable just to swap the arg order
	#var rssp = func reversed_set_shader_parameter(val,uniform): #lambda
		#lens.material.set_shader_parameter(uniform,val)
	transition.set_parallel()
	transition.tween_method(rssp.bind("intensity"),0.0,25.0,transition_time);
	#transition.tween_property(lens,"visible",false,0);
	transition.tween_property(world,"scale",Vector2.ZERO,transition_time*0.66);
	transition.tween_property(world,"modulate:a",0,transition_time * 0.66)
	PlayerVariables.combat_fading.emit()
	print(str(PlayerVariables.combat_ended.get_connections()))
	await transition.finished
	PlayerVariables.combat_ended.emit()
	world.queue_free()

func rssp(val,uniform):
		lens.material.set_shader_parameter(uniform,val)

#func _exit_tree() -> void:
	#world.apply_scale(Vector2.ONE)
