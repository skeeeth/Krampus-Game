class_name NPC
extends Area2D

@export var npc_type:NPCType
@export var cart_knockdown_speed:float = 30

enum NPCType {
	Kid,
	Guard
}

enum NPCState {
	Idle,
	KnockedDown
}

var state:NPCState = NPCState.Idle

func _on_body_entered(body: Node2D) -> void:
	if (body is ShoppingCart and state != NPCState.KnockedDown and body.velocity.length() >= cart_knockdown_speed):
		var is_cart_moving_left = body.velocity.x < 0
		var sprite_knockdown_rotation = -PI/2 if is_cart_moving_left else PI/2
		transform = Transform2D(sprite_knockdown_rotation, position)
		state = NPCState.KnockedDown
