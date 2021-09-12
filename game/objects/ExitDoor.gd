extends Area2D

signal entered
func _on_ExitDoor_body_entered(body):
	if(body.is_in_group("player")):
		emit_signal("entered")
