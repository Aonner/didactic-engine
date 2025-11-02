extends Node

## GameManager - Singleton for managing global game state
## Handles character selection, progression, and save data

enum CharacterType {
	MALE_ARCHAEOLOGIST,
	FEMALE_ARCHAEOLOGIST
}

# Character selection
var selected_character: CharacterType = CharacterType.MALE_ARCHAEOLOGIST
var character_selected: bool = false

# Character names
var character_names = {
	CharacterType.MALE_ARCHAEOLOGIST: "Tobias",
	CharacterType.FEMALE_ARCHAEOLOGIST: "Diana"  # TBD
}

# Character nicknames
var character_nicknames = {
	CharacterType.MALE_ARCHAEOLOGIST: "Toby",
	CharacterType.FEMALE_ARCHAEOLOGIST: ""  # TBD
}

# Character descriptions
var character_descriptions = {
	CharacterType.MALE_ARCHAEOLOGIST: "Practical field archaeologist with a hands-on approach. Red hair, full beard, glasses, plaid shirt.",
	CharacterType.FEMALE_ARCHAEOLOGIST: ""  # TBD
}

# Progression tracking
var abilities_unlocked: Dictionary = {
	CharacterType.MALE_ARCHAEOLOGIST: {
		# Tobias "Toby" Bradshaw abilities
		"vine_cutting": true,           # Shared: Machete for cutting vines
		"crowbar": false,               # Non-Combat: Pry open sealed doors/crates
		"hammer": false,                # Non-Combat: Break weak walls
		"explosives": false,            # Non-Combat: Small charges for blocked passages
		"sledgehammer": false,          # Combat: Heavy/powerful melee attacks
	},
	CharacterType.FEMALE_ARCHAEOLOGIST: {
		"vine_cutting": true,           # Shared ability
		"special_combat": false,        # TBD
		"special_noncombat": false      # TBD
	}
}

# Tool/weapon inventory (what player currently has equipped)
var current_tool: String = "machete"  # Default tool

# Game state
var current_health: int = 100
var max_health: int = 100
var base_camp_position: Vector2 = Vector2.ZERO

signal character_selected(character_type: CharacterType)
signal ability_unlocked(character_type: CharacterType, ability_name: String)
signal health_changed(new_health: int, max_health: int)

func _ready():
	print("GameManager initialized")

func select_character(character: CharacterType) -> void:
	selected_character = character
	character_selected = true
	character_selected.emit(character)
	print("Character selected: ", character_names[character])

func get_selected_character() -> CharacterType:
	return selected_character

func get_character_name(character: CharacterType = selected_character) -> String:
	return character_names[character]

func unlock_ability(character: CharacterType, ability_name: String) -> void:
	if abilities_unlocked[character].has(ability_name):
		abilities_unlocked[character][ability_name] = true
		ability_unlocked.emit(character, ability_name)
		print("Ability unlocked: ", ability_name, " for ", character_names[character])

func is_ability_unlocked(ability_name: String, character: CharacterType = selected_character) -> bool:
	return abilities_unlocked[character].get(ability_name, false)

func take_damage(amount: int) -> void:
	current_health = max(0, current_health - amount)
	health_changed.emit(current_health, max_health)
	if current_health <= 0:
		_handle_death()

func heal(amount: int) -> void:
	current_health = min(max_health, current_health + amount)
	health_changed.emit(current_health, max_health)

func _handle_death() -> void:
	print("Player died!")
	# TODO: Implement death/respawn logic
	pass

func reset_game() -> void:
	character_selected = false
	current_health = max_health
	# Reset abilities to starting state
	for character in abilities_unlocked:
		for ability in abilities_unlocked[character]:
			abilities_unlocked[character][ability] = (ability == "basic_attack")
