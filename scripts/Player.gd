extends CharacterBody2D

@export var base_speed: float = 8.0
@export var bullet_scene: PackedScene
@export var shoot_cooldown: float = 0.22

var _speed_bonus: float = 0.0
var _damage_bonus: int = 0
var _can_shoot: bool = true
var _invulnerable: bool = false

func _physics_process(_delta: float) -> void:
	var direction := Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
	velocity = Vector2(direction * (base_speed + _speed_bonus) * 100.0, 0.0)
	move_and_slide()
	position.x = clamp(position.x, 40.0, 680.0)

	if Input.is_action_pressed("shoot"):
		_shoot()

func _shoot() -> void:
	if not _can_shoot or bullet_scene == null:
		return
	_can_shoot = false
	var bullet := bullet_scene.instantiate()
	bullet.global_position = global_position + Vector2(0, -42)
	if bullet.has_method("configure_damage"):
		bullet.configure_damage(1 + _damage_bonus)
	get_tree().current_scene.add_child(bullet)
	await get_tree().create_timer(shoot_cooldown).timeout
	_can_shoot = true

func apply_speed_powerup() -> void:
	_speed_bonus += 2.0
	await get_tree().create_timer(20.0).timeout
	_speed_bonus = max(_speed_bonus - 2.0, 0.0)

func apply_bullet_powerup() -> void:
	_damage_bonus += 1
	await get_tree().create_timer(20.0).timeout
	_damage_bonus = max(_damage_bonus - 1, 0)

func trigger_invulnerability(duration: float = 1.5) -> void:
	if _invulnerable:
		return
	_invulnerable = true
	var flicker := create_tween().set_loops(int(duration / 0.15))
	flicker.tween_property(self, "modulate:a", 0.25, 0.075)
	flicker.tween_property(self, "modulate:a", 1.0, 0.075)
	await get_tree().create_timer(duration).timeout
	modulate.a = 1.0
	_invulnerable = false

func is_invulnerable() -> bool:
	return _invulnerable
