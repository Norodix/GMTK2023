extends CharacterBody3D

var movement_speed: float = 2.0
var movement_target_position: Vector3 = Vector3(-3.0,0.0,2.0)

@onready var navigation_agent: NavigationAgent3D = $NavigationAgent3D

var attention_counter = 0
@onready var shout_detection_marker = preload("res://Characters/shout_detection_marker.tscn")
var working = false

@export var tasks : Array[Node3D]

func _ready():
	# Make sure to not await during _ready.
	call_deferred("actor_setup")


func actor_setup():
	# Wait for the first physics frame so the NavigationServer can sync.
	await get_tree().physics_frame

	# Now that the navigation map is no longer empty, set the movement target.
	set_movement_target(movement_target_position)


func grab_attention():
	if working: return
	attention_counter += 1
	var marker : Sprite3D = shout_detection_marker.instantiate()
	self.add_child(marker)
	marker.top_level = true
	
	if attention_counter >= 1:
		attention_counter = 0
		activate_task(randi() % tasks.size())


func set_movement_target(movement_target: Vector3):
	navigation_agent.set_target_position(movement_target)


func _physics_process(delta):
	if navigation_agent.is_navigation_finished():
		# Arrived at destination
		if working:
			# start work animation
			var bodies : Array[Area3D] = $Interactor.get_overlapping_areas()
			print("bodies: ", bodies)
			if not bodies.is_empty():
				if bodies[0].has_method("interact"):
					bodies[0].interact()
				
			# on animation finished set working to false
			working = false
			pass
		else:
			set_movement_target(Vector3(randf_range(-5, 5), 0, randf_range(-5, 5)))
		return

	var current_agent_position: Vector3 = global_position
	var next_path_position: Vector3 = navigation_agent.get_next_path_position()

	var new_velocity: Vector3 = next_path_position - current_agent_position
	new_velocity = new_velocity.normalized()
	new_velocity = new_velocity * movement_speed

	velocity = lerp(velocity, new_velocity, 0.1)
	move_and_slide()


func activate_task(index):
	if index >= tasks.size():
		print("invalid task index")
		return
	working = true
	set_movement_target(tasks[index].global_position)
