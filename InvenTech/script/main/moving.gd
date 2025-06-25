extends Node2D

var database : SQLite

@onready var branch_select_1 = get_node("branch_select_1")
@onready var branch_select_2 = get_node("branch_select_2")
@onready var stock_1 = get_node("stock_1")
@onready var stock_2 = get_node("stock_2")

@onready var timer = get_node("Timer")

@onready var edit_1 = get_node("LineEdit")
@onready var edit_2 = get_node("LineEdit2")

@onready var info_1 = get_node("info_1")
@onready var info_2 = get_node("info_2")

@onready var error_1 = get_node("error")
@onready var error_2 = get_node("error2")

@onready var tasks = get_node("tasks")

@onready var task_search = get_node("task_search")
@onready var date = get_node("task_date")
@onready var task_name = get_node("task_name")
@onready var task_text = get_node("task_text")
@onready var status = get_node("status")
@onready var who_did = get_node("who_did")

@onready var create_task = get_node("create")
@onready var save_task = get_node("save")
@onready var change_status = get_node("update")
@onready var edit_task = get_node("edit")

@onready var dir = OS.get_executable_path().get_base_dir()
@onready var floor_dir = dir.path_join('floors/')
@onready var data_dir = dir.path_join('database/data.db')

func _ready():
	database = SQLite.new()
	database.path = data_dir
	database.open_db()
	
	var directories = DirAccess.get_directories_at(floor_dir)
	for i in (len(directories)):
		var text = "{} = '{}'".format([Global.file, directories[i]], "{}")
		var data = database.select_rows(Global.branches, text, ["*"])
		if len(data) != 0:
			branch_select_1.add_item(data[0].get(Global.address))
			branch_select_2.add_item(data[0].get(Global.address))
		else:
			branch_select_1.add_item(directories[i])
			branch_select_2.add_item(directories[i])
	
	branch_select_1.select(-1)
	branch_select_2.select(-1)

func _on_back_pressed():
	Global.pressed = false
	get_tree().change_scene_to_file("res://scenes/main/main.tscn")

func _on_add_1_pressed():
	var num = edit_1.text
	
	var text = '{} = "{}"'.format([Global.number, num], "{}")
	
	if ":" in num:
		error_1.visible = false
		
		info_1.add_item(edit_1.text)
		edit_1.text = ""
	else:
		if stock_1.button_pressed == true:
			var result = database.select_rows("stock", text, ["*"])
			
			if result.is_empty():
				error_1.visible = true
				timer.start()
				
				edit_1.text = ""
			else:
				error_1.visible = false
				
				info_1.add_item(edit_1.text)
				edit_1.text = ""
		else:
			var result2 = database.select_rows(Global.office_m1, text, ["*"])
			
			if result2.is_empty():
				error_1.visible = true
				timer.start()
				
				edit_1.text = ""
			else:
				error_1.visible = false
				
				info_1.add_item(edit_1.text)
				edit_1.text = ""

func _on_add_2_pressed():
	var num = edit_2.text
	
	var text = '{} = "{}"'.format([Global.number, num], "{}")
	
	if ":" in num:
		error_2.visible = false
		
		info_2.add_item(edit_2.text)
		edit_2.text = ""
	else:
		if stock_2.button_pressed == true:
			var result = database.select_rows("stock", text, ["*"])
			
			if result.is_empty():
				error_2.visible = true
				timer.start()
				
				edit_2.text = ""
			else:
				error_2.visible = false
				
				info_2.add_item(edit_2.text)
				edit_2.text = ""
		else:
			var result2 = database.select_rows(Global.office_m2, text, ["*"])
			
			if result2.is_empty():
				error_2.visible = true
				timer.start()
				
				edit_2.text = ""
			else:
				error_2.visible = false
				
				info_2.add_item(edit_2.text)
				edit_2.text = ""

