# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

This is a Godot 4.4 game project called "The Return of The Pineapple Pizza" - a 2D top-down game featuring player movement, enemy AI, and PIN code security mechanics.

## Development Commands

**Running the game:**
- Open project in Godot 4.4 editor
- Press F5 or click "Play" button to run the project
- Main scene appears to be configurable in project settings

**Testing scenes individually:**
- Use F6 to play current scene in Godot editor
- Main game scenes are located in `Scenes/` directory

## Architecture

### Core Game Systems

**Player System (`player.gd`):**
- Character movement with WASD/arrow keys and sprint (Shift)
- 8-directional animated movement with acceleration/friction physics
- Portal interaction system for scene transitions

**Enemy AI (`enemy.gd`):**
- Simple AI that tracks and follows the player
- Uses CharacterBody2D with lerp-based movement
- Animated sprites with direction-based animation selection

**PIN Code Security (`Scenes/pin_code_ui.gd`):**
- 4-digit PIN entry system with hardcoded PIN "1234"
- Button-based number input with visual feedback
- Auto-reset on incorrect PIN after 1-second delay

### Project Structure

- **Root level:** Core scripts (`player.gd`, `enemy.gd`) and main map (`2D_map.tscn`)
- **`Scenes/`:** All scene files including UI components and world scenes
- **`Player_Sprite/`:** Player character sprites and animations
- **`ModernExteriors/`:** Complete tileset assets for modern city environments

### Scene Organization

- `test_world.tscn` - Testing/development scene
- `real_map.tscn` - Main game world
- `player.tscn` - Player character prefab
- `enemy.tscn` - Enemy character prefab  
- `pin_code_ui.tscn` - PIN entry interface

### Input System

Custom input map defined in `project.godot`:
- Movement: WASD keys + arrow keys
- Sprint: Shift key
- All inputs have 0.2 deadzone for controller support

### Asset Integration

Uses 16x16 pixel art style with Modern Exteriors tileset covering:
- City terrains and buildings
- Vehicles and props
- Specialized locations (police, hospital, school, etc.)
- Modular building system for level design

## Development Notes

- Game uses Forward Plus rendering pipeline
- Default texture filter set to nearest neighbor (pixel art appropriate)
- Player group used for collision detection and scene interactions
- Enemy uses groups system to locate player reference
- PIN system uses button groups and meta properties for number input