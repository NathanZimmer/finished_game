extends CanvasLayer

const player_controller = preload("res://scripts/player_controller.gd")

var show_menu = false

@onready var slider = $HSlider
@onready var button = $Button

func _ready():
	hide()
	button.connect('pressed', quit.bind())

func _process(_delta):
	if Input.is_action_just_pressed("ui_cancel"):
		show_menu = not show_menu
		show() if show_menu else hide()

	if slider.drag_ended:
		player_controller.set_look_sens(slider.value)

func quit():
	get_tree().quit()