func _on_move_pressed():
	var items_1 = info_1.get_item_count()
	var items_2 = info_2.get_item_count()
	
	var branch_index_1 = branch_select_1.get_selected()
	var branch_index_2 = branch_select_2.get_selected()
	
	var btn_1 = ""
	var flr_1 = ""
	var cab_1 = ""
	var spt_1 = ""
	var num_1 = ""
	var name_1 = ""
	var model_1 = ""
	
	var btn_2 = ""
	var flr_2 = ""
	var cab_2 = ""
	var spt_2 = ""
	var num_2 = ""
	var name_2 = ""
	var model_2 = ""
	
	if branch_index_1 != -1 and branch_index_2 != -1:
		if stock_1.button_pressed == true:
			if ":" in str(info_2.get_item_text(0)):
				if items_2 == 1:
					var num = ""
					var cab = str(info_2.get_item_text(0)).get_slice(":",0)
					var spot = str(info_2.get_item_text(0)).get_slice(":",1)
					
					var text3 = '{} = "{}" and {} = "{}"'.format([Global.cabinet, cab, Global.spot, spot], "{}")
					var result2 = database.select_rows(Global.office_m1, text3, ["*"])
					
					btn_2 = str(result2[0].get(Global.button))
					flr_2 = str(result2[0].get(Global.floor))
					cab_2 = str(result2[0].get(Global.cabinet))
					spt_2 = str(result2[0].get(Global.spot))
					
					var result = []
					var data = {}
					
					for i in range(items_1):
						num = str(info_1.get_item_text(i))
						
						var text = '{} = "{}"'.format([Global.number, num], "{}")
						
						result = database.select_rows("stock", text, ["*"])
						
						num_1 = str(result[0].get(Global.number))
						name_1 = str(result[0].get(Global.pc_name))
						model_1 = str(result[0].get(Global.model))
						
						data = {
							"Кнопка" : btn_2,
							"Этаж" : flr_2,
							"Кабинет" : cab_2,
							"Место" : spt_2,
							"Серийный_номер" : num_1,
							"Имя_ПК" : name_1,
							"Модель" : model_1
						}
						
						database.insert_row(Global.office_m1, data)
						
						database.delete_rows("stock", text)
					
					if len(result2) == 1:
						text3 = '{} = "{}" and {} = "{}" and {} = ""'.format([Global.cabinet, cab, Global.spot, spot, Global.number], "{}")
						
						database.delete_rows(Global.office_m1, text3)
				else:
					var num = ""
					
					var cab = str(info_2.get_item_text(0)).get_slice(":",0)
					var spot = str(info_2.get_item_text(0)).get_slice(":",1)
					
					var text3 = '{} = "{}" and {} = "{}"'.format([Global.cabinet, cab, Global.spot, spot], "{}")
					
					var result2 = database.select_rows(Global.office_m2, text3, ["*"])
					
					var result = []
					var data = {}
						
					for i in range(items_1):
						num = str(info_1.get_item_text(i))
						
						cab = str(info_2.get_item_text(i)).get_slice(":",0)
						spot = str(info_2.get_item_text(i)).get_slice(":",1)
						
						text3 = '{} = "{}" and {} = "{}"'.format([Global.cabinet, cab, Global.spot, spot], "{}")
						
						result2 = database.select_rows(Global.office_m2, text3, ["*"])
						
						btn_2 = str(result2[0].get(Global.button))
						flr_2 = str(result2[0].get(Global.floor))
						cab_2 = str(result2[0].get(Global.cabinet))
						spt_2 = str(result2[0].get(Global.spot))
						
						var text = '{} = "{}"'.format([Global.number, num], "{}")
						
						result = database.select_rows("stock", text, ["*"])
						
						num_1 = str(result[0].get(Global.number))
						name_1 = str(result[0].get(Global.pc_name))
						model_1 = str(result[0].get(Global.model))
						
						data = {
							"Кнопка" : btn_2,
							"Этаж" : flr_2,
							"Кабинет" : cab_2,
							"Место" : spt_2,
							"Серийный_номер" : num_1,
							"Имя_ПК" : name_1,
							"Модель" : model_1
						}
						
						database.insert_row(Global.office_m2, data)
						
						database.delete_rows("stock", text)
						
						if len(result2) == 1:
							text3 = '{} = "{}" and {} = "{}" and {} = ""'.format([Global.cabinet, cab, Global.spot, spot, Global.number], "{}")
							
							database.delete_rows(Global.office_m2, text3)
			else:
				var num = ""
				var num2 = ""
				
				var result = []
				var result2 = []
				
				var data = {}
				var data2 = {}
				
				for i in range(items_1):
					num = str(info_1.get_item_text(i))
					num2 = str(info_2.get_item_text(i))
					
					var text = '{} = "{}"'.format([Global.number, num], "{}")
					var text2 = '{} = "{}"'.format([Global.number, num2], "{}")
					
					result = database.select_rows("stock", text, ["*"])
					result2 = database.select_rows(Global.office_m2, text2, ["*"])
					
					btn_2 = str(result2[0].get(Global.button))
					flr_2 = str(result2[0].get(Global.floor))
					cab_2 = str(result2[0].get(Global.cabinet))
					spt_2 = str(result2[0].get(Global.spot))
					num_2 = str(result2[0].get(Global.number))
					name_2 = str(result2[0].get(Global.pc_name))
					model_2 = str(result2[0].get(Global.model))
					
					num_1 = str(result[0].get(Global.number))
					name_1 = str(result[0].get(Global.pc_name))
					model_1 = str(result[0].get(Global.model))
					
					data = {
						"Кнопка" : btn_2,
						"Этаж" : flr_2,
						"Кабинет" : cab_2,
						"Место" : spt_2,
						"Серийный_номер" : num_1,
						"Имя_ПК" : name_1,
						"Модель" : model_1
					}
					
					data2 = {
						"Серийный_номер" : num_2,
						"Имя_ПК" : name_2,
						"Модель" : model_2
					}
					
					database.insert_row(Global.office_m2, data)
					database.insert_row("stock", data2)
					
					database.delete_rows("stock", text)
					database.delete_rows(Global.office_m2, text2)
		else:
			if ":" in str(info_1.get_item_text(0)):
				if stock_2.button_pressed == true and items_2 == 0:
					var cab = ""
					var spot = ""
					
					var result = []
					var data = {}
					
					for i in range(items_1):
						cab = str(info_1.get_item_text(i)).get_slice(":",0)
						spot = str(info_1.get_item_text(i)).get_slice(":",1)
						
						var text = '{} = "{}" and {} = "{}"'.format([Global.cabinet, cab, Global.spot, spot], "{}")
						
						result = database.select_rows(Global.office_m1, text, ["*"])
						
						for j in range(len(result)):
							btn_1 = str(result[j].get(Global.button))
							flr_1 = str(result[j].get(Global.floor))
							cab_1 = str(result[j].get(Global.cabinet))
							spt_1 = str(result[j].get(Global.spot))
							num_1 = str(result[j].get(Global.number))
							name_1 = str(result[j].get(Global.pc_name))
							model_1 = str(result[j].get(Global.model))
							
							data = {
								"Серийный_номер" : num_1,
								"Имя_ПК" : name_1,
								"Модель" : model_1
							}
							
							database.insert_row("stock", data)
						
						var text2 = '{} = "{}" and {} = "{}" and {} != ""'.format([Global.cabinet, cab, Global.spot, spot, Global.number], "{}")
						
						num_1 = ""
						name_1 = ""
						model_1 = ""
						
						data = {
							"Кнопка" : btn_1,
							"Этаж" : flr_1,
							"Кабинет" : cab_1,
							"Место" : spt_1,
							"Серийный_номер" : num_1,
							"Имя_ПК" : name_1,
							"Модель" : model_1
						}
						
						database.insert_row(Global.office_m1, data)
						
						database.delete_rows(Global.office_m1, text2)
				elif stock_2.button_pressed == false:
					if ":" in str(info_2.get_item_text(0)):
						var cab1 = ""
						var spot1 = ""
						var cab2 = ""
						var spot2 = ""
						
						var result1 = []
						var data1 = {}
						var result2 = []
						var data2 = {}
						
						var result = 0
						
						for i in range(items_1):
							cab1 = str(info_1.get_item_text(i)).get_slice(":",0)
							spot1 = str(info_1.get_item_text(i)).get_slice(":",1)
							
							cab2 = str(info_2.get_item_text(i)).get_slice(":",0)
							spot2 = str(info_2.get_item_text(i)).get_slice(":",1)
							
							var text1 = '{} = "{}" and {} = "{}"'.format([Global.cabinet, cab1, Global.spot, spot1], "{}")
							var text2 = '{} = "{}" and {} = "{}"'.format([Global.cabinet, cab2, Global.spot, spot2], "{}")
							
							result1 = database.select_rows(Global.office_m1, text1, ["*"])
							result2 = database.select_rows(Global.office_m2, text2, ["*"])
							
							if len(result1) > len(result2):
								result = len(result1)
							else:
								result = len(result2)
							
							btn_1 = str(result1[i].get(Global.button))
							flr_1 = str(result1[i].get(Global.floor))
							cab_1 = str(result1[i].get(Global.cabinet))
							spt_1 = str(result1[i].get(Global.spot))
							
							btn_2 = str(result2[i].get(Global.button))
							flr_2 = str(result2[i].get(Global.floor))
							cab_2 = str(result2[i].get(Global.cabinet))
							spt_2 = str(result2[i].get(Global.spot))
							
							for j in range(result):
								if (result == len(result2) and j <= len(result1)) or (result == len(result1) and j <= len(result2)):
									
									num_1 = str(result1[j].get(Global.number))
									name_1 = str(result1[j].get(Global.pc_name))
									model_1 = str(result1[j].get(Global.model))
									
									num_2 = str(result2[j].get(Global.number))
									name_2 = str(result2[j].get(Global.pc_name))
									model_2 = str(result2[j].get(Global.model))
									
									data1 = {
										"Кнопка" : btn_2,
										"Этаж" : flr_2,
										"Кабинет" : cab_2,
										"Место" : spt_2,
										"Серийный_номер" : num_1,
										"Имя_ПК" : name_1,
										"Модель" : model_1
									}
									
									data2 = {
										"Кнопка" : btn_1,
										"Этаж" : flr_1,
										"Кабинет" : cab_1,
										"Место" : spt_1,
										"Серийный_номер" : num_2,
										"Имя_ПК" : name_2,
										"Модель" : model_2
									}
									
									database.insert_row(Global.office_m1, data1)
									database.insert_row(Global.office_m1, data2)
									
									var text2_1 = '{} = "{}" and {} = "{}" and {} = "{}"'.format([Global.cabinet, cab_1, Global.spot, spt_1, Global.number, num_1], "{}")
									var text2_2 = '{} = "{}" and {} = "{}" and {} = "{}"'.format([Global.cabinet, cab_2, Global.spot, spt_2, Global.number, num_2], "{}")
									
									database.delete_rows(Global.office_m1, text2_1)
									database.delete_rows(Global.office_m1, text2_2)
								elif result == len(result2) and j >= len(result1):
									num_2 = str(result2[j].get(Global.number))
									name_2 = str(result2[j].get(Global.pc_name))
									model_2 = str(result2[j].get(Global.model))
									
									data2 = {
										"Кнопка" : btn_1,
										"Этаж" : flr_1,
										"Кабинет" : cab_1,
										"Место" : spt_1,
										"Серийный_номер" : num_2,
										"Имя_ПК" : name_2,
										"Модель" : model_2
									}
									
									database.insert_row(Global.office_m1, data2)
									
									var text2_2 = '{} = "{}" and {} = "{}" and {} = "{}"'.format([Global.cabinet, cab_2, Global.spot, spt_2, Global.number, num_2], "{}")
									
									database.delete_rows(Global.office_m1, text2_2)
								elif result == len(result1) and j >= len(result2):
									num_1 = str(result1[j].get(Global.number))
									name_1 = str(result1[j].get(Global.pc_name))
									model_1 = str(result1[j].get(Global.model))
									
									data1 = {
										"Кнопка" : btn_2,
										"Этаж" : flr_2,
										"Кабинет" : cab_2,
										"Место" : spt_2,
										"Серийный_номер" : num_1,
										"Имя_ПК" : name_1,
										"Модель" : model_1
									}
									
									database.insert_row(Global.office_m1, data1)
									
									var text2_1 = '{} = "{}" and {} = "{}" and {} = "{}"'.format([Global.cabinet, cab_1, Global.spot, spt_1, Global.number, num_1], "{}")
									
									database.delete_rows(Global.office_m1, text2_1)
			else:
				if stock_2.button_pressed == true and items_2 == 0:
					var num = ""
					
					var result = []
					var data = {}
					
					for i in range(items_1):
						num = str(info_1.get_item_text(i))
						
						var text = '{} = "{}"'.format([Global.number, num], "{}")
						
						result = database.select_rows(Global.office_m1, text, ["*"])
						
						btn_1 = str(result[0].get(Global.button))
						flr_1 = str(result[0].get(Global.floor))
						cab_1 = str(result[0].get(Global.cabinet))
						spt_1 = str(result[0].get(Global.spot))
						num_1 = str(result[0].get(Global.number))
						name_1 = str(result[0].get(Global.pc_name))
						model_1 = str(result[0].get(Global.model))
						
						data = {
							"Серийный_номер" : num_1,
							"Имя_ПК" : name_1,
							"Модель" : model_1
						}
						
						database.insert_row("stock", data)
						
						var text2 = '{} = "{}" and {} = "{}" and {} = "{}"'.format([Global.cabinet, cab_1, Global.spot, spt_1, Global.number, num], "{}")
						
						database.delete_rows(Global.office_m1, text2)
					
					var text1 = '{} = "{}" and {} = "{}"'.format([Global.cabinet, cab_1, Global.spot, spt_1], "{}")
					var result1 = database.select_rows(Global.office_m1, text1, ["*"])
					
					if result1.is_empty():
						num_1 = ""
						name_1 = ""
						model_1 = ""
						
						data = {
							"Кнопка" : btn_1,
							"Этаж" : flr_1,
							"Кабинет" : cab_1,
							"Место" : spt_1,
							"Серийный_номер" : num_1,
							"Имя_ПК" : name_1,
							"Модель" : model_1
						}
						
						database.insert_row(Global.office_m1, data)
				elif stock_2.button_pressed == false:
					if ":" in str(info_2.get_item_text(0)):
						if items_2 == 1:
							var num = ""
							var cab = str(info_2.get_item_text(0)).get_slice(":",0)
							var spot = str(info_2.get_item_text(0)).get_slice(":",1)
							
							var text3 = '{} = "{}" and {} = "{}"'.format([Global.cabinet, cab, Global.spot, spot], "{}")
							var result2 = database.select_rows(Global.office_m1, text3, ["*"])
							
							btn_2 = str(result2[0].get(Global.button))
							flr_2 = str(result2[0].get(Global.floor))
							cab_2 = str(result2[0].get(Global.cabinet))
							spt_2 = str(result2[0].get(Global.spot))
							
							var result = []
							var data = {}
							
							for i in range(items_1):
								num = str(info_1.get_item_text(i))
								
								var text = '{} = "{}"'.format([Global.number, num], "{}")
								
								result = database.select_rows(Global.office_m1, text, ["*"])
								
								btn_1 = str(result[0].get(Global.button))
								flr_1 = str(result[0].get(Global.floor))
								cab_1 = str(result[0].get(Global.cabinet))
								spt_1 = str(result[0].get(Global.spot))
								num_1 = str(result[0].get(Global.number))
								name_1 = str(result[0].get(Global.pc_name))
								model_1 = str(result[0].get(Global.model))
								
								data = {
									"Кнопка" : btn_2,
									"Этаж" : flr_2,
									"Кабинет" : cab_2,
									"Место" : spt_2,
									"Серийный_номер" : num_1,
									"Имя_ПК" : name_1,
									"Модель" : model_1
								}
								
								database.insert_row(Global.office_m1, data)
								
								var text2_1 = '{} = "{}" and {} = "{}" and {} = "{}"'.format([Global.cabinet, cab_1, Global.spot, spt_1, Global.number, num_1], "{}")
								
								database.delete_rows(Global.office_m1, text2_1)
							
							if len(result2) == 1:
								text3 = '{} = "{}" and {} = "{}" and {} = ""'.format([Global.cabinet, cab, Global.spot, spot, Global.number], "{}")
								
								database.delete_rows(Global.office_m1, text3)
						else:
							var num = ""
							
							var cab = str(info_2.get_item_text(0)).get_slice(":",0)
							var spot = str(info_2.get_item_text(0)).get_slice(":",1)
							
							var text3 = '{} = "{}" and {} = "{}"'.format([Global.cabinet, cab, Global.spot, spot], "{}")
							
							var result2 = database.select_rows(Global.office_m2, text3, ["*"])
							
							var result = []
							var data = {}
								
							for i in range(items_1):
								num = str(info_1.get_item_text(i))
								
								cab = str(info_2.get_item_text(i)).get_slice(":",0)
								spot = str(info_2.get_item_text(i)).get_slice(":",1)
								
								text3 = '{} = "{}" and {} = "{}"'.format([Global.cabinet, cab, Global.spot, spot], "{}")
								
								result2 = database.select_rows(Global.office_m2, text3, ["*"])
								
								btn_2 = str(result2[0].get(Global.button))
								flr_2 = str(result2[0].get(Global.floor))
								cab_2 = str(result2[0].get(Global.cabinet))
								spt_2 = str(result2[0].get(Global.spot))
								
								var text = '{} = "{}"'.format([Global.number, num], "{}")
								
								result = database.select_rows(Global.office_m1, text, ["*"])
								
								btn_1 = str(result[0].get(Global.button))
								flr_1 = str(result[0].get(Global.floor))
								cab_1 = str(result[0].get(Global.cabinet))
								spt_1 = str(result[0].get(Global.spot))
								num_1 = str(result[0].get(Global.number))
								name_1 = str(result[0].get(Global.pc_name))
								model_1 = str(result[0].get(Global.model))
								
								data = {
									"Кнопка" : btn_2,
									"Этаж" : flr_2,
									"Кабинет" : cab_2,
									"Место" : spt_2,
									"Серийный_номер" : num_1,
									"Имя_ПК" : name_1,
									"Модель" : model_1
								}
								
								database.insert_row(Global.office_m2, data)
								
								var text2_1 = '{} = "{}" and {} = "{}" and {} = "{}"'.format([Global.cabinet, cab_1, Global.spot, spt_1, Global.number, num_1], "{}")
								
								database.delete_rows(Global.office_m2, text2_1)
								
								if len(result2) == 1:
									text3 = '{} = "{}" and {} = "{}" and {} = ""'.format([Global.cabinet, cab, Global.spot, spot, Global.number], "{}")
									
									database.delete_rows(Global.office_m2, text3)
					else:
						var num = ""
						var num2 = ""
						
						var result = []
						var result2 = []
						
						var data = {}
						var data2 = {}
						
						for i in range(items_1):
							num = str(info_1.get_item_text(i))
							num2 = str(info_2.get_item_text(i))
							
							var text = '{} = "{}"'.format([Global.number, num], "{}")
							var text2 = '{} = "{}"'.format([Global.number, num2], "{}")
							
							result = database.select_rows(Global.office_m1, text, ["*"])
							result2 = database.select_rows(Global.office_m1, text2, ["*"])
							
							btn_2 = str(result2[0].get(Global.button))
							flr_2 = str(result2[0].get(Global.floor))
							cab_2 = str(result2[0].get(Global.cabinet))
							spt_2 = str(result2[0].get(Global.spot))
							num_2 = str(result2[0].get(Global.number))
							name_2 = str(result2[0].get(Global.pc_name))
							model_2 = str(result2[0].get(Global.model))
							
							btn_1 = str(result[0].get(Global.button))
							flr_1 = str(result[0].get(Global.floor))
							cab_1 = str(result[0].get(Global.cabinet))
							spt_1 = str(result[0].get(Global.spot))
							num_1 = str(result[0].get(Global.number))
							name_1 = str(result[0].get(Global.pc_name))
							model_1 = str(result[0].get(Global.model))
							
							data = {
								"Кнопка" : btn_2,
								"Этаж" : flr_2,
								"Кабинет" : cab_2,
								"Место" : spt_2,
								"Серийный_номер" : num_1,
								"Имя_ПК" : name_1,
								"Модель" : model_1
							}
							
							data2 = {
								"Кнопка" : btn_1,
								"Этаж" : flr_1,
								"Кабинет" : cab_1,
								"Место" : spt_1,
								"Серийный_номер" : num_2,
								"Имя_ПК" : name_2,
								"Модель" : model_2
							}
							
							database.insert_row(Global.office_m1, data)
							database.insert_row(Global.office_m1, data2)
							
							var text2_1 = '{} = "{}" and {} = "{}" and {} = "{}"'.format([Global.cabinet, cab_1, Global.spot, spt_1, Global.number, num_1], "{}")
							var text2_2 = '{} = "{}" and {} = "{}" and {} = "{}"'.format([Global.cabinet, cab_2, Global.spot, spt_2, Global.number, num_2], "{}")
							
							database.delete_rows(Global.office_m1, text2_1)
							database.delete_rows(Global.office_m1, text2_2)

