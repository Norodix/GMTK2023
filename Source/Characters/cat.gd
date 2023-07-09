extends CharacterBody3D

var movement_speed: float = 2.0
var movement_target_position: Vector3 = Vector3(-3.0,0.0,2.0)

@onready var navigation_agent: NavigationAgent3D = $NavigationAgent3D

var attention_counter = 0
@onready var shout_detection_marker = preload("res://Characters/shout_detection_marker.tscn")
var seek_work = false
var working = false
var current_target_time = 0
const target_timeout = 10

@export var tasks : Array[Node3D]
var task_counter = 0
@onready var anim_state_machine : AnimationNodeStateMachinePlayback = $Cat/AnimationTree["parameters/playback"]
@onready var anim_player : AnimationPlayer = $Cat/AnimationPlayer
@onready var avatar : Node3D = $Cat

func _ready():
	# Make sure to not await during _ready.
	call_deferred("actor_setup")


func actor_setup():
	# Wait for the first physics frame so the NavigationServer can sync.
	await get_tree().physics_frame

	# Now that the navigation map is no longer empty, set the movement target.
	set_movement_target(movement_target_position)


func grab_attention():
	if working or seek_work: return
	attention_counter += 1
	var marker : Sprite3D = shout_detection_marker.instantiate()
	self.add_child(marker)
	marker.top_level = true
	
	if attention_counter >= 1:
		attention_counter = 0
		activate_task(task_counter)


func set_random_target():
	set_movement_target(Vector3(randf_range(-5, 5), 0, randf_range(-5, 5)))


func set_movement_target(movement_target: Vector3):
	navigation_agent.set_target_position(movement_target)
#	print(navigation_agent.is_target_reachable())


func _physics_process(delta):
	if navigation_agent.is_navigation_finished():
		# Arrived at destination
		current_target_time = 0
		if seek_work:
			seek_work = false
			working = true
			# start work animations
			var bodies : Array[Area3D] = $Interactor.get_overlapping_areas()
			print("bodies: ", bodies)
			if not bodies.is_empty():
				if bodies[0].has_method("interact"):
					anim_state_machine.travel("Use")
					await get_tree().create_timer(anim_player.get_animation("Use").length).timeout
					bodies[0].interact()
					task_counter += 1
				
			# on animation finished set working to false
			working = false
			pass
		elif working:
			pass
		else:
			set_random_target()
		return
	
	# not at target yet
	current_target_time += delta
	if current_target_time > target_timeout:
		print("navigation timeout")
		current_target_time = 0
		set_random_target()
	var current_agent_position: Vector3 = global_position
	var next_path_position: Vector3 = navigation_agent.get_next_path_position()

	var new_velocity: Vector3 = next_path_position - current_agent_position
	new_velocity = new_velocity.normalized()
	new_velocity = new_velocity * movement_speed

	velocity = lerp(velocity, new_velocity, 0.1)
	velocity.y -= 10 * delta
	move_and_slide()
	var look_velocity = velocity
	look_velocity.y = 0
	if look_velocity.length() > 0.05:
		avatar.look_at(self.global_position - look_velocity.normalized(), Vector3.UP)
	
	if velocity.length() > 0.05:
		var current = anim_state_machine.get_current_node()
		if current != "Use":
			anim_state_machine.travel("Movement")


func activate_task(index):
	if index >= tasks.size():
		print("invalid task index")
		return
	seek_work = true
	var target_pos = tasks[index].global_position
	var interactible = tasks[index].find_child("Interactible")
	if interactible != null:
		target_pos = interactible.global_position
	set_movement_target(target_pos)
