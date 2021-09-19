extends Node

var songs = [preload("res://assets/music/StageOne.wav")]
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
