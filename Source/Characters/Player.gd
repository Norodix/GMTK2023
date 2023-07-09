extends CharacterBody3D

@export var movement_speed = 1
@export var sprint_speed = 2
@onready var cam : Camera3D = $pivot/rod/Camera3D
@onready var camera_pivot : Node3D = $pivot
@onready var camera_rod : Node3D = $pivot/rod

const camera_min_vertical_rotation = -80
const camera_max_vertical_rotation =  80
const mouse_local_sensitivity = 0.1
const footstep_size = 0.7

var movement_input : Vector3 = Vector3.ZERO
var distance_traveled = 0

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	

func _process(delta):
	var pressed = Input.get_vector("Left", "Right", "Up", "Down")
	movement_input.x = pressed.x
	movement_input.y = 0
	movement_input.z = pressed.y
	
	# Shout at cat
	if Input.is_action_just_pressed("Shout"):
		if $ShoutCooldown.is_stopped():
			$ShoutCooldown.start()
			$Shout.play()
			var bodies : Array[Node3D] = $CatDetector.get_overlapping_bodies()
			if not bodies.is_empty():
				if bodies[0].has_method("grab_attention"):
					bodies[0].grab_attention()
	

func _physics_process(delta):
	var new_velocity = camera_pivot.global_transform.basis * movement_input
	var speed = sprint_speed if Input.is_action_pressed("Sprint") else movement_speed
	new_velocity = new_velocity.normalized() * speed
	velocity = lerp(velocity, new_velocity, 0.1)
	velocity.y -= 10 * delta
	move_and_slide()
	distance_traveled += delta * velocity.length()
	if distance_traveled > footstep_size:
		$Footstep.play()
		distance_traveled -= footstep_size


func _unhandled_input(event):
	process_mouse_input(event)


func process_mouse_input(event : InputEvent) -> void:
	# Cursor movement
	if event is InputEventMouseMotion:
		var sensitivity = Globals.mouse_sensitivity * mouse_local_sensitivity
		var camera_direction = Vector2(
			deg_to_rad(event.relative.x * sensitivity),
			deg_to_rad(event.relative.y * sensitivity))
		
		
		rotate_camera(camera_direction)


func rotate_camera(camera_direction : Vector2) -> void:
	camera_pivot.rotate_y(-camera_direction.x)

	camera_rod.rotate_x(-camera_direction.y)
		
	# Limit vertical rotation
	camera_rod.rotation_degrees.x = clamp(
		camera_rod.rotation_degrees.x,
		camera_min_vertical_rotation, camera_max_vertical_rotation
	)
