extends Area2D
class_name Enemy

@export var state_machine:StateMachine
@export var base_speed:float = 10.0
@export var max_distance:float = 1200;
var player:Player
var diff:Vector2

func _ready() -> void:
	base_speed *= randf_range(0.8,1.2)
	player = get_tree().get_first_node_in_group("Player")

@warning_ignore("unused_parameter")
func _process(delta: float) -> void:
	diff = player.global_position - global_position
	if diff.length() > max_distance:
		global_position = player.global_position + (diff * 0.8)

func take_knockback(dir:Vector2,strength:float, stun_duration:float = -1.0):
	var kb = create_tween()
	kb.tween_property(self,"position",position+dir.normalized()*strength,0.15);
	if stun_duration > 0:
		if state_machine.currentState.name == "Stun":
			print("Already Stunned")
			return
		var previous_state:State = state_machine.currentState
		state_machine.currentState.transitioned.emit(
				state_machine.currentState,"Stun")
		var stun_state = state_machine.currentState
		print("Stun Started")
		await get_tree().create_timer(stun_duration).timeout
		print("Stun Finished, returning to " + str(previous_state))
		state_machine.currentState.transitioned.emit(stun_state,previous_state.name)
	
