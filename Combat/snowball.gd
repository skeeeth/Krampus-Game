extends Area2D

var size:float = 5.0
var damage:float = 10
var kb_strength:float = 0
var direction:Vector2
var speed:float
func _draw() -> void:
	draw_circle(Vector2.ZERO,size/2.0,Color.SNOW)
	draw_circle(Vector2.ZERO,(size/2.0)+1,Color.BLACK,false)
	#could use a shader for a real perfect circle but this is fine
	
# Called when the node enters the scene tree for the first time.
#func _ready() -> void:
	#pass # Replace with function body.
#
#
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	queue_redraw()
	position += speed * direction
	if size == 0:
		queue_free()
	pass


func _on_body_entered(body: Node2D) -> void:
	if body is Player:
		body.take_damage(damage,direction*kb_strength)
		queue_free()
		scale = Vector2(1.0,1.0) * size/10.0
	pass # Replace with function body.


func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	queue_free()
	pass # Replace with function body.
