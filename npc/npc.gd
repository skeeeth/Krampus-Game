class_name NPC
extends Area2D

@export var npc_type:NPCType


@export var default_sprite:Sprite2D
@export var knocked_down_sprite:Sprite2D

@export var cart_knockdown_speed:float = 130
var knockdown_timer:Timer
var knockdown_duration:float = 3

var wandering_cardinal_direction:Vector2
var wandering_variance_max_angle:float = PI/8

var wandering_min_speed:float = 160
var wandering_max_speed:float = 240
var wandering_speed:float = 200

#If a wandering npc bumps into a shelf, they'll idle for a bit
var wandering_collision_min_idle_duration:float = 1
var wandering_collision_max_idle_duration:float = 4
var wandering_collision_idle_timer:Timer


var nav_ray_length = 150

enum NPCType {
	Kid,
	Guard
}

enum NPCState {
	Idle,
	Wandering,
	KnockedDown,
	Chasing,
	Stuck
}

var nav_ray:RayCast2D

var state:NPCState = NPCState.Idle


func _ready():
	wandering_collision_idle_timer = Timer.new()
	add_child(wandering_collision_idle_timer)
	wandering_collision_idle_timer.one_shot = true
	wandering_collision_idle_timer.timeout.connect(_start_wandering)
	
	knockdown_timer = Timer.new()
	add_child(knockdown_timer)
	knockdown_timer.one_shot = true
	knockdown_timer.timeout.connect(_start_wandering)
	
	nav_ray = RayCast2D.new()
	add_child(nav_ray)
	nav_ray.collision_mask = 34#Layer 2 and layer 6 = 2^1 + 2^5 = 34

	wandering_speed = randf_range(wandering_min_speed, wandering_max_speed)
	_pick_random_wandering_direction()
	_start_wandering()


func _pick_random_wandering_direction():
	wandering_cardinal_direction = Vector2.RIGHT.rotated(randi_range(0, 3) * (PI/2)) #Randomly choose up, down, left, or right
	nav_ray.target_position = nav_ray_length * add_fuzz_to_vector(wandering_cardinal_direction, wandering_variance_max_angle)


func add_fuzz_to_vector(vector, max_angle):
	return vector.rotated(randf_range(-max_angle, max_angle))


func figure_out_new_wandering_direction():
	var num_attempts_to_find_new_direction = 0
	var random_sign = 1 - 2*(randi() % 2) #Choose 1 or -1 at random
	
	while (num_attempts_to_find_new_direction < 3):
		wandering_cardinal_direction = wandering_cardinal_direction.rotated(random_sign*(PI/2))
		nav_ray.target_position = nav_ray_length * add_fuzz_to_vector(wandering_cardinal_direction, wandering_variance_max_angle)
		nav_ray.force_raycast_update()
		if (not nav_ray.is_colliding()):
			return
	
		num_attempts_to_find_new_direction += 1
	
	state == NPCState.Stuck
	print("Help, I'm stuck!")


func _start_wandering_collision_idle_period():
	state = NPCState.Idle
	wandering_collision_idle_timer.start(randf_range(wandering_collision_min_idle_duration, wandering_collision_max_idle_duration))

func _start_wandering():
	state = NPCState.Wandering
	_set_rotation(nav_ray.target_position.angle())
	if (default_sprite != null and knocked_down_sprite != null):
		default_sprite.visible = true
		knocked_down_sprite.visible = false

func _get_knocked_down(knockdown_direction):
	wandering_collision_idle_timer.stop()
	state = NPCState.KnockedDown
	_set_rotation(knockdown_direction.angle() - PI)
	if (default_sprite != null and knocked_down_sprite != null):
		knocked_down_sprite.visible = true
		default_sprite.visible = false	
	knockdown_timer.start(knockdown_duration)

#I want the raycast logic to be independent of the parent rotation, so let's always use this function that performs a counter-rotation
func _set_rotation(new_rotation:float):
	rotation = new_rotation
	nav_ray.rotation = -new_rotation
	

func _physics_process(delta: float):
	if (state == NPCState.Wandering):
		_set_rotation(nav_ray.target_position.angle())
		nav_ray.force_raycast_update()
		
		if (nav_ray.is_colliding()):
			if (nav_ray.get_collider() is Shelf): #Bumped into a shelf
				_start_wandering_collision_idle_period()
			
			figure_out_new_wandering_direction()
		else:
			position = position + wandering_speed * delta * nav_ray.target_position.normalized()


func _on_body_entered(body: Node2D):
	if (body is ShoppingCart and state != NPCState.KnockedDown and body.velocity.length() >= cart_knockdown_speed):
		#var is_cart_moving_left = body.velocity.x < 0
		#var sprite_knockdown_rotation = -PI/2 if is_cart_moving_left else PI/2
		#transform = Transform2D(sprite_knockdown_rotation, position)
		_get_knocked_down(body.velocity.normalized())
