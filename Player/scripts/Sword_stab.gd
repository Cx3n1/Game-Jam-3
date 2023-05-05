extends Area2D


@export
var standard_damage = 5
# todo add crit chances and stuff

@export
var hitbox : FacingCollisionShape

@onready
var player = self.get_parent() as Player


func _ready() -> void:
	player.connect("facing_directin_changed", _on_facing_direction_changed) 


func _on_body_entered(body: Node2D) -> void:
	for child in body.get_children():
		if child is Damageable:
			child.hit(standard_damage)

func _on_facing_direction_changed(facing_left):
	if facing_left:
		hitbox.position = hitbox.facing_left_position
	else:
		hitbox.position = hitbox.facing_right_position
