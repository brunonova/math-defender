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

class_name Operation
# Contains an operation and it's answer

# The operation
var operation: String
# The correct answer
var answer: int
# The range of possible values for the answers
var answer_range_min: int
var answer_range_max: int


func _init(_operation: String, _answer: int, _answer_range_min: int, _answer_range_max: int) -> void:
	operation = _operation
	answer = _answer
	answer_range_min = _answer_range_min
	answer_range_max = _answer_range_max
