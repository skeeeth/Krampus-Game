class_name Dialoguesystem
extends Control

signal dialogue_finished
signal dialogue_started

@export var happy_face_texture:Texture2D
@export var surprised_face_texture:Texture2D
@export var disgusted_face_texture:Texture2D
@export var grumpy_face_texture:Texture2D

@export var face_texture_rect:TextureRect
@export var text_label:RichTextLabel

var current_dialogue_list = []
var current_dialogue_list_index = 0

func _ready() -> void:
	face_texture_rect = $Visuals/TextureRect
	text_label = $Visuals/RichTextLabel
	#play_entered_store_dialogue()


func play_entered_store_dialogue():
	var dialogue_list = [[happy_face_texture, "Time for a little Christmas shopping! I have 20 naughty little kids to nab."],
						 [surprised_face_texture, "But what's that music? Why, it's filling me with Christmas cheer!"],
						 [disgusted_face_texture, "How disgusting!"],
						 [grumpy_face_texture, "I'll need to hop in my sack soon to get a break from it..."]]
	'''
	var dialogue_list = [[surprised_face_texture, "This music... why, it's filling me with Christmas cheer!"],
						 [disgusted_face_texture, "How disgusting!"],
						 [grumpy_face_texture, "I'll need to hop in my sack soon to get a break from it..."]]
	'''
	_play_dialogue(dialogue_list)


func play_respawn_dialogue():
	var dialogue_list = [[surprised_face_texture, "Huh? Did those pesky fleas actually manage to kill me?"],
						 [happy_face_texture, "Fools! It'll take more than that to make it stick!"],
						 [grumpy_face_texture, "Looks like a few got out while I was regenerating, though..."]]
	_play_dialogue(dialogue_list)

func _play_dialogue(new_dialogue_list):
	dialogue_started.emit()
	current_dialogue_list = new_dialogue_list
	current_dialogue_list_index = 0
	#GameStateManager.state = GameStateManager.GameState.Dialogue
	_update_dialogue_visuals()
	$Visuals.visible = true


func _update_dialogue_visuals():
	face_texture_rect.texture = current_dialogue_list[current_dialogue_list_index][0]
	text_label.text = current_dialogue_list[current_dialogue_list_index][1]


func _input(event: InputEvent) -> void:
	if (event.is_action_pressed("attack") or event.is_action_pressed("interact")):
		_advance_dialogue()

func _advance_dialogue():
	current_dialogue_list_index += 1
	if (current_dialogue_list_index == current_dialogue_list.size()):
		$Visuals.visible = false
		dialogue_finished.emit()
		GameStateManager.state = GameStateManager.GameState.Gameplay
	elif (current_dialogue_list_index < current_dialogue_list.size()):
		_update_dialogue_visuals()
