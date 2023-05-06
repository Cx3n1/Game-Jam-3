extends HBoxContainer


@export
var player : Player

func _process(delta):
	$Bar.value = player.health.current_health
