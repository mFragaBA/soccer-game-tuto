extends Node

enum Sound { BOUNCE, HURT, PASS, POWERSHOT, SHOT, TACKLING, UI_NAV, UI_SELECT, WHISTLE }

const N_CHANNELS := 4
const SFX_MAP : Dictionary = {
	Sound.BOUNCE: preload("res://assets/assets/sfx/bounce.wav"),
	Sound.HURT: preload("res://assets/assets/sfx/hurt.wav"),
	Sound.PASS: preload("res://assets/assets/sfx/pass.wav"),
	Sound.POWERSHOT: preload("res://assets/assets/sfx/power-shot.wav"),
	Sound.SHOT: preload("res://assets/assets/sfx/shoot.wav"),
	Sound.TACKLING: preload("res://assets/assets/sfx/tackle.wav"),
	Sound.UI_NAV: preload("res://assets/assets/sfx/ui-navigate.wav"),
	Sound.UI_SELECT: preload("res://assets/assets/sfx/ui-select.wav"),
	Sound.WHISTLE: preload("res://assets/assets/sfx/whistle.wav"),
}

var stream_players : Array[AudioStreamPlayer] = []

func _ready() -> void:
	for i in range(N_CHANNELS):
		var stream_player := AudioStreamPlayer.new()
		stream_players.append(stream_player)
		add_child(stream_player)
	
func play(sound: Sound) -> void:
	var available_audio_stream := find_fist_available_player()
	if available_audio_stream != null:
		available_audio_stream.stream = SFX_MAP[sound]
		available_audio_stream.play()	
	
# returns an available audiostreamplayer or null if none are available	
func find_fist_available_player() -> AudioStreamPlayer:
	for player in stream_players:
		if not player.playing:
			return player
			
	return null
	
