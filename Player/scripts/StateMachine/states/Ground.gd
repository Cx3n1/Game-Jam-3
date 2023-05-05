extends State

class_name GroundState


var jumped = false

func state_input(event: InputEvent):
	if(event.is_action_pressed("jump")):
		character.jump()
		jumped = true
	elif (event.is_action_pressed("attack")):
		state_machine.transition_to("Attack")


@warning_ignore("unused_parameter")
func state_process(delta):
	if(!character.is_on_floor()):
		if(jumped):
			jumped = false
			state_machine.transition_to("Air", {from_ground = true, jumped = true})
		else:
			state_machine.transition_to("Air", {from_ground = true})
	else:
		jumped = false
	
	#character._update_movement()
	

func on_enter(_msg:={}):
	playback.travel("Move")
	pass
