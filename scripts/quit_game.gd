extends Area3D

func _ready():
	connect('body_entered', quit.bind())

func quit(_body):
	get_tree().quit()