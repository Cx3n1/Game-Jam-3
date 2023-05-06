extends Node

signal walk_screen_shake(intensity, duration) # global signal

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func shake(intensity, duration):
	emit_signal("walk_screen_shake", intensity, duration)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
