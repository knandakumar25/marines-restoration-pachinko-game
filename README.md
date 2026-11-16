# Restoration (Pachinko Game)

[![Godot Engine](https://img.shields.io/badge/Engine-Godot_4.4-blue.svg)](https://godotengine.org/)
[![Language](https://img.shields.io/badge/Language-GDScript-brightgreen.svg)]()
[![Platform](https://img.shields.io/badge/Platform-Windows_|_macOS_|_Linux-orange.svg)]()
[![Course](https://img.shields.io/badge/Course-CSC_486-purple.svg)]()
[![Team](https://img.shields.io/badge/Developed_By-The_Marines-red.svg)]()

> A 2D physics-driven pachinko adventure where tactical ball trajectories restore lost memory relics, overcome obstacle-laden peg boards, and topple a multi-stage boss.

---

## Overview

**Restoration** is a 2D physics arcade game developed in **Godot 4.4** by **The Marines** for CSC 486. Built around authentic rigid-body physics and kinetic bounce mechanics, the game challenges players to drop restorative orbs through treacherous arrays of pegs, bumpers, and dynamic hazards to collect core memory orbs and defeat a formidable final boss.

---

## Gameplay Mechanics

```
   [Spawner / Top Marker] 
             │
             ▼  (Press SPACE / Click)
     ○  Restoration Orb
             │
      •   •  Peg Board Array
        •   •   •  (Kinetic Deflection)
             │
      ┌──────┴──────┐
      ▼             ▼
 [Goal Buckets]  [Relic Orbs] ──────> [Boss Combat]
 (Score Points)  (Family/House/Ship)  (Damage Boss HP)
```

- **Ball Launching & Cooldowns**: Players release orbs from the top spawner. Each drop requires timing and precision to exploit bounces off pin arrangements.
- **Peg Dynamics**: Varied peg types (`peg.tscn`, `peg2.tscn`, `peg3.tscn`) provide distinct bounce coefficients and impulse responses.
- **Relic Collection**: Navigate trajectories into hard-to-reach pockets to collect essential narrative memory orbs:
  - **Family Orb (`family_orb.tscn`)**
  - **House Orb (`house_orb.tscn`)**
  - **Ship Orb (`ship_orb.tscn`)**
- **Boss Encounter (`boss.tscn`)**: In the final battle, a boss with **100 HP** looms below. Striking target zones with falling balls inflicts progressive damage, demanding accuracy under pressure.
- **Health & Survival**: Players monitor both player vitality (`player_health: 100`) and ball reserves across all four levels.

---

## Levels & Progression

1. **Title / Home (`scenes/home.tscn`)**: Intro hub with transition to level select and tutorial sequences.
2. **Level 1 (`scenes/level1.tscn`)**: Fundamental pachinko physics, initial peg grids, and goal bucket alignment.
3. **Level 2 (`scenes/level2.tscn`)**: Tightened bounce channels, moving targets, and increased peg density.
4. **Level 3 (`scenes/level3.tscn`)**: Multi-tiered drops featuring cavern hazards and relic collection pockets.
5. **Level 4 & Boss Battle (`scenes/level4.tscn`)**: The ultimate confrontation pitting player aim against the Boss entity.

---

## Controls

| Action | Input |
| :--- | :--- |
| **Spawn Ball / Launch** | `Spacebar` or `Left Mouse Button` |
| **Aim / Menu Navigation** | `Mouse Cursor` |
| **Restart / Retry** | UI Buttons / Enter |

---

## Running the Game in Godot

### Prerequisites
- [Godot Engine 4.4](https://godotengine.org/download) (Standard or .NET edition; project uses standard GDScript).

### Steps
1. Clone the repository:
   ```bash
   git clone https://github.com/knandakumar25/marines-restoration-pachinko-game.git
   ```
2. Open Godot Engine and click **Import**.
3. Browse to the cloned directory and select the `project.godot` file.
4. Click **Import & Edit**.
5. Press **F5** (or click the Play icon in the top right corner) to launch the project from the home scene (`res://scenes/home.tscn`).

---

## Project Structure

```
marines-restoration-pachinko-game/
├── project.godot       # Godot 4.4 project configuration and input maps
├── scenes/             # All game scene trees and GDScript controllers
│   ├── home.tscn / .gd       # Title screen and main menu
│   ├── level1.tscn - 4.tscn  # Handcrafted campaign stages
│   ├── boss.tscn / .gd       # Boss entity, health tracker, and collision
│   ├── ball.tscn             # RigidBody2D ball physics instance
│   ├── peg.tscn - peg3.tscn  # Varied peg bumper colliders
│   ├── goal.tscn / .gd       # Score collection zone
│   └── *_orb.tscn            # Collectible story relics
├── *.webp / *.png      # Background artwork, sprites, textures, and UI elements
├── Boldonse-Regular.ttf# Custom display typography
└── README.md           # Project documentation
```

---

## Credits

- **Development Team**: The Marines (CSC 486)
- **Engine**: [Godot Engine](https://godotengine.org/)
- **Typography**: Boldonse Regular
