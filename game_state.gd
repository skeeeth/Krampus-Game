extends Node

enum GameState {
	Dialogue,
	Transition,
	Gameplay
}

signal dialogue_started
signal dialogue_stopped

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
