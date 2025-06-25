extends Node2D

var database : SQLite

@onready var good_not_good = get_node("Label")

@onready var office = get_node("office")
@onready var branch = get_node("branch")
@onready var address = get_node("LineEdit")

@onready var fun_btn = get_node("fun_btn")

@onready var files = get_node("files")

@onready var dir = OS.get_executable_path().get_base_dir()
@onready var floor_dir = dir.path_join('floors/')
@onready var data_dir = dir.path_join('database/data.db')

func _ready():
	good_not_good.text = str(floor_dir)
	database = SQLite.new()
	database.path = data_dir
	database.open_db()
	
	database.query("Select * from office_b1")
	var result = database.query_result
	print(result)

func _on_back_pressed():
	get_tree().change_scene_to_file("res://scenes/main/start_screen.tscn")

func _on_add_pressed():
	pass

func _on_fun_btn_pressed():
	database.query("select * from office_b1")
	var data = database.query_result
	
	var query = "{} = '{}' and {} = '{}'"
	
	var floor = ""
	var btn = ""
	var spot = ""
	var cabinet = ""
	var model = ""
	var number = ""
	var pc_name = ""
	
	var data_to_add = {}
	
	for i in range(len(data)):
		btn = data[i].get(Global.button)
		floor = data[i].get(Global.floor)
		cabinet = data[i].get(Global.cabinet)
		spot = data[i].get(Global.spot)
		number = data[i].get(Global.number)
		model = data[i].get(Global.model)
		
		database.delete_rows("office_b1", query.format([Global.button, btn, Global.number, number], "{}"))
		
		data_to_add = {
			Global.button : btn,
			Global.floor : floor,
			Global.cabinet : cabinet,
			Global.spot : spot,
			Global.number : number,
			Global.pc_name : pc_name,
			Global.model : model
		}
		
		database.insert_row("office_b1", data_to_add)
	
	good_not_good.text = "Победа"
