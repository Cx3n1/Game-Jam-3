extends HBoxContainer

@export
var player : Player

func _process(delta):
	$Bar.value = player.stamina.current_stamina
