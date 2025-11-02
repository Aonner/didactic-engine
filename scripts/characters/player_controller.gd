extends CharacterBody2D

## Base Player Controller for both archaeologist characters
## Handles movement, jumping, attacks, and special abilities

# Movement constants
@export var SPEED: float = 100.0
@export var JUMP_VELOCITY: float = -300.0
@export var ACCELERATION: float = 800.0
@export var FRICTION: float = 1000.0
@export var AIR_RESISTANCE: float = 200.0

# Combat
@export var attack_damage: int = 10
@export var attack_cooldown: float = 0.5

# State
var is_attacking: bool = false
var can_attack: bool = true
var facing_direction: int = 1  # 1 for right, -1 for left
var character_type: GameManager.CharacterType

# Get the gravity from the project settings
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

# Node references
@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var attack_timer: Timer = $AttackTimer
@onready var attack_hitbox: Area2D = $AttackHitbox

func _ready():
	# Set up based on selected character
	character_type = GameManager.get_selected_character()
	setup_character()

	# Connect attack timer
	if attack_timer:
		attack_timer.timeout.connect(_on_attack_timer_timeout)

func setup_character():
	# Override this in character-specific scripts or configure via export vars
	print("Setting up character: ", GameManager.get_character_name(character_type))

func _physics_process(delta):
	# Apply gravity
	if not is_on_floor():
		velocity.y += gravity * delta

	# Handle movement input
	handle_movement(delta)

	# Handle actions
	handle_actions()

	# Move the character
	move_and_slide()

	# Update animations
	update_animation()

func handle_movement(delta: float):
	var input_direction = Input.get_axis("move_left", "move_right")

	if input_direction != 0:
		facing_direction = sign(input_direction)
		if is_on_floor():
			velocity.x = move_toward(velocity.x, input_direction * SPEED, ACCELERATION * delta)
		else:
			velocity.x = move_toward(velocity.x, input_direction * SPEED, AIR_RESISTANCE * delta)
	else:
		if is_on_floor():
			velocity.x = move_toward(velocity.x, 0, FRICTION * delta)
		else:
			velocity.x = move_toward(velocity.x, 0, AIR_RESISTANCE * delta)

	# Handle jump
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY

func handle_actions():
	# Don't allow actions while already attacking
	if is_attacking:
		return

	# Basic attack
	if Input.is_action_just_pressed("attack") and can_attack:
		perform_attack()

	# Special combat ability
	if Input.is_action_just_pressed("special_combat"):
		if GameManager.is_ability_unlocked("special_combat", character_type):
			perform_special_combat()

	# Special non-combat ability
	if Input.is_action_just_pressed("special_noncombat"):
		if GameManager.is_ability_unlocked("special_noncombat", character_type):
			perform_special_noncombat()

func perform_attack():
	is_attacking = true
	can_attack = false
	attack_timer.start(attack_cooldown)

	# Play attack animation
	if animated_sprite:
		animated_sprite.play("attack")

	# Enable hitbox briefly
	if attack_hitbox:
		attack_hitbox.monitoring = true
		await get_tree().create_timer(0.2).timeout
		attack_hitbox.monitoring = false

	is_attacking = false

func perform_special_combat():
	# Override this in character-specific scripts
	print("Special combat ability used!")
	pass

func perform_special_noncombat():
	# Override this in character-specific scripts
	print("Special non-combat ability used!")
	pass

func update_animation():
	if not animated_sprite:
		return

	# Flip sprite based on facing direction
	animated_sprite.flip_h = (facing_direction == -1)

	# Don't change animation if attacking
	if is_attacking:
		return

	# Choose animation based on state
	if not is_on_floor():
		animated_sprite.play("jump")
	elif abs(velocity.x) > 10:
		animated_sprite.play("run")
	else:
		animated_sprite.play("idle")

func _on_attack_timer_timeout():
	can_attack = true

func take_damage(amount: int):
	GameManager.take_damage(amount)
	# Play hurt animation/effect
	print("Player took ", amount, " damage!")

# Signal handlers for hitbox
func _on_attack_hitbox_body_entered(body):
	if body.is_in_group("enemies"):
		if body.has_method("take_damage"):
			body.take_damage(attack_damage)
