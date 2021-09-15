extends StaticBody2D

export(Vector2) var velocity = Vector2.RIGHT

func _ready():
	$Sprite/AnimationPlayer.play("default")

func time_scale_changed(t:float):
	constant_linear_velocity = velocity*t
	$Sprite/AnimationPlayer.playback_speed = t*velocity.normalized().dot(Vector2.RIGHT)

func set_tile(t:int):
	$Sprite.region_rect.position.x = t*64

const frames = [
	preload("res://assets/conveyor/1.png"),
	preload("res://assets/conveyor/2.png"),
	preload("res://assets/conveyor/3.png")
]
func set_frame(f:int):#called from animation
	$Sprite.texture = frames[f]
