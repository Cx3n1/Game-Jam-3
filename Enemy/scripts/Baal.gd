extends CharacterBody2D


const SPEED = 80.0

@onready
var playback = $AnimationTree.get("parameters/playback")

var direction = 1

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity: int = ProjectSettings.get_setting("physics/2d/default_gravity")


func _ready() -> void:
	$AnimationTree.active = true
	$Timer.start()

func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity.y += gravity

	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
	
	move_and_slide()
	
	_update_animation()
	_update_facing_direction()
	

func _update_animation():
	$AnimationTree.set("parameters/move/blend_position", direction)

func _update_facing_direction():
	if direction > 0: # right
		$Sprite.flip_h = false
	elif direction < 0: # left
		$Sprite.flip_h = true


func _on_timer_timeout() -> void:
	var rand = RandomNumberGenerator.new()
	
	direction = rand.randi_range(-1,1)
	
	$Timer.start()
