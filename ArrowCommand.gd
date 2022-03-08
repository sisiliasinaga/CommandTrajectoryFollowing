extends Polygon2D

const SQLite = preload("res://addons/godot-sqlite/bin/gdsqlite.gdns")
var db
var db_name = "res://UserDataStore/userdatabase"

# Variables to define the arrows in the GUI
var follow_color = Color(0.1,.9,.05)
var off_color = Color(1,1,1)
var color_dict = {-1: off_color, 1: follow_color}
var arrow_list = ["left", "right", "up", "down"]
var arrow_str = "none"
var user_dir = "none"
var curr_target = null
var angle

# Variables to calculate parameters
var num_incorrect = 0
var num_attempts = 0
var prompt_start_time = 0
var duration = 0
var response_time = 0
var target_mag = 0
var scale_amount = 0

var sum_t_r = 0
# var t_r = 0

var epsilon = 10 * PI / 180

# var input_type = "keyboard"
var input_type = "controller"
var input_vector = Vector2.ZERO
var input_theta = 0
var target_angle = 0

var started = false
var first_response = false
var commands_list = []
var durations_list = []
var magnitude_list = []
var command_index = 0

var rng = RandomNumberGenerator.new()

var commands_per_rep = Global.commands_terminate / Global.repetitions

func _ready():
	# Called when the node is added to the scene for the first time.
	# Initialization here
	get_node("../Button").connect("pressed",self,"on_start_button")
	
	db = SQLite.new()
	db.path = db_name
	
	num_attempts = 0
	commands_list = []
	rng.randomize()
	
	Global.prompted_commands = 0
	Global.num_correct = 0
	Global.avg_response_time = 0.0
	
	if !Global.magnitude:
		get_node("../MagnitudeLabel").hide()
	
	generate_commands()

func _input(event):
	var arrow_node = get_node("../ArrowFeedback")
	if event is InputEventKey and event.pressed:
		if event.scancode == KEY_UP:
			angle = 0
			user_dir = "up"
		elif event.scancode == KEY_DOWN:
			angle = PI
			user_dir = "down"
		elif event.scancode == KEY_LEFT:
			angle = -PI/2
			user_dir = "left"
		elif event.scancode == KEY_RIGHT:
			angle = PI/2
			user_dir = "right"
		arrow_node.set_rotation(angle)
		arrow_node.show()
			
	elif event is InputEventJoypadMotion:
		input_vector.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
		input_vector.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
		# input_vector = input_vector.normalized()
		
		input_theta = atan2(input_vector.y, input_vector.x) + PI / 2
		arrow_node.set_rotation(input_theta)
		if Global.magnitude:
			var polygon : PoolVector2Array = arrow_node.polygon
			scale_amount = sqrt(pow(input_vector.x, 2) + pow(input_vector.y, 2)) / 2
			arrow_node.scale = Vector2(scale_amount, scale_amount)
		arrow_node.show()
			
	else:
		# print("hide")
		user_dir = "none"
		arrow_node.hide()

func _process(delta):
	if input_type == "keyboard":
		if user_dir == arrow_str and user_dir != "none":
			# print("correct input")
			Global.num_correct += 1
			
			# Calculate tR (time b/t prompt and correct response)
			var response_time = OS.get_ticks_msec()
			sum_t_r += (response_time - prompt_start_time)
			# t_r = (1 / prompted_commands) * sum_t_r
			
			if curr_target != null:
				curr_target.hide()
			target_arrow()
		elif user_dir == "none":
			num_attempts += 1
		else:
			num_incorrect += 1
	elif input_type == "controller":
		if started == true:
			
			var curr_time = OS.get_ticks_msec()
			
			# If the user failed to give the correct response within the given duration
			if curr_time - prompt_start_time >= duration * 1000:
				num_incorrect += 1
				num_attempts += 1
				if curr_target != null:
					curr_target.hide()
				target_arrow()
			
			# angle checking for controller goes here
			if target_angle - epsilon <= input_theta and input_theta <= target_angle + epsilon and scale_amount >= target_mag:
				
				if first_response:
					# Calculate tR (time b/t prompt and correct response)
					response_time = OS.get_ticks_msec()
					sum_t_r += (response_time - prompt_start_time)
					Global.num_correct += 1
					first_response = false
				else:
					# print("duration: ", duration)
					# print("current time: ", OS.get_ticks_msec())
					# print("goal time: ", response_time + duration * 1000)
					if OS.get_ticks_msec() >= response_time + duration * 1000:
						if curr_target != null:
							curr_target.hide()
						num_attempts += 1
						
						target_arrow()
			else:
				if !first_response:
					first_response = true
					
	if num_attempts >= Global.commands_terminate:
		# write to SQL database here
		Global.avg_response_time = float(sum_t_r / Global.prompted_commands) / 1000.0
		get_tree().change_scene("res://CommandFollowingResults.tscn")
		
# Function to generate the arrow directions, durations, and magnitudes for the entire run
func generate_commands():
	for i in range(Global.commands_terminate / Global.repetitions):
		var next_command = randi() % 4
		if commands_list.size() > 0:
			while next_command == commands_list[-1]:
				next_command = randi() % 4
		commands_list.append(next_command)
		durations_list.append(randi() % (Global.max_time - Global.min_time) + Global.min_time)
		if Global.magnitude:
			magnitude_list.append(rng.randf_range(0.0, 1.0))

func target_arrow():
	first_response = true
	var arrow_index = commands_list[command_index]
	arrow_str = arrow_list[arrow_index]
	if arrow_str == "left":
		curr_target = get_node("../Arrows/ArrowLeft")
		target_angle = 3 * PI / 2
	elif arrow_str == "right":
		curr_target = get_node("../Arrows/ArrowRight")
		target_angle = PI / 2
	elif arrow_str == "up":
		curr_target = get_node("../Arrows/ArrowUp")
		target_angle = 0
	elif arrow_str == "down":
		curr_target = get_node("../Arrows/ArrowDown")
		target_angle = PI
	curr_target.show()
	prompt_start_time = OS.get_ticks_msec()
	duration = durations_list[command_index]
	if Global.magnitude:
		target_mag = magnitude_list[command_index]
		get_node("../MagnitudeLabel").set_text("Magnitude of command: " + str(target_mag))
	Global.prompted_commands += 1
	get_node("../DurationLabel").set_text("Command Duration: " + str(duration) + " sec")
	get_node("../CommandsLabel").set_text("Commands Given: " + str(Global.prompted_commands))
	command_index += 1
	if command_index >= commands_per_rep:
		command_index -= commands_per_rep

func on_start_button():
	var start_str = "start"
	# godot2ros_node.send_msg_to_ros(start_str)
	get_node("../Button").hide()
	self.get_node(".").hide()
	print("started")
	started = true
	target_arrow()
	
func pause():
	hide()
	

func _on_BackButton_pressed():
	get_tree().change_scene("res://Menu.tscn")


func _on_MenuButton_pressed():
	get_tree().change_scene("res://CommandFollowingMenu.tscn")
