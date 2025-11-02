# Jungle Archaeologists
A 2D Metroidvania-style adventure game set in the jungle, featuring two playable archaeologist characters.

## Game Concept
An adventure game inspired by classics like Metroid and Castlevania: Symphony of the Night. Players choose between two archaeologist characters, each with unique combat and non-combat abilities. The game features pixel art graphics and exploration-focused gameplay in a mysterious jungle setting.

## Project Status
**Current Phase:** Initial Setup Complete

### Completed Features
- ✅ Godot 4 project configuration
- ✅ Base player controller with movement and jumping
- ✅ Character selection system
- ✅ Opening sequence framework (biplane intro)
- ✅ Game manager singleton for global state
- ✅ Input system (movement, attack, special abilities)
- ✅ Basic level structure

### To Be Implemented
- [ ] Character-specific abilities and mechanics
- [ ] Enemy AI and combat system
- [ ] Animation sprites (currently using colored rectangles as placeholders)
- [ ] Metroidvania progression system (upgrades, locked areas)
- [ ] Save/load system
- [ ] Level design and tilemap system
- [ ] Sound effects and music
- [ ] UI/HUD system

## Characters

### Male Archaeologist (Jack)
- **Basic Attack:** TBD
- **Special Combat Ability:** TBD
- **Special Non-Combat Ability:** TBD

### Female Archaeologist (Diana)
- **Basic Attack:** TBD
- **Special Combat Ability:** TBD
- **Special Non-Combat Ability:** TBD

## Project Structure

```
didactic-engine/
├── project.godot              # Main project configuration
├── scenes/
│   ├── intro/                 # Opening sequence scenes
│   │   └── intro_sequence.tscn
│   ├── levels/                # Level scenes
│   │   └── level_01.tscn
│   ├── characters/            # Character scenes
│   │   └── player.tscn
│   ├── ui/                    # UI scenes
│   └── environments/          # Environment prefabs
├── scripts/
│   ├── characters/            # Character controllers
│   │   └── player_controller.gd
│   ├── systems/               # Core game systems
│   │   └── game_manager.gd
│   ├── enemies/               # Enemy AI scripts
│   └── ui/                    # UI scripts
│       └── intro_sequence.gd
└── assets/
    ├── sprites/               # Sprite sheets and textures
    │   ├── characters/
    │   ├── environments/
    │   ├── enemies/
    │   └── effects/
    └── audio/                 # Sound effects and music
        ├── music/
        └── sfx/
```

## Technical Details

### Engine
- **Godot Version:** 4.3
- **Target Resolution:** 320x180 (scaled to 1280x720)
- **Art Style:** Pixel art
- **Physics:** 2D

### Controls
- **Movement:** WASD or Arrow Keys
- **Jump:** Space or W
- **Attack:** J key
- **Special Combat:** K key
- **Special Non-Combat:** L key

### Architecture

#### GameManager (Singleton)
Handles global game state including:
- Character selection
- Ability progression tracking
- Health management
- Save/load data

#### Player Controller
Base controller with:
- Physics-based movement (acceleration, friction, air resistance)
- Jump mechanics
- Attack system with cooldowns
- Extensible special ability system
- Animation state machine

#### Intro Sequence
Multi-stage cinematic sequence:
1. Biplane landing animation
2. Characters walking to base camp
3. Character selection UI
4. Heroic pose animation
5. Transition to gameplay

## Getting Started

1. Open the project in Godot 4.3 or later
2. Run the project (F5) to see the intro sequence
3. Select your character
4. Test basic movement and combat in Level 01

## Development Notes

### Current Placeholders
- All sprites are currently colored rectangles
- Animations are not yet implemented
- Character abilities need to be defined
- Audio is not yet implemented

### Next Steps
1. Define specific abilities for each character
2. Create pixel art sprites for characters and environments
3. Implement ability systems
4. Design first level layout
5. Create enemy types
6. Add progression mechanics (locked doors, upgrades, etc.)

## Contributing
This is a game development project. Feel free to expand on the base systems provided!

## License
[To be determined]
