extends Node

#Spawn npcs in a rectanglular area defined by these two bounds
#We'll use the global positions of the child nodes $UpperLeftBoundPosition and $LowerRightBoundPosition
var upper_left_bound:Vector2
var lower_right_bound:Vector2

#Iterate over this area left-to-right, top-to-bottom in steps. The step size is given by average_horizontal_spacing and average_vertical_spacing
#E.g. if upper_left_bound=(0,0) and average_horizontal_spacing=10, we'd check (0,0), (10,0), (20,0), etc
#But to make things look more organic, randomly nudge each of these positions by these amounts:
#	left or right by spacing_variance*average_horizontal_spacing
#	up or down by spacing_variance*average_vertical_spacing
@export var average_horizontal_spacing:float
@export var average_vertical_spacing:float
@export var spacing_variance:float

#The spawn area will be divided up into sections
#We'll make a list where each element represents one section. Each element will be a list of valid spawn positions within that section
#When we're spawning npcs, we can spawn 1 guard and 3 children per section (for example) to make sure that they're spread throughout the store
@export var num_horizontal_sections:int = 8
@export var num_vertical_sections:int = 3
var sections = []

@export var spawn_position_collision_shape:Shape2D

var guard_scene = preload("res://npc/guard.tscn")
var kid_scene = preload("res://npc/kid.tscn")

func _ready() -> void:
	sections.resize(num_vertical_sections*num_horizontal_sections)
	sections.fill([])
	
	upper_left_bound = $UpperLeftBoundPosition.global_position
	lower_right_bound = $LowerRightBoundPosition.global_position
	
	await _find_spawn_positions()
	_spawn_npcs(200, 10)


func _spawn_npcs(num_kids_to_spawn:int, num_guards_to_spawn:int):
	var num_kids_spawned = 0
	var num_guards_spawned = 0
	
	var section_index = 0
	
	var krampus_position = Vector2(0, 0) #TO-DO: get the actual krampus position upon coming back to the store from the sack
	var guard_detection_radius = Guard.krampus_detection_radius
	
	sections.shuffle()
	while (num_kids_spawned < num_kids_to_spawn):
		var spawn_position = sections[section_index].pick_random()
		var kid_inst = kid_scene.instantiate()
		kid_inst.global_position = spawn_position
		add_child(kid_inst)
		
		num_kids_spawned += 1
		section_index = (section_index + 1) % sections.size()
	
	sections.shuffle()
	while (num_guards_spawned < num_guards_to_spawn):
		var spawn_position:Vector2 = sections[section_index].pick_random()
		var too_close_to_krampus = (spawn_position-krampus_position).length() <= (guard_detection_radius + 200)
		var num_attempted_spawn_positions = 1
		
		while (num_attempted_spawn_positions < 5 and too_close_to_krampus):
			num_attempted_spawn_positions += 1
			spawn_position = sections[section_index].pick_random()
			too_close_to_krampus = (spawn_position-krampus_position).length() <= (guard_detection_radius + 200)
		
		if (not too_close_to_krampus):
			var guard_inst = guard_scene.instantiate()
			guard_inst.global_position = spawn_position
			add_child(guard_inst)
			num_guards_spawned += 1
			
		section_index = (section_index + 1) % sections.size()


func _find_spawn_positions():
	var current_position = upper_left_bound
	var candidate_position_area2ds:Array[Area2D] = []
	
	#Iterate from upper_left_bound to lower_right_bound by average_horizontal_spacing and average_vertical_spacing
	#At each step, add some fuzz with spacing_variance, then spawn an Area2D
	while (current_position.y < lower_right_bound.y):
		while (current_position.x < lower_right_bound.x):
			var position_fuzz = spacing_variance * Vector2(randf_range(-average_horizontal_spacing, average_horizontal_spacing), 
														   randf_range(-average_vertical_spacing, average_vertical_spacing))
			var candidate_position = current_position + position_fuzz
			
			var new_area_2d = Area2D.new()
			new_area_2d.global_position = candidate_position
			candidate_position_area2ds.append(new_area_2d)
			add_child(new_area_2d)
			
			var new_collision_shape_2d = CollisionShape2D.new()
			new_collision_shape_2d.shape = spawn_position_collision_shape
			new_area_2d.add_child(new_collision_shape_2d)
			
			current_position.x += average_horizontal_spacing
		
		current_position.x = upper_left_bound.x
		current_position.y += average_vertical_spacing
	
	#Wait until after one physics step
	await get_tree().process_frame
	await get_tree().process_frame
	
	
	var overall_spawn_area_size = lower_right_bound - upper_left_bound
	var section_width = overall_spawn_area_size.x / float(num_horizontal_sections)
	var section_height = overall_spawn_area_size.y / float(num_vertical_sections)
	
	for area in candidate_position_area2ds:
		if (not area.has_overlapping_bodies()):
			#This is a valid spawn position
			#Figure out which section it's in, then add it to that section's list of spawn positions
			var section_row = int((area.global_position.y - upper_left_bound.y) / section_height) #the int cast truncates, so this should now be zero-indexed
			var section_column = int((area.global_position.x - upper_left_bound.x) / section_width)
			
			#Since we added fuzz to these positions, some might be slightly outside the bounds
			section_row = clampi(section_row, 0, num_vertical_sections-1)
			section_column = clampi(section_column, 0, num_horizontal_sections-1)
			
			var sections_index = (section_row * num_horizontal_sections) + section_column
				
			sections[sections_index].append(area.global_position)
		
		#Delete the area regardless of whether or not it's overlapping, 
		area.queue_free()
	
	#Low priority to-do: 
	#	store the results to a resource or json file
	#	Instead of running the above logic every time the game runs, just run it in development whenever the level changes, then load from the resource/file in the actual game
