extends StaticBody3D

@onready var text_front: Label3D = $TextFront
@onready var text_back: Label3D = $TextBack
@onready var front_trigger: Area3D = $FrontTrigger
@onready var back_trigger: Area3D = $BackTrigger

@export var wall: Node3D
@export var exit: Node3D

const TEXT = [
	'This is a \nfinished game.',
	'It might not \nbe much,',
	"but it's a \nstart.",
	'Progress \ntakes time.',
	'You just have \nto keep at it.',
]

var trigger_count = 0
var text_done = false

func _ready():
	front_trigger.connect('body_entered', change_text.bind('front'))
	back_trigger.connect('body_entered', change_text.bind('back'))

func change_text(_body, side):
	if text_done:
		return

	if side == 'front':
		text_front.text = TEXT[trigger_count]
	elif side == 'back':
		text_back.text = TEXT[trigger_count]

	trigger_count += 1
	# If we reach the end of the text, show exit
	if trigger_count == len(TEXT):
		text_done = true
		wall.queue_free()
		exit.show()

