extends Node

class_name State


@export
var can_move = true # defines if character can move in this state

@export
var can_face = true

var state_machine: StateMachine

var character: Player

var playback: AnimationNodeStateMachinePlayback


# called in state machine input
@warning_ignore("unused_parameter")
func state_input(event):
	pass

# called in state machine _process
@warning_ignore("unused_parameter")
func state_process(delta):
	pass


# called in state machine _physics_process
@warning_ignore("unused_parameter")
func state_physics_process(delta):
	pass


# called in state machine when this state is entered
@warning_ignore("unused_parameter")
func on_enter(_mst:={}):
	pass


# called in state machine when this state is exited
func on_exit():
	pass