func _on_clear_pressed():
	info_1.clear()
	info_2.clear()

func _on_search_pressed():
	tasks.clear()
	var request = ""
	var a = 0
	
	if task_search.text.strip_edges() == "":
		request = "select * from tasks"
		
		database.query(request)
		var result = database.query_result
		
		var date1 = ""
		var name1 = ""
		var text = "{}: {}"
		
		for i in range(len(result)):
			date1 = result[i].get(Global.task_date).get_slice(" ", 0)
			name1 = result[i].get(Global.task_name)
			tasks.add_item(text.format([date1, name1], "{}"))
	elif task_search.text.to_lower() in Global.status_list:
		request = "select * from tasks"
		
		database.query(request)
		var result = database.query_result
		
		var date1 = ""
		var name1 = ""
		var text = "{}: {}"
		
		for i in range(len(result)):
			if task_search.text.to_lower() == result[i].get(Global.status).to_lower():
				date1 = result[i].get(Global.task_date).get_slice(" ", 0)
				name1 = result[i].get(Global.task_name)
				tasks.add_item(text.format([date1, name1], "{}"))
			else:
				a = a + 1
	elif "-" in task_search.text:
		request = "select * from tasks"
		
		database.query(request)
		var result = database.query_result
		
		var date1 = ""
		var name1 = ""
		var text = "{}: {}"
		
		for i in range(len(result)):
			if task_search.text == result[i].get(Global.task_date).get_slice(" ", 0):
				date1 = result[i].get(Global.task_date).get_slice(" ", 0)
				name1 = result[i].get(Global.task_name)
				tasks.add_item(text.format([date1, name1], "{}"))
			else:
				a = a + 1
	else:
		request = "select * from tasks"
		
		database.query(request)
		var result = database.query_result
		
		var date1 = ""
		var name1 = ""
		var text = "{}: {}"
		
		for i in range(len(result)):
			if task_search.text.to_lower() == result[i].get(Global.task_name).to_lower():
				date1 = result[i].get(Global.task_date).get_slice(" ", 0)
				name1 = result[i].get(Global.task_name)
				tasks.add_item(text.format([date1, name1], "{}"))
			else:
				a = a + 1
	
	if a != 0:
		tasks.add_item("Ничего не было найдено :(")

