extends CharacterBody2D

# Constants
const SPEED = 120.0
const CHASE_DISTANCE = 100.0
const IDLE_TIME = 3
const GAP_BETWEEN_ENEMY_AND_PLAYER = 20
const DAMAGE = 30
const INSPECTING_RADIUS = 50
const PATROL_DISTANCE = 75
const RANGED_ATTACK_DISTANCE = 60
const RANGED_ATTACK_COOLDOWN = 3.0
const ATTACK_INTERVAL = 1

# Variables
@onready var sprite = $Sprite
@onready var playback = $AnimationTree.get("parameters/playback")
@export var player: Player
@onready var damageable = $Damageable
var direction = 1
var state = "idle"
var radius_where_enemy_inspecting = 0
var gravity: int = ProjectSettings.get_setting("physics/2d/default_gravity")
var ranged_attack_timer = 0.0

func _ready() -> void:
	$AnimationTree.active = true
	$Timer.start(IDLE_TIME)

func _physics_process(delta: float) -> void:
	if not is_on_floor():  # if enemy is not on the ground apply gravity
		velocity.y += gravity

	# Choose behavior based on current state
	match state:
		"idle":
			velocity.x = move_toward(velocity.x, 0, SPEED) # Move towards 0 with given speed
			#playback.travel("Move", 0)
		"patrol":
			velocity.x = direction * SPEED # Move in patrol direction with given speed
			if abs(position.x - player.poosition.x) > PATROL_DISTANCE: # If enemy exceeds the patrol distance, change direction
				direction = -direction
			#playback.travel("Move", clamp(velocity.x, -1, 1))
		"chase":
			# If distance is less then actual gap then always move in opposite direction of the player 		
			direction = sign(player.position.x - position.x)
			velocity.x = direction * SPEED
			radius_where_enemy_inspecting = radius_where_enemy_inspecting - 1 if direction == -1 else radius_where_enemy_inspecting + 1
			#playback.travel("Move", clamp(velocity.x, -1, 1))
			# Ranged attack if cooldown has elapsed and player is within range
			if ranged_attack_timer <= 0 and position.distance_to(player.position) < RANGED_ATTACK_DISTANCE:
				ranged_attack()
				ranged_attack_timer = RANGED_ATTACK_COOLDOWN
		
	if abs(position.x - player.position.x) < GAP_BETWEEN_ENEMY_AND_PLAYER:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	_update_facing_direction()

	move_and_slide() # Move the enemy with slide effect

	# Update the animation
	_update_animation()

	

func _update_animation():
	if state != "attack":
		$AnimationTree.set("parameters/Move/blend_position", direction)

func _update_facing_direction():
	if direction > 0:  # right
		$Sprite.flip_h = false
	elif direction < 0:  # left
		$Sprite.flip_h = true

func _on_timer_timeout() -> void:
	$Timer.start(IDLE_TIME)
	if state == "idle":
		state = "patrol"
	elif state == "patrol":
		state = "idle"

func ranged_attack():
	# TODO: Implement ranged attack logic here
	pass
	
func _process(delta: float):
	# Check the distance between the enemy and the player
	var distance_between_player_and_enemy = position.distance_to(player.position)

	# Choose behavior based on distance and state
	if state == "chase" and CHASE_DISTANCE < distance_between_player_and_enemy or distance_between_player_and_enemy < GAP_BETWEEN_ENEMY_AND_PLAYER and INSPECTING_RADIUS > abs(radius_where_enemy_inspecting):
		state = "idle"
	else:
		state = "chase"
	
	# TODO: Check for collision with other objects
	# TODO: Handle collision with other objects
	# TODO: Implement


func _on_area_2d_body_entered(body):
	for child in body.get_children():
		if child is Damageable_player:
			child.hit(DAMAGE)


func _on_animation_tree_animation_finished(anim_name):
	#if state == "attack" && anim_name == "Attack":
	#	state = "idle"
	$AttackTimer.start(ATTACK_INTERVAL)



func _on_detector_body_entered(body):
	state = "attack"
	playback.travel("Attack")


func _on_detector_body_exited(body):
	state == "idle"


func _on_attack_timer_timeout():
	playback.travel("Attack")
