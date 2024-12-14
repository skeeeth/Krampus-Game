extends Label

func _process(delta: float) -> void:
	text = "%03d
	


 %03d" % [PlayerVariables.naughty_kids_nabbed,100]
