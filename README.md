# Road 2 Mars (Godot 4.x)

A 2D arcade shooter built for Godot 4.6 with scene instancing, signal-based communication, mobile touch controls, progressive level difficulty, and a level-25 boss encounter.

## Included Scenes

- `scenes/Main.tscn` - game loop/state/UI/spawn management
- `scenes/Player.tscn` - player ship with shooting marker
- `scenes/Bullet.tscn` - upward projectile with asteroid collision
- `scenes/Asteroid.tscn` - random health/movement and score payout
- `scenes/PowerUp.tscn` - speed/bullet modifiers
- `scenes/BossAsteroid.tscn` - 50 HP boss with tweened movement

## Controls

- Keyboard: `A/D`, `Left/Right Arrow`, `Space`
- Mobile: `TouchScreenButton` controls for left/right/shoot

## Notes

- Multi-touch is enabled in `project.godot`.
- Assign audio streams to the 4 `AudioStreamPlayer` nodes in `Main.tscn`:
  - `Pew`
  - `Crash`
  - `LevelUp`
  - `GameOver`
