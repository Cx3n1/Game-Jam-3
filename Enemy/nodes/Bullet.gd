extends Area2D

const RIGHT = Vector2.RIGHT
@export
var SPEED = 200


func _physics_process(delta):
	var movement = RIGHT.rotated(rotation) * SPEED * delta
	global_position += movement

func destroy():
	queue_free()
	pass

func _on_VisibilityNotifier2D_screen_exited():
	#queue_free()
	pass

func _on_Bullet_body_entered(body):
	for child in body.get_children():
		if child is Damageable_player:
			child.hit(20)
	destroy()
