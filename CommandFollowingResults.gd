extends Control


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	print("Number settled: " + str(Global.num_settled))
	get_node("NinePatchRect/VBoxContainer/TotalCommands").text = "Total number of commands given: " + str(Global.prompted_commands)
	get_node("NinePatchRect/VBoxContainer/SuccessfulCommands").text = "Average successful response percent: " + str(Global.num_correct / (Global.prompted_commands) * 100) + "%"
	get_node("NinePatchRect/VBoxContainer/AvgResponse").text = "Average response time: " + str(Global.avg_response_time) + " sec"
	get_node("NinePatchRect/VBoxContainer/AvgSettlingPercent").text = "Average successful settling percent: " + str(Global.num_settled / (Global.prompted_commands) * 100) + "%"
	get_node("NinePatchRect/VBoxContainer/AvgSettling").text = "Average settling time: " + str(Global.avg_settling_time) + " sec"
	get_node("NinePatchRect/VBoxContainer/InitResponseAcc").text = "Initial response accuracy: " + str(Global.init_response_acc)
	get_node("NinePatchRect/VBoxContainer/AvgSettlingAcc").text = "Average settling accuracy: " + str(Global.avg_settling_acc)


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_TaskButton_pressed():
	get_tree().change_scene("res://CommandFollowing.tscn")


func _on_MenuButton_pressed():
	get_tree().change_scene("res://Menu.tscn")
