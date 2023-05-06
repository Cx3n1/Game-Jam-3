extends GPUParticles2D


@export
var left_position : Vector2

@export
var right_positon : Vector2


func set_to_left():
	self.process_material.direction.x = -1
	self.position = left_position

func set_to_right():
	self.process_material.direction.x = 1
	self.position = right_positon


