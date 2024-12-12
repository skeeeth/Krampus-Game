class_name Shelf
extends StaticBody2D


#Tweak the collision shape's shape resource so that it matches the dimensions of the LineRenderer
#Also make sure that the points of the line renderer don't have a y component. This lets me be a little haphazard in the editor when I'm stretching out the lines with my mouse
func _ready() -> void:
	#Note: I marked this rectangle shape as "Local to scene" in the editor
	var shape_resource_duplicate:RectangleShape2D = $CollisionShape2D.shape.duplicate()

	if ($Line2D.points.size() == 2):
		$Line2D.points[0].y = 0
		$Line2D.points[1].y = 0
		var start_pos = $Line2D.points[0]
		var end_pos = $Line2D.points[1]
		
		var displacement = end_pos - start_pos
		var new_position = start_pos + displacement/2
		$CollisionShape2D.position = new_position
		shape_resource_duplicate.size = Vector2(displacement.length(), shape_resource_duplicate.size.y)
		$CollisionShape2D.shape = shape_resource_duplicate
