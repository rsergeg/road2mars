extends CanvasLayer

@onready var left_button: TouchScreenButton = $VirtualControls/LeftButton
@onready var right_button: TouchScreenButton = $VirtualControls/RightButton
@onready var shoot_button: TouchScreenButton = $VirtualControls/ShootButton

func _ready() -> void:
	var mobile := OS.get_name() == "Android" or OS.get_name() == "iOS"
	$VirtualControls.visible = mobile
	left_button.action = "move_left"
	right_button.action = "move_right"
	shoot_button.action = "shoot"
