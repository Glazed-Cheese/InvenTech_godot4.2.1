extends Node2D

@export var group : ButtonGroup
@export var floor_group : ButtonGroup

var is_panning = true

var database : SQLite

@onready var main = get_node("cam_container")
@onready var main_cam = main.get_node("Camera2D")

@onready var floor = get_node("/root/Main/Floor")
@onready var floor_image = floor.get_node("floor_image")

@onready var floor_btns = get_node("menu/floor_btns")

@onready var floor_list = get_node("menu/floor_list")
@onready var floor_select = get_node("menu/floor_list/floor_select")

@onready var list = get_node("/root/Main/menu/ItemList")
@onready var edit = get_node("/root/Main/menu/LineEdit")
@onready var info = get_node("/root/Main/menu/info")
@onready var label2 = get_node("/root/Main/menu/Label2")

@onready var dir = OS.get_executable_path().get_base_dir()
@onready var floor_dir = dir.path_join('floors/')
@onready var data_dir = dir.path_join('database/data.db')

var cam_spd = 10

func _ready():
	floor_list.visible = true
	floor_btns.visible = false
	
	var floors = DirAccess.get_files_at(floor_dir+Global.branch+"/")
	
	for i in range(1,len(floors)+1):
		floor_select.add_item(str(i))
	
	floor_select.select(-1)
	
	database = SQLite.new()
	database.path = data_dir
	database.open_db()

func _on_floor_btn_pressed():
	var floor_text = ""
	var buttn = floor_group.get_pressed_button()
	Global.current_button = buttn
	
	if Global.search == false:
		Global.last_btn = "none"
		Global.last_btn_color = 0
	
	print(buttn)
	
	if "null" not in str(buttn):
		floor_text = int(buttn.text.get_slice(" ",0))
	else:
		floor_text = int(Global.right_btn.right(1))
		print(Global.right_btn)
		print(floor_text)
	
	var toLoad : PackedScene = PackedScene.new()
	
	Global.current_floor = floor_text
	
	var floors = DirAccess.get_files_at(floor_dir+Global.branch+"/")
	var flr1 = ""
	var num1
	
	for i in range(len(floors)):
		num1 = 0
		var fl = floors[i].get_slice(".", 0).left(-2)
		
		print(int(fl))
		
		for j in range(1, len(fl)+1):
			if fl.right(j).is_valid_int() == false:
				num1 = int(fl.right(j))
				break
		
		if num1 == floor_text:
			flr1 = floors[i]
			print(flr1)
	
	toLoad = ResourceLoader.load(floor_dir+Global.branch+"/"+flr1)
	
	var this_floor = toLoad.instantiate()
	self.remove_child(floor)
	floor.queue_free()
	self.add_child(this_floor)
	floor_image = self.get_node("Floor/floor_image")
	floor = this_floor
	
	var child = floor.get_child_count()
	for i in range(1,child):
		if "Area" in str(floor.get_child(i)):
			var area = str(floor.get_child(i).name)
			var btn = floor.get_child(i).get_child(-1).get_child(-1)
			var texture = btn.get_parent()
			
			database.query("select * from {}".format([Global.office], "{}"))
			var result = database.query_result
			
			if len(result) != 0:
				var text = '{} = "{}" and {} = "{}"'.format([Global.button, area, Global.floor, floor_text], "{}")
				
				var num = database.select_rows(Global.office, text, [Global.number])[0]
				var pc_name = database.select_rows(Global.office, text, [Global.pc_name])[0]
				var model = database.select_rows(Global.office, text, [Global.model])[0]
				
				num = str(num).lstrip("{ ").rstrip(" }").replace('"', "")
				pc_name = str(pc_name).lstrip("{ ").rstrip(" }").replace('"', "")
				model = str(model).lstrip("{ ").rstrip(" }").replace('"', "")
				
				var str_num = num.get_slice(":", 1)
				var str_model = model.get_slice(":", 1)
				var str_pc = pc_name.get_slice(":", 1)
				
				if str_pc == " " and str_num == " " and str_model == " ":
					texture.set_frame(2)
				
			btn.pressed.connect(self.button_pressed)
			btn.set_button_group(group)
	
	if Global.search == true:
		Global.search = false

