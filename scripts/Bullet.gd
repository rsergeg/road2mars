extends Area2D

@export var speed: float = 800.0
var damage: int = 1

func configure_damage(value: int) -> void:
	damage = value

func _process(delta: float) -> void:
	position.y -= speed * delta
	if position.y < -50.0:
		queue_free()

func _on_body_entered(body: Node) -> void:
	if body.has_method("take_damage"):
		body.take_damage(damage)
	queue_free()

func _on_area_entered(area: Area2D) -> void:
	if area.has_method("take_damage"):
		area.take_damage(damage)
	queue_free()
