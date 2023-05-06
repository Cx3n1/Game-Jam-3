extends Node

class_name Damageable

@export var health : float = 100


func hit(damage : int):
	# TODO: do hit animation
	Globs.shake(10, 0.2)
	health -= damage
	
	if(health <= 0):
		# TODO: do death animation and start timer after which queue free
		print("aqlemi")
		get_parent().queue_free()

	


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
