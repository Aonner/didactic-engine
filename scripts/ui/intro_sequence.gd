extends Node2D

## Intro Sequence Controller
## Handles the opening cinematic: biplane landing, character selection, and transition to gameplay

enum IntroState {
	BIPLANE_LANDING,
	CHARACTERS_WALKING,
	CHARACTER_SELECTION,
	HEROIC_POSE,
	TRANSITION_TO_GAME
}

var current_state: IntroState = IntroState.BIPLANE_LANDING
var state_timer: float = 0.0
var selected_character_node: Node2D = null

# Node references
@onready var biplane: Node2D = $Biplane
@onready var male_archaeologist: Node2D = $MaleArchaeologist
@onready var female_archaeologist: Node2D = $FemaleArchaeologist
@onready var base_camp: Node2D = $BaseCamp
@onready var selection_ui: Control = $SelectionUI
@onready var selection_label: Label = $SelectionUI/SelectionLabel
@onready var male_button: Button = $SelectionUI/MaleButton
@onready var female_button: Button = $SelectionUI/FemaleButton

# Animation parameters
var biplane_landing_duration: float = 3.0
var walk_duration: float = 2.5
var pose_duration: float = 1.5

func _ready():
	# Connect UI buttons
	if male_button:
		male_button.pressed.connect(_on_male_selected)
	if female_button:
		female_button.pressed.connect(_on_female_selected)

	# Hide selection UI initially
	if selection_ui:
		selection_ui.visible = false

	# Start the intro sequence
	start_intro_sequence()

func start_intro_sequence():
	current_state = IntroState.BIPLANE_LANDING
	state_timer = 0.0

	# Position characters initially hidden or in the biplane
	if male_archaeologist:
		male_archaeologist.position = biplane.position if biplane else Vector2.ZERO
		male_archaeologist.visible = false

	if female_archaeologist:
		female_archaeologist.position = biplane.position if biplane else Vector2.ZERO
		female_archaeologist.visible = false

func _process(delta):
	state_timer += delta

	match current_state:
		IntroState.BIPLANE_LANDING:
			process_biplane_landing(delta)
		IntroState.CHARACTERS_WALKING:
			process_characters_walking(delta)
		IntroState.CHARACTER_SELECTION:
			# Waiting for player input
			pass
		IntroState.HEROIC_POSE:
			process_heroic_pose(delta)
		IntroState.TRANSITION_TO_GAME:
			transition_to_gameplay()

func process_biplane_landing(delta):
	# Animate biplane landing (simple downward movement for now)
	if biplane:
		var target_y = 50.0  # Landing position
		biplane.position.y = move_toward(biplane.position.y, target_y, 30.0 * delta)

	# After landing duration, show characters
	if state_timer >= biplane_landing_duration:
		if male_archaeologist:
			male_archaeologist.visible = true
		if female_archaeologist:
			female_archaeologist.visible = true

		change_state(IntroState.CHARACTERS_WALKING)

func process_characters_walking(delta):
	# Move both characters toward base camp
	var walk_speed = 40.0
	var target_x = base_camp.position.x - 50 if base_camp else 160

	if male_archaeologist:
		male_archaeologist.position.x = move_toward(
			male_archaeologist.position.x,
			target_x,
			walk_speed * delta
		)

	if female_archaeologist:
		female_archaeologist.position.x = move_toward(
			female_archaeologist.position.x,
			target_x + 30,
			walk_speed * delta
		)

	# After walking duration, show character selection
	if state_timer >= walk_duration:
		change_state(IntroState.CHARACTER_SELECTION)

func process_heroic_pose(delta):
	# Play pose animation/hold pose
	if state_timer >= pose_duration:
		change_state(IntroState.TRANSITION_TO_GAME)

func change_state(new_state: IntroState):
	current_state = new_state
	state_timer = 0.0

	match new_state:
		IntroState.CHARACTER_SELECTION:
			show_character_selection()
		IntroState.HEROIC_POSE:
			hide_character_selection()
			position_characters_for_pose()

func show_character_selection():
	if selection_ui:
		selection_ui.visible = true

	if selection_label:
		selection_label.text = "Choose Your Archaeologist"

func hide_character_selection():
	if selection_ui:
		selection_ui.visible = false

func position_characters_for_pose():
	# Move unselected character to base camp (sitting position)
	# Selected character strikes heroic pose
	var unselected: Node2D

	if GameManager.selected_character == GameManager.CharacterType.MALE_ARCHAEOLOGIST:
		selected_character_node = male_archaeologist
		unselected = female_archaeologist
	else:
		selected_character_node = female_archaeologist
		unselected = male_archaeologist

	# Move unselected to camp
	if unselected and base_camp:
		var tween = create_tween()
		tween.tween_property(unselected, "position", base_camp.position, 0.5)

	# Selected character strikes pose (could trigger animation here)
	if selected_character_node:
		print(GameManager.get_character_name(), " strikes a heroic pose!")
		# TODO: Play heroic pose animation

func transition_to_gameplay():
	# Load the first level/gameplay scene
	print("Transitioning to gameplay...")
	# TODO: Load actual first level scene
	get_tree().change_scene_to_file("res://scenes/levels/level_01.tscn")

func _on_male_selected():
	GameManager.select_character(GameManager.CharacterType.MALE_ARCHAEOLOGIST)
	change_state(IntroState.HEROIC_POSE)

func _on_female_selected():
	GameManager.select_character(GameManager.CharacterType.FEMALE_ARCHAEOLOGIST)
	change_state(IntroState.HEROIC_POSE)
