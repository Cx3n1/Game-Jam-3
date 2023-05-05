extends State

class_name CrouchState

func state_input(event: InputEvent):
	if(event.is_action_pressed("jump")):
		character.jump()
		playback.travel("Jump_start")
		state_machine.transition_to("Air", {from_ground = true, jumped = true})


func state_process(delta):
	if(!character.is_on_floor()):
		state_machine.transition_to("Air", {from_ground = true})
	if(!Input.is_action_pressed("crouch")):
		state_machine.transition_to("Ground")

func on_exit():
	pass

func on_enter(_msg:={}):
	playback.travel("Crouch")

