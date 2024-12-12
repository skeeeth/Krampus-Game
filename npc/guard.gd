class_name Guard
extends NPC

var krampus_ray:RayCast2D
var krampus_detection_radius:float

var krampus:Krampus = null
var last_known_krampus_location:Vector2 = Vector2(0, 0)
var last_known_krampus_movement_direction:Vector2 = Vector2(0, 0)
var already_visited_last_known_location = false

var time_since_last_krampus_sighting:float = 0
var max_time_since_last_krampus_sighting:float = 500 #If krampus is out of sight for this long, give up on chasing
var chasing_velocity:Vector2 = Vector2(0, 0)
@export var chasing_speed:float = 300


func _ready() -> void:
	krampus_detection_radius = $KrampusInitialDetector/DetectionCircle.shape.radius
	
	krampus_ray = RayCast2D.new()
	krampus_ray.collision_mask = 33 #This represents line of sight, so it should only collide with the player and environment (not shopping carts)
									#That's layer 1 and layer 6, so the mask is 2^0 + 2^5 = 33
	add_child(krampus_ray)
	
	super()	


func _physics_process(delta: float) -> void:
	var is_krampus_in_sight = false
	if (krampus != null):
		krampus_ray.target_position = krampus_detection_radius * (krampus.global_position - global_position).normalized()
		krampus_ray.force_raycast_update()
		is_krampus_in_sight = (krampus_ray.is_colliding() and krampus_ray.get_collider() == krampus)
		
		if (is_krampus_in_sight):
			last_known_krampus_location = krampus.global_position
			time_since_last_krampus_sighting = 0
			already_visited_last_known_location = false
			last_known_krampus_movement_direction = krampus.get_real_velocity()
			
			if (state == NPCState.Idle or state == NPCState.Wandering):
				_start_chasing()
		
		elif (state == NPCState.Chasing):
			#to-do: turn "!" yellow when krampus first gets out of sight
			time_since_last_krampus_sighting += delta
			if (time_since_last_krampus_sighting > max_time_since_last_krampus_sighting):
				_give_up_chase()
	
	if (state == NPCState.Chasing):
		var displacement_to_last_known_krampus_position = (last_known_krampus_location - global_position)
		
		if (is_krampus_in_sight and displacement_to_last_known_krampus_position.length() < 20): 
			#He's in line of sight and in punching range! Get him!
			pass #to-do: deal damage
		
		
		if ((not is_krampus_in_sight) and displacement_to_last_known_krampus_position.length() < 5):
			already_visited_last_known_location = true
		if (already_visited_last_known_location):
			#Head in whatever direction he was moving in at the last sighting
			nav_ray.target_position = nav_ray_length * last_known_krampus_movement_direction.normalized()
		else:
			nav_ray.target_position = nav_ray_length * displacement_to_last_known_krampus_position.normalized()
		
		
		nav_ray.force_raycast_update()
		if (nav_ray.is_colliding()):
			#The direct line towards the last known location is blocked. Try going 45 degrees clockwise 
			nav_ray.target_position = nav_ray.target_position.rotated(-PI/4) * 1.1
			nav_ray.force_raycast_update()
		if (nav_ray.is_colliding()):
			#That way is blocked too. Try going 45 degrees counterclockwise from the direct path
			nav_ray.target_position = nav_ray.target_position.rotated(PI/2)
			nav_ray.force_raycast_update()
			
		
		if (nav_ray.is_colliding()):
			print("Trying to chase Krampus, but I don't see a way forward")
			_give_up_chase()
		else:
			position += chasing_speed * delta * nav_ray.target_position.normalized()
		
		print("Using this angle: " + str(nav_ray.target_position.angle()))
		_set_rotation(nav_ray.target_position.angle())
	else:
		super(delta)


#I want the raycast logic to be independent of the parent rotation, so let's always use this function that performs a counter-rotation
func _set_rotation(new_rotation:float):
	super(new_rotation)
	krampus_ray.rotation = -new_rotation

func _start_chasing():
	wandering_collision_idle_timer.stop()
	#to-do: display little red "!"
	state = NPCState.Chasing

func _give_up_chase():
	#To-do: display little "?" icon instead of "!"
	_pick_random_wandering_direction()
	state = NPCState.Idle


func _on_krampus_initial_detector_body_entered(body: Node2D) -> void:
	if (body is Krampus):
		krampus = body
