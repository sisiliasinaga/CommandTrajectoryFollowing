extends Control


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

const SQLite = preload("res://addons/godot-sqlite/bin/gdsqlite.gdns")
var db
var db_name = "res://UserDataStore/userdatabase"

# Called when the node enters the scene tree for the first time.
func _ready():
	db = SQLite.new()
	db.path = db_name


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_EffortSlider_value_changed(value):
	Global.effort_slider = value


func _on_TemporalSlider_value_changed(value):
	Global.temporal_slider = value


func _on_PerformanceSlider_value_changed(value):
	Global.performance_slider = value


func _on_Button_button_up():
	# Store in SQL
	db.open_db()
	var tableName = "WorkloadQuestionnaire"
	var db_query = "insert into WorkloadQuestionnaire (MentalSum, PhysicalSum, TemporalSum, PerformanceSum, EffortSum, FrustrationSum, MentalSlider, PhysicalSlider, TemporalSlider, PerformanceSlider, EffortSlider, FrustrationSlider) values ('"
	db_query += str(Global.mental_sum) + "', '"
	db_query += str(Global.physical_sum) + "', '"
	db_query += str(Global.temporal_sum) + "', '"
	db_query += str(Global.performance_sum) + "', '"
	db_query += str(Global.effort_sum) + "', '"
	db_query += str(Global.frustration_sum) + "', '"
	db_query += str(Global.mental_slider) + "', '"
	db_query += str(Global.physical_slider) + "', '"
	db_query += str(Global.temporal_slider) + "', '"
	db_query += str(Global.performance_slider) + "', '"
	db_query += str(Global.effort_slider) + "', '"
	db_query += str(Global.frustration_slider) + "')"
	db.query(db_query)
	
	get_tree().change_scene("res://Questionnaires.tscn")


func _on_BackButton_pressed():
	get_tree().change_scene("res://WorkloadRatingSheet.tscn")


func _on_MenuButton_pressed():
	get_tree().change_scene("res://Questionnaires.tscn")
