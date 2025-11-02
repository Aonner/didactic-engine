extends "res://scripts/characters/player_controller.gd"

## Tobias "Toby" Bradshaw - Male Archaeologist Controller
## Specializes in demolition/force and heavy combat attacks

# Tobias-specific constants
@export var sledgehammer_damage: int = 30
@export var sledgehammer_knockback: float = 400.0
@export var sledgehammer_cooldown: float = 1.5
@export var sledgehammer_charge_time: float = 0.8

# State
var is_using_tool: bool = false
var is_charging_sledgehammer: bool = false
var sledgehammer_charge_timer: float = 0.0

# Tool interaction detection
@onready var tool_detector: Area2D = $ToolDetector

func _ready():
	super._ready()
	character_type = GameManager.CharacterType.MALE_ARCHAEOLOGIST
	setup_tobias()

func setup_tobias():
	print("Tobias Bradshaw ready for action!")
	# Tobias is slightly slower but has more knockback
	SPEED = 90.0
	attack_damage = 15  # Regular machete attack

func _physics_process(delta):
	super._physics_process(delta)

	# Handle sledgehammer charging
	if is_charging_sledgehammer:
		sledgehammer_charge_timer += delta
		# Visual feedback could go here (charging animation, particle effects)

func handle_actions():
	# Don't allow actions while already attacking or using tools
	if is_attacking or is_using_tool:
		return

	# Basic attack (machete)
	if Input.is_action_just_pressed("attack") and can_attack:
		perform_attack()

	# Special combat ability - Sledgehammer
	if Input.is_action_just_pressed("special_combat"):
		if GameManager.is_ability_unlocked("sledgehammer", character_type):
			start_sledgehammer_charge()

	# Release sledgehammer attack
	if Input.is_action_just_released("special_combat") and is_charging_sledgehammer:
		release_sledgehammer()

	# Special non-combat abilities - Demolition tools
	if Input.is_action_just_pressed("special_noncombat"):
		use_demolition_tool()

func start_sledgehammer_charge():
	if not can_attack:
		return

	is_charging_sledgehammer = true
	sledgehammer_charge_timer = 0.0
	velocity.x = 0  # Stop movement while charging

	if animated_sprite:
		animated_sprite.play("sledgehammer_charge")

func release_sledgehammer():
	is_charging_sledgehammer = false
	is_attacking = true
	can_attack = false

	# Calculate damage based on charge time (minimum 50%, full charge 100%)
	var charge_ratio = min(sledgehammer_charge_timer / sledgehammer_charge_time, 1.0)
	var final_damage = int(sledgehammer_damage * (0.5 + (charge_ratio * 0.5)))

	print("Sledgehammer attack! Charge: ", int(charge_ratio * 100), "% Damage: ", final_damage)

	# Play attack animation
	if animated_sprite:
		animated_sprite.play("sledgehammer_attack")

	# Create shockwave/impact effect
	perform_sledgehammer_impact(final_damage, charge_ratio)

	attack_timer.start(sledgehammer_cooldown)
	is_attacking = false

func perform_sledgehammer_impact(damage: int, charge_ratio: float):
	# Larger hitbox for sledgehammer
	var space_state = get_world_2d().direct_space_state
	var impact_size = 40.0 * (1.0 + charge_ratio * 0.5)  # Grows with charge

	# Query for enemies in front of player
	var query = PhysicsShapeQueryParameters2D.new()
	var shape = RectangleShape2D.new()
	shape.size = Vector2(impact_size, 30)
	query.shape = shape
	query.collision_mask = 4  # Enemies layer
	query.transform = Transform2D(0, global_position + Vector2(facing_direction * impact_size/2, 0))

	var results = space_state.intersect_shape(query)

	for result in results:
		var body = result.collider
		if body.is_in_group("enemies") and body.has_method("take_damage"):
			body.take_damage(damage)
			# Apply knockback if enemy has the method
			if body.has_method("apply_knockback"):
				var knockback_force = sledgehammer_knockback * (0.5 + charge_ratio * 0.5)
				body.apply_knockback(Vector2(facing_direction * knockback_force, -200))

	# Camera shake for fully charged attacks
	if charge_ratio >= 1.0:
		trigger_camera_shake()

func use_demolition_tool():
	# Check what's in front of Tobias
	if tool_detector:
		var nearby_objects = tool_detector.get_overlapping_areas()

		for obj in nearby_objects:
			# Check for sealed doors (crowbar)
			if obj.is_in_group("sealed_door") and GameManager.is_ability_unlocked("crowbar"):
				use_crowbar(obj)
				return

			# Check for weak walls (hammer)
			if obj.is_in_group("weak_wall") and GameManager.is_ability_unlocked("hammer"):
				use_hammer(obj)
				return

			# Check for blocked passages (explosives)
			if obj.is_in_group("blocked_passage") and GameManager.is_ability_unlocked("explosives"):
				use_explosives(obj)
				return

func use_crowbar(target):
	is_using_tool = true
	print("Using crowbar to pry open sealed door!")

	if animated_sprite:
		animated_sprite.play("crowbar")

	# Wait for animation, then open door
	await get_tree().create_timer(1.0).timeout

	if target.has_method("open"):
		target.open()

	is_using_tool = false

func use_hammer(target):
	is_using_tool = true
	print("Using hammer to break weak wall!")

	if animated_sprite:
		animated_sprite.play("hammer")

	# Wait for animation, then destroy wall
	await get_tree().create_timer(0.8).timeout

	if target.has_method("break_wall"):
		target.break_wall()

	is_using_tool = false

func use_explosives(target):
	is_using_tool = true
	print("Placing explosives on blocked passage!")

	if animated_sprite:
		animated_sprite.play("place_explosive")

	# Place explosive, wait, then detonate
	await get_tree().create_timer(1.5).timeout

	if target.has_method("explode"):
		target.explode()

	is_using_tool = false

func perform_special_combat():
	# Sledgehammer is handled by charge/release system
	pass

func perform_special_noncombat():
	# Demolition tools handled by context-sensitive system
	pass

func trigger_camera_shake():
	# TODO: Implement camera shake effect
	print("*KABOOM* - Camera shake!")

func update_animation():
	if not animated_sprite:
		return

	# Flip sprite based on facing direction
	animated_sprite.flip_h = (facing_direction == -1)

	# Priority animations
	if is_charging_sledgehammer:
		return  # Keep showing charge animation

	if is_attacking or is_using_tool:
		return  # Keep showing current action

	# Movement animations
	if not is_on_floor():
		animated_sprite.play("jump")
	elif abs(velocity.x) > 10:
		animated_sprite.play("run")
	else:
		animated_sprite.play("idle")
