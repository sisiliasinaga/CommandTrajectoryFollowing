extends Control

# Needed to use checkboxes
# var group = $NinePatchRect/VBoxContainer/CheckBox.group
onready var only_dir = get_node("NinePatchRect/VBoxContainer/CheckBox")
onready var mag_dir = get_node("NinePatchRect/VBoxContainer/CheckBox2")

# Called when the node enters the scene tree for the first time.
func _ready():
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_RepetitionsInput_text_changed(new_text):
	Global.repetitions = int(new_text)


func _on_CommandsTerminateInput_text_changed(new_text):
	Global.commands_terminate = int(new_text)


func _on_MinTimeInput_text_changed(new_text):
	Global.min_time = int(new_text)


func _on_MaxTimeInput_text_changed(new_text):
	Global.max_time = int(new_text)


func _on_CheckBox_toggled(button_pressed):
	Global.magnitude = false


func _on_CheckBox2_toggled(button_pressed):
	Global.magnitude = true


func _on_Button_pressed():
	get_tree().change_scene("res://CommandFollowing.tscn")
