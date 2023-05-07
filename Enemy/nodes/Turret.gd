extends Node2D

@export
var BULLET: PackedScene = null

var target: Node2D = null

@onready var gunSprite = $GunSprite
@onready var rayCast = $RayCast2D
@onready var reloadTimer = $RayCast2D/ReloadTimer

func _ready():
	pass

func shoot_towards(position):
	var angle_to_target: float = global_position.direction_to(position).angle()
	rayCast.global_rotation = angle_to_target
	
	if BULLET:
		var bullet = BULLET.instantiate()
		get_tree().current_scene.add_child(bullet)
		bullet.global_position = global_position
		bullet.global_rotation = rayCast.global_rotation

func shoot_reload(position):
	var angle_to_target: float = global_position.direction_to(position).angle()
	rayCast.global_rotation = angle_to_target
	rayCast.enabled = false
	
	if BULLET:
		var bullet = BULLET.instantiate()
		get_tree().current_scene.add_child(bullet)
		bullet.global_position = global_position
		bullet.global_rotation = rayCast.global_rotation
	
	reloadTimer.start()


func _on_ReloadTimer_timeout():
	rayCast.enabled = true
