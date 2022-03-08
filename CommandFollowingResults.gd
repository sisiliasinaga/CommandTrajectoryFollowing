extends Control


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	get_node("NinePatchRect/VBoxContainer/SuccessfulCommands").text = "Number of succesful commands: " + str(Global.num_correct)
	get_node("NinePatchRect/VBoxContainer/TotalCommands").text = "Total number of commands given: " + str(Global.prompted_commands - 1)
	get_node("NinePatchRect/VBoxContainer/AvgResponse").text = "Average response time: " + str(Global.avg_response_time) + " sec"


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_TaskButton_pressed():
	get_tree().change_scene("res://CommandFollowing.tscn")


func _on_MenuButton_pressed():
	get_tree().change_scene("res://Menu.tscn")
