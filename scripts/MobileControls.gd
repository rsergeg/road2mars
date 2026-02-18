extends CanvasLayer

signal start_pressed
signal restart_pressed

@onready var left_button: TouchScreenButton = $VirtualControls/LeftButton
@onready var right_button: TouchScreenButton = $VirtualControls/RightButton
@onready var shoot_button: TouchScreenButton = $VirtualControls/ShootButton
@onready var start_screen: Control = $StartScreen
@onready var game_over_screen: Control = $GameOverScreen
@onready var final_score_label: Label = $GameOverScreen/Panel/VBoxContainer/FinalScoreLabel
@onready var final_stars_label: Label = $GameOverScreen/Panel/VBoxContainer/FinalStarsLabel
@onready var start_button: Button = $StartScreen/Panel/VBoxContainer/StartButton
@onready var restart_button: Button = $GameOverScreen/Panel/VBoxContainer/RestartButton

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	var mobile := OS.get_name() == "Android" or OS.get_name() == "iOS"
	$VirtualControls.visible = mobile
	left_button.action = "move_left"
	right_button.action = "move_right"
	shoot_button.action = "shoot"
	start_button.pressed.connect(_on_start_button_pressed)
	restart_button.pressed.connect(_on_restart_button_pressed)
	show_start_screen()

func show_start_screen() -> void:
	start_screen.visible = true
	game_over_screen.visible = false

func hide_start_screen() -> void:
	start_screen.visible = false

func show_game_over_screen(final_score: int, final_stars: int) -> void:
	final_score_label.text = "Final Score: %d" % final_score
	final_stars_label.text = "Stars Collected: %d" % final_stars
	game_over_screen.visible = true

func hide_game_over_screen() -> void:
	game_over_screen.visible = false

func _on_start_button_pressed() -> void:
	hide_start_screen()
	start_pressed.emit()

func _on_restart_button_pressed() -> void:
	restart_pressed.emit()
