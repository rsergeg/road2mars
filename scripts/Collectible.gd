extends Area2D

@export var fall_speed: float = 180.0
@export var score_value: int = 0
@export var star_value: int = 0
@export var power_type: String = ""

func _process(delta: float) -> void:
	position.y += fall_speed * delta
	if position.y > 1400.0:
		queue_free()

func _on_body_entered(body: Node) -> void:
	if body is CharacterBody2D:
		if score_value > 0:
			GameManager.add_score(score_value)
		if star_value > 0:
			GameManager.add_stars(star_value)
		if power_type == "speed" and body.has_method("apply_speed_powerup"):
			body.apply_speed_powerup()
		if power_type == "bullet" and body.has_method("apply_bullet_powerup"):
			body.apply_bullet_powerup()
		queue_free()