func button_pressed():
	var texture = group.get_pressed_button().get_parent()
	var area = str(texture.get_parent().name)
	var flr = ""
	
	flr = str(Global.current_floor)
	
	var color = texture.frame
	
	info.clear()
	
	var text2 = '{} = "{}" and {} = "{}"'.format([Global.floor, flr, Global.button, area], "{}")
	var select = []
	
	select = database.select_rows(Global.office, text2, ["*"])
	
	texture.set_frame(1)
	
	if select.is_empty():
		info.add_item("Кнопка : {}".format([area], "{}"))
		info.add_item("Этаж : {}".format([flr], "{}"))
	else:
		var text = '{} = "{}" and {} = "{}"'.format([Global.button, area, Global.floor, flr], "{}")
		var result = database.select_rows(Global.office, text, ["*"])
		
		if len(result) == 1:
			var flor = database.select_rows(Global.office, text, [Global.floor])[0]
			var cabinet = database.select_rows(Global.office, text, [Global.cabinet])[0]
			var spt = database.select_rows(Global.office, text, [Global.spot])[0]
			var num = database.select_rows(Global.office, text, [Global.number])[0]
			var pc_name = database.select_rows(Global.office, text, [Global.pc_name])[0]
			var model = database.select_rows(Global.office, text, [Global.model])[0]
			
			flor = str(flor).lstrip("{ ").rstrip(" }").replace('"', "")
			cabinet = str(cabinet).lstrip("{ ").rstrip(" }").replace('"', "")
			spt = str(spt).lstrip("{ ").rstrip(" }").replace('"', "")
			num = str(num).lstrip("{ ").rstrip(" }").replace('"', "")
			pc_name = str(pc_name).lstrip("{ ").rstrip(" }").replace('"', "")
			model = str(model).lstrip("{ ").rstrip(" }").replace('"', "")
			
			var str_num = num.get_slice(":", 1).format([""], " ")
			var str_model = model.get_slice(":", 1).format([""], " ")
			var str_pc = pc_name.get_slice(":", 1).format([""], " ")
			
			info.add_item(flor)
			info.add_item(cabinet)
			info.add_item(spt)
			
			if str_num != "":
				info.add_item(num)
			if str_pc != "":
				info.add_item(pc_name)
			if str_model != "":
				info.add_item(model)
		else:
			var flor = database.select_rows(Global.office, text, [Global.floor])[0]
			var cabinet = database.select_rows(Global.office, text, [Global.cabinet])[0]
			var spt = database.select_rows(Global.office, text, [Global.spot])[0]
			
			flor = str(flor).lstrip("{ ").rstrip(" }").replace('"', "")
			cabinet = str(cabinet).lstrip("{ ").rstrip(" }").replace('"', "")
			spt = str(spt).lstrip("{ ").rstrip(" }").replace('"', "")
			
			info.add_item(flor)
			info.add_item(cabinet)
			info.add_item(spt)
			
			for i in range(len(result)):
				var num = database.select_rows(Global.office, text, [Global.number])[i]
				var pc_name = database.select_rows(Global.office, text, [Global.pc_name])[i]
				var model = database.select_rows(Global.office, text, [Global.model])[i]
				
				var num_str = str(num).lstrip("{ ").rstrip(" }").replace('"', "")
				var model_str = str(model).lstrip("{ ").rstrip(" }").replace('"', "")
				var pc_name_str = str(pc_name).lstrip("{ ").rstrip(" }").replace('"', "")
				
				var str_pc = pc_name_str.get_slice(":", 1).format([""], " ")
				var str_num = num_str.get_slice(":", 1).format([""], " ")
				var str_model = model_str.get_slice(":", 1).format([""], " ")
				
				if str_num != "":
					info.add_item(num_str)
				if str_pc != "":
					info.add_item(pc_name_str)
				if str_model != "":
					info.add_item(model_str)
	
	if Global.last_btn == "none":
		Global.last_btn = area
		Global.last_btn_color = color
	else:
		if Global.last_btn != area:
			var last_btn = floor.get_node(Global.last_btn)
			last_btn.get_child(-1).set_frame(Global.last_btn_color)
			
			Global.last_btn = area
			Global.last_btn_color = color

