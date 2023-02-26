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

class_name PauseScreen
extends CanvasLayer

export(NodePath) var player_nodepath: NodePath
onready var player: Player = get_node(player_nodepath)


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("pause") and player.visible and not player.dead:
		get_tree().set_input_as_handled()
		pause(not visible)


func _notification(what: int) -> void:
	if what == NOTIFICATION_WM_FOCUS_OUT:
		# Pause the game when it loses focus
		pause(true)
	elif what == NOTIFICATION_WM_GO_BACK_REQUEST:
		# Android: when pressing the back button, pause the game or quit to the main menu
		if visible:
			get_tree().paused = false
			Game.to_main_menu_screen()
		else:
			pause(true)


func _on_ContinueButton_pressed() -> void:
	pause(false)


func _on_ExitButton_pressed() -> void:
	get_tree().paused = false
	Game.to_main_menu_screen()


func pause(pause: bool) -> void:
	visible = pause
	get_tree().paused = pause
	if pause:
		$UI/ContinueButton.grab_focus()
