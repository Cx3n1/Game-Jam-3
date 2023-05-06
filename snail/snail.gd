extends Node2D

@onready var animatio_tree : AnimationTree = $AnimatioTree

@export var starting_move_direction : Vector2 = Vector2.LEFT


@export var movement_speed : float = 30.0

@onready var state_machine : CharacterStateMachine = $CharacterStateMachine

@export var hit_state : State

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")


# Called when the node enters the scene tree for the first time.
func _ready():
	animatio_tree.active = true

func physics_process(delta):
	#add the gravity
	if not is_on_floor():
		velocity.y += gravity * delta


	var direction : Vector2 = starting_move_direction
	if direction && state_machine.check_if_can_move():
		velocity.x = move_toward(velocity.x,0,movement_speed)
	elif state_machine.current_state != hit_state:
		velocity.x = move_toward(velocity.x,0,movement_speed)

	move_and_slide()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
