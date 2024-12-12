extends Camera2D

#@onready var progress_bar: ProgressBar = $ProgressBar
@onready var timer: Label = $Timer_Container/Timer
var time:float = 20.0
@export var transition_time:float = 2.0
@onready var lens: ColorRect = 	$Lens
var fading:bool = false
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Timer_Container.position.y = -get_viewport_rect().size.y/2.0
	lens.size = get_viewport_rect().size
	lens.position = -get_viewport_rect().size/2.0
	make_current()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	time -= delta
	timer.text = "  %2.2f" %time
	if time < 0:
		PlayerVariables.current_health += PlayerVariables.sack_heal
		PlayerVariables.current_health = clamp(
				PlayerVariables.current_health,0,PlayerVariables.max_hp)
		get_tree().change_scene_to_file("res://cart_test.tscn")
	#if time < transition_time:
		#if !fading:
			#fade_out()
	
#dont actually like how this looks so disabled for now
func fade_out():
	fading = true
	var transition = create_tween()
	
	#tween_method can only interpolate on on the first argument of a callable
	# so I have to make a lambda just to swap the arg order
	var rssp = func reversed_set_shader_parameter(val,uniform): #lambda
		lens.material.set_shader_parameter(uniform,val)
		
	transition.tween_method(rssp.bind("intensity"),0.0,10.0,transition_time);
	await transition.finished
	get_tree().change_scene_to_file("res://cart_test.tscn")
