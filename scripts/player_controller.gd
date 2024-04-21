extends CharacterBody3D
## Handles player movement

const SPEED = 3
## Lerp rate for following CharacterBody
const CAM_SPEED = 30

static var look_sensitivity = 0.2

var mouse_input = Vector2.ZERO
var cam_target

@export var camera: Camera3D

func _ready():
	DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_EXCLUSIVE_FULLSCREEN)
	# DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_MAXIMIZED)

	cam_target = camera.position
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func _process(delta):
	# Press escape to get mouse control
	if Input.is_action_just_pressed("ui_cancel"):
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED if Input.mouse_mode == Input.MOUSE_MODE_VISIBLE else Input.MOUSE_MODE_VISIBLE

	# Rotate camera
	rotate_y(mouse_input.x * look_sensitivity * delta)
	camera.rotation.y = 0
	camera.rotate_x(mouse_input.y * look_sensitivity * delta)
	camera.rotation.x = clamp(camera.rotation.x, -PI/2, PI/2)
	camera.rotation.y = rotation.y

	# Move camera
	camera.position = camera.position.lerp(cam_target, CAM_SPEED * delta)

	mouse_input = Vector2.ZERO

func _physics_process(_delta):
	walk_and_jump()
	move_and_slide()

	cam_target = Vector3(
		position.x,
		position.y + 0.5,
		position.z
	)

func _input(event):
	if event is InputEventMouseMotion and Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
		mouse_input = Vector2(
			-event.relative.x,
			-event.relative.y
		)

## Handles player input for walking using the player_ input actions
func walk_and_jump():
	var input_direction = Input.get_vector(
		"player_left", "player_right", "player_forward", "player_back"
	)

	var direction = (
		transform.basis * Vector3(input_direction.x, 0, input_direction.y)
	).normalized()

	if direction:
		velocity.x = direction.x * SPEED
		velocity.y = direction.y * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.y = move_toward(velocity.y, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)

static func set_look_sens(new_sensitivity: float):
	look_sensitivity = new_sensitivity