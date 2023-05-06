extends State

class_name HitState

@export var damageable : Damageable
@export var dead_state : State
@export var dead_animation_node : String = "dead"
@export var knockback_velocity :Vector2 = Vector2(100,0)
@export var return_state : State

# Called when the node enters the scene tree for the first time.
func _ready():
	damageable.connect("on_hit",on_damageable_hit)

func on_enter():
	character.velocity = knockback_velocity


func on_damageable_hit(node : Node, damage_amount : int):
	if damageable.health > 0:
		emit_signal("interrupt_state", self)
	else :
		emit_signal("interrupt_state", self)
		playback.travel(dead_animation_node)



func on_exit():
	character.velocity = Vector2.ZERO


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_timer_timeout():
	next_state = return_state
