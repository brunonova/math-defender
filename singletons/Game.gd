extends Node

const NUM_SPEEDS = 5
const NUM_LEVELS = 5
const NUM_SUBLEVELS = 3

# Current difficulty level
var level setget _set_level, _get_level
# Current game speed
var speed setget _set_speed, _get_speed


func _ready() -> void:
	randomize()


func to_main_menu_screen() -> void:
	# warning-ignore:return_value_discarded
	get_tree().change_scene("res://screens/MainMenu.tscn")


func to_game_screen() -> void:
	# warning-ignore:return_value_discarded
	get_tree().change_scene("res://screens/GameScreen.tscn")


func _set_level(val: int) -> void:
	Config.level.value = val

func _get_level() -> int:
	return Config.level.value


func _set_speed(val: int) -> void:
	Config.speed.value = val

func _get_speed() -> int:
	return Config.speed.value
