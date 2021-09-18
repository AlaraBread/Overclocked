extends ParallaxLayer

func _ready():
	_process(Timesaver.time)

var time_scale:float = 1
func time_scale_changed(t:float):
	time_scale = t

func _process(delta):
	Timesaver.time += delta
	delta *= PI*0.1
	$secondhand.rotation += delta*time_scale
	$minutehand.rotation += delta*time_scale*(1.0/6.0)
	$hourhand.rotation += delta*time_scale*(1.0/(6.0*6.0))
