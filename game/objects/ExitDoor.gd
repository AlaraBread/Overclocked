extends Area2D

export(bool) var flipped = false
signal entered

func _ready():
	if(flipped):
		var tmp = $EnterPos.position
		$EnterPos.position = $DonePos.position
		$DonePos.position = tmp
		$Back.flip_h = true
		$Front.flip_h = true
	set_process(false)

var player
var initial_dist:float
var speed = 0.1
func _on_ExitDoor_body_entered(body):
	if(body.is_in_group("player")):
		$SFXTimer.start()
		player = body
		body.dummy_mode()
		initial_dist = player.position.distance_to($EnterPos.global_position)
		set_process(true)

var state = 0
func _process(delta):
	match state:
		0:
			player.position = lerp(player.position, $EnterPos.global_position, speed*initial_dist*delta)
			if(player.position.distance_squared_to($EnterPos.global_position) < 10):
				state = 1
		1:
			player.position = lerp(player.position, $DonePos.global_position, speed*64*delta)
			if(player.position.distance_squared_to($DonePos.global_position) < 10):
				emit_signal("entered")
				set_process(false)

func _on_SFXTimer_timeout():
	$EnterPlayer.play()