func _on_refresh_pressed():
	tasks.clear()
	timer.start()
	tasks.add_item("Поиск...")
	Global.start = true
	
	if Global.stop == true:
		tasks.clear()
		_on_search_pressed()
		Global.stop = false
		Global.start = false

func _on_edit_pressed():
	change_status.disabled = true
	save_task.disabled = false
	edit_task.disabled = true
	
	task_name.editable = true
	task_text.editable = true

func _on_update_pressed():
	edit_task.disabled = true
	save_task.disabled = false
	change_status.disabled = true
	
	status.disabled = false
	who_did.editable = true

func _on_save_pressed():
	database.delete_rows("tasks", "{} = '{}'".format([Global.task_date, date.text], "{}"))
	
	var data = {
		"Дата" : date.text,
		"Название" : task_name.text,
		"Текст" : task_text.text,
		"Статус" : status.get_item_text(status.get_selected()),
		"Кто_выполнил" : who_did.text 
	}
		
	database.insert_row(Global.tasks, data)
	database.query("select * from tasks")
	print(database.query_result)
	
	status.select(-1)
	date.text = ""
	task_name.text = ""
	task_text.text = ""
	who_did.text = ""
	
	edit_task.disabled = true
	save_task.disabled = true
	change_status.disabled = true
	create_task.disabled = false
	
	status.disabled = true
	who_did.editable = false
	task_text.editable = false
	task_name.editable = false
	
	_on_search_pressed()

