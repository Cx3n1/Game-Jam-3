extends Node

class_name Damageable

@export var health : float = 100

var imune = false

signal got_hit
signal death

func hit(damage : int):
	# TODO: do hit animation
	Globs.shake(10, 0.2)
	health -= damage
	if(health <= 0):
		# TODO: do death animation and start timer after which queue free
		imune = false
		emit_signal("death")
		return
	emit_signal("got_hit")
	
