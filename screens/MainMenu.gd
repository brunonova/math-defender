extends Control

onready var play_button: Button = $"%PlayButton"
onready var exit_button: Button = $"%ExitButton"
onready var difficulty_slider: HSlider = $"%DifficultySlider"
onready var difficulty_value: Label = $"%DifficultyValue"
onready var speed_slider: HSlider = $"%SpeedSlider"
onready var speed_value: Label = $"%SpeedValue"
onready var sound_button: CheckButton = $"%SoundButton"
onready var music_button: CheckButton = $"%MusicButton"
onready var fullscreen_button: CheckButton = $"%FullscreenButton"


func _ready() -> void:
	play_button.grab_focus()

	# warning-ignore:return_value_discarded
	Config.connect("sound_toggled", self, "_on_Config_sound_toggled")
	# warning-ignore:return_value_discarded
	Config.connect("music_toggled", self, "_on_Config_music_toggled")
	# warning-ignore:return_value_discarded
	Config.connect("fullscreen_toggled", self, "_on_Config_fullscreen_toggled")

	difficulty_slider.max_value = Game.NUM_LEVELS
	difficulty_slider.value = Game.level
	difficulty_value.text = str(Game.level)

	speed_slider.max_value = Game.NUM_SPEEDS
	speed_slider.value = Game.speed
	speed_value.text = str(Game.speed)

	sound_button.pressed = Config.sound.value
	music_button.pressed = Config.music.value
	fullscreen_button.pressed = Config.fullscreen.value

	match OS.get_name():
		"Android":
			fullscreen_button.visible = false
		"HTML5":
			exit_button.visible = false


func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventKey and event.is_action_pressed("ui_cancel") and OS.get_name() != "HTML5":
		get_tree().set_input_as_handled()
		get_tree().quit()
	elif event.is_action_pressed("pause"):
		get_tree().set_input_as_handled()
		_on_PlayButton_pressed()


func _notification(what: int) -> void:
	if what == NOTIFICATION_WM_GO_BACK_REQUEST:
		# Android: when pressing the back button, quit the game
		get_tree().quit()


func _on_DifficultySlider_value_changed(value: float) -> void:
	Game.level = int(value)
	difficulty_value.text = str(int(value))


func _on_SpeedSlider_value_changed(value: float) -> void:
	Game.speed = int(value)
	speed_value.text = str(int(value))


func _on_PlayButton_pressed() -> void:
	Game.to_game_screen()


func _on_ExitButton_pressed() -> void:
	get_tree().quit()


func _on_SoundButton_pressed() -> void:
	Config.sound.value = sound_button.pressed


func _on_MusicButton_pressed() -> void:
	Config.music.value = music_button.pressed


func _on_FullscreenButton_pressed() -> void:
	# Handled differently because of HTML5
	Config.fullscreen.toggle()
	fullscreen_button.pressed = Config.fullscreen.value


func _on_Config_sound_toggled(val: bool) -> void:
	sound_button.pressed = val


func _on_Config_music_toggled(val: bool) -> void:
	music_button.pressed = val


func _on_Config_fullscreen_toggled(val: bool) -> void:
	fullscreen_button.pressed = val