func _on_create_pressed():
	if Global.pressed == false:
		date.text = ""
		task_name.text = ""
		task_text.text = ""
		status.select(-1)
		
		date.editable = true
		date.text = Time.get_datetime_string_from_system(false, true)
		task_name.editable = true
		task_text.editable = true
		status.disabled = false
		Global.pressed = true
		database.query("select * from tasks")
		print(database.query_result)
	else:
		var data = {
			"Дата" : date.text,
			"Название" : task_name.text,
			"Текст" : task_text.text,
			"Статус" : status.get_item_text(status.get_selected()),
			"Кто_выполнил" : "" 
			}
		
		database.insert_row(Global.tasks, data)
		database.query("select * from tasks")
		print(database.query_result)
		
		date.editable = false
		task_name.editable = false
		task_text.editable = false
		status.disabled = true
		Global.pressed = false
		
		date.text = ""
		task_name.text = ""
		task_text.text = ""
		status.select(-1)

func _on_branch_select_1_item_selected(index):
	if index != -1:
		if "floorsb" in branch_select_1.get_item_text(index):
			var nums_office = 0
			
			for i in range(1,len(Global.office)+1):
				if Global.office_m1.right(i).is_valid_int() == false:
					nums_office = i-1
					break
			
			var num = 0
			var item = branch_select_1.get_item_text(index)
			
			for i in range(1,len(item)+1):
				if item.right(i).is_valid_int() == false:
					num = i-1
					break
			
			if nums_office != 0:
				if num == 0:
					Global.office_m1 = Global.office_m1.left(-nums_office) + str(index)
				else:
					Global.office_m1 = Global.office_m1.left(-nums_office) + item.right(num)
			else:
				if num == 0:
					Global.office_m1 = Global.office_m1 + str(index)
				else:
					Global.office_m1 = Global.office_m1 + item.right(num)
		else:
			var text = "{} = '{}'".format([Global.address, branch_select_1.get_item_text(index)], "{}")
			var result = database.select_rows(Global.branches, text, ["*"])
			
			Global.office_m1 = "office_b" + result[0].get(Global.file).right(1)

