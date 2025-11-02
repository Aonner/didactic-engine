extends Area2D

## Vine Obstacle - Can be cut with machete (shared ability for both characters)

@export var health: int = 3  # Number of slashes needed
@onready var sprite: Node2D = $Sprite

signal vine_cut

func _ready():
	add_to_group("vine_obstacle")

func take_damage(amount: int):
	health -= 1
	print("Vine slashed! Remaining: ", health)

	# Visual feedback - vine getting thinner
	if sprite and sprite is Node2D:
		sprite.modulate = Color(1, 1, 1, float(health) / 3.0)

	if health <= 0:
		cut_vine()

func cut_vine():
	print("Vine completely cut through!")
	vine_cut.emit()

	# Play cutting animation
	if sprite:
		var tween = create_tween()
		tween.tween_property(sprite, "modulate:a", 0.0, 0.3)
		tween.tween_callback(func(): queue_free())
	else:
		queue_free()
