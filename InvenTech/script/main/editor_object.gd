extends Node2D

var database : SQLite

@export var group : ButtonGroup

var can_place = true
var is_panning = true

@warning_ignore("shadowed_global_identifier")

@onready var floor = get_node("/root/editor/Floor")
@onready var floor_image = floor.get_node("floor_image")
@onready var cursor_sprite = get_node("Sprite2D")
@onready var object_cursor = get_node("/root/editor/editor_object")
@onready var folder = get_node("/root/editor/CanvasLayer/menu/hardware_select/FileDialog")
@onready var folder2 = get_node("/root/editor/CanvasLayer/menu/hardware_select/FileDialog2")

@onready var prev_btn = get_node("/root/editor/CanvasLayer/menu/prev_btn")
@onready var next_btn = get_node("/root/editor/CanvasLayer/menu/next_btn")

@onready var editor = get_node("/root/editor/cam_container")
@onready var editor_cam = editor.get_node("Camera2D")

@onready var model = get_node("/root/editor/CanvasLayer/menu/model")
@onready var flr = get_node("/root/editor/CanvasLayer/menu/floors")
@onready var btn_name = get_node("/root/editor/CanvasLayer/menu/button_name")
@onready var cab = get_node("/root/editor/CanvasLayer/menu/cabinet")
@onready var spot = get_node("/root/editor/CanvasLayer/menu/spot")
@onready var num = get_node("/root/editor/CanvasLayer/menu/number")
@onready var pc_name = get_node("/root/editor/CanvasLayer/menu/pc_name")

@onready var saved = get_node("/root/editor/CanvasLayer/menu/saved")
@onready var error = get_node("/root/editor/CanvasLayer/menu/error")

@onready var confirm_delete = get_node("/root/editor/CanvasLayer/menu/confirm_delete")
@onready var confirm_delete_label = get_node("/root/editor/CanvasLayer/menu/confirm_delete/Label")
@onready var confirm_drop = get_node("/root/editor/CanvasLayer/menu/confirm_drop")
@onready var confirm_drop_label = get_node("/root/editor/CanvasLayer/menu/confirm_drop/Label")

@onready var dir = OS.get_executable_path().get_base_dir()
@onready var floor_dir = dir.path_join('floors/')
@onready var data_dir = dir.path_join('database/data.db')

@onready var timer = get_node("/root/editor/CanvasLayer/menu/Timer")

var current_item
var cam_spd = 10

func _ready():
	var floors = DirAccess.get_files_at(floor_dir+Global.branch+"/")
	
	if len(floors) != 0:
		flr.clear()
		for i in range(1,len(floors)+1):
			flr.add_item(str(i))
	
	if Global.floor_to_select == 0:
		flr.select(-1)
	else:
		flr.select(Global.floor_to_select-1)
	
	database = SQLite.new()
	database.path = data_dir
	database.open_db()
	
	var child = floor.get_child_count()
	for i in range(1,child):
		if "Area" in str(floor.get_child(i)):
			var btn = floor.get_child(i).get_child(-1).get_child(-1)
			btn.pressed.connect(self.button_press)
			btn.set_button_group(group)
	
	saved.visible = false
	error.visible = false
	
	model.text = ""
	btn_name.text = ""
	cab.text = ""
	spot.text = ""
	num.text = ""
	pc_name.text = ""

func _process(_delta):
	global_position = get_global_mouse_position()
	
	if current_item != null and can_place and Input.is_action_just_pressed("mb_left"):
		var new_item = current_item.instantiate()
		floor.add_child(new_item)
		new_item.owner = floor
		new_item.global_position = get_global_mouse_position()
		new_item.name = Global.new_btn_name
		print(new_item)
		
		if "Area" in str(new_item):
			var btn_new = new_item.get_child(-1).get_child(0)
			print(btn_new)
			btn_new.pressed.connect(self.button_press)
			btn_new.set_button_group(group)
	
	if Input.is_action_pressed("remove"):
		current_item = null
		cursor_sprite.set_texture(null)
		
	move_editor()
	is_panning = Input.is_action_pressed("mb_right")

func move_editor():
	if Input.is_action_pressed("w"):
		editor.global_position.y -= cam_spd
	if Input.is_action_pressed("a"):
		editor.global_position.x -= cam_spd
	if Input.is_action_pressed("s"):
		editor.global_position.y += cam_spd
	if Input.is_action_pressed("d"):
		editor.global_position.x += cam_spd

func _unhandled_input(event):
	if event is InputEventMouseButton:
		if event.is_pressed():
			if event.button_index == MOUSE_BUTTON_WHEEL_UP:
				editor_cam.zoom += Vector2(0.2,0.2)
			if event.button_index == MOUSE_BUTTON_WHEEL_DOWN:
				editor_cam.zoom -= Vector2(0.2,0.2)
	if event is InputEventMouseMotion:
		if is_panning:
			editor.global_position -= event.relative * editor_cam.zoom
	
	pass