func _on_branch_select_2_item_selected(index):
	if index != -1:
		if "floorsb" in branch_select_2.get_item_text(index):
			var nums_office = 0
			
			for i in range(1,len(Global.office)+1):
				if Global.office_m2.right(i).is_valid_int() == false:
					nums_office = i-1
					break
			
			var num = 0
			var item = branch_select_2.get_item_text(index)
			
			for i in range(1,len(item)+1):
				if item.right(i).is_valid_int() == false:
					num = i-1
					break
			
			if nums_office != 0:
				if num == 0:
					Global.office_m2 = Global.office_m2.left(-nums_office) + str(index)
				else:
					Global.office_m2 = Global.office_m2.left(-nums_office) + item.right(num)
			else:
				if num == 0:
					Global.office_m2 = Global.office_m2 + str(index)
				else:
					Global.office_m2 = Global.office_m2 + item.right(num)
		else:
			var text = "{} = '{}'".format([Global.address, branch_select_2.get_item_text(index)], "{}")
			var result = database.select_rows(Global.branches, text, ["*"])
			
			Global.office_m2 = "office_b" + result[0].get(Global.file).right(1)

func _on_timer_timeout():
	error_1.visible = false
	error_2.visible = false
	timer.stop()
	
	if Global.stop == false and Global.start == true:
		Global.stop = true
		_on_refresh_pressed()

