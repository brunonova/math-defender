# Copyright (C) 2023  Bruno Nova
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <https://www.gnu.org/licenses/>.

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
