extends ParallaxLayer

func _ready():
	_process(Timesaver.time, true)

var time_scale:float = 1
func time_scale_changed(t:float):
	time_scale = t

func _process(delta, fast_forward=false):
	if(not fast_forward):
		Timesaver.time += delta*time_scale
	$secondhand.rotation += delta*time_scale
	$minutehand.rotation += delta*time_scale*(1.0/6.0)
	$hourhand.rotation += delta*time_scale*(1.0/(6.0*6.0))
