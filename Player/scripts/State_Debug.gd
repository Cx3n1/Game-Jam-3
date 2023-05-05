extends Label



func _on_state_machine_transitioned(state_name) -> void:
	text = state_name
