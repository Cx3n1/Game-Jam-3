extends State
class_name Dodge

@export
var dodge_distance = 500

@export
var dodge_stamina = 10

func on_enter(_mst:={}):
	playback.travel("Roll_ground")
	

func state_process(delta):
	if character.sprite.flip_h: # left
		character.velocity.x = -dodge_distance
	else: # right
		character.velocity.x = dodge_distance
	
	if !character.is_on_floor():
		character.velocity.y += character.GRAVITY
	else: 
		character.velocity.y = 0
	
	character.move_and_slide()
	

func _on_animation_tree_animation_finished(anim_name):
	if state_machine.current_state != self:
		return
	
	state_machine.transition_to("Ground")
