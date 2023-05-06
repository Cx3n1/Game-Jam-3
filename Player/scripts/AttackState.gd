extends State


@export var hand_to_hand_attacks : Array[String]
@export var melee_attacks : Array[String]

@onready var timer : Timer = $Timer

var current_attack_index = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func state_input(event):
	if(event.is_action_pressed("attack")):
		timer.start()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func on_enter(_msg:={}):
	Globs.shake()
	if character.armed:
		playback.travel(melee_attacks[0])
	else:
		playback.travel(hand_to_hand_attacks[0])
	current_attack_index = 0



func _on_animation_tree_animation_finished(anim_name: StringName) -> void:
	if timer.is_stopped() || anim_name == melee_attacks.back() || anim_name == hand_to_hand_attacks.back():
		state_machine.transition_to("Ground")
		return
	timer.stop()
	
	current_attack_index += 1
	
	if character.armed:
		playback.travel(melee_attacks[current_attack_index])
		return
	
	playback.travel(hand_to_hand_attacks[current_attack_index])