func _on_floor_selected(index):
	var floor_text = int(floor_select.get_item_text(index))
	
	if Global.search == false:
		Global.last_btn = "none"
		Global.last_btn_color = 0
	
	var toLoad : PackedScene = PackedScene.new()
	
	if index == -1:
		toLoad = PackedScene.new()
		toLoad = ResourceLoader.load(floor_dir+"floor.tscn")
		var this_floor = toLoad.instantiate()
		self.remove_child(floor)
		floor.queue_free()
		self.add_child(this_floor)
		floor_image = self.get_node("Floor/floor_image")
		floor = this_floor
	else:
		Global.current_floor = floor_text
		
		var floors = DirAccess.get_files_at(floor_dir+Global.branch+"/")
		var flr1 = ""
		var num1
		
		for i in range(len(floors)):
			num1 = 0
			var fl = floors[i].get_slice(".", 0).left(-2)
			
			for j in range(1, len(fl)+1):
				if fl.right(j).is_valid_int() == false:
					num1 = int(fl.right(j))
					break
			
			if num1 == floor_text:
				flr1 = floors[i]
				print(flr1)
		
		toLoad = ResourceLoader.load(floor_dir+Global.branch+"/"+flr1)
		
		var this_floor = toLoad.instantiate()
		self.remove_child(floor)
		floor.queue_free()
		self.add_child(this_floor)
		floor_image = self.get_node("Floor/floor_image")
		floor = this_floor
		
		var child = floor.get_child_count()
		for i in range(1,child):
			if "Area" in str(floor.get_child(i)):
				var area = str(floor.get_child(i).name)
				var btn = floor.get_child(i).get_child(-1).get_child(-1)
				var texture = btn.get_parent()
				
				database.query("select * from {}".format([Global.office], "{}"))
				var result = database.query_result
				
				if len(result) != 0:
					var text = '{} = "{}" and {} = "{}"'.format([Global.button, area, Global.floor, floor_text], "{}")
					
					var num = database.select_rows(Global.office, text, [Global.number])[0]
					var pc_name = database.select_rows(Global.office, text, [Global.pc_name])[0]
					var model = database.select_rows(Global.office, text, [Global.model])[0]
					
					num = str(num).lstrip("{ ").rstrip(" }").replace('"', "")
					pc_name = str(pc_name).lstrip("{ ").rstrip(" }").replace('"', "")
					model = str(model).lstrip("{ ").rstrip(" }").replace('"', "")
					
					var str_num = num.get_slice(":", 1)
					var str_model = model.get_slice(":", 1)
					var str_pc = pc_name.get_slice(":", 1)
					
					if str_pc == " " and str_num == " " and str_model == " ":
						texture.set_frame(2)
					
				btn.pressed.connect(self.button_pressed)
				btn.set_button_group(group)
	
	if Global.search == true:
		Global.search = false

func _process(_delta):
	move_editor()
	is_panning = Input.is_action_pressed("mb_right")

func move_editor():
	if Input.is_action_pressed("w"):
		main.global_position.y -= cam_spd
	if Input.is_action_pressed("a"):
		main.global_position.x -= cam_spd
	if Input.is_action_pressed("s"):
		main.global_position.y += cam_spd
	if Input.is_action_pressed("d"):
		main.global_position.x += cam_spd

func _unhandled_input(event):
	if event is InputEventMouseButton:
		if event.is_pressed():
			if event.button_index == MOUSE_BUTTON_WHEEL_UP:
				main_cam.zoom += Vector2(0.2,0.2)
			if event.button_index == MOUSE_BUTTON_WHEEL_DOWN:
				main_cam.zoom -= Vector2(0.2,0.2)
	if event is InputEventMouseMotion:
		if is_panning:
			main.global_position -= event.relative * main_cam.zoom

func _on_back_pressed():
	Global.last_btn = "none"
	get_tree().change_scene_to_file("res://scenes/main/start_screen.tscn")

