extends CharacterBody2D


# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

@export
var player :Player

@export
var rest_position : Node2D

@export
var attack_position : Node2D

@onready
var turret = $Turret

var state = "unactive"

var states: Array = ["attack1", "rest", "attack2", "rest", "attack2", "attack2"]

var state_count = 0

func _ready():
	state = "attack1"
	
	

func _process(delta):
	if (state == "unactive"):
		return
	
	
	if(state != "trans"):
		print("in state")
		state_handler()

func _physics_process(delta):
	if state == "unactive":
		return
		
	move_and_slide()

func state_trans_start():
	$Timer.start()

func state_trans():
	if state_count >= states.size():
		state_count = 0
	
	state = states[state_count]
	print(state)
	state_count += 1


var to_rest = false

var shot = 0

func state_handler():
	if state == "attack1": #shoot in fixed
		turret.shoot_towards($pos1.global_position)
		turret.shoot_towards($pos2.global_position)
		turret.shoot_towards($pos3.global_position)
		turret.shoot_towards($pos4.global_position)
		state = "trans"
		state_trans_start()
	elif state == "attack2":
		state = "trans"
		$Timer2.start(0.1)
	elif state == "rest":
		state = "trans"
		global_position.move_toward(rest_position.global_position, 500)
		

func _on_timer_timeout():
	state_trans()



func _on_timer_2_timeout():
	if(shot == 4):
		shot = 0
		state_trans_start()
	else:
		shot += 1
		turret.shoot_towards(player.global_position)
		$Timer2.start(0.5)

func _on_timer_3_timeout():
	velocity.y = 0
	if !to_rest:
		state_trans_start()
	else:
		$Rest.start()


func _on_rest_timeout():
	print("rest timer")
	velocity.y = -100
	to_rest = false
	$Timer3.start()


