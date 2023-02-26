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

extends Control
# Area to move and shoot with the mouse or touch

export(int, 0, 3) var position_index = 0
export(NodePath) var player_nodepath

onready var _player = get_node(player_nodepath) as Player


func _on_MouseAreaPlayer_mouse_entered() -> void:
	#_player.move_to_position_index(position_index)
	pass


func _on_MouseAreaPlayer_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.pressed and event.button_index == BUTTON_LEFT:
			_player.move_to_position_index(position_index)
			_player.shoot()
