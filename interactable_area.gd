class_name InteractableArea
extends Area2D

@export var handler:Node

signal interacted(interactor)


func on_select_as_interaction_target():
	pass #to-do: display visual that shows this thing is selected

func on_deselect_as_interaction_target():
	pass
