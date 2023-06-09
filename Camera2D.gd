extends Camera2D

#variables
@onready var shake_timer = $Timer
@onready var shake_intensity = 5

var default_offset = offset


@export var intensity = 5
@export var shake_time = 0.2

# Called when the node enters the scene tree for the first time.
func _ready():
	Globs.connect("walk_screen_shake", shake)
	set_process(false)
	randomize()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var shake_vector = Vector2(randf_range(-1,1)* shake_intensity, randf_range(-1,1)*shake_intensity)
	var tween = create_tween()
	tween.tween_property(self,"offset",shake_vector,0.1)


func shake(intensity, duration):
	shake_intensity = intensity
	set_process(true)
	shake_timer.start(duration)


func _on_timer_timeout():
	set_process(false)
	var tween = create_tween()
	tween.tween_property(self,"offset",default_offset,0.1)


