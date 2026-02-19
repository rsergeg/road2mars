extends Node

signal score_changed(score: int)
signal stars_changed(stars: int)
signal level_changed(level: int)
signal boss_requested

const STAR_THRESHOLDS := [20, 40, 55, 70, 100]
const POST_THRESHOLD_STEP := 25
const MAX_LEVEL := 25

var score: int = 0
var stars: int = 0
var level: int = 1
var boss_started: bool = false

func reset_run() -> void:
	score = 0
	stars = 0
	level = 1
	boss_started = false
	score_changed.emit(score)
	stars_changed.emit(stars)
	level_changed.emit(level)

func add_score(amount: int) -> void:
	score += amount
	score_changed.emit(score)

func add_stars(amount: int) -> void:
	stars += amount
	stars_changed.emit(stars)
	_update_level_progression()

func _update_level_progression() -> void:
	var next_level := level
	for i in STAR_THRESHOLDS.size():
		if stars >= STAR_THRESHOLDS[i]:
			next_level = max(next_level, i + 2)

	if stars >= STAR_THRESHOLDS[-1]:
		var extra_stars := stars - STAR_THRESHOLDS[-1]
		next_level = max(next_level, 6 + int(float(extra_stars) / POST_THRESHOLD_STEP))

	next_level = min(next_level, MAX_LEVEL)
	if next_level != level:
		level = next_level
		level_changed.emit(level)

	if level >= MAX_LEVEL and not boss_started:
		boss_started = true
		boss_requested.emit()
