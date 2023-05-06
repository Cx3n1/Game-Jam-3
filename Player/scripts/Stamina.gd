extends Node

class_name Stamina

@export
var MAX_STAMINA = 100

@export
var STAMINA_INCREASE = 30

@export
var STAMINA_COOLDOWN = 1.5 # after what time does stamina increase

@onready
var timer = $Timer

var current_stamina

var recover = false

# Called when the node enters the scene tree for the first time.
func _ready():
	current_stamina = MAX_STAMINA


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if recover && current_stamina < MAX_STAMINA:
		current_stamina += STAMINA_INCREASE*delta


func reset():
	current_stamina = MAX_STAMINA
	timer.stop()


func check_decrease(value):
	if(have_enough(value)):
		decrease(value)
		return true
	return false


func have_enough(value):
	return current_stamina - value >= 0

func decrease(value):
	current_stamina -= value
	timer.start(STAMINA_COOLDOWN)
	recover = false
	


func _on_timer_timeout():
	recover = true
