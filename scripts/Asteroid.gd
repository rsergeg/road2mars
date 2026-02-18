extends Area2D

signal destroyed(position: Vector2)

enum AsteroidSize { SMALL, MEDIUM, LARGE }

@export var size: AsteroidSize = AsteroidSize.SMALL
@export var speed: float = 230.0
@export var star_scene: PackedScene
@export var speed_powerup_scene: PackedScene
@export var bullet_powerup_scene: PackedScene

var health: int = 1
var _small_texture := preload("res://assets/sprites/asteroid_small.png")
var _med_texture := preload("res://assets/sprites/asteroid_med.png")
var _large_texture := preload("res://assets/sprites/asteroid_large.png")

func _ready() -> void:
	var sprite: Sprite2D = $Sprite2D
	match size:
		AsteroidSize.SMALL:
			health = 1
			scale = Vector2.ONE * 0.7
			sprite.texture = _small_texture
		AsteroidSize.MEDIUM:
			health = 2
			scale = Vector2.ONE
			sprite.texture = _med_texture
		AsteroidSize.LARGE:
			health = 4
			scale = Vector2.ONE * 1.35
			sprite.texture = _large_texture

func _process(delta: float) -> void:
	position.y += speed * delta
	if position.y > 1400.0:
		queue_free()

func take_damage(amount: int) -> void:
	health -= amount
	if health <= 0:
		_destroy_and_drop()

func _destroy_and_drop() -> void:
	GameManager.add_score(10 + int(size) * 10)
	if randf() <= 0.70 and star_scene != null:
		var star := star_scene.instantiate()
		star.global_position = global_position
		get_tree().current_scene.add_child(star)
	if randf() <= 0.08 and speed_powerup_scene != null:
		var speed_drop := speed_powerup_scene.instantiate()
		speed_drop.global_position = global_position
		get_tree().current_scene.add_child(speed_drop)
	if randf() <= 0.08 and bullet_powerup_scene != null:
		var bullet_drop := bullet_powerup_scene.instantiate()
		bullet_drop.global_position = global_position
		get_tree().current_scene.add_child(bullet_drop)
	destroyed.emit(global_position)
	queue_free()
