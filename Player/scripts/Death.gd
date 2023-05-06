extends State



func on_enter(_mst:={}):
	playback.travel("Death")

func _process(delta):
	if state_machine.current_state != self:
		return
	character.velocity.y += character.GRAVITY
	character.move_and_slide()

