extends State

@export_category("Frame Data")
@export var startup:float = 0.3
#active frames tied to animation time for now
@export var follow_through:float = 0.2

@export_category("Node Refs")
@export var parent : Enemy
@export var hitbox : Area2D
@export var pivot:Node2D
@export var sprite:AnimatedSprite2D
@export var indicator:ColorRect
@export var idle_state:Idle

func enter():
	print("Melee Attack Startup")
	pivot.visible = true
	hitbox.collision_mask = 1
	#target
	pivot.rotation = parent.diff.angle()
	
	var indicate = create_tween()
	indicator.visible = true
	indicate.tween_property(indicator,"color:a",1.0,startup)
	
	await indicate.finished
	#enable
	indicator.color.a = 0.0
	sprite.visible = true
	sprite.play("default")
	hitbox.monitoring = true
	print("Melee Attack Active")
	
	await sprite.animation_finished
	#disable
	idle_state.next_wait = follow_through
	transitioned.emit(self,"Idle")
	sprite.visible = false
	hitbox.monitoring = false
	print("Melee Attack Finished")
	pass
	
func exit():
	hitbox.collision_mask = 0
	pivot.visible = false
	pass
	
func update(_delta):
	pass

func physics_update(_delta):
	pass
