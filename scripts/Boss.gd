extends Area2D

signal defeated

@export var max_health: int = 50
@export var horizontal_speed: float = 120.0
@export var vertical_speed: float = 40.0

var health: int
var _direction: float = 1.0

func _ready() -> void:
	health = max_health

func _process(delta: float) -> void:
	position.x += _direction * horizontal_speed * delta
	position.y += vertical_speed * delta
	if position.x < 90.0:
		_direction = 1.0
	if position.x > 630.0:
		_direction = -1.0
	position.y = clamp(position.y, 100.0, 420.0)

func take_damage(amount: int) -> void:
	health = max(health - amount, 0)
	if health == 0:
		GameManager.add_score(1000)
		defeated.emit()
		queue_free()