func _on_refresh_pressed():
	edit.text = ""
	info.clear()
	label2.visible = false
	list.clear()
	
	if Global.last_btn != "none":
		floor.get_node(Global.last_btn).get_child(-1).set_frame(Global.last_btn_color)
		Global.last_btn = "none"
		Global.last_btn_color = 0

func _on_search_pressed():
	list.clear()
	info.clear()
	label2.visible = false
	
	_on_floor_selected(-1)
	floor_select.select(-1)
	
	if str(Global.current_button) != "":
		Global.current_floor = 0
		Global.current_button.set_pressed(false)
	
	var count = 0
	var text = str(edit.text)
	
	if (len(text) == 3 and text != "all") or len(text) == 4 or "ферма" in text:
		var spot = ""
		var stroke = "{}:{}"
		
		var text2 = '{} = "{}"'.format([Global.cabinet, text], "{}")
		var data = database.select_rows(Global.office, text2, ["*"])
		
		for i in range(len(data)):
			var items = 0
			
			for j in range(list.get_item_count()):
				spot = str(data[i].get(Global.spot))
				if stroke.format([text, spot], "{}") == list.get_item_text(j):
					items = items + 1
			
			if items == 0:
				spot = str(data[i].get(Global.spot))
				list.add_item(stroke.format([text,spot], "{}"))
	elif text == "1" or text == "2" or text == "3" or text == "4" or text == "5" or text == "6":
		var spot = ""
		var cab = ""
		var stroke = "{}:{}"
		
		var text2 = '{} = "{}"'.format([Global.floor, text], "{}")
		var data = database.select_rows(Global.office, text2, ["*"])
		
		for i in range(len(data)):
			var items = 0
			
			spot = str(data[i].get(Global.spot))
			cab = str(data[i].get(Global.cabinet))
			
			for j in range(list.get_item_count()):
				if stroke.format([cab, spot], "{}") == list.get_item_text(j):
					items = items + 1
			
			if items == 0:
				list.add_item(stroke.format([cab, spot], "{}"))
	elif text == "all":
		var spot = ""
		var cab = ""
		var stroke = "{}:{}"
		
		database.query("select * from {}".format([Global.office], "{}"))
		var data = database.query_result
		
		for i in range(len(data)):
			var items = 0
			
			spot = str(data[i].get(Global.spot))
			cab = str(data[i].get(Global.cabinet))
			
			for j in range(list.get_item_count()):
				if stroke.format([cab, spot], "{}") == list.get_item_text(j):
					items = items + 1
			
			if items == 0:
				list.add_item(stroke.format([cab, spot], "{}"))
	elif len(text) > 10:
		var sep = ""
		
		for i in len(text):
			if text[i] not in Global.numbers and text[i] not in Global.letters:
				sep = text[i]
				break
		
		var sep_num = text.count(sep)
		
		for i in range(sep_num+1):
			list.add_item(text.get_slice(sep, i))
	elif ":" in text:
		var cab = str(text.get_slice(":", 0))
		var spot = str(text.get_slice(":", 1))
		
		database.query("select * from {}".format([Global.office], "{}"))
		var data = database.query_result
		
		for i in range(len(data)):
			if cab == data[i].get(Global.cabinet) and spot == data[i].get(Global.spot):
				list.add_item(text)
				break
			else:
				count = count + 1
		
		if count == len(data):
			label2.visible = true
		else:
			label2.visible = false
	else:
		database.query("select * from {}".format([Global.office], "{}"))
		var data = database.query_result
		
		for i in range(len(data)):
			if text == data[i].get(Global.number):
				list.add_item(text)
				break
			elif text == data[i].get(Global.pc_name):
				list.add_item(text)
				break
			elif text == data[i].get(Global.model):
				list.add_item(text)
				break
			else:
				count = count + 1
		
		if count == len(data):
			label2.visible = true
		else:
			label2.visible = false

