extends Node

class_name Damageable_player

signal death

@export var MAX_HEALTH : float = 100

@export
var HEALTH_INCREASE = 5

@export
var HEALTH_COOLDOWN = 1 # after what time does stamina increase

@onready
var timer = $Timer

@onready
var character : Player = get_parent()

var current_health

var recover = false

# Called when the node enters the scene tree for the first time.
func _ready():
	current_health = MAX_HEALTH

func hit(damage : int):
	if get_parent().state_machine.current_state.is_imune:
		return
	
	# TODO: do hit animation
	Globs.shake(5, 0.2)
	
	if(character.is_on_floor()):
		character.state_machine.current_state.playback.travel("Hurt_ground")
	else:
		character.state_machine.current_state.playback.travel("Hurt_air")
	
	current_health -= damage
	
	
	if(current_health <= 0):
		# TODO: do death animation and start timer after which queue free
		emit_signal("death")
		timer.stop()
		recover = false
		return
	
	recover = false
	timer.start(HEALTH_COOLDOWN)
	
func reset():
	current_health = MAX_HEALTH
	timer.stop()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if recover && current_health < MAX_HEALTH:
		current_health += HEALTH_INCREASE*delta


func _on_timer_timeout():
	recover = true

