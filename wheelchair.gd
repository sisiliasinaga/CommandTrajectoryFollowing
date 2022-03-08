extends Area2D

const SQLite = preload("res://addons/godot-sqlite/bin/gdsqlite.gdns")
var db
var db_name = "res://UserDataStore/userdatabase"

var rotation_speed = 0.01
var forward_speed = 0.8
var past_first_block = false  #used for final instructions (i.e. stop)
var on_curved_path = false

var time_start = 0.0
var time_now = 0.0
var time_exit = 0.0
var time_enter = 0.0
var nBB = 0
var time_outside = 0.0

var inpx = 0.0
var inpy = 0.0
var max_speed = 0.0

# var input_type = "keyboard"
var input_type = "controller"

func _ready():
	position.x = 550
	position.y = 550
	rotation = PI
	get_node('../curve_collision_area').hide()
	
	db = SQLite.new()
	db.path = db_name
	time_start = OS.get_ticks_msec()
	
	# global_translate(Vector2(40, 50))

func _process(delta):
	if input_type == "keyboard":
		inpx = (int(Input.is_action_pressed("ui_right")) - int(Input.is_action_pressed("ui_left")))
		inpy = (int(Input.is_action_pressed("ui_down")) - int(Input.is_action_pressed("ui_up")))
	else:
		inpx = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
		inpy = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	var angle  = rotation-PI/2
	position.x += forward_speed*inpy*cos(angle)
	position.y += forward_speed*inpy*sin(angle)
	rotation += rotation_speed*inpx
	change_display_directions()
	
func change_display_directions():
	var bot_y = 550
	var right_x = 550
	var left_x = 50
	var top_y = 50
	var pos_tol = 40
	var rot_tol = 10*PI/180
	var up_heading = PI
	var left_heading = PI/2
	var right_heading = -PI/2
	var down_heading = 0
	var rot = wrap_pi(rotation)
	# print("X:", position.x)
	# print("Y:", position.y)
	# FIRST TURN BLOCK
	if position.x < (right_x-left_x)/2:
		past_first_block = true
	if abs(position.x - right_x) <pos_tol and abs(position.y-top_y) <pos_tol and abs(up_heading - abs(rot)) < rot_tol :   #the abs(rot) only needed for up_heading
		$direction_arrow.set_rotation(-PI/2)
		$Camera2D/direction_label.set_text("Left")
		# print("Left")
	if abs(position.x - right_x) <pos_tol and abs(position.y-top_y) <pos_tol and abs(left_heading - rot) < rot_tol :
		$direction_arrow.set_rotation(0)
		$Camera2D/direction_label.set_text("Forward")
		#past_first_block = true
		# print("Forward")
	# SECOND TURN BLOCK
	if abs(position.x - left_x) <pos_tol and abs(position.y-top_y) <pos_tol and abs(left_heading - rot) < rot_tol :
		$direction_arrow.set_rotation(PI/2)
		$Camera2D/direction_label.set_text("Right")
	if abs(position.x - left_x) <pos_tol and abs(position.y-top_y) <pos_tol and abs(up_heading - abs(rot)) < rot_tol :
		$direction_arrow.set_rotation(-PI)
		$Camera2D/direction_label.set_text("Backward")
	## 3rd TURN BLOCK
	if abs(position.x - left_x) <pos_tol and abs(position.y-bot_y) <pos_tol and abs(up_heading - abs(rot)) < rot_tol :
		$direction_arrow.set_rotation(-PI/2)
		$Camera2D/direction_label.set_text("Left")
	if abs(position.x - left_x) <pos_tol and abs(position.y-bot_y) <pos_tol and abs(left_heading - rot) < rot_tol :
		$direction_arrow.set_rotation(-PI)
		$Camera2D/direction_label.set_text("Backward")
	## FINAL BLOCK
	if abs(position.x - right_x) <pos_tol and abs(position.y-bot_y) <pos_tol and abs(left_heading - rot) < rot_tol :
		$direction_arrow.set_rotation(PI/2)
		$Camera2D/direction_label.set_text("Right")
	if (past_first_block):
		if abs(position.x - right_x) <pos_tol and abs(position.y-bot_y) <pos_tol and abs(up_heading - abs(rot)) < rot_tol :
			$direction_arrow.hide()
			$Camera2D/direction_label.set_text("Follow path")
			on_curved_path = true
			get_node('../curve_collision_area').show()
			get_node('../path_area').hide()
			get_node('../path_color').hide()
			get_node('../collision_area').hide()
#			get_node('../path/turn2').hide()
#			get_node('../path/turn3').hide()
#			get_node('../path/turn4').hide()
			
		if abs(position.x - 2200) < pos_tol and abs(position.y-550) < pos_tol:
			$Camera2D/direction_label.set_text("Done")
			time_now = OS.get_ticks_msec()
			var elapsed_time = float((time_now - time_start) / 1000)
			
			var tOB = float(time_outside / elapsed_time)
			
			Global.percent_oob = tOB
			
			db.open_db()
			var db_query = "insert into UserSignalsTrajectory (nBB, tOB, UserID) values ('" + str(nBB)
			db_query += "', '" + str(tOB)
			db_query += "', '1')"
			db.query(db_query)
			
			get_tree().change_scene("res://TrajectoryFollowingResults.tscn")
			# print("Writing to database")
			return

func calc_avg_speed(t_0, t_f, x_0, x_f, y_0, y_f):
	var numerator = sqrt(pow(x_f - x_0, 2) - pow(y_f - y_0, 2))
	var denom = t_f - t_0
	return numerator / denom
	
func calc_avg_stability(t_0, t_f):
	# https://jneuroengrehab.biomedcentral.com/track/pdf/10.1186/s12984-015-0090-9.pdf
	pass  # read more on the paper before trying to implement

func wrap_pi(angle):
	while angle < -PI:
		angle += 2*PI
	
	while angle > PI:
		angle -= 2*PI
	return angle		
		

func _on_collision_area_area_entered(area):
	if (!on_curved_path):
		# print("enter")
		nBB += 1
		time_enter = OS.get_ticks_msec()


func _on_collision_area_area_exited(area):
	if (!on_curved_path):
		# print("exit")
		time_exit = OS.get_ticks_msec()
		time_outside += (time_exit - time_enter)
		print(time_outside)


func _on_curve_collision_area_area_entered(area):
	if (on_curved_path):
		print("enter")
		time_exit = OS.get_ticks_msec()
		time_outside += (time_exit - time_enter)
		print(time_outside)


func _on_curve_collision_area_area_exited(area):
	if (on_curved_path):
		print("exit")
		nBB += 1
		time_enter = OS.get_ticks_msec()


func _on_BackButton_pressed():
	get_tree().change_scene("res://Menu.tscn")
