extends Node2D

@export var asteroid_scene: PackedScene
@export var boss_scene: PackedScene

@onready var player: CharacterBody2D = $Player
@onready var spawn_timer: Timer = $SpawnTimer
@onready var ui: CanvasLayer = $UI
@onready var score_label = $UI/HUD/VBoxContainer/ScoreLabel
@onready var level_label = $UI/HUD/VBoxContainer/LevelLabel
@onready var stars_label = $UI/HUD/VBoxContainer/StarsLabel
@onready var life_label = $UI/HUD/VBoxContainer/LifeLabel
@onready var game_over_label = $UI/HUD/VBoxContainer/GameOverLabel
@onready var shoot_sfx: AudioStreamPlayer = $ShootSfx
@onready var hit_sfx: AudioStreamPlayer = $HitSfx
@onready var levelup_sfx: AudioStreamPlayer = $LevelupSfx
@onready var gameover_sfx: AudioStreamPlayer = $GameoverSfx

var boss_spawned: bool = false
var game_over: bool = false
var _last_level: int = 1

func _ready() -> void:
	randomize()
	GameManager.reset_run()
	GameManager.score_changed.connect(_on_score_changed)
	GameManager.stars_changed.connect(_on_stars_changed)
	GameManager.level_changed.connect(_on_level_changed)
	GameManager.boss_requested.connect(_on_boss_requested)
	spawn_timer.timeout.connect(_spawn_asteroid)

	if player.has_signal("health_changed"):
		player.health_changed.connect(_on_player_health_changed)
	if player.has_signal("player_died"):
		player.player_died.connect(_on_player_died)
	if player.has_signal("shot_fired"):
		player.shot_fired.connect(_on_player_shot_fired)

	if player.has_method("get_current_health"):
		_on_player_health_changed(player.get_current_health(), player.max_health)

	game_over_label.visible = false
	_on_score_changed(GameManager.score)
	_on_stars_changed(GameManager.stars)
	_on_level_changed(GameManager.level)

func _spawn_asteroid() -> void:
	if boss_spawned or game_over or asteroid_scene == null:
		return
	var asteroid := asteroid_scene.instantiate()
	asteroid.global_position = Vector2(randf_range(80.0, 640.0), -40.0)
	asteroid.size = randi_range(0, 2)
	asteroid.speed = 150.0 + (GameManager.level * 7.0)
	asteroid.body_entered.connect(_on_asteroid_body_entered.bind(asteroid))
	add_child(asteroid)

func _on_asteroid_body_entered(body: Node, asteroid: Area2D) -> void:
	if game_over:
		return
	if body != player:
		return
	if not player.has_method("take_hit"):
		return

	if player.is_invulnerable():
		return

	player.take_hit()
	hit_sfx.play()
	if is_instance_valid(asteroid):
		asteroid.queue_free()

func _on_boss_requested() -> void:
	if boss_spawned or game_over or boss_scene == null:
		return
	boss_spawned = true
	spawn_timer.stop()
	var boss := boss_scene.instantiate()
	boss.global_position = Vector2(360.0, -80.0)
	boss.defeated.connect(_on_boss_defeated)
	add_child(boss)

func _on_boss_defeated() -> void:
	spawn_timer.start()
	boss_spawned = false

func _on_score_changed(value: int) -> void:
	score_label.text = "Score: %d" % value

func _on_stars_changed(value: int) -> void:
	stars_label.text = "Stars: %d" % value

func _on_level_changed(value: int) -> void:
	level_label.text = "Level: %d" % value
	spawn_timer.wait_time = clamp(1.0 - float(value) * 0.02, 0.35, 1.0)
	if value > _last_level:
		levelup_sfx.play()
	_last_level = value

func _on_player_health_changed(current_health: int, max_health: int) -> void:
	life_label.text = "LIFE: %d/%d" % [current_health, max_health]

func _on_player_died() -> void:
	if game_over:
		return
	game_over = true
	spawn_timer.stop()
	game_over_label.visible = true
	player.set_physics_process(false)
	player.set_process(false)
	gameover_sfx.play()

func _on_player_shot_fired() -> void:
	shoot_sfx.play()