func _on_item_list_item_selected(index):
	var text = list.get_item_text(index)
	var btn_list = floor_group.get_buttons()
	var data = []
	var data_num = []
	var data_name = []
	var data_model = []
	
	var btn = {}
	var flr = {}
	var cabinet = {}
	var spt = {}
	var num = {}
	var pc_name = {}
	var model = {}
	
	var str_num = ""
	var str_model = ""
	var str_pc = ""
	
	var cab = str(text.get_slice(":",0))
	var spot = str(text.get_slice(":",1))
	
	var result = 0
	
	info.clear()
	
	if ":" in text:
		var text2 = '{} = "{}" and {} = "{}"'.format([Global.cabinet, cab, Global.spot, spot], "{}")
		
		flr = database.select_rows(Global.office, text2, [Global.floor])[0]
		cabinet = database.select_rows(Global.office, text2, [Global.cabinet])[0]
		spt = database.select_rows(Global.office, text2, [Global.spot])[0]
		num = database.select_rows(Global.office, text2, [Global.number])[0]
		pc_name = database.select_rows(Global.office, text2, [Global.pc_name])[0]
		model = database.select_rows(Global.office, text2, [Global.model])[0]
		
		data = database.select_rows(Global.office, text2, ["*"])
		result = len(data)
		
		if Global.current_floor != int(flr.get(Global.floor)):
			
			if Global.office != "office_b1":
				_on_floor_selected(flr.get(Global.floor).to_int()-1)
				floor_select.select(flr.get(Global.floor).to_int()-1)
			else:
				var right_btn = ""
				
				for i in range(len(btn_list)):
					print(str(btn_list[i]) + " " + btn_list[i].name)
					if str(flr.get(Global.floor).to_int()) in str(btn_list[i].name):
						right_btn = str(btn_list[i].name)
						print(right_btn)
						break
				
				for i in range(floor_btns.get_child_count()):
					print(floor_btns.get_child(i).name)
					if right_btn == floor_btns.get_child(i).name:
						Global.right_btn = right_btn
						
						floor_btns.get_child(i).set_pressed(true)
						floor_btns.get_child(i).emit_signal("pressed")
						break
			
			if Global.last_btn != data[0].get(Global.button):
				if Global.search == false:
					Global.search = true
				Global.last_btn = data[0].get(Global.button)
				Global.last_btn_color = floor.get_node(data[0].get(Global.button)).get_child(-1).frame
				
				var child = floor.get_node(data[0].get(Global.button))
				main_cam.set_position(child.get_position())
				
				floor.get_node(data[0].get(Global.button)).get_child(-1).set_frame(1)
		else:
			var flor = floor.get_child_count()
			
			var child = floor.get_node(data[0].get(Global.button))
			var texture = child.get_child(-1)
			var button = str(texture.get_child(-1))
			
			var color = texture.frame
			
			main_cam.set_position(child.get_position())
			texture.set_frame(1)
			
			if Global.last_btn == "none":
				Global.last_btn = str(child.name)
				Global.last_btn_color = color
			else:
				if Global.last_btn != str(child.name):
					var last_btn = floor.get_node(Global.last_btn)
					last_btn.get_child(-1).set_frame(Global.last_btn_color)
					
					Global.last_btn = str(child.name)
					Global.last_btn_color = color
	else:
		var text_num = '{} = "{}"'.format([Global.number, text], "{}")
		data_num = database.select_rows(Global.office, text_num,["*"])
		
		var text_name = '{} = "{}"'.format([Global.pc_name, text], "{}")
		data_name = database.select_rows(Global.office, text_name,["*"])
		
		var text_model = '{} = "{}"'.format([Global.model, text], "{}")
		data_model = database.select_rows(Global.office, text_model,["*"])
		
		var text2 = ""
		
		if data_num.is_empty() == false:
			text2 = text_num
			data = data_num
		elif data_name.is_empty() == false:
			text2 = text_name
			data = data_name
		else:
			text2 = text_model
			data = data_model
		
		flr = database.select_rows(Global.office, text2, [Global.floor])[0]
		cabinet = database.select_rows(Global.office, text2, [Global.cabinet])[0]
		spt = database.select_rows(Global.office, text2, [Global.spot])[0]
		num = database.select_rows(Global.office, text2, [Global.number])[0]
		pc_name = database.select_rows(Global.office, text2, [Global.pc_name])[0]
		model = database.select_rows(Global.office, text2, [Global.model])[0]
		btn = database.select_rows(Global.office, text2, [Global.button])[0]
		
		cab = str(cabinet.get(Global.cabinet))
		spot = str(spt.get(Global.spot))
		
		
		if floor_select.get_selected() != flr.get(Global.floor).to_int()-1:
			_on_floor_selected(flr.get(Global.floor).to_int()-1)
			floor_select.select(flr.get(Global.floor).to_int()-1)
			
			Global.last_btn = btn.get(Global.button)
			Global.last_btn_color = floor.get_node(btn.get(Global.button)).get_child(-1).frame
			
			floor.get_node(btn.get(Global.button)).get_child(-1).set_frame(1)
			main_cam.set_position(floor.get_node(btn.get(Global.button)).get_position())
		else:
			var flor = floor.get_child_count()
			
			var child = floor.get_node(btn.get(Global.button))
			var texture = child.get_child(-1)
			var button = str(texture.get_child(-1))
			
			var color = texture.frame
			
			main_cam.set_position(child.get_position())
			texture.set_frame(1)
			
			if Global.last_btn == "none":
				if Global.last_btn != btn.get(Global.button):
					Global.last_btn = btn.get(Global.button)
					Global.last_btn_color = color
			else:
				if Global.last_btn != btn.get(Global.button):
					var last_btn = floor.get_node(Global.last_btn)
					last_btn.get_child(-1).set_frame(Global.last_btn_color)
					
					Global.last_btn = btn.get(Global.button)
					Global.last_btn_color = color
			
		text2 = '{} = "{}" and {} = "{}"'.format([Global.cabinet, cab, Global.spot, spot], "{}")
		
		data = database.select_rows(Global.office, text2, ["*"])
		result = len(data)
	
	if result == 1:
		flr = str(flr).lstrip("{ ").rstrip(" }").replace('"', "")
		cabinet = str(cabinet).lstrip("{ ").rstrip(" }").replace('"', "")
		spt = str(spt).lstrip("{ ").rstrip(" }").replace('"', "")
		num = str(num).lstrip("{ ").rstrip(" }").replace('"', "")
		pc_name = str(pc_name).lstrip("{ ").rstrip(" }").replace('"', "")
		model = str(model).lstrip("{ ").rstrip(" }").replace('"', "")
		
		str_num = num.get_slice(":", 1).format([""], " ")
		str_model = model.get_slice(":", 1).format([""], " ")
		str_pc = pc_name.get_slice(":", 1).format([""], " ")
		
		info.add_item(flr)
		info.add_item(cabinet)
		info.add_item(spt)
		
		if str_num != "":
			info.add_item(num)
		if str_pc != "":
			info.add_item(pc_name)
		if str_model != "":
			info.add_item(model)
	else:
		flr = str(flr).lstrip("{ ").rstrip(" }").replace('"', "")
		cabinet = str(cabinet).lstrip("{ ").rstrip(" }").replace('"', "")
		spt = str(spt).lstrip("{ ").rstrip(" }").replace('"', "")
		
		info.add_item(flr)
		info.add_item(cabinet)
		info.add_item(spt)
		
		var text2 = '{} = "{}" and {} = "{}"'.format([Global.cabinet, cab, Global.spot, spot], "{}")
		
		for i in range(result):
			num = database.select_rows(Global.office, text2, [Global.number])[i]
			pc_name = database.select_rows(Global.office, text2, [Global.pc_name])[i]
			model = database.select_rows(Global.office, text2, [Global.model])[i]
			
			var num_str = str(num).lstrip("{ ").rstrip(" }").replace('"', "")
			var model_str = str(model).lstrip("{ ").rstrip(" }").replace('"', "")
			var pc_name_str = str(pc_name).lstrip("{ ").rstrip(" }").replace('"', "")
			
			str_num = num_str.get_slice(":", 1).format([""], " ")
			str_model = model_str.get_slice(":", 1).format([""], " ")
			str_pc = pc_name_str.get_slice(":", 1).format([""], " ")
			
			if str_num != "":
				info.add_item(num_str)
			if str_pc != "":
				info.add_item(pc_name_str)
			if str_model != "":
				info.add_item(model_str)
