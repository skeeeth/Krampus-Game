extends Area2D

signal sacked_npc()

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


#For now, I'm going to have this "Attack" scene handle both the sack and birch rod attack
#If it gets too complicated, we'll split them up
func _on_area_entered(area: Area2D) -> void:
	if (area is NPC):
		var num_npcs_of_this_type_in_sack = PlayerVariables.sack_npc_type_counts.get_or_add(area.npc_type, 0)
		PlayerVariables.sack_npc_type_counts[area.npc_type] = num_npcs_of_this_type_in_sack + 1
		#sacked_npc.emit()
		area.queue_free()
