extends Node

class_name StateMachine


@export
var character: Player

@export
var current_state: State

@export
var animation_tree: AnimationTree

# Emitted when transitioning to a new state.
signal transitioned(state_name)



# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_fill_states_array()
	current_state.on_enter()


func _input(event: InputEvent) -> void:
	current_state.state_input(event)


func _process(delta: float) -> void:
	current_state.state_process(delta)


func _physics_process(delta: float) -> void:
	current_state.state_physics_process(delta)


# fills states array and assigns them appropriate properties
func _fill_states_array():
	for child in get_children():
		if child is State:
			child.state_machine = self
			child.character = character
			child.playback = animation_tree.get("parameters/playback")
		
		else:
			push_warning("Child " + str(child) + " is not a State!")


# checks if character can move
func can_move():
	return current_state.can_move

func can_face():
	return current_state.can_face

# transitions to the given state and passes on information to the nexst state if provided as msg
func transition_to(target_state_name: String, msg: Dictionary = {}) -> void:
	if not has_node(target_state_name):
		return

	current_state.on_exit()
	current_state = get_node(target_state_name)
	current_state.on_enter(msg)
	emit_signal("transitioned", current_state.name)

