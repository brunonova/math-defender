extends Node

# Operators
const ADD = "+"
const SUB = "-"
const MUL = "×"
const DIV = "÷"

# Flags to define extra behavior and restrictions
const THREE_OPERANDS = 0b1         # operation will have 3 operands
const ANSWER_OPERANDS = 0b10       # the question mark will be one of the operands
const LOW_OPERAND_MUL_DIV = 0b100  # the second operand will not exceed 10 if it's a multiplication or division

# Parameters of each level
# operators, operands_min_value, operands_max_value, result_min_value, result_max_value, flags
var level_params = [
	# Level 1
	LevelParams.new([ADD, SUB], 1, 10, 0, 10),
	# Level 2
	LevelParams.new([ADD, SUB], 1, 20, 0, 20),
	# Level 3
	LevelParams.new([ADD, SUB], 1, 40, 0, 40),
	# Level 4
	LevelParams.new([ADD, SUB, MUL, DIV], 1, 40, 0, 99, LOW_OPERAND_MUL_DIV),
	# Level 5
	LevelParams.new([ADD, SUB, MUL, DIV], 1, 99, 0, 99),
]


# Generates a new operation
func generate_operation(level: int, extra_flags: int) -> Operation:
	# Get the parameters for this level and add the extra flags
	var params: LevelParams = level_params[level - 1]
	var flags = params.flags | extra_flags

	# Initialize variables
	var operators := []
	var operands := []
	var res = -1

	# Decide the number of operands
	var num_operands = 3 if flags & THREE_OPERANDS == THREE_OPERANDS else 2

	# Generate the operators
	if num_operands == 3:
		operators = [_rand_operator(params), _rand_operator(params)]
	else:
		operators = [_rand_operator(params)]

	# Generate the operation and check if valid in a loop
	while true:
		# Generate the operands
		if num_operands == 3:
			operands = [_rand_operand(params), _rand_operand(params), _rand_operand(params)]
		else:
			operands = [_rand_operand(params), _rand_operand(params)]

		# Process LOW_OPERAND_MUL_DIV flag
		if flags & LOW_OPERAND_MUL_DIV == LOW_OPERAND_MUL_DIV:
			for i in len(operators):
				if operators[i] in [MUL, DIV]:
					operands[i + 1] = Util.randi_range(params.operands_min_value, int(min(params.operands_max_value, 10)))

		# Calculate the result and check if the operation is valid
		res = _calc_and_check_valid(params, operators, operands)
		if res is int:
			break

	# Decide the position of the ?, and save the answer
	var answer: int
	if flags & ANSWER_OPERANDS == ANSWER_OPERANDS:
		var index = randi() % len(operands)
		answer = operands[index]
		operands[index] = "?"
	else:
		answer = res
		res = "?"

	# Build the operation string
	var operation: String
	if len(operands) == 3:
		operation = "%s %s %s %s %s = %s" % [operands[0], operators[0], operands[1], operators[1], operands[2], res]
	else:
		operation = "%s %s %s = %s" % [operands[0], operators[0], operands[1], res]

	return Operation.new(operation, answer, params.result_min_value, params.result_max_value)


func _rand_operator(params: LevelParams) -> String:
	return params.operators[randi() % len(params.operators)]


func _rand_operand(params: LevelParams) -> int:
	return Util.randi_range(params.operands_min_value, params.operands_max_value)


# Calculate the operation and check if it's valid
func _calc_and_check_valid(params: LevelParams, operators: Array, operands: Array):
	# Check if the result is inside the range
	if len(operators) == 0:
		return false

	# Check if the operands are inside the range
	for n in operands:
		if n < params.operands_min_value or n > params.operands_max_value:
			return false

	# Calculate the operation
	var res = false
	if len(operands) == 3:
		# First figure out which is the first operation
		if operators[1] in [MUL, DIV] and operators[0] in [ADD, SUB]:
			# It's the second operation
			# Calculate and check the intermediate operation
			var intermediate = _calc(operators[1], operands[1], operands[2])
			if intermediate is bool or intermediate < params.result_min_value or intermediate > params.result_max_value:
				return false

			# Calculate the final operation
			res = _calc(operators[0], operands[0], intermediate)
		else:
			# It's the first operation
			# Calculate and check the intermediate operation
			var intermediate = _calc(operators[0], operands[0], operands[1])
			if intermediate is bool or intermediate < params.result_min_value or intermediate > params.result_max_value:
				return false

			# Calculate the final operation
			res = _calc(operators[1], intermediate, operands[2])
	else:  # Two operands
		res = _calc(operators[0], operands[0], operands[1])

	# Check if the result is inside the range
	if res is bool or res < params.result_min_value or res > params.result_max_value:
		return false

	return res


func _calc(operator: String, n1: int, n2: int):
	match operator:
		ADD:
			return n1 + n2
		SUB:
			return n1 - n2
		MUL:
			if n1 == 0 or n2 == 0:
				return false  # to prevent ? x 0 or 0 x ?, which could be any value
			return n1 * n2
		DIV:
			if n1 == 0 or n2 == 0:
				return false  # to prevent ? / 0 or 0 / ?, which could be any value, and divisions by zero
			elif n1 % n2 != 0:
				return false  # result not integer!
			else:
				# warning-ignore:integer_division
				return n1 / n2
