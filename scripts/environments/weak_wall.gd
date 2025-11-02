extends Area2D

## Weak Wall - Can be broken with hammer (Tobias ability)

@onready var collision_blocker: StaticBody2D = $CollisionBlocker
@onready var sprite: Node2D = $Sprite

signal wall_broken

func _ready():
	add_to_group("weak_wall")
	show_cracks()

func break_wall():
	print("Weak wall shattered!")

	# Play breaking animation/particles
	play_break_effect()

	# Remove collision
	if collision_blocker:
		collision_blocker.queue_free()

	wall_broken.emit()

	# Destroy the wall
	queue_free()

func show_cracks():
	# Visual indicator that this wall is breakable
	# Could show cracks, different color, etc.
	pass

func play_break_effect():
	# Particle effects, debris, etc.
	# For now just print
	print("*CRASH* Wall debris flying!")
