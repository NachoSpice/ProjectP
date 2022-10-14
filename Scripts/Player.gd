extends KinematicBody

var mouse_sens = 0.08

func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		rotate_y(deg2rad(-event.relative.x * mouse_sens))
		$Head.rotate_x(deg2rad(-event.relative.y * mouse_sens))
		$Head.rotation.x = clamp($Head.rotation.x, deg2rad(-40), deg2rad(40))

func _physics_process(delta: float) -> void:
	pass
