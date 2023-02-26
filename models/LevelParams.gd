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

class_name LevelParams
# Defines the parameters of operations to generate for a level and sublevel

var operators: Array
var operands_min_value: int
var operands_max_value: int
var result_min_value: int
var result_max_value: int
var flags: int  # flags to define extra behavior and restrictions


func _init(_operators: Array, _operands_min_value: int, _operands_max_value: int, _result_min_value: int, _result_max_value: int, _flags: int = 0) -> void:
	operators = _operators
	operands_min_value = _operands_min_value
	operands_max_value = _operands_max_value
	result_min_value = _result_min_value
	result_max_value = _result_max_value
	flags = _flags