func button_press():
	var child = floor.get_child_count()
	var pr_button = str(group.get_pressed_button().get_parent().get_parent().name)
	var texture = group.get_pressed_button().get_parent()
	
	prev_btn.disabled = true
	next_btn.disabled = true
	
	Global.i = 0
	Global.info_count = 0
	Global.info_arr = []
	
	if Global.last_btn == "none":
		btn_name.text = pr_button
		texture.set_frame(1)
		
		Global.last_btn = pr_button
	else:
		if Global.last_btn != pr_button:
			var last_btn = floor.get_node(Global.last_btn)
			last_btn.get_child(-1).set_frame(0)
			
			btn_name.text = pr_button
			texture.set_frame(1)
			
			model.text = ""
			cab.text = ""
			spot.text = ""
			num.text = ""
			pc_name.text = ""
			
			saved.visible = false
			error.visible = false
			
			Global.last_btn = pr_button
	
	var query = "{} = '{}' and {} = '{}'"
	var data = database.select_rows(Global.office, query.format([Global.floor, flr.get_item_text(flr.get_selected()), Global.button, btn_name.text], "{}"), ["*"])
	
	if data.is_empty() == false:
		model.text = data[0].get(Global.model)
		cab.text = data[0].get(Global.cabinet)
		spot.text = data[0].get(Global.spot)
		num.text = data[0].get(Global.number)
		pc_name.text = data[0].get(Global.pc_name)
		
		if len(data) > 1:
			next_btn.disabled = false
			Global.info_count = len(data)
			Global.info_arr = data

func _on_exit_pressed():
	Global.last_btn = "none"
	Global.last_btn_color = 0
	Global.floor_to_select = 0
	
	Global.i = 0
	Global.info_count = 0
	Global.info_arr = []
	
	Global.new_btn_name = "new_btn"
	
	get_tree().change_scene_to_file("res://scenes/main/start_screen.tscn")

func _on_save_pressed():
	var flr_index = flr.get_selected()
	var flor = str(flr.get_item_text(flr_index))
	
	if btn_name.text != "":
		var query = "{} = '{}' and {} = '{}' and {} = '{}'"
		var query2 = "{} = '{}'"
		
		var data_to_add = {
			"Кнопка" : btn_name.text,
			"Этаж" : flor,
			"Кабинет" : cab.text,
			"Место" : spot.text,
			"Серийный_номер" : num.text,
			"Имя_ПК" : pc_name.text,
			"Модель" : model.text
		}
		
		database.insert_row(Global.office, data_to_add)
		
		if len(num.text) != 0:
			var data = database.select_rows(Global.office, query.format([Global.cabinet, cab.text, Global.spot, spot.text, Global.number, ''], "{}"), ["*"])
			
			if data.is_empty() == false:
				database.delete_rows(Global.office, query.format([Global.cabinet, cab.text, Global.spot, spot.text, Global.number, ''], "{}"))
		
		btn_name.text = ""
		model.text = ""
		cab.text = ""
		spot.text = ""
		num.text = ""
		pc_name.text = ""
		
		Global.i = 0
		Global.info_count = 0
		Global.info_arr = []
		
		var last_btn = floor.get_node(Global.last_btn)
		last_btn.get_child(-1).set_frame(0)
		
		Global.last_btn = "none"
		Global.last_btn_color = 0
		
		prev_btn.disabled = true
		next_btn.disabled = true
		
		saved.visible = true
		error.visible = false
		
		timer.start()
	else:
		saved.visible = false
		error.visible = true
		
		timer.start()

func _on_search_pressed():
	Global.new_btn_name = btn_name.text
	btn_name.text = ""

func _on_drop_pressed():
	confirm_drop.visible = true
	confirm_delete.visible = false
	
	confirm_drop_label.text = confirm_drop_label.text.format([btn_name.text], "{}")

func _on_cancel_drop_pressed():
	confirm_drop.visible = false

func _on_confirm_drop_pressed():
	confirm_drop.visible = false
	
	var query = "{} = '{}' and {} = '{}' and {} = '{}'"
	
	var data = database.select_rows(Global.office, query.format([Global.floor, flr.get_item_text(flr.get_selected()), Global.button, btn_name.text, Global.number, num.text], "{}"), ["*"])
	
	if data.is_empty() == false:
		database.delete_rows(Global.office, query.format([Global.floor, flr.get_item_text(flr.get_selected()), Global.button, btn_name.text, Global.number, num.text], "{}"))
	
	query = "{} = '{}' and {} = '{}' and {} != '{}'"
	data = database.select_rows(Global.office, query.format([Global.spot, spot.text, Global.cabinet, cab.text, Global.number, num.text], "{}"), ["*"])
	
	if data.is_empty() == true:
		var data_to_add = {
			Global.button : btn_name.text,
			Global.floor : flr.get_item_text(flr.get_selected()),
			Global.cabinet : cab.text,
			Global.spot : spot.text,
			Global.number : num.text,
			Global.pc_name : pc_name.text,
			Global.model : model.text
		}
		
		database.insert_row(Global.office, data_to_add)
	else:
		var data_to_add = {
			"Кнопка" : btn_name.text,
			"Этаж" : flr.get_item_text(flr.get_selected()),
			"Кабинет" : cab.text,
			"Место" : spot.text,
			"Серийный_номер" : "",
			"Имя_ПК" : "",
			"Модель" : ""
		}
		
		database.insert_row(Global.office, data_to_add)
	
	btn_name.text = ""
	cab.text = ""
	spot.text = ""
	num.text = ""
	pc_name.text = ""
	model.text = ""
	
	prev_btn.disabled = true
	next_btn.disabled = true
	
	Global.i = 0
	Global.info_count = 0
	Global.info_arr = []
	
	saved.visible = false
	error.visible = false

