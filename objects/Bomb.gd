class_name Bomb
extends Area2D

# Emitted when the bomb is hit
signal hit

# Speeds for each game speed level
export(Array, float) var speeds

# Falling speed of the bomb
onready var speed = speeds[Game.speed - 1]
# Whether this is the correct bomb
var is_correct_bomb = false
# The number on the bomb
var number = 0 setget _set_number, _get_number
var dead = false


func _process(delta: float) -> void:
	if not dead:
		position.y += speed * delta


func _on_Bomb_area_entered(area: Area2D) -> void:
	if area.is_in_group("bullets") and not dead:
		area.queue_free()  # delete the bullet
		destroy()
		emit_signal("hit")


func destroy(play_sound = true) -> void:
	# Hide and disable the bomb
	dead = true
	$Sprite.visible = false
	$Label.visible = false
	$CollisionShape2D.set_deferred("disabled", true)

	# Play the explosion animation
	var explosion: AnimatedSprite = $Explosion
	var explosion_scale = 2.0 if is_correct_bomb else 0.75
	explosion.visible = true
	explosion.play("default")
	explosion.scale = Vector2(explosion_scale, explosion_scale)
	explosion.rotation = rand_range(0, 2 * PI)

	if play_sound:
		# Play the explosion sound
		var sound: AudioStreamPlayer = $RightBombSound if is_correct_bomb else $WrongBombSound
		sound.play()


func _on_Explosion_animation_finished() -> void:
	queue_free()


func _set_number(val: int) -> void:
	number = val
	$Label.text = str(val)

func _get_number() -> int:
	return number
