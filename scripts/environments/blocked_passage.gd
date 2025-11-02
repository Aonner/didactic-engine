extends Area2D

## Blocked Passage - Can be cleared with explosives (Tobias ability)

@onready var collision_blocker: StaticBody2D = $CollisionBlocker
@onready var sprite: Node2D = $Sprite

signal passage_cleared

func _ready():
	add_to_group("blocked_passage")

func explode():
	print("Explosives detonating in 3... 2... 1...")

	# Play explosion effect
	play_explosion_effect()

	# Remove collision
	if collision_blocker:
		collision_blocker.queue_free()

	passage_cleared.emit()

	# Destroy the blockage
	queue_free()

func play_explosion_effect():
	# Big explosion animation, particles, camera shake
	print("*BOOM!* Passage cleared!")
	# TODO: Add particle effects, camera shake, debris
