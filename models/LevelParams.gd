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
