extends Area2D

var is_attack_on_cooldown:bool = false
@export var attack_cooldown_duration:float = 0.3


func attempt_attack(direction):
	transform.x = direction
	transform.y = direction.rotated(-PI/2)
	if (not is_attack_on_cooldown):
		_attack()


func _attack():
	$AnimationPlayer.play("melee_attack")
	$CollisionShape2D.disabled = false
	is_attack_on_cooldown = true
	$CooldownTimer.start(attack_cooldown_duration)


func _on_animation_finished(anim_name: StringName) -> void:
	if (anim_name == "melee_attack"):
		$CollisionShape2D.disabled = true


func _on_cooldown_timer_timeout() -> void:
	is_attack_on_cooldown = false
