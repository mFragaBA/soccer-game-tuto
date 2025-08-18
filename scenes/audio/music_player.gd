extends AudioStreamPlayer

enum Music {NONE, GAMEPLAY, MAIN_MENU, TOURNAMENT, WIN}

const MUSIC_MAP : Dictionary = {
	Music.GAMEPLAY: preload("res://assets/assets/music/gameplay.mp3"),
	Music.MAIN_MENU: preload("res://assets/assets/music/menu.mp3"),
	Music.TOURNAMENT: preload("res://assets/assets/music/tournament.mp3"),
	Music.WIN: preload("res://assets/assets/music/win.mp3")
}

var current_music : Music = Music.NONE

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	
func play_music(music: Music) -> void:
	if current_music != music:
		stream = MUSIC_MAP[music]
		current_music = music
		play() 
