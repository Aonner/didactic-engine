extends Area2D

## Sealed Door - Can be opened with crowbar (Tobias ability)

@export var is_locked: bool = true
@onready var collision_blocker: StaticBody2D = $CollisionBlocker
@onready var sprite: Node2D = $Sprite

signal door_opened

func _ready():
	add_to_group("sealed_door")
	if is_locked:
		show_locked_state()

func open():
	if not is_locked:
		return

	print("Sealed door pried open!")
	is_locked = false

	# Play opening animation
	play_open_animation()

	# Disable collision
	if collision_blocker:
		collision_blocker.queue_free()

	door_opened.emit()

func show_locked_state():
	# Visual indicator that this needs a crowbar
	pass

func play_open_animation():
	# Animate door opening
	if sprite:
		var tween = create_tween()
		tween.tween_property(sprite, "position:x", sprite.position.x + 50, 0.5)
		tween.tween_callback(func(): queue_free())
