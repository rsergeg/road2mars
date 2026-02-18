extends CharacterBody2D

signal health_changed(current_health: int, max_health: int)
signal player_died
signal shot_fired

@export var base_speed: float = 200.0
@export var bullet_scene: PackedScene
@export var shoot_cooldown: float = 0.22
@export var max_health: int = 5

var _speed_bonus: float = 0.0
var _damage_bonus: int = 0
var _can_shoot: bool = true
var _invulnerable: bool = false
var _health: int = 0

func _ready() -> void:
	_health = max_health
	health_changed.emit(_health, max_health)

func _physics_process(_delta: float) -> void:
	var direction := Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
	velocity = Vector2(direction * (base_speed + _speed_bonus), 0.0)
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
	var current_bullet_damage := 1 + _damage_bonus
	if bullet.has_method("configure_damage"):
		bullet.configure_damage(current_bullet_damage)
	elif bullet.has_method("set"):
		bullet.set("damage", current_bullet_damage)
	get_tree().current_scene.add_child(bullet)
	shot_fired.emit()
	await get_tree().create_timer(shoot_cooldown).timeout
	_can_shoot = true

func apply_speed_powerup() -> void:
	_speed_bonus += 50.0
	await get_tree().create_timer(20.0).timeout
	_speed_bonus = max(_speed_bonus - 50.0, 0.0)

func apply_bullet_powerup() -> void:
	_damage_bonus += 1
	await get_tree().create_timer(20.0).timeout
	_damage_bonus = max(_damage_bonus - 1, 0)

func take_hit() -> void:
	if _invulnerable or _health <= 0:
		return

	_health -= 1
	health_changed.emit(_health, max_health)

	if _health <= 0:
		player_died.emit()
		return

	trigger_invulnerability(2.0)

func trigger_invulnerability(duration: float = 2.0) -> void:
	if _invulnerable:
		return
	_invulnerable = true
	var loop_count := int(duration / 0.2)
	var flicker := create_tween().set_loops(loop_count)
	flicker.tween_property(self, "modulate:a", 0.5, 0.1)
	flicker.tween_property(self, "modulate:a", 1.0, 0.1)
	get_tree().create_timer(duration).timeout.connect(_end_invulnerability, CONNECT_ONE_SHOT)

func _end_invulnerability() -> void:
	modulate.a = 1.0
	_invulnerable = false

func is_invulnerable() -> bool:
	return _invulnerable

func get_current_health() -> int:
	return _health
