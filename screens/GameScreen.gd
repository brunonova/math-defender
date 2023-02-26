extends Node

export(PackedScene) var bomb_scene: PackedScene
# Width of a bullet in the ammo bar
export(int, 0, 100) var ammo_width = 20
# Position2Ds specifying the positions where the bombs will spawn
export(Array, NodePath) var possible_bomb_positions: Array
# The music of each difficulty level
export(Array, NodePath) var musics_paths: Array
export(int, 1, 50) var initial_lives = 5
export(int, 1, 99) var max_lives = 99
export(float, 0.0, 1.0) var probability_second_bomb_same_last_digit = 0.7
export(float, 0.0, 1.0) var probability_third_bomb_close_to_answer = 0.7
export(float, 0.0, 200.0) var speed_per_level_after_last_level = 20.0

# Operation flags per round
export(Array, int) var round_flags = [
	0,
	0,
	0,
	0,
	0,
	0,
	0,
	0,
	0,
	0,
	OperationGenerator.ANSWER_OPERANDS,
	OperationGenerator.ANSWER_OPERANDS,
	OperationGenerator.ANSWER_OPERANDS,
	OperationGenerator.ANSWER_OPERANDS,
	OperationGenerator.ANSWER_OPERANDS,
	OperationGenerator.THREE_OPERANDS,
	OperationGenerator.THREE_OPERANDS,
	OperationGenerator.THREE_OPERANDS,
	OperationGenerator.ANSWER_OPERANDS | OperationGenerator.THREE_OPERANDS,
	OperationGenerator.ANSWER_OPERANDS | OperationGenerator.THREE_OPERANDS,
]

# Parameters for the camera shake when the bombs hit the ground
export(int, 0, 100) var camera_shake_iterations = 8
export(float, 0.0, 1000.0) var camera_shake_max_offset = 25.0
export(float, 0.0, 2.0) var camera_shake_iteration_duration = 0.05

onready var camera: Camera2D = $Camera
onready var new_round_timer: Timer = $Timers/NewRoundTimer
onready var new_level_timer: Timer = $Timers/NewLevelTimer
onready var game_over_music: AudioStreamPlayer = $Audio/GameOverMusic
onready var pause_screen: PauseScreen = $"%PauseScreen"
onready var flash_animation: AnimationPlayer = $"%FlashAnimation"
onready var level_up_layer: CanvasLayer = $"%LevelUpLayer"
onready var level_up_label: Label = $"%LevelUpLabel"
onready var game_over_animation: AnimationPlayer = $"%GameOverAnimation"
onready var operation_label: Label = $"%OperationLabel"
onready var operation_animation: AnimationPlayer = $"%OperationAnimation"
onready var level_label: Label = $"%LevelLabel"
onready var score_label: Label = $"%ScoreLabel"
onready var high_score_label: Label = $"%HighScoreLabel"
onready var high_score_animation: AnimationPlayer = $"%HighScoreAnimation"
onready var ammo_bar: TextureRect = $"%AmmoBar"
onready var lives_label: Label = $"%LivesLabel"
onready var player: Player = $"%Player"


# Positions where the bombs will spawn (Vector2[])
onready var bomb_positions: Array = Util.nodepath_array_to_vector2_array(self, possible_bomb_positions)
# The music of each difficulty level
onready var musics: Array = Util.nodepath_array_to_node_array(self, musics_paths)
var current_music: AudioStreamPlayer

var lives: int setget _set_lives
var score: int = 0 setget _set_score
var rounds := 0
var bombs_hit := 0
var is_highscore := false  # true when the score surpasses the highscore
var extra_speed := 0  # extra speed level after the last difficulty and speed level


func _ready() -> void:
	self.lives = initial_lives
	_update_highscore_label()
	_update_level_hud()
	_play_music()
	player.clear_ammo()
	_new_round()


func _on_correct_bomb_hit() -> void:
	bombs_hit += 1

	# Hide the operation and set player ammo to 0, and flash the screen
	operation_animation.play("hide")
	player.clear_ammo()
	flash_animation.play("flash_white")

	# Delete all other bombs
	for bomb in get_tree().get_nodes_in_group("bombs"):
		if bomb is Bomb and not bomb.is_correct_bomb:
			bomb.queue_free()

	# Increase the score
	self.score += 4 + Game.level * Game.NUM_SPEEDS + Game.speed + extra_speed

	# Start the next round (after a small delay)
	_new_round_after_delay()


func _on_Player_ammo_changed(ammo) -> void:
	# Update the ammo bar
	ammo_bar.rect_size.x = ammo_width * ammo


func _on_LoseArea_area_entered(area: Area2D) -> void:
	if area.is_in_group("bombs") and area.is_correct_bomb and not area.dead:
		# Bomb reached the ground!
		# Hide the operation and set player ammo to 0
		operation_animation.play("hide")
		player.clear_ammo()

		# Destroy all bombs, shake the screen and blink the player
		get_tree().call_group("bombs", "destroy")

		# Shake the screen
		_shake_camera()

		# Lose a life and check game over
		self.lives -= 1
		if lives > 0:
			# Flash the screen and blink the player
			flash_animation.play("flash_red")
			player.blink()

			# Start the next round (after a small delay)
			_new_round_after_delay()
		else:
			# Game Over!
			player.dead = true
			if current_music:
				current_music.stop()
			game_over_music.play()
			game_over_animation.play("show")
			yield(game_over_animation, "animation_finished")
			Game.to_main_menu_screen()


