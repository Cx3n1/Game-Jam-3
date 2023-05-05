extends State

class_name AirState

# how many jumps are left
var curr_jump_ammount: int


func state_input(event: InputEvent):
	if(event.is_action_pressed("jump")):
		if(curr_jump_ammount > 0):
			character.double_jump()
			playback.travel("Double_jump")
			curr_jump_ammount -= 1


# Called every frame. 'delta' is the elapsed time since the previous frame.
@warning_ignore("unused_parameter")
func state_process(delta):
	if(character.is_on_floor()):
		if(curr_jump_ammount < character.MAX_JUMP_AMOUNT - 1):
			state_machine.transition_to("Landing")
		else:
			state_machine.transition_to("Ground")
	
	#character._update_movement()

# called in state machine _physics_process
@warning_ignore("unused_parameter")
func state_physics_process(delta):
	character.velocity.y += character.GRAVITY


func on_enter(_mst:={}):
	if(_mst.has("from_ground")):
		curr_jump_ammount = character.MAX_JUMP_AMOUNT
		
	if(_mst.has("jumped")):
		playback.travel("Jump_start")
		curr_jump_ammount -= 1

