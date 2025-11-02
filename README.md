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
- ✅ Tobias character implementation with all abilities
- ✅ Demolition/force mechanics (crowbar, hammer, explosives)
- ✅ Sledgehammer combat system with charging
- ✅ Environmental obstacles (sealed doors, weak walls, blocked passages)
- ✅ Vine cutting mechanics

### To Be Implemented
- [ ] Female archaeologist character abilities
- [ ] Enemy AI and combat system
- [ ] Animation sprites (currently using colored rectangles as placeholders)
- [ ] Metroidvania progression system (upgrades, locked areas)
- [ ] Save/load system
- [ ] Level design and tilemap system
- [ ] Sound effects and music
- [ ] UI/HUD system
- [ ] Camera shake effects
- [ ] Particle effects for abilities

## Characters

### Tobias "Toby" Bradshaw (Male Archaeologist)
**Appearance:** Red hair and full beard, glasses, plaid shirt, sturdy build
**Archetype:** Practical field archaeologist with a hands-on approach
**Playstyle:** Heavy-hitting, demolition expert, slower but powerful

**Abilities:**
- **Shared Ability:** Vine Cutting (Machete) - Cut through jungle vines blocking paths
- **Basic Attack:** Machete swings (15 damage)
- **Combat Special:** Sledgehammer
  - Hold K to charge, release to attack
  - Damage scales 50-100% based on charge time
  - Fully charged: 30 damage + knockback + area effect
  - Slower cooldown (1.5s) but devastating impact
- **Non-Combat Special - Demolition/Force Tools:**
  - **Crowbar:** Pry open sealed doors and locked crates
  - **Hammer:** Break through weak/cracked walls
  - **Explosives:** Clear blocked passages and heavy debris

**Unique Mechanics:**
- Slightly slower movement speed (90 vs 100)
- Context-sensitive tool usage (approach obstacle, press L)
- Charge-based heavy attack system
- Environmental puzzle solving through force

### Female Archaeologist (TBD)
- **Name:** TBD
- **Abilities:** TBD (Coming soon!)

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
- **Basic Attack:** J key (Machete)
- **Special Combat:** K key (Hold to charge Sledgehammer for Tobias)
- **Special Non-Combat:** L key (Context-sensitive demolition tools for Tobias)

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
