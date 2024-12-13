extends Control

@onready var _pickup_card_scene = preload("res://Items/item_pickup_card.tscn")

func _ready() -> void:
	PlayerVariables.new_item.connect(spawn_card)

func spawn_card(title,description,flavor,image):
	var p1 = $Marker2D.position
	var p2 = $Marker2D2.position
	var card:ItemCard = _pickup_card_scene.instantiate()
	card.title = title
	card.image = image
	card.description = description
	card.flavor = flavor
	card.position = p1
	add_child(card)
	var back_forth = create_tween()

	back_forth.tween_property(card,"position",p2,0.6)
	back_forth.tween_property(card,"position",p1,0.3).set_delay(1.5)
	back_forth.tween_callback(card.queue_free)
