extends CharacterBody2D
class_name Player

const JUMP_FORCE = 1000			# Force applied on jumping (pixel/second^2)
const DEFAULT_MOVE_SPEED = 400	# Speed to walk with (pixel/second)
const CROUNCH_MOVE_SPEED = 100	# speed when crouching (pixel/second)
#const MOVE_ACCEL = 200			# Movement acceleration (pixel/second)
const MAX_SPEED = 4000			# Maximum speed the player is allowed to move (pixel/second)
const FRICTION_AIR = 0.965		# The friction while airborne
const FRICTION_GROUND = 0.85	# The friction while on the ground
const CHAIN_LENGHT = 600		# Maximum lenght that chain can extend to (pixels)
const CHAIN_PULL = 80
const MAX_JUMP_AMOUNT = 5		# Amount of jumps player is allowed before they touch ground
const HIDE_OPACITY = 0.2		# Determines the opacity of player sprite when hiding


@export
var attack_stamina = 10

@export
var dodge_stamina = 15


var GRAVITY = ProjectSettings.get_setting("physics/2d/default_gravity")				# Gravity applied every second (pixel/second^2)

signal facing_directin_changed(facing_left : bool)

@onready
var stamina: Stamina = $Stamina

@onready
var health: Damageable_player = $Damageable

@onready
var state_machine : StateMachine = $StateMachine

@onready
var animation_tree : AnimationTree = $AnimationTree

@onready
var sprite : Sprite2D = $Sprite2D

@onready 
var last_checkpoint = self.global_position # checkpoint system

@onready
var particles = $Run_particle

var jump_count = 2

var move_speed = DEFAULT_MOVE_SPEED	# current movment speed

var chain_velocity := Vector2(0,0)

var crouching = false

var armed = true

func _ready():
	particles.emitting = false
	animation_tree.active = true
	

@warning_ignore("unused_parameter")
func _process(delta):
	if(Input.is_action_just_pressed("restart")):
		_reset()
	
	if(Input.is_action_just_pressed("test hurt")):
		health.hit(10)
	
	#_update_crouching()
	_update_movement()
	_update_animation()
	_update_facing_direction()

# updates crouching
func _update_crouching():
	if(Input.is_action_pressed("dodge") && is_on_floor()):
		move_speed = CROUNCH_MOVE_SPEED
		crouching =  true
	else:
		move_speed = DEFAULT_MOVE_SPEED
		crouching = false

# updates movement
func _update_movement():
	if(state_machine.can_move()):
		var dir = _get_input_direction()
		if(is_zero_approx(dir)):
			velocity.x = move_toward(velocity.x, 0, move_speed)
		else:
			velocity.x = dir*move_speed
			
		move_and_slide()

# updates animation (runs in _process)
func _update_animation():
	if !state_machine.can_move():
		return
	var move_direction = _get_input_direction() # -1 - left; 0 - idle; 1 - right
	#var crouch_indicator = _get_crouching_index() # 0 - not crouching; -1 - is coruching
	
	animation_tree.set("parameters/Move/blend_position", Vector2(move_direction, 0))

# updates sprite facing direction
func _update_facing_direction():
	if !state_machine.can_face():
		return
	var dir = _get_input_direction()
	if dir > 0: # right
		sprite.flip_h = false
	elif dir < 0: # left
		sprite.flip_h = true
	
	emit_signal("facing_directin_changed", sprite.flip_h)


# to get crouching index if crouching -1 if not 0
func _get_crouching_index():
	if(crouching):
		return -1
	else:
		return 0

# to get direction of player input
func _get_input_direction():
	var right = Input.get_action_strength("right")
	var left = Input.get_action_strength("left")
	var direction = right - left
	
	return direction


func _on_damageable_death():
	state_machine.transition_to("Death")


# to reset character to the starting position (define as you wish)
func _reset():
	$StateMachine.transition_to("Air")
	health.reset()
	stamina.reset()
	#$Chain.release()
	position = last_checkpoint


# to set new checkpoint
func _set_new_checkpoint(new_pos):
	last_checkpoint = new_pos


func jump():
	velocity.y = -JUMP_FORCE

func double_jump():
	velocity.y = -JUMP_FORCE


func attack_check():
	return stamina.check_decrease(attack_stamina)

func dodge_check():
	return stamina.check_decrease(dodge_stamina)

# depricated
func _handle_hook_input(event: InputEvent) -> void:
	pass
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_RIGHT:
			if event.pressed:
			# We clicked the mouse -> shoot()
				$Chain.shoot(event.position - get_viewport().size * 0.5)
			else:
			# We released the mouse -> release()
				$Chain.release()

# depricated
@warning_ignore("unused_parameter")
func manage_hook_physics(delta):
	pass
	if $Chain.hooked:
		# `to_local($Chain.tip).normalized()` is the direction that the chain is pulling
		chain_velocity = to_local($Chain.tip).normalized() * CHAIN_PULL
		
		if chain_velocity.y > 0:
			# Pulling down isn't as strong
			chain_velocity.y *= 0.55
		else:
			# Pulling up is stronger
			chain_velocity.y *= 1.65
		if sign(chain_velocity.x) != _get_input_direction():
			# if we are trying to walk in a different
			# direction than the chain is pulling
			# reduce its pull
			chain_velocity.x *= 0.7
		
	else:
		# Not hooked -> no chain velocity
		chain_velocity = Vector2(0,0)
	
	if $Chain.flying && ($Chain.tip - position).length() >= CHAIN_LENGHT:
		$Chain.release()
	
	velocity += chain_velocity


