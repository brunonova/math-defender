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
