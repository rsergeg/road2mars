extends Node2D

@export var asteroid_scene: PackedScene
@export var boss_scene: PackedScene

@onready var player: CharacterBody2D = $Player
@onready var spawn_timer: Timer = $SpawnTimer
@onready var ui: CanvasLayer = $UI
@onready var score_label = $UI/HUD/VBoxContainer/ScoreLabel
@onready var level_label = $UI/HUD/VBoxContainer/LevelLabel
@onready var stars_label = $UI/HUD/VBoxContainer/StarsLabel

var boss_spawned: bool = false

func _ready() -> void:
	randomize()
	GameManager.reset_run()
	GameManager.score_changed.connect(_on_score_changed)
	GameManager.stars_changed.connect(_on_stars_changed)
	GameManager.level_changed.connect(_on_level_changed)
	GameManager.boss_requested.connect(_on_boss_requested)
	spawn_timer.timeout.connect(_spawn_asteroid)
	_on_score_changed(GameManager.score)
	_on_stars_changed(GameManager.stars)
	_on_level_changed(GameManager.level)

func _spawn_asteroid() -> void:
	if boss_spawned or asteroid_scene == null:
		return
	var asteroid := asteroid_scene.instantiate()
	asteroid.global_position = Vector2(randf_range(80.0, 640.0), -40.0)
	asteroid.size = randi_range(0, 2)
	asteroid.speed = 150.0 + (GameManager.level * 7.0)
	add_child(asteroid)

func _on_boss_requested() -> void:
	if boss_spawned or boss_scene == null:
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
