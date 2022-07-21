extends Control


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var performance_mental = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Performance_toggled(button_pressed):
	performance_mental = 0


func _on_Mental_toggled(button_pressed):
	performance_mental = 1


func _on_Button_button_up():
	if performance_mental == 0:
		Global.performance_sum += 1
	else:
		Global.mental_sum += 1
	get_tree().change_scene("res://PerformancevTemporal.tscn")


func _on_BackButton_pressed():
	get_tree().change_scene("res://PhysicalvTemporal.tscn")


func _on_MenuButton_pressed():
	get_tree().change_scene("res://Questionnaires.tscn")
