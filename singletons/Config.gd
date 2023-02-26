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

signal sound_toggled(sound)
signal music_toggled(music)
signal fullscreen_toggled(fullscreen)

const GAME_SECTION = "Game"
const OPTIONS_SECTION = "Options"

export var config_path := "user://math-defender.options.cfg"
export var config_pass := "7e'{fI69-)"
var config := ConfigFile.new()

var level := Option.new(self, GAME_SECTION, "level", 1)
var speed := Option.new(self, GAME_SECTION, "speed", 1)
var highscore := Option.new(self, GAME_SECTION, "highscore", 0)

var sound := Option.new(self, OPTIONS_SECTION, "sound", true, "_sound_changed")
var music := Option.new(self, OPTIONS_SECTION, "music", true, "_music_changed")
var _store_fullscreen := not OS.get_name() in ["Android", "HTML5"]
var fullscreen := Option.new(self, OPTIONS_SECTION, "fullscreen", _store_fullscreen, "_fullscreen_changed", _store_fullscreen)


func _ready() -> void:
	# warning-ignore:return_value_discarded
	config.load_encrypted_pass(config_path, config_pass)

	_sound_changed(sound.value)
	_music_changed(music.value)
	_fullscreen_changed(fullscreen.value)


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("fullscreen") and OS.get_name() != "Android":
		get_tree().set_input_as_handled()
		Config.fullscreen.toggle()


func _sound_changed(val: bool) -> void:
	AudioServer.set_bus_mute(AudioServer.get_bus_index("Sound"), not val)
	emit_signal("sound_toggled", val)


func _music_changed(val: bool) -> void:
	AudioServer.set_bus_mute(AudioServer.get_bus_index("Music"), not val)
	emit_signal("music_toggled", val)


func _fullscreen_changed(val: bool) -> void:
	OS.window_fullscreen = val
	emit_signal("fullscreen_toggled", val)
