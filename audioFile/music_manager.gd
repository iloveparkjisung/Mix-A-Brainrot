extends Node

@onready var menu_music: AudioStreamPlayer = $MenuMusic
@onready var game_music: AudioStreamPlayer = $GameMusic

func _ready() -> void:
	play_menu_music()

func play_menu_music() -> void:
	menu_music.stop()
	
	if not menu_music.playing:
		menu_music.play()

func play_game_music() -> void:
	menu_music.stop()
	if not game_music.playing:
		game_music.play()
