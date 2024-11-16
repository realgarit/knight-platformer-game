extends Area2D

signal mushroom_jumped

@onready var animated_sprite_2d = $AnimatedSprite2D
var animation_played = false

func _ready():
	connect("body_entered", Callable(self, "_on_body_entered"))
	animated_sprite_2d.connect("animation_finished", Callable(self, "_on_animation_finished"))

func _on_body_entered(body):
	if body is CharacterBody2D and not animation_played:
		animated_sprite_2d.play("squish")
		emit_signal("mushroom_jumped", body)
		animation_played = true

func _on_animation_finished():
	# Reset the state so the animation can play again on the next collision
	animation_played = false
