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


# Converts a NodePath array to an array of positions (Vector2's)
func nodepath_array_to_vector2_array(node: Node, array: Array) -> Array:
	var res = []
	for node_path in array:
		res.append(node.get_node(node_path).position)
	return res


# Converts a NodePath array to an array of Nodes
func nodepath_array_to_node_array(node: Node, array: Array) -> Array:
	var res = []
	for node_path in array:
		res.append(node.get_node(node_path))
	return res


# Generates a random integer number between the given limits
func randi_range(minimum: int, maximum: int) -> int:
	return (randi() % (maximum - minimum + 1)) + minimum
