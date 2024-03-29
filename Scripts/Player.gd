extends KinematicBody

#Movement Values
const GRAVITY = 10

export var movement_speed = 10
var h_acceleration = 6
var full_contact = false

var gravity_vector = Vector3()
var movement_direction = Vector3()
var h_velocity = Vector3()
var movement_vector = Vector3()

onready var animation_tree = $Head/Camera/AnimationTree.get("parameters/playback")
onready var animation_player = $Head/Camera/AnimationPlayer

#Control Variables
var mouse_sens = 0.08

func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		rotate_y(deg2rad(-event.relative.x * mouse_sens))
		$Head.rotate_x(deg2rad(-event.relative.y * mouse_sens))
		$Head.rotation.x = clamp($Head.rotation.x, deg2rad(-40), deg2rad(40))

func _process(delta: float) -> void:
	if movement_direction != Vector3() and full_contact:
		if $FootstepTimer.time_left <= 0:
			$FootstepSound.pitch_scale = rand_range(0.8, 1.2)
			$FootstepSound.play()
			$FootstepTimer.start(0.6)


func _physics_process(delta: float) -> void:
	
	movement_direction = Vector3()
	
	if $GroundCHK.is_colliding():
		full_contact = true
	else:
		full_contact = false
	
	if not is_on_floor():
		gravity_vector += Vector3.DOWN * GRAVITY * delta
	elif is_on_floor() and full_contact:
		gravity_vector = -get_floor_normal() * GRAVITY
	else:
		gravity_vector = -get_floor_normal()
	
	if Input.is_action_pressed("move_forward"):
		movement_direction -= transform.basis.z
	elif Input.is_action_pressed("move_backward"):
		movement_direction += transform.basis.z
	if Input.is_action_pressed("move_left"):
		movement_direction -= transform.basis.x
	elif Input.is_action_pressed("move_right"):
		movement_direction += transform.basis.x
	
	movement_direction = movement_direction.normalized()
	
	h_velocity = h_velocity.linear_interpolate(movement_direction * movement_speed, h_acceleration * delta)
	movement_vector.z = h_velocity.z + gravity_vector.z
	movement_vector.x = h_velocity.x + gravity_vector.x
	movement_vector.y = gravity_vector.y
	
	move_and_slide(movement_vector, Vector3.UP)
	
	if movement_direction != Vector3():
		animation_tree.travel("HeadBob")
	elif movement_direction == Vector3():
		animation_tree.travel("default")
