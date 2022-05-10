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


func _on_FatigueButton_pressed():
	get_tree().change_scene("res://FatiguePhysical.tscn")


func _on_MotivationButton_pressed():
	get_tree().change_scene("res://MotivationIntEnjoy.tscn")


func _on_WorkloadButton_pressed():
	get_tree().change_scene("res://WorkloadStart.tscn")


func _on_PainButton_pressed():
	pass # Replace with function body.


func _on_StimulantButton_pressed():
	get_tree().change_scene("res://StimulantConsumption.tscn")


func _on_ConfidenceButton_pressed():
	get_tree().change_scene("res://Confidence.tscn")


func _on_StressButton_pressed():
	get_tree().change_scene("res://StressWorries.tscn")