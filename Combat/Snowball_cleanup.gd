extends Timer

var checked_once:bool = false

func _on_timeout() -> void:
	if get_parent().process_mode == PROCESS_MODE_DISABLED:
		if checked_once:
			get_parent().queue_free()
		else:
			checked_once = true
	pass # Replace with function body.
