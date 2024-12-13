extends Area2D
class_name AttackHitbox

var strength:float = 100
var stun_duration:float = 1.0
var override_direction:Vector2
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	area_entered.connect(on_area_entered)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func on_area_entered(area:Area2D):
	if area is Enemy:
		var dir = area.global_position - global_position
		if override_direction != Vector2.ZERO:
			dir = override_direction
		area.take_knockback(dir,strength,stun_duration)
