extends State

class_name LandingState

var landing_anim_name = "Jump_end"

func _ready() -> void:
	can_move = false


func on_enter(_mst:={}):
	Globs.shake(5, 0.5)
	playback.travel(landing_anim_name)


func _on_animation_tree_animation_finished(anim_name: StringName) -> void:
	if(anim_name == landing_anim_name || anim_name == "Hurt"):
		state_machine.transition_to("Ground")
