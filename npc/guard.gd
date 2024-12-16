class_name Guard
extends NPC

var krampus_ray:RayCast2D
const krampus_detection_radius:float = 800 #$KrampusInitialDetector/DetectionCircle.shape.radius

var krampus:Krampus = null
var last_known_krampus_location:Vector2 = Vector2(0, 0)
var last_known_krampus_movement_direction:Vector2 = Vector2(0, 0)
var already_visited_last_known_location = false

var time_since_last_krampus_sighting:float = 0
var max_time_since_last_krampus_sighting:float = 5 #If krampus is out of sight for this long, give up on chasing
var chasing_velocity:Vector2 = Vector2(0, 0)
@export var chasing_speed:float = 310

var dps:float = 5
var melee_attack_range:float = 80


func _ready() -> void:
	$KrampusInitialDetector/DetectionCircle.shape.radius = krampus_detection_radius
	
	krampus_ray = RayCast2D.new()
	krampus_ray.hit_from_inside = true
	krampus_ray.collision_mask = 33 #This represents line of sight, so it should only collide with the player and environment (not shopping carts)
									#That's layer 1 and layer 6, so the mask is 2^0 + 2^5 = 33
	add_child(krampus_ray)
	
	super()	

func _process(_delta: float) -> void:
	$Attention_Icons.rotation = -rotation

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
		
		if (is_krampus_in_sight and displacement_to_last_known_krampus_position.length() < melee_attack_range): 
			PlayerVariables.current_health -= (dps*delta)
			if (displacement_to_last_known_krampus_position.length() < melee_attack_range * 0.75):
				return #If I'm very close to krampus, don't try to come closer - I'll overlap with the krampus sprite, which looks confusing
		
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
			#_give_up_chase()
		else:
			position += chasing_speed * delta * nav_ray.target_position.normalized()
		
		_set_rotation(nav_ray.target_position.angle())
	else:
		super(delta)


#I want the raycast logic to be independent of the parent rotation, so let's always use this function that performs a counter-rotation
func _set_rotation(new_rotation:float):
	super(new_rotation)
	krampus_ray.rotation = -new_rotation

func _start_chasing():
	wandering_collision_idle_timer.stop()
	state = NPCState.Chasing
	#to-do: display little red "!"
	var grow = create_tween()
	grow.tween_property($"Attention_Icons/!","scale:y",1.0,0.4)
	await grow.finished
	$"Attention_Icons/!".scale.y = 0


func _give_up_chase():
	display_question()
	
	_pick_random_wandering_direction()
	state = NPCState.Idle


func _on_krampus_initial_detector_body_entered(body: Node2D) -> void:
	if (body is Krampus):
		krampus = body

func display_question():
	var size_and_rotate = create_tween()
	var icon = $"Attention_Icons/?"
	size_and_rotate.set_parallel()
	size_and_rotate.tween_property(icon,"scale",1.0,0.3)
	size_and_rotate.tween_property(icon,"rotation",0,0.5)
	size_and_rotate.tween_property(icon,"rotation",0,0.2).set_delay(2.0)
	size_and_rotate.tween_property(icon,"scale",0.0,0.5)
