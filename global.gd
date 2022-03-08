extends Node

# Variables to store inputs for command following menu
# Current values are standard values
var repetitions = 1
var commands_terminate = 5
var min_time = 1
var max_time = 5
var magnitude = false

# Variables to display on the results page after command following is done
var prompted_commands = 0
var num_correct = 0
var avg_response_time = 0.0
var avg_settling_time = 0.0
var control_acc = 0.0

# Variables to display on trajectory results page
var avg_stability = 0.0
var avg_speed = 0.0
var percent_oob = 0.0

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
