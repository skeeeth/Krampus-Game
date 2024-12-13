extends Area2D

var interaction_target
var interactables_in_range = {}


@export var krampus:Krampus

'''
func _on_body_entered(body: Node2D) -> void:
	print("Body entered! Name: " + body.name) 
	if (body is InteractableArea):
		interactables_in_range[body] = 1

func _on_body_exited(body: Node2D) -> void:
	print("Body exited! Name: " + body.name) 
	if (body is InteractableArea):
		interactables_in_range.erase(body)
'''

func _on_area_entered(area: Area2D) -> void:
	print("Area entered! Name: " + area.name) 
	if (area is InteractableArea):
		interactables_in_range[area] = 1

func _on_area_exited(area: Area2D) -> void:
	print("Area exited! Name: " + area.name) 
	if (area is InteractableArea):
		interactables_in_range.erase(area)



func _input(event: InputEvent) -> void:
	if event.is_action_pressed("interact"):
		krampus.on_attempt_interaction(interaction_target)


func _physics_process(delta: float) -> void:
	var closest_interactable = null
	var closest_interactable_distance = INF
	
	for interactable in interactables_in_range:
		var distance = (interactable.global_position - krampus.global_position).length()
		if (distance < closest_interactable_distance):
			closest_interactable_distance = distance
			closest_interactable = interactable
	
	#Something changed
	#Maybe we found a closer interaction target than what we had before
	#Maybe we couldn't find any nearby interaction targets, so interaction_target should now be null
	if (closest_interactable != interaction_target):
		
		'''
		var old_interaction_target_name = "<NULL>"
		var new_interaction_target_name = "<NULL>"
		if (interaction_target != null):
			old_interaction_target_name = interaction_target.name
		if (closest_interactable != null):
			new_interaction_target_name = closest_interactable.name
		print("My old interaction target was: " + old_interaction_target_name)
		print("My new interaction target is: " + new_interaction_target_name)
		'''
		
		#Stop selecting the old thing (if it even exists)
		if (interaction_target != null):
			interaction_target.on_deselect_as_interaction_target()
		
		#Start selecting the new thing
		if (closest_interactable != null):
			closest_interactable.on_select_as_interaction_target()
		
		interaction_target = closest_interactable