func _on_clear_2_pressed():
	tasks.clear()
	task_text.text = ""
	change_status.disabled = true
	edit_task.disabled = true
	save_task.disabled = true
	
	date.text = ""
	task_name.text = ""
	task_text.text = ""
	who_did.text = ""
	status.select(-1)

func _on_tasks_item_selected(index):
	change_status.disabled = false
	edit_task.disabled = false
	create_task.disabled = true
	
	database.query("select * from tasks")
	var result = database.query_result
	
	var tdate = tasks.get_item_text(index).get_slice(":", 0)
	var tname = tasks.get_item_text(index).get_slice(":", 1).strip_edges()
	
	for i in range(len(result)):
		if tdate == result[i].get(Global.task_date).get_slice(" ", 0) and tname == result[i].get(Global.task_name):
			date.text = result[i].get(Global.task_date)
			task_name.text = result[i].get(Global.task_name)
			task_text.text = result[i].get(Global.task_text)
			
			if result[i].get(Global.status) == "Выполнено":
				status.select(0)
			elif result[i].get(Global.status) == "В процессе":
				status.select(1)
			elif result[i].get(Global.status) == "Заморожен":
				status.select(2)
			
			who_did.text = result[i].get(Global.who_did)
			
			break

func _on_info_1_item_activated(index):
	info_1.remove_item(index)

func _on_info_2_item_activated(index):
	info_2.remove_item(index)
