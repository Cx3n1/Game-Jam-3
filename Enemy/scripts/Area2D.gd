extends Area2D


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if get_parent().sprite.flip_h:
		$CollisionShape2D.position = $CollisionShape2D.left_positon
	else:
		$CollisionShape2D.position = $CollisionShape2D.right_positon
	
