extends Node2D

@export var ui_layer:CanvasLayer
@export var shader_transition:bool
@onready var bg: Sprite2D = $bg
var target:Node2D
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$SackKrampus/Lens.visible = shader_transition
	#PlayerVariables.combat_ended.connect(queue_free)
	var grow = create_tween()
	#grow.tween_property(self,"scale",0.1,0.1)
	var bg_size = Vector2(10000,10000)
	bg.region_rect.size = get_viewport_rect().size * 2.0
	grow.set_parallel(true)
	grow.tween_property(self,"scale", Vector2.ONE,1.0)
	grow.tween_method(ui_layer.rssp.bind("intensity"),15,0,1.0)
	grow.tween_property(self,"modulate:a", 1.0,0.5)
	await grow.finished
	bg.region_rect.size = bg_size
	#grow.set_parallel(false)
	#grow.tween_property(bg,"region_rect:size",bg_size,2.0);
	#grow.tween_property(bg,"position",bg_size/2.0,1.0)
	pass # Replace with function body.


## Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	position = target.position
	#bg.position = -bg.size/2.0
	pass

#func end():
	#queue_free()