func _on_PauseButton_pressed() -> void:
	pause_screen.pause(true)


func _new_round() -> void:
	rounds += 1

	# Generate the operation
	var operation := OperationGenerator.generate_operation(Game.level, round_flags[rounds - 1])

	# Update the operation on the screen
	operation_label.text = operation.operation

	# Start the animation to show the operation and wait for it to finish
	operation_animation.play("show")
	yield(operation_animation, "animation_finished")

	# Add the correct answer to the options
	var options = []
	options.append(operation.answer)

	# Add the other random options
	var second_bomb_same_last_digit = operation.answer_range_max > 20 and randf() <= probability_second_bomb_same_last_digit
	var third_bomb_close_to_answer = randf() < probability_third_bomb_close_to_answer
	while len(options) < len(bomb_positions):
		var n: int
		if len(options) == 2 and third_bomb_close_to_answer:
			# Make this bomb be close to the answer
			var difference = Util.randi_range(1, 3)
			n = operation.answer + (difference if randf() <= 0.5 else -difference)
		else:
			# Generate a random number
			n = Util.randi_range(operation.answer_range_min, operation.answer_range_max)
		if len(options) == 1 and second_bomb_same_last_digit:
			# Make this bomb have the same last digit as the answer
			var digit = operation.answer % 10
			n = n - (n % 10) + digit
		if not n in options and n >= operation.answer_range_min and n <= operation.answer_range_max:
			options.append(n)

	# Shuffle the options
	options.shuffle()

	# Spawn the bombs and reset the player ammo
	_spawn_bombs(options, operation.answer)
	player.reset_ammo()


func _new_round_after_delay() -> void:
	new_round_timer.start()
	yield(new_round_timer, "timeout")
	var rounds_per_level = len(round_flags)

	if rounds >= rounds_per_level:
		# Speed level complete: go to next speed/difficulty level
		rounds = 0

		# Show the level up screen for a few seconds
		player.visible = false
		level_up_layer.visible = true
		var key: String
		if bombs_hit == rounds_per_level:
			key = "PERFECT"
		elif bombs_hit >= rounds_per_level - 2:
			key = "GREAT"
		elif bombs_hit >= rounds_per_level - 4:
			key = "GOOD"
		else:
			key = "REASONABLE"
		level_up_label.text = tr(key)
		new_level_timer.start()
		yield(new_level_timer, "timeout")
		level_up_layer.visible = false
		player.visible = true
		bombs_hit = 0

		# Add a new life
		if lives < max_lives:
			self.lives += 1

		if Game.level < Game.NUM_LEVELS or Game.speed < Game.NUM_SPEEDS:
			Game.speed += 1
			if Game.speed > Game.NUM_SPEEDS:
				Game.speed = 1
				Game.level += 1
			_play_music()
		else:
			# It's the last level and speed: add more speed
			extra_speed += 1

		# Update the HUD
		_update_level_hud()

		# Start the new round
		_new_round()
	else:
		# New round
		_new_round()


func _spawn_bombs(numbers: Array, correct_number: int) -> void:
	for index in len(numbers):
		var number = numbers[index]
		var bomb: Bomb = bomb_scene.instance()
		add_child(bomb)
		bomb.position = bomb_positions[index]
		bomb.number = number
		bomb.is_correct_bomb = number == correct_number
		if bomb.is_correct_bomb:
			# warning-ignore:return_value_discarded
			bomb.connect("hit", self, "_on_correct_bomb_hit")
		if extra_speed > 0:
			# Add extra speed to the bomb
			bomb.speed += extra_speed * speed_per_level_after_last_level


func _shake_camera() -> void:
	var tween := create_tween()
	var offset = camera_shake_max_offset
	var reduce_offset = camera_shake_max_offset / camera_shake_iterations
	for i in camera_shake_iterations:
		# warning-ignore:return_value_discarded
		tween.tween_property(camera, "offset", Vector2(offset, 0).rotated(rand_range(0, 2 * PI)), camera_shake_iteration_duration)
		offset -= reduce_offset
	# warning-ignore:return_value_discarded
	tween.tween_property(camera, "offset", Vector2.ZERO, camera_shake_iteration_duration)


func _update_highscore_label() -> void:
	high_score_label.text = tr("BEST") % Config.highscore.value


func _update_level_hud() -> void:
	level_label.text = tr("LVL") % [Game.level, Game.speed + extra_speed]


func _play_music() -> void:
	# Stop all music nodes
	if current_music:
		current_music.stop()

	# Play the music for the current difficulty level
	current_music = musics[Game.speed - 1]
	current_music.play()


func _set_lives(val: int) -> void:
	lives = val
	lives_label.text = "× %s" % val


func _set_score(val: int) -> void:
	score = val
	score_label.text = str(val)

	# Check/update the highscore
	if score > Config.highscore.value:
		Config.highscore.value = score
		_update_highscore_label()
		if not is_highscore:
			is_highscore = true
			high_score_animation.play("highscore")
