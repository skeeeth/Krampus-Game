extends Node
class_name StateMachine

var currentState : State
var states : Dictionary = {}
@export var startingState : State

# Called when the node enters the scene tree for the first time.
func _ready():
	for child in get_children():
		if child is State:
			states[child.name] = child;
			child.transitioned.connect(on_child_transition)
	
	if startingState:
		startingState.enter()
		currentState = startingState;
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if currentState:
		currentState.update(delta)
	pass

func _physics_process(delta):
	if currentState:
		currentState.physics_update(delta);
		

func on_child_transition(state,new_state_name):
	#Accept them :3
	if state != currentState: #Only listen to current state
		return;
	
	var new_state = states.get(new_state_name)
	if !new_state: #check that new state exists
		return
		
	if currentState:
		currentState.exit()
	
	new_state.enter()
	
	currentState = new_state
