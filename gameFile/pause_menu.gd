extends CanvasLayer

@onready var menu_panel = $MenuPanel

@onready var resume_button = $MenuPanel/ResumeButton
@onready var settings_button = $MenuPanel/SettingsButton
@onready var quit_button = $MenuPanel/QuitButton

@onready var settings_panel = $SettingsPanel
@onready var back_button = $SettingsPanel/BackButton
@onready var volume_slider = $SettingsPanel/VolumeSlider
@onready var volume_value = $SettingsPanel/VolumeValue

const MUSIC_BUS_NAME = "Music"

func _ready():
	process_mode = Node.PROCESS_MODE_ALWAYS
	menu_panel.hide()
	settings_panel.hide()
	volume_slider.min_value = 0
	volume_slider.max_value = 100
	volume_slider.step = 1
	resume_button.pressed.connect(resume_game)
	settings_button.pressed.connect(open_settings)
	quit_button.pressed.connect(quit_game)
	back_button.pressed.connect(back_to_menu)
	volume_slider.value_changed.connect(change_music_volume)
	var bus_index = AudioServer.get_bus_index(MUSIC_BUS_NAME)
	if bus_index >= 0:
		var db = AudioServer.get_bus_volume_db(bus_index)
		var volume_percent = db_to_linear(db) * 100.0
		volume_slider.value = clampf(volume_percent, 0.0, 100.0)
	change_music_volume(volume_slider.value)
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func _input(event):
	if event is InputEventKey:
		if event.pressed and not event.echo:
			if event.keycode == KEY_ESCAPE:
				if settings_panel.visible:
					back_to_menu()
				elif menu_panel.visible:
					resume_game()
				else:
					open_pause_menu()

				get_viewport().set_input_as_handled()

func open_pause_menu():
	menu_panel.show()
	settings_panel.hide()
	get_tree().paused = true
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE

func resume_game():
	menu_panel.hide()
	settings_panel.hide()
	get_tree().paused = false
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func open_settings():
	menu_panel.hide()
	settings_panel.show()

func back_to_menu():
	settings_panel.hide()
	menu_panel.show()

func change_music_volume(value: float):
	volume_value.text = str(int(value)) + "%"
	var bus_index = AudioServer.get_bus_index(MUSIC_BUS_NAME)
	if bus_index < 0:
		push_warning("No audio bus named Music was found.")
		return
	if value <= 0:
		AudioServer.set_bus_volume_db(bus_index, -80.0)
	else:
		AudioServer.set_bus_volume_db(
			bus_index,
			linear_to_db(value / 100.0)
		)

func quit_game():
	get_tree().quit()
