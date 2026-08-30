# Cat Herder

A tiny top down game about keeping three cats with three different personalities entertained on a patio before they get bored and wander off. Built in Godot 4 as a first project for learning game development, coming from a background in Laravel/PHP web development.

## Concept

You have a limited amount of time to keep each cat happy using toys placed around the patio. Each cat behaves differently:

- Cat 1 chases toys constantly.
- Cat 2 wants nothing to do with your toys.
- Cat 3 only wants to sit on the one piece of furniture you are trying to keep it off of.

The whole game is one screen, one short session (3 to 5 minutes), no combat, no inventory, no branching story. The goal is to learn core game programming concepts (movement, collision, state, timers, simple behavior logic) through something small enough to actually finish.

## Status

This project is early and under active development. Currently working:

- Player movement with arrow key input and collision against patio boundaries and furniture.
- A static, single screen patio with a fixed (non following) camera.
- A placeable yarn ball toy, snapped to the player's position on key press.

Not yet built: cat behavior, happiness meters, timers, win/lose state, real art assets.

## Built with

- Godot 4 (GDScript)
- Placeholder art during development, final sprites to be sourced from free/CC0 asset packs (attribution and licensing to be documented here once added)

## Running the project

Open the project folder in Godot 4 and press Play, or open `patio.tscn` directly and run it.

## Why this project exists

A small, finished, playable project meant to demonstrate game development fundamentals learned outside of a primary background in web/backend development, and to have something concrete and demoable to point to alongside other work.
