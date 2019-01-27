extends Sprite

onready var audio_sources = [
	$Misc/Mom/AudioStreamPlayer2D3,
	$Misc/Kitty/AudioStreamPlayer2D2,
	$Misc/Fire/AudioStreamPlayer2D
]

func stop_all_sounds():
	for source in audio_sources:
		source.playing = false
	
func play_all_sounds():
	for source in audio_sources:
		source.playing = true