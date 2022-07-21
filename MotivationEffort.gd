extends Control


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

const SQLite = preload("res://addons/godot-sqlite/bin/gdsqlite.gdns")
var db
var db_name = "res://UserDataStore/userdatabase"

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_HSlider16_value_changed(value):
	Global.motiv_q16 = value


func _on_HSlider17_value_changed(value):
	Global.motiv_q17 = value


func _on_HSlider18_value_changed(value):
	Global.motiv_q18 = value


func _on_Button_button_up():
	db.open_db()
	var db_query = "insert into MotivationQuestions (UserID, Q1, Q2, Q3, Q4, Q5, Q6, Q7, Q8, Q9, Q10, Q11, Q12, Q13, Q14, Q15, Q16, Q17, Q18) values ('" + Global.user_ID
	db_query += "', '" + str(Global.motiv_q1)
	db_query += "', '" + str(Global.motiv_q2)
	db_query += "', '" + str(Global.motiv_q3)
	db_query += "', '" + str(Global.motiv_q4)
	db_query += "', '" + str(Global.motiv_q5)
	db_query += "', '" + str(Global.motiv_q6)
	db_query += "', '" + str(Global.motiv_q7)
	db_query += "', '" + str(Global.motiv_q8)
	db_query += "', '" + str(Global.motiv_q9)
	db_query += "', '" + str(Global.motiv_q10)
	db_query += "', '" + str(Global.motiv_q11)
	db_query += "', '" + str(Global.motiv_q12)
	db_query += "', '" + str(Global.motiv_q13)
	db_query += "', '" + str(Global.motiv_q14)
	db_query += "', '" + str(Global.motiv_q15)
	db_query += "', '" + str(Global.motiv_q16)
	db_query += "', '" + str(Global.motiv_q17)
	db_query += "', '" + str(Global.motiv_q18)
	db_query += "')"
	db.query(db_query)
	
	get_tree().change_scene("res://Questionnaires.tscn")


func _on_BackButton_pressed():
	get_tree().change_scene("res://MotivationPercEffort.tscn")


func _on_MenuButton_pressed():
	get_tree().change_scene("res://Questionnaires.tscn")
