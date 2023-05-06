extends State


@export var hand_to_hand_attacks : Array[String]
@export var melee_attacks : Array[String]

@export
var attack_stamina = 10

@onready var timer : Timer = $Timer
@onready var cancel_timer : Timer =$Cancel_timer

var current_attack_index = 0



func state_input(event):
	if(event.is_action_pressed("attack")):
		timer.start()
		cancel_timer.stop()
		cancel_timer.start()
	
	
	if (event.is_action_pressed("dodge") && !cancel_timer.is_stopped()):
		state_machine.transition_to("Dodge")
	


func on_enter(_msg:={}):
	#Globs.shake()
	if character.armed:
		playback.travel(melee_attacks[0])
	else:
		playback.travel(hand_to_hand_attacks[0])
	current_attack_index = 0
	
	cancel_timer.start()
	



func _on_animation_tree_animation_finished(anim_name: StringName) -> void:
	if(state_machine.current_state != self):
		return
		
	if timer.is_stopped() || anim_name == melee_attacks.back() || anim_name == hand_to_hand_attacks.back() || anim_name == "Hurt":
		state_machine.transition_to("Ground")
		return
	timer.stop()
	
	if !character.attack_check():
		state_machine.transition_to("Ground")
		return
	
	current_attack_index += 1
	
	if character.armed:
		playback.travel(melee_attacks[current_attack_index])
		return
	
	playback.travel(hand_to_hand_attacks[current_attack_index])