func _on_delete_pressed():
	confirm_delete.visible = true
	confirm_drop.visible = false
	
	confirm_delete_label.text = confirm_delete_label.text.format([btn_name.text], "{}")

func _on_cancel_delete_pressed():
	confirm_delete.visible = false

func _on_confirm_delete_pressed():
	confirm_delete.visible = false
	
	var query = "{} = '{}' and {} = '{}'"
	
	var data = database.select_rows(Global.office, query.format([Global.floor, flr.get_item_text(flr.get_selected()), Global.button, btn_name.text], "{}"), ["*"])
	
	if data.is_empty() == false:
		database.delete_rows(Global.office, query.format([Global.floor, flr.get_item_text(flr.get_selected()), Global.button, btn_name.text], "{}"))
	
	floor.remove_child(floor.find_child(btn_name.text))
	print("Deleted: ", btn_name.text)
	
	Global.last_btn = "none"
	Global.last_btn_color = 0
	
	model.text = ""
	btn_name.text = ""
	cab.text = ""
	spot.text = ""
	num.text = ""
	pc_name.text = ""
	
	prev_btn.disabled = true
	next_btn.disabled = true
	
	Global.i = 0
	Global.info_count = 0
	Global.info_arr = []
	
	saved.visible = false
	error.visible = false

func _on_mouse_entered():
	object_cursor.can_place = false
	object_cursor.hide()

func _on_mouse_exited():
	object_cursor.can_place = true
	object_cursor.show()

func _on_load_image_pressed():
	folder2.popup()
	folder2.clear_filters()
	folder2.set_file_mode(FileDialog.FILE_MODE_OPEN_FILE)
	folder2.set_filters(PackedStringArray(["*.png ; PNG Images", "*.jpg ; JPG Images"]))

func _on_load_floor_pressed():
	folder.popup()
	folder.clear_filters()
	folder.set_file_mode(FileDialog.FILE_MODE_OPEN_FILE)
	folder.set_filters(PackedStringArray(["*.tscn"]))

func _on_save_floor_pressed():
	folder.popup()
	folder.clear_filters()
	folder.set_file_mode(FileDialog.FILE_MODE_SAVE_FILE)
	folder.set_filters(PackedStringArray(["*.tscn"]))

func save_floor():
	var toSave : PackedScene = PackedScene.new()
	floor_image.owner = floor
	toSave.pack(floor)
	ResourceSaver.save(toSave,folder.current_path)

func _on_folder_confirmed():
	if folder.title == "Save a File":
		save_floor()
	else:
		load_floor()
		_ready()

func load_floor():
	var toLoad : PackedScene = PackedScene.new()
	toLoad = ResourceLoader.load(folder.current_path)
	Global.floor_to_select = int(str(folder.current_path).get_slice("floor",3).get_slice(".", 0).left(-2))
	var this_floor = toLoad.instantiate()
	get_parent().remove_child(floor)
	floor.queue_free()
	get_parent().add_child(this_floor)
	floor_image = get_parent().get_node("Floor/floor_image")
	floor = this_floor

func _folder_confirm():
	var image = Image.new()
	var texture = ImageTexture.new()
	image = Image.load_from_file(folder2.current_path)
	texture = ImageTexture.create_from_image(image)
	floor_image.texture = texture

func _on_timer_timeout():
	saved.visible = false
	error.visible = false

func _on_prev_btn_pressed():
	Global.i -= 1
	
	if next_btn.disabled == true:
		next_btn.disabled = false
	
	if Global.i == 0:
		prev_btn.disabled = true
	
	model.text = Global.info_arr[Global.i].get(Global.model)
	cab.text = Global.info_arr[Global.i].get(Global.cabinet)
	spot.text = Global.info_arr[Global.i].get(Global.spot)
	num.text = Global.info_arr[Global.i].get(Global.number)
	pc_name.text = Global.info_arr[Global.i].get(Global.pc_name)

func _on_next_btn_pressed():
	Global.i += 1
	
	if prev_btn.disabled == true:
		prev_btn.disabled = false
	
	if Global.i == Global.info_count-1:
		next_btn.disabled = true
	
	model.text = Global.info_arr[Global.i].get(Global.model)
	cab.text = Global.info_arr[Global.i].get(Global.cabinet)
	spot.text = Global.info_arr[Global.i].get(Global.spot)
	num.text = Global.info_arr[Global.i].get(Global.number)
	pc_name.text = Global.info_arr[Global.i].get(Global.pc_name)
