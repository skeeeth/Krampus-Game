extends Area2D
class_name Enemy

@export var state_machine:StateMachine
@export var base_speed:float = 10.0
var player:Player
var diff:Vector2

func _ready() -> void:
	player = get_tree().get_first_node_in_group("Player")

func _process(delta: float) -> void:
	diff = player.global_position - global_position

func take_knockback(dir:Vector2,strength:float, stun_duration:float = -1.0):
	var kb = create_tween()
	kb.tween_property(self,"position",position+dir.normalized()*strength,0.15);
	if stun_duration > 0:
		if state_machine.currentState.name == "Stun":
			return
		var previous_state:State = state_machine.currentState
		state_machine.currentState.transitioned.emit(
				state_machine.currentState,"Stun")
		var stun_state = state_machine.currentState
		await get_tree().create_timer(stun_duration).timeout
		state_machine.currentState.transitioned.emit(stun_state,previous_state.name)
	
