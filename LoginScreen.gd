extends Control

const SQLite = preload("res://addons/godot-sqlite/bin/gdsqlite.gdns")
var db
var db_name = "res://UserDataStore/userdatabase"
var username = ""
var password = ""

# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	db = SQLite.new()
	db.path = db_name
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _on_LoginButton_pressed():
	var db_query = "select * from UserInfo where Username = '"
	db_query += username
	db_query += "' and Password = '"
	db_query += password
	db_query += "'"
	db.query(db_query)
	if db.query_result.size() > 0:
		print("Login successful!")
	else:
		print("Login failed. Please try again.")
	get_tree().change_scene("res://Menu.tscn")


func _on_CreateUserButton_pressed():
	db.open_db()
	var tableName = "UserInfo"
	var db_query = "insert into UserInfo (UserName, Password) values ('"
	db_query += username
	db_query += "', '"
	db_query += password
	db_query += "')"
	db.query(db_query)
	# dict["UserName"] = "ssinaga"
	# dict["Password"] = "0328"
	
	# db.insert_row(tableName, dict)


func _on_Username_text_changed(new_text):
	username = new_text


func _on_Password_text_changed(new_text):
	password = new_text
