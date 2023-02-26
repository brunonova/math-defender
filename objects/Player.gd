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

class_name Player
extends Node2D

signal ammo_changed(ammo)

export(PackedScene) var bullet_scene: PackedScene
# Position2Ds specifying the positions that the player can move to
export(Array, NodePath) var possible_positions: Array
# Initial position index of the player
export(int, 0, 3) var starting_position_index = 1
# Number of bullets per round
export(int, 1, 100) var ammo_per_round = 2

onready var move_sound: AudioStreamPlayer = $MoveSound
onready var shoot_sound: AudioStreamPlayer = $ShootSound
onready var no_ammo_sound: AudioStreamPlayer = $NoAmmoSound
onready var animation_player: AnimationPlayer = $AnimationPlayer

# Positions that the player can move to (Vector2[])
onready var positions: Array = Util.nodepath_array_to_vector2_array(self, possible_positions)
var current_position_index = -1
var ammo: int = 0 setget _set_ammo
var dead := false


func _ready() -> void:
	# Move to the starting position
	move_to_position_index(starting_position_index, false)


func _input(event: InputEvent) -> void:
	if visible and not dead:
		if event.is_action_pressed("move_left"):
			move_to_position_index(current_position_index - 1)
		elif event.is_action_pressed("move_right"):
			move_to_position_index(current_position_index + 1)
		elif event.is_action_pressed("shoot"):
			shoot()


# Moves the ship to the given position index.
func move_to_position_index(index: int, play_sound = true) -> void:
	if index != current_position_index and index >= 0 and index < len(positions):
		current_position_index = index
		position = positions[index]
		if play_sound:
			move_sound.play()


# Sets ammo to 0
func clear_ammo() -> void:
	self.ammo = 0  # self., so the setter triggers


# Reset ammo to default ammo per round
func reset_ammo() -> void:
	self.ammo = ammo_per_round  # self., so the setter triggers


func shoot() -> void:
	if self.ammo > 0:
		var bullet: Bullet = bullet_scene.instance()
		bullet.position = position
		get_parent().add_child(bullet)
		shoot_sound.play()
		self.ammo -= 1  # self., so the setter triggers
	else:
		# No ammo!
		no_ammo_sound.play()


func blink() -> void:
	animation_player.play("blink")


func _set_ammo(val: int) -> void:
	ammo = val
	emit_signal("ammo_changed", ammo)
