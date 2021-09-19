extends Node

var songs = [
		preload("res://assets/music/StageOne.wav"),
		preload("res://assets/music/youwinintro.wav"),
		preload("res://assets/music/youwinloop.wav")]
var cur_song = -1
func music(id:int):
	if(id == cur_song):
		return
	cur_song = id
	if(id == -1):
		$MusicPlayer.stop()
	else:
		$MusicPlayer.stream = songs[id]
		$MusicPlayer.play()

func click():
	$Click.play()

func vol(v):
	$MusicPlayer.volume_db = linear2db(v)

func _on_MusicPlayer_finished():
	if(cur_song == 1):
		music(2)
