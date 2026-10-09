extends Node

@onready var menu_music: AudioStreamPlayer = $MenuMusic
@onready var game_music: AudioStreamPlayer = $GameMusic

func _ready() -> void:
	menu_music.finished.connect(_on_menu_music_finished)
	game_music.finished.connect(_on_game_music_finished)
	play_menu_music()

func play_menu_music() -> void:
	game_music.stop()
	menu_music.play()

func play_game_music() -> void:
	menu_music.stop()
	game_music.play()

func _on_menu_music_finished() -> void:
	menu_music.play()

func _on_game_music_finished() -> void:
	game_music.play()
