extends Control


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_CommandButton_pressed():
	get_tree().change_scene("res://CommandFollowing.tscn")


func _on_TrajectoryButton_pressed():
	get_tree().change_scene("res://TrajectoryFollowing.tscn")


func _on_UserInfo_pressed():
	get_tree().change_scene("res://UserInfo.tscn")


func _on_UserResults_pressed():
	get_tree().change_scene("res://OutcomeResults.tscn")


func _on_Questionnaires_pressed():
	get_tree().change_scene("res://Questionnaires.tscn")
