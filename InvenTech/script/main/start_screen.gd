extends Node2D

var database : SQLite

@export var group : ButtonGroup

@onready var data_sec_timer = get_node("ColorRect2/data_sec")

@onready var form = get_node("ColorRect3")
@onready var login = get_node("ColorRect3/login")
@onready var password = get_node("ColorRect3/password")
@onready var enter = get_node("ColorRect3/enter_button")
@onready var show_hide = get_node("ColorRect3/show_hide")
@onready var back_btn_form = get_node("ColorRect3/back_btn")

@onready var login_btn = get_node("enter_btn")

@onready var label = get_node("ColorRect3/Label2")
@onready var label2 = get_node("ColorRect3/Label")
@onready var timer = get_node("ColorRect3/Timer")

@onready var task_window = get_node("tasks_window")
@onready var task_search_line = get_node("tasks_window/task_search_line")
@onready var task_search_btn = get_node("tasks_window/search_task_btn")
@onready var search_status_list = get_node("tasks_window/search_status_list")
@onready var task_list = get_node("tasks_window/task_list")
@onready var add_task_btn = get_node("tasks_window/add_task_btn")
@onready var delete_task_btn = get_node("tasks_window/delete_task_btn")
@onready var task_back_btn = get_node("tasks_window/task_back_btn")
@onready var edit_task_btn = get_node("tasks_window/edit_task_btn")
@onready var save_task_btn = get_node("tasks_window/save_task_btn")
@onready var update_status_btn = get_node("tasks_window/update_status")
@onready var clear_task_list = get_node("tasks_window/clear_task_list")

@onready var popup_menu = get_node("tasks_window/popup_menu")

@onready var task_timer = get_node("tasks_window/task_timer")
@onready var data_saved_label = get_node("tasks_window/data_saved_label")
@onready var task_count = get_node("task_count")

@onready var task_date_label = get_node("tasks_window/Label2")
@onready var task_date = get_node("tasks_window/task_date")
@onready var task_name_label = get_node("tasks_window/Label3")
@onready var task_name = get_node("tasks_window/task_name")
@onready var task_text_label = get_node("tasks_window/Label4")
@onready var task_text = get_node("tasks_window/task_text")
@onready var task_spots_label = get_node("tasks_window/Label5")
@onready var task_spots = get_node("tasks_window/task_spots")
@onready var task_user_label = get_node("tasks_window/Label7")
@onready var task_user = get_node("tasks_window/task_user")
@onready var task_status_label = get_node("tasks_window/Label6")
@onready var task_status = get_node("tasks_window/task_status")

@onready var view = get_node("view_button")
@onready var edit = get_node("edit_button")

@onready var branches = get_node("branches")
@onready var settings = get_node("settings")
@onready var tasks = get_node("tasks")
@onready var exit = get_node("exit_button")
@onready var select_branch_label = get_node("select_branch")

@onready var settings_panel = get_node("ColorRect2")

@onready var new_branch = get_node("ColorRect2/branch_button")
@onready var branch = get_node("ColorRect2/address")
@onready var add_branch = get_node("ColorRect2/save_button")
@onready var branch_added = get_node("ColorRect2/branch_added")

@onready var delete_branch_btn = get_node("ColorRect2/delete_button")
@onready var branches_to_delete = get_node("ColorRect2/branches_to_delete")
@onready var branches_label = get_node("ColorRect2/Label")
@onready var no_btn = get_node("ColorRect2/no_btn")
@onready var yes_btn = get_node("ColorRect2/yes_btn")
@onready var confirm_label = get_node("ColorRect2/Label3")
@onready var success_label = get_node("ColorRect2/Label4")
@onready var label_select_branch = get_node("ColorRect2/Label_select_branch")

@onready var branch_add_info = get_node("ColorRect2/branch_add_info")
@onready var add_info = get_node('ColorRect2/add_info')
@onready var add_info_btn = get_node("ColorRect2/add_info_btn")
@onready var data_label = get_node("ColorRect2/Label2")
@onready var not_added_list = get_node("ColorRect2/not_added")

@onready var show_hide2 = get_node("ColorRect2/show_hide")
@onready var add_user_login = get_node("ColorRect2/login_add_user")
@onready var add_user = get_node("ColorRect2/add_user")
@onready var add_user_password = get_node("ColorRect2/password_add_user")
@onready var add_user_btn = get_node("ColorRect2/add_user_btn")
@onready var user_added = get_node("ColorRect2/label_user")

@onready var delete_user_btn = get_node("ColorRect2/delete_user")
@onready var user_label = get_node("ColorRect2/user_label")
@onready var user_list = get_node("ColorRect2/user_list")
@onready var delete_user = get_node("ColorRect2/delete_user_btn")
@onready var delete_user_label = get_node("ColorRect2/delete_user_label")
@onready var do_delete_btn = get_node("ColorRect2/do_delete")
@onready var do_not_delete_btn = get_node("ColorRect2/do_not_delete")
@onready var select_user_label = get_node("ColorRect2/select_user_delete")

@onready var change_password_btn = get_node("ColorRect2/change_password")
@onready var old_password_line = get_node("ColorRect2/old_password")
@onready var new_password_line = get_node("ColorRect2/new_password")
@onready var change_password = get_node("ColorRect2/change")
@onready var password_changed = get_node("ColorRect2/password_changed")
@onready var select_user_change_password = get_node("ColorRect2/select_user_change")

@onready var progress = get_node('ColorRect2/ProgressBar')
@onready var timer_data = get_node("ColorRect2/data_timer")

@onready var dir = OS.get_executable_path().get_base_dir()
@onready var floor_dir = dir.path_join('floors/')
@onready var data_dir = dir.path_join('database/data.db')
@onready var icons_dir = dir.path_join('icons/')

func check_user():
	if Global.user != "":
		if Global.user == "admin":
			settings.visible = true
			edit.visible = true
			tasks.visible = true
			task_count.visible = false
		else:
			var query = "{} = '{}' and {} = '{}'"
			var data = database.select_rows(Global.tasks, query.format([Global.who_did, Global.user, Global.status, "В процессе"], "{}"), ["*"])
			task_count.text = len(data)
			
			task_count.visible = true
			tasks.visible = true
			settings.visible = false
			edit.visible = false
		
		login_btn.text = "Сменить пользователя"
	else:
		settings.visible = false
		edit.visible = false
		tasks.visible = false

func _on_exit_pressed():
	get_tree().quit()

func _on_branches_item_selected(index):
	if index != 0:
		view.disabled = false
		edit.disabled = false
		
		if "floorsb" in branches.get_item_text(index):
			var nums_office = 0
			var nums_branch = 0
			
			for i in range(1,len(Global.branch)+1):
				if Global.branch.right(i).is_valid_int() == false:
					nums_branch = i-1
					break
			
			for i in range(1,len(Global.office)+1):
				if Global.office.right(i).is_valid_int() == false:
					nums_office = i-1
					break
			
			var num = 0
			var item = branches.get_item_text(index)
			
			for i in range(1,len(item)+1):
				if item.right(i).is_valid_int() == false:
					num = i-1
					break
			
			if nums_branch != 0 and nums_office != 0:
				if num == 0:
					Global.office = Global.office.left(-nums_office) + str(index)
					Global.branch = Global.branch.left(-nums_branch) + str(index)
				else:
					Global.office = Global.office.left(-nums_office) + item.right(num)
					Global.branch = Global.branch.left(-nums_branch) + item.right(num)
			else:
				if num == 0:
					Global.office = Global.office + str(index)
					Global.branch = Global.branch + str(index)
				else:
					Global.office = Global.office + item.right(num)
					Global.branch = Global.branch + item.right(num)
			
			if num != 0:
				Global.floors = len(DirAccess.get_files_at(floor_dir+branches.get_item_text(index)+"/"))
		else:
			var text = "{} = '{}'".format([Global.address, branches.get_item_text(index)], "{}")
			var result = database.select_rows(Global.branches, text, ["*"])
			
			Global.branch = result[0].get(Global.file)
			Global.office = "office_b" + Global.branch.right(1)
			
			Global.floors = len(DirAccess.get_files_at(floor_dir+Global.branch+"/"))
	else:
		view.disabled = true
		edit.disabled = true

func _ready():
	database = SQLite.new()
	database.path = data_dir
	database.open_db()
	
	var directories = DirAccess.get_directories_at(floor_dir)
	for i in (len(directories)):
		var text = "{} = '{}'".format([Global.file, directories[i]], "{}")
		var data = database.select_rows(Global.branches, text, ["*"])
		if len(data) != 0:
			branches.add_item(data[0].get(Global.address))
			branches_to_delete.add_item(data[0].get(Global.address))
			branch_add_info.add_item(data[0].get(Global.address))
		else:
			branches.add_item(directories[i])
			branches_to_delete.add_item(directories[i])
			branch_add_info.add_item(directories[i])
	
	var btn_list = group.get_buttons()
	for i in range(len(btn_list)):
		btn_list[i].pressed.connect(self._on_settings_btn_pressed)
	
	check_user()

func _on_add_branch_button_pressed():
	if branch.text.strip_edges() != "":
		var query = "{} = '{}'"
		var query_result = database.select_rows(Global.branches, query.format([Global.address, branch.text.strip_edges()], "{}"), ["*"])
		
		if query_result.is_empty() == true:
			branches.add_item(branch.text.strip_edges())
			branches_to_delete.add_item(branch.text.strip_edges())
			branch_add_info.add_item(branch.text.strip_edges())
			
			var directories = DirAccess.get_directories_at(floor_dir)
			var nums = []
			
			for i in range(len(directories)):
				var num = 0
				for j in range(1,len(directories[i])+1):
					if directories[i].right(j).is_valid_int() == false:
						num = int(directories[i].right(j-1))
						print(num)
						break
				nums.append(num)
			
			var max_num = nums.max()
			print(nums)
			
			DirAccess.make_dir_absolute(floor_dir+Global.branch+str(max_num + 1))
			
			var data = {}
			
			print(branch.text)
			
			data = {
				Global.file : Global.branch + str(max_num+1),
				Global.address : branch.text.strip_edges(),
			}
			
			database.insert_row("branches", data)
			
			database.query("select * from branches")
			var result = database.query_result
			print(result)
			
			var table_name = Global.office + str(max_num+1)
			var table_dict : Dictionary
			
			table_dict["{}".format([Global.button], "{}")] = {"data_type" : "TEXT"}
			table_dict["{}".format([Global.floor], "{}")] = {"data_type" : "TEXT"}
			table_dict["{}".format([Global.cabinet], "{}")] = {"data_type" : "TEXT"}
			table_dict["{}".format([Global.spot], "{}")] = {"data_type" : "TEXT"}
			table_dict["{}".format([Global.number], "{}")] = {"data_type" : "TEXT"}
			table_dict["{}".format([Global.pc_name], "{}")] = {"data_type" : "TEXT"}
			table_dict["{}".format([Global.model], "{}")] = {"data_type" : "TEXT"}
			
			database.create_table(table_name, table_dict)
			
			branch_added.visible = true
			timer.start()
		else:
			branch_added.text = "Такой филиал уже есть"
			branch_added.visible = true
			timer.start()
	else:
		branch_added.text = "Введите название филиала"
		branch_added.visible = true
		timer.start()

func _on_view_button_pressed():
	if branches.get_selected() != -1:
		Global.view = true
		get_tree().change_scene_to_file("res://scenes/main/main.tscn")
	else:
		select_branch_label.visible = true
		timer.start()

func _on_edit_button_pressed():
	if branches.get_selected() != -1:
		Global.view = false
		get_tree().change_scene_to_file("res://scenes/main/editor.tscn")
	else:
		select_branch_label.visible = true
		timer.start()

func _on_enter_button_pressed():
	if login.text != "" and password.text != "":
		var password_hash = password.text.sha256_text()
		var text = "{} = '{}'".format([Global.user_db, str(login.text)], "{}")
		var result = database.select_rows(Global.users, text, ["*"])
		
		if password.text == "fun" and login.text == "fun":
			enter.visible = false
			password.secret = false
			show_hide.set_button_icon(ResourceLoader.load("res://icons/eye.png"))
			password.text = "https://matias.me/nsfw/"
			label2.text = "Скопируй"
			label2.visible = true
			show_hide.disabled = true
			
			timer.start()
		else:
			if result.is_empty() == false:
				var db_password = result[0].get(Global.password)
				
				if password_hash == db_password:
					Global.user = login.text
					
					form.visible = false
					branches.disabled = false
					settings.disabled = false
					edit.disabled = false
					view.disabled = false
					exit.disabled = false
					tasks.disabled = false
					login_btn.disabled = false
					login.text = ""
					password.text = ""
					
					if login_btn.text == "Войти":
						login_btn.text = "Сменить пользователя"
					
					check_user()
				else:
					label2.text = "Неверный пароль"
					password.text = ""
					label2.visible = true
					
					timer.start()
			else:
				label2.visible = true
				label2.text = "Такого пользователя нет"
				
				timer.start()

func _on_timer_timeout():
	if enter.visible == false:
		enter.visible = true
		password.secret = true
		
		show_hide.set_button_icon(ResourceLoader.load("res://icons/eye_hide.png"))
		show_hide.disabled = false
		
		password.text = ""
		login.text = ""
	elif user_added.visible == true:
		user_added.visible = false
		
		add_user_login.text = ""
		add_user_password.text = ""
	elif label2.visible == true:
		label2.visible = false
		password.text = ""
		login.text = ""
	elif branch_added.visible == true:
		branch_added.visible = false
		branch.text = ""
	elif password_changed.visible == true:
		if password_changed.text != "Пароль изменён":
			old_password_line.text = ""
			new_password_line.text = ""
			password_changed.text = "Пароль изменён"
			password_changed.visible = false
		else:
			user_list.select(-1)
			old_password_line.text = ""
			new_password_line.text = ""
			password_changed.visible = false
	elif select_branch_label.visible == true:
		select_branch_label.visible = false
	elif label_select_branch.visible == true:
		label_select_branch.visible = false
	elif select_user_label.visible == true:
		select_user_label.visible = false
	elif select_user_change_password.visible == true:
		select_user_change_password.visible = false
	elif data_saved_label.visible == true:
		data_saved_label.visible = false
	
	timer.stop()

func _on_test_button_pressed():
	get_tree().change_scene_to_file("res://scenes/other/test.tscn")

func _on_show_hide_pressed():
	if Global.show == false:
		Global.show = true
		password.secret = false
		show_hide.set_button_icon(ResourceLoader.load(icons_dir+"eye.png"))
	else:
		Global.show = false
		password.secret = true
		show_hide.set_button_icon(ResourceLoader.load(icons_dir+"eye_hide.png"))

func _on_settings_pressed():
	settings_panel.visible = true
	branches.disabled = true
	edit.disabled = true
	view.disabled = true
	settings.disabled = true
	tasks.disabled = true
	login_btn.disabled = true
	exit.disabled = true
	enter.disabled = true

func _on_settings_btn_pressed():
	var button = group.get_pressed_button().text
	var btn_list = group.get_buttons()
	
	var count = settings_panel.get_child_count()
	
	for i in range(count):
		if settings_panel.get_child(i).visible == true and settings_panel.get_child(i) not in btn_list and "Color" not in settings_panel.get_child(i).name:
			settings_panel.get_child(i).visible = false
			if settings_panel.get_child(i) is LineEdit or settings_panel.get_child(i) is TextEdit:
				settings_panel.get_child(i).text = ""
			elif settings_panel.get_child(i) is OptionButton:
				settings_panel.get_child(i).select(-1)
	
	if button == "Добавить филиал":
		add_branch.visible = true
		branch.visible = true
	elif button == "Удалить филиал":
		branches_to_delete.visible = true
		branches_label.visible = true
		delete_branch_btn.visible = true
	elif button == "Добавить данные":
		add_info.visible = true
		add_info_btn.visible = true
		branch_add_info.visible = true
		branches_label.visible = true
		progress.visible = true
		not_added_list.clear()
		not_added_list.add_item("Для следующих данных нет места:")
	elif button == "Добавить пользователя":
		add_user_btn.visible = true
		add_user_login.visible = true
		add_user_password.visible = true
		show_hide2.visible = true
	elif button == "Удалить пользователя":
		delete_user.visible = true
		user_label.visible = true
		user_list.visible = true
		user_list.clear()
		
		database.query("select * from users")
		var data = database.query_result
		
		for i in range(len(data)):
			if data[i].get(Global.user_db) != "admin":
				user_list.add_item(data[i].get(Global.user_db))
		
		user_list.select(-1)
	elif button == "Поменять пароль":
		user_label.visible = true
		user_list.visible = true
		user_list.clear()
		new_password_line.visible = true
		old_password_line.visible = true
		change_password.visible = true
		
		database.query("select * from users")
		var data = database.query_result
		
		for i in range(len(data)):
			user_list.add_item(data[i].get(Global.user_db))
		
		user_list.select(-1)
	elif button == "Назад":
		settings_panel.visible = false
		
		settings_panel.visible = false
		branches.disabled = false
		edit.disabled = false
		view.disabled = false
		settings.disabled = false
		tasks.disabled = false
		login_btn.disabled = false
		exit.disabled = false
		password.editable = true
		show_hide.disabled = false
		enter.disabled = false

func _on_add_info_btn_pressed():
	Global.not_added_info = []
	
	not_added_list.clear()
	not_added_list.add_item("Для следующих данных нет места:")
	
	var btn_list = group.get_buttons()
	var settings_count = settings_panel.get_child_count()
	
	for i in range(settings_count):
		if settings_panel.get_child(i) in btn_list:
			settings_panel.get_child(i).disabled = true
	
	add_info.editable = false
	branch_add_info.disabled = true
	add_info_btn.disabled = true
	
	var info_dict = {}
	var add_info_dict = {}
	var add_base_dict = {}
	
	var info_cab = ""
	var info_spot = ""
	var info_num = ""
	var info_name = ""
	var info_model = ""
	
	var info = add_info.text
	
	if info != "" and branch_add_info.get_selected() != -1:
		var sep = ""
		
		for i in len(info):
			if info[i] not in Global.numbers and info[i] not in Global.letters and info[i] not in Global.symbols:
				sep = info[i]
				break
		
		var sep_num = info.count(sep)
		
		var count = 0
		
		for i in range(sep_num+1):
			if count != 5:
				if count == 0:
					info_cab = info.get_slice(sep,i)
				elif count == 1:
					info_spot = str(info.get_slice(sep,i))
					if info_spot.begins_with("0") == true:
						info_spot = info_spot.substr(1,-1)
						if info_spot.begins_with("0") == true:
							info_spot = info_spot.substr(1,-1)
					info_spot = info_spot.to_lower()
				elif count == 2:
					info_num = info.get_slice(sep,i)
				elif count == 3:
					if info.get_slice(sep,i) == "#Н/Д":
						info_name = ""
					else:
						info_name = info.get_slice(sep,i)
				elif count == 4:
					if i == sep_num:
						if info.get_slice(sep,i).left(len(info.get_slice(sep,i))-1) == "#Н/Д":
							info_model = ""
						else:
							info_model = info.get_slice(sep,i).left(len(info.get_slice(sep,i))-1)
							info_model = info_model.replacen(sep, "")
					else:
						if info.get_slice(sep,i).left(len(info.get_slice(sep,i))-4) == "#Н/Д":
							info_model = ""
						else:
							info_model = info.get_slice(sep,i).left(len(info.get_slice(sep,i))-4)
							info_model = info_model.replacen(sep, "")
					
					info_dict = {
						Global.cabinet : info_cab,
						Global.spot : info_spot,
						Global.number : info_num,
						Global.pc_name : info_name,
						Global.model : info_model
					}
					
					Global.info_arr.append(info_dict)
					
					if info.get_slice(sep,i).right(1) not in Global.letters:
						info_cab = info.get_slice(sep,i).right(3)
					else:
						info_cab = info.get_slice(sep,i).right(4)
				
				count = count + 1
			else:
				count = 2
				
				info_spot = str(info.get_slice(sep,i))
				if info_spot.begins_with("0") == true:
					info_spot = info_spot.substr(1,-1)
					if info_spot.begins_with("0") == true:
						info_spot = info_spot.substr(1,-1)
				info_spot = info_spot.to_lower()
		
		progress.value = 0
		
		info_cab = ""
		info_spot = ""
		info_num = ""
		info_name = ""
		info_model = ""
		
		Global.info_count = len(Global.info_arr) - 1
		progress.max_value = Global.info_count
		
		not_added_list.visible = true
		data_sec_timer.start()

func _on_branch_add_info_item_selected(index):
	if index != 0:
		if "floorsb" in branch_add_info.get_item_text(index):
			var nums_office = 0
			
			for i in range(1,len(Global.office)+1):
				if Global.office.right(i).is_valid_int() == false:
					nums_office = i-1
					break
			
			var num = 0
			var item = branch_add_info.get_item_text(index)
			
			for i in range(1,len(item)+1):
				if item.right(i).is_valid_int() == false:
					num = i-1
					break
			
			if nums_office != 0:
				if num == 0:
					Global.office_info = Global.office_info.left(-nums_office) + str(index)
				else:
					Global.office_info = Global.office_info.left(-nums_office) + item.right(num)
			else:
				if num == 0:
					Global.office_info = Global.office_info + str(index)
				else:
					Global.office_info = Global.office_info + item.right(num)
		else:
			var text = "{} = '{}'".format([Global.address, branch_add_info.get_item_text(index)], "{}")
			var result = database.select_rows(Global.branches, text, ["*"])
			
			Global.branch = result[0].get(Global.file)
			Global.office_info = "office_b" + Global.branch.right(1)
			
			print(Global.office_info)
			
			Global.branch = "floorsb"

func _on_data_timer_timeout():
	if user_list.visible == true:
		delete_user_label.text = "Вы уверены?"
		delete_user_label.visible = false
		
		database.query("select * from users")
		var data = database.query_result
		
		for i in range(len(data)):
			if data[i].get(Global.user_db) != "admin":
				user_list.add_item(data[i].get(Global.user_db))
		
		user_list.select(-1)
		
		var btn_list = group.get_buttons()
		var count = settings_panel.get_child_count()
		
		for i in range(count):
			if settings_panel.get_child(i) in btn_list:
				settings_panel.get_child(i).disabled = false
		
		user_list.disabled = false
		delete_user.disabled = false
	else:
		data_label.visible = false
		success_label.visible = false
		progress.value = 0
		add_info.text = ""
		
		var btn_list = group.get_buttons()
		var count = settings_panel.get_child_count()
		
		for i in range(count):
			if settings_panel.get_child(i) in btn_list:
				settings_panel.get_child(i).disabled = false
		
		add_info.editable = true
		branch_add_info.disabled = false
		add_info_btn.disabled = false
		
		Global.i = 0
		Global.info_count = 0
		Global.info_arr = []
		
		var not_added_file = FileAccess.open("logs/not_added_log.txt",FileAccess.WRITE)
		Global.not_added_info = str(Global.not_added_info).replacen("[", "").replacen("]", "").replacen('"', "").replacen(", ", "\n").replacen("*", "	")
		not_added_file.store_string(Global.not_added_info)
		not_added_file.close()

func _on_delete_button_pressed():
	if branches_to_delete.get_selected() != -1 and branches_to_delete.get_selected() != 0:
		yes_btn.visible = true
		no_btn.visible = true
		confirm_label.visible = true
		delete_branch_btn.visible = false
		branches_to_delete.disabled = true
	else:
		label_select_branch.visible = true
		timer.start()

func _on_no_btn_pressed():
	yes_btn.visible = false
	no_btn.visible = false
	confirm_label.visible = false
	delete_branch_btn.visible = true
	branches_to_delete.disabled = false

func _on_yes_btn_pressed():
	var files = DirAccess.get_files_at(floor_dir+Global.branch+"/")
	
	if Global.floors != 0:
		for i in range(Global.floors):
			DirAccess.remove_absolute(floor_dir+Global.branch+"/"+files[i])
	
	database.drop_table(Global.office)
	database.delete_rows(Global.branches, "{} = '{}'".format([Global.file, Global.branch], "{}"))
	
	var data = database.select_rows(Global.users, "{} = '{}'".format([Global.file, Global.branch], "{}"), ["*"])
	
	if data.is_empty() == false:
		database.delete_rows(Global.users, "{} = '{}'".format([Global.file, Global.branch], "{}"))
	
	DirAccess.remove_absolute(floor_dir+Global.branch)
	
	yes_btn.visible = false
	no_btn.visible = false
	confirm_label.visible = false
	branches_to_delete.disabled = false
	delete_branch_btn.visible = true
	
	branches_to_delete.select(-1)
	branches_to_delete.remove_item(Global.item_index)
	branches.select(-1)
	branches.remove_item(Global.item_index)
	branch_add_info.select(-1)
	branch_add_info.remove_item(Global.item_index)
	
	success_label.visible = true
	timer_data.start()

func _on_branches_to_delete_item_selected(index):
	if index != 0:
		Global.item_index = index
		
		if "floorsb" in branches.get_item_text(index):
			var nums_office = 0
			var nums_branch = 0
			
			for i in range(1,len(Global.branch)+1):
				if Global.branch.right(i).is_valid_int() == false:
					nums_branch = i-1
					break
			
			for i in range(1,len(Global.office)+1):
				if Global.office.right(i).is_valid_int() == false:
					nums_office = i-1
					break
			
			var num = 0
			var item = branches.get_item_text(index)
			
			for i in range(1,len(item)+1):
				if item.right(i).is_valid_int() == false:
					num = i-1
					break
			
			if nums_branch != 0 and nums_office != 0:
				if num == 0:
					Global.office = Global.office.left(-nums_office) + str(index)
					Global.branch = Global.branch.left(-nums_branch) + str(index)
				else:
					Global.office = Global.office.left(-nums_office) + item.right(num)
					Global.branch = Global.branch.left(-nums_branch) + item.right(num)
			else:
				if num == 0:
					Global.office = Global.office + str(index)
					Global.branch = Global.branch + str(index)
				else:
					Global.office = Global.office + item.right(num)
					Global.branch = Global.branch + item.right(num)
			
			if num != 0:
				Global.floors = len(DirAccess.get_files_at(floor_dir+branches.get_item_text(index)+"/"))
		else:
			var text = "{} = '{}'".format([Global.address, branches.get_item_text(index)], "{}")
			var result = database.select_rows(Global.branches, text, ["*"])
			
			Global.branch = result[0].get(Global.file)
			Global.office = "office_b" + Global.branch.right(1)
			
			Global.floors = len(DirAccess.get_files_at(floor_dir+Global.branch+"/"))

func _on_enter_btn_pressed():
	settings.disabled = true
	form.visible = true
	branches.disabled = true
	edit.disabled = true
	view.disabled = true
	exit.disabled = true
	tasks.disabled = true
	login_btn.disabled = true

func _on_back_btn_pressed():
	settings.disabled = false
	form.visible = false
	branches.disabled = false
	edit.disabled = false
	view.disabled = false
	exit.disabled = false
	tasks.disabled = false
	login_btn.disabled = false
	login.text = ""
	password.text = ""

func _on_add_user_btn_pressed():
	var query = "{} = '{}'"
	var user_info = {}
	
	if add_user_login.text != "" and add_user_password.text != "":
		var data = database.select_rows(Global.users, query.format([Global.user_db, add_user_login.text], "{}"), ["*"])
		
		if data.is_empty() == false:
			user_added.text = "Такой пользователь уже есть"
			
			user_added.visible = true
			
			timer.start()
		else:
			var password_hash = add_user_password.text.sha256_text()
			
			user_info = {
				Global.user_db : add_user_login.text,
				Global.password : password_hash
			}
			
			database.insert_row(Global.users, user_info)
			
			user_added.text = "Пользователь добавлен"
			user_added.visible = true
			
			timer.start()
	else:
		user_added.text = "Заполните все поля"
		user_added.visible = true
		
		timer.start()

func _on_data_sec_timeout():
	var info_to_add = {}
	
	var query = "{} = '{}' and {} = '{}'"
	
	var info_cab = ""
	var info_spot = ""
	var info_num = ""
	var info_name = ""
	var info_model = ""
	
	info_cab = Global.info_arr[Global.i].get(Global.cabinet)
	info_spot = Global.info_arr[Global.i].get(Global.spot)
	info_num = Global.info_arr[Global.i].get(Global.number)
	info_name = Global.info_arr[Global.i].get(Global.pc_name)
	info_model = Global.info_arr[Global.i].get(Global.model)
	
	var is_there_spot = database.select_rows(Global.office_info, query.format([Global.cabinet, info_cab, Global.spot, info_spot], "{}"), ["*"])
	
	if is_there_spot.is_empty() == false:
		query = "{} = '{}'"
		
		var duplicate_floor = ""
		var duplicate_button = ""
		var duplicate_spot = ""
		var duplicate_cab = ""
		var duplicate_number = ""
		var duplicate_name = ""
		var duplicate_model = ""
		
		var is_there_dublicate = database.select_rows(Global.office_info, query.format([Global.pc_name, info_name], "{}"), ["*"])
		
		if len(info_name) != 0:
			if is_there_dublicate.is_empty() == false:
				duplicate_floor = is_there_dublicate[0].get(Global.floor)
				duplicate_button = is_there_dublicate[0].get(Global.button)
				duplicate_cab = is_there_dublicate[0].get(Global.cabinet)
				duplicate_spot = is_there_dublicate[0].get(Global.spot)
				duplicate_model = is_there_dublicate[0].get(Global.model)
				duplicate_number = is_there_dublicate[0].get(Global.number)
				
				database.delete_rows(Global.office_info, query.format([Global.pc_name, info_name], "{}"))
				
				info_to_add = {
					Global.button : duplicate_button,
					Global.floor : duplicate_floor,
					Global.cabinet : duplicate_cab,
					Global.spot : duplicate_spot,
					Global.number : duplicate_number,
					Global.pc_name : duplicate_name,
					Global.model : duplicate_model
				}
				
				database.insert_row(Global.office_info, info_to_add)
		
		is_there_dublicate = database.select_rows(Global.office_info, query.format([Global.number, info_num], "{}"), ["*"])
		
		if is_there_dublicate.is_empty() == false:
			query = "{} != '{}' and {} = '{}' and {} = '{}'"
			var is_there_info = database.select_rows(Global.office_info, query.format([Global.number, info_num, Global.spot, info_spot, Global.cabinet, info_cab], "{}"), ["*"])
			
			if is_there_info.is_empty() == true:
				duplicate_floor = is_there_dublicate[0].get(Global.floor)
				duplicate_button = is_there_dublicate[0].get(Global.button)
				duplicate_cab = is_there_dublicate[0].get(Global.cabinet)
				duplicate_spot = is_there_dublicate[0].get(Global.spot)
				
				info_to_add = {
					Global.button : duplicate_button,
					Global.floor : duplicate_floor,
					Global.cabinet : duplicate_cab,
					Global.spot : duplicate_spot,
					Global.number : "",
					Global.pc_name : "",
					Global.model : ""
				}
				
				database.insert_row(Global.office_info, info_to_add)
			
			query = "{} = '{}'"
			database.delete_rows(Global.office_info, query.format([Global.number, info_num], "{}"))
		
		var base_spot_to_add = is_there_spot[0].get(Global.spot)
		var base_cab_to_add = is_there_spot[0].get(Global.cabinet)
		var base_floor_to_add = is_there_spot[0].get(Global.floor)
		var base_button_to_add = is_there_spot[0].get(Global.button)
		
		query = "{} = '{}' and {} = '{}' and {} = '{}'"
		var is_there_empty_spot = database.select_rows(Global.office_info, query.format([Global.number, "", Global.spot, info_spot, Global.cabinet, info_cab], "{}"), ["*"])
		
		if is_there_empty_spot.is_empty() == false:
			database.delete_rows(Global.office_info, query.format([Global.number, "", Global.spot, info_spot, Global.cabinet, info_cab], "{}"))
		
		info_to_add = {
			Global.button : base_button_to_add,
			Global.floor : base_floor_to_add,
			Global.cabinet : base_cab_to_add,
			Global.spot : base_spot_to_add,
			Global.number : info_num,
			Global.pc_name : info_name,
			Global.model : info_model
		}
		
		database.insert_row(Global.office_info, info_to_add)
	else:
		var text = "{}:{} {}".format([info_cab, info_spot, info_num], "{}")
		not_added_list.add_item(text)
		text = "{}*{}*{}".format([info_cab, info_spot, info_num], "{}")
		Global.not_added_info.append(text)
	
	if Global.i == progress.max_value:
		data_label.visible = true
		data_sec_timer.stop()
		timer_data.start()
	
	Global.i += 1
	progress.value += 1

func _on_tasks_pressed():
	branches.disabled = true
	edit.disabled = true
	view.disabled = true
	settings.disabled = true
	tasks.disabled = true
	login_btn.disabled = true
	exit.disabled = true
	enter.disabled = true
	task_window.visible = true
	
	if Global.user == "admin":
		add_task_btn.visible = true
		delete_task_btn.visible = true
	else:
		add_task_btn.visible = false
		delete_task_btn.visible = false
	
	

func _on_task_back_btn_pressed():
	branches.disabled = false
	edit.disabled = false
	view.disabled = false
	settings.disabled = false
	tasks.disabled = false
	login_btn.disabled = false
	exit.disabled = false
	enter.disabled = false
	task_window.visible = false
	
	task_date_label.visible = false
	task_date.visible = false
	task_date.text = ""
	task_name_label.visible = false
	task_name.visible = false
	task_name.text = ""
	task_text_label.visible = false
	task_text.visible = false
	task_text.text = ""
	task_spots_label.visible = false
	task_spots.visible = false
	task_spots.text = ""
	task_user_label.visible = false
	task_user.visible = false
	task_user.text = ""
	task_status_label.visible = false
	task_status.visible = false
	task_status.select(-1)
	edit_task_btn.visible = false
	save_task_btn.visible = false
	update_status_btn.visible = false
	
	search_status_list.select(0)
	task_list.clear()

func _on_add_task_btn_pressed():
	task_date_label.visible = true
	task_date.visible = true
	task_name_label.visible = true
	task_name.visible = true
	task_name.editable = true
	task_text_label.visible = true
	task_text.visible = true
	task_text.editable = true
	task_spots_label.visible = true
	task_spots.visible = true
	task_spots.editable = true
	task_user_label.visible = true
	task_user.visible = true
	task_user.editable = true
	task_status_label.visible = true
	task_status.visible = true
	task_status.disabled = false
	save_task_btn.visible = true
	
	task_date.text = str(Time.get_datetime_string_from_system(false, true))

func _on_task_list_item_selected(index):
	var tdate = task_list.get_item_text(index).get_slice(":", 0)
	var tname = task_list.get_item_text(index).get_slice(":", 1).strip_edges()
	
	task_date_label.visible = true
	task_date.visible = true
	task_name_label.visible = true
	task_name.visible = true
	task_text_label.visible = true
	task_text.visible = true
	task_spots_label.visible = true
	task_spots.visible = true
	task_status_label.visible = true
	task_status.visible = true
	
	delete_task_btn.disabled = false
	
	if Global.user == "admin":
		edit_task_btn.visible = true
		task_user_label.visible = true
		task_user.visible = true
	else:
		update_status_btn.visible = true
	
	database.query("select * from tasks")
	var result = database.query_result
	
	for i in range(len(result)):
		if tdate == result[i].get(Global.task_date).get_slice(" ", 0) and tname == result[i].get(Global.task_name):
			task_date.text = result[i].get(Global.task_date)
			task_name.text = result[i].get(Global.task_name)
			task_text.text = result[i].get(Global.task_text)
			task_spots.text = result[i].get(Global.task_spots)
			task_user.text = result[i].get(Global.who_did)
			
			if result[i].get(Global.status) == "Выполнено":
				task_status.select(1)
			elif result[i].get(Global.status) == "В процессе":
				task_status.select(0)
			
			break

func _on_edit_task_btn_pressed():
	save_task_btn.visible = true
	edit_task_btn.visible = false
	
	task_name.editable = true
	task_text.editable = true
	task_spots.editable = true
	task_user.editable = true
	task_status.disabled = false

func _on_update_status_pressed():
	save_task_btn.visible = true
	update_status_btn.visible = false
	
	task_status.disabled = false

func _on_save_task_btn_pressed():
	if len(task_name.text) != 0:
		var task_to_add = {}
		var query = "{} = '{}'"
		var task_data = database.select_rows(Global.tasks, query.format([Global.task_date, task_date.text], "{}"), ["*"])
		
		if task_data.is_empty() == false:
			database.delete_rows(Global.tasks, query.format([Global.task_date, task_date.text], "{}"))
		
		task_data = database.select_rows(Global.users, query.format([Global.user_db, task_user.text], "{}"), ["*"])
		
		if task_data.is_empty() == false:
			task_to_add = {
				Global.task_date : task_date.text,
				Global.task_name : task_name.text,
				Global.task_text : task_text.text,
				Global.task_spots : task_spots.text,
				Global.status : task_status.get_item_text(task_status.get_selected()),
				Global.who_did : task_user.text
			}
			
			database.insert_row(Global.tasks, task_to_add)
			
			data_saved_label.visible = true
			
			task_name.editable = false
			task_text.editable = false
			task_spots.editable = false
			task_user.editable = false
			task_status.disabled = true
			
			task_list.clear()
			
			task_timer.start()
		else:
			data_saved_label.visible = true
			data_saved_label.text = "Такого пользователя нет"
			
			timer.start()
	else:
		data_saved_label.visible = true
		data_saved_label.text = "Заполните все поля"
		
		timer.start()

func _on_task_timer_timeout():
	if data_saved_label.text == "Такого пользователя нет":
		task_timer.stop()
		data_saved_label.text = "Данные сохранены"
		task_user.text = ""
	else:
		data_saved_label.visible = false
		
		task_date_label.visible = false
		task_date.visible = false
		task_date.text = ""
		task_name_label.visible = false
		task_name.visible = false
		task_name.text = ""
		task_text_label.visible = false
		task_text.visible = false
		task_text.text = ""
		task_spots_label.visible = false
		task_spots.visible = false
		task_spots.text = ""
		task_user_label.visible = false
		task_user.visible = false
		task_user.text = ""
		task_status_label.visible = false
		task_status.visible = false
		task_status.select(-1)
		edit_task_btn.visible = false
		save_task_btn.visible = false
		update_status_btn.visible = false
		
		delete_task_btn.disabled = true
		
		task_list.clear()
		
		task_timer.stop()

func _on_search_task_btn_pressed():
	var query = "{} = '{}'"
	var task_item = "{}: {}"
	var tdate = ""
	var tname = ""
	var result = ""
	
	if task_search_line.text == "" and search_status_list.get_selected() == 0:
		if Global.user == "admin":
			database.query("select * from {}".format([Global.tasks], "{}"))
		else:
			database.query("select * from {} where {} = '{}'".format([Global.tasks, Global.who_did, Global.user], "{}"))
		
		result = database.query_result
		
		for i in range(len(result)):
			tdate = result[i].get(Global.task_date).get_slice(" ", 0)
			tname = result[i].get(Global.task_name)
			task_list.add_item(task_item.format([tdate, tname], "{}"))
		
	elif task_search_line.text == "" and search_status_list.get_selected() != 0:
		if Global.user == "admin":
			result = database.select_rows(Global.tasks, query.format([Global.status, search_status_list.get_item_text(search_status_list.get_selected())], "{}"), ["*"])
		else:
			query = "{} = '{}' and {} = '{}'"
			result = database.select_rows(Global.tasks, query.format([Global.who_did, Global.user, Global.status, search_status_list.get_item_text(search_status_list.get_selected())], "{}"), ["*"])
		
		for i in range(len(result)):
			tdate = result[i].get(Global.task_date).get_slice(" ", 0)
			tname = result[i].get(Global.task_name)
			task_list.add_item(task_item.format([tdate, tname], "{}"))
		
	elif task_search_line.text != "" and search_status_list.get_selected() == 0:
		if Global.user == "admin":
			database.query("select * from {}".format([Global.tasks], "{}"))
		else:
			database.query("select * from {} where {} = '{}'".format([Global.tasks, Global.who_did, Global.user], "{}"))
		
		result = database.query_result
		
		for i in range(len(result)):
			if task_search_line.text in result[i].get(Global.task_date) or task_search_line.text == result[i].get(Global.task_name):
				tdate = result[i].get(Global.task_date).get_slice(" ", 0)
				tname = result[i].get(Global.task_name)
				task_list.add_item(task_item.format([tdate, tname], "{}"))
		
	elif task_search_line.text != "" and search_status_list.get_selected() != 0:
		if Global.user == "admin":
			result = database.select_rows(Global.tasks, query.format([Global.status, search_status_list.get_item_text(search_status_list.get_selected())], "{}"), ["*"])
		else:
			query = "{} = '{}' and {} = '{}'"
			result = database.select_rows(Global.tasks, query.format([Global.who_did, Global.user, Global.status, search_status_list.get_item_text(search_status_list.get_selected())], "{}"), ["*"])
		
		for i in range(len(result)):
			if task_search_line.text in result[i].get(Global.task_date) or task_search_line.text == result[i].get(Global.task_name):
				tdate = result[i].get(Global.task_date).get_slice(" ", 0)
				tname = result[i].get(Global.task_name)
				task_list.add_item(task_item.format([tdate, tname], "{}"))

func _on_clear_task_list_pressed():
	task_list.clear()
	
	task_date_label.visible = false
	task_date.visible = false
	task_date.text = ""
	task_name_label.visible = false
	task_name.visible = false
	task_name.text = ""
	task_text_label.visible = false
	task_text.visible = false
	task_text.text = ""
	task_spots_label.visible = false
	task_spots.visible = false
	task_spots.text = ""
	task_user_label.visible = false
	task_user.visible = false
	task_user.text = ""
	task_status_label.visible = false
	task_status.visible = false
	task_status.select(-1)
	edit_task_btn.visible = false
	save_task_btn.visible = false
	update_status_btn.visible = false

func _on_show_hide_2_pressed():
	if Global.show2 == false:
		Global.show2 = true
		add_user_password.secret = false
		show_hide.set_button_icon(ResourceLoader.load(icons_dir+"eye.png"))
	else:
		Global.show2 = false
		add_user_password.secret = true
		show_hide.set_button_icon(ResourceLoader.load(icons_dir+"eye_hide.png"))

func _on_delete_task_btn_pressed():
	popup_menu.visible = true
	
	delete_task_btn.disabled = true
	clear_task_list.disabled = true
	add_task_btn.disabled = true
	task_back_btn.disabled = true
	task_list.disabled = true
	task_search_line.editable = false
	search_status_list.disabled = true
	task_search_btn.disabled = true
	
	task_name.editable = false
	task_text.editable = false
	task_spots.editable = false
	task_user.editable = false
	task_status.disabled = true
	
	save_task_btn.disabled = true
	update_status_btn.disabled = true
	edit_task_btn.disabled = true

func _on_delete_no_btn_pressed():
	popup_menu.visible = false
	
	delete_task_btn.disabled = false
	clear_task_list.disabled = false
	add_task_btn.disabled = false
	task_back_btn.disabled = false
	task_list.disabled = false
	task_search_line.editable = true
	search_status_list.disabled = false
	task_search_btn.disabled = false
	
	task_name.editable = true
	task_text.editable = true
	task_spots.editable = true
	task_user.editable = true
	task_status.disabled = false
	
	save_task_btn.disabled = false
	update_status_btn.disabled = false
	edit_task_btn.disabled = false

func _on_delete_yes_btn_pressed():
	popup_menu.visible = false
	
	delete_task_btn.disabled = false
	clear_task_list.disabled = false
	add_task_btn.disabled = false
	task_back_btn.disabled = false
	task_list.disabled = false
	task_search_line.editable = true
	search_status_list.disabled = false
	task_search_btn.disabled = false
	
	task_name.editable = true
	task_text.editable = true
	task_spots.editable = true
	task_user.editable = true
	task_status.disabled = false
	
	save_task_btn.disabled = false
	update_status_btn.disabled = false
	edit_task_btn.disabled = false
	
	var query = "{} = '{}'"
	
	database.delete_rows(Global.tasks, query.format([Global.task_date, task_date.text], "{}"))
	
	data_saved_label.visible = false
	
	task_date_label.visible = false
	task_date.visible = false
	task_date.text = ""
	task_name_label.visible = false
	task_name.visible = false
	task_name.text = ""
	task_text_label.visible = false
	task_text.visible = false
	task_text.text = ""
	task_spots_label.visible = false
	task_spots.visible = false
	task_spots.text = ""
	task_user_label.visible = false
	task_user.visible = false
	task_user.text = ""
	task_status_label.visible = false
	task_status.visible = false
	task_status.select(-1)
	edit_task_btn.visible = false
	save_task_btn.visible = false
	update_status_btn.visible = false
	
	delete_task_btn.disabled = true
	
	task_list.clear()

func _on_delete_user_btn_pressed():
	if user_list.get_selected() != -1:
		delete_user_label.visible = true
		
		do_delete_btn.visible = true
		do_not_delete_btn.visible = true
		
		var btn_list = group.get_buttons()
		var count = settings_panel.get_child_count()
		
		for i in range(count):
			if settings_panel.get_child(i) in btn_list:
				settings_panel.get_child(i).disabled = true
		
		user_list.disabled = true
		delete_user.disabled = true
	else:
		select_user_label.visible = true
		
		timer.start()

func _on_do_delete_pressed():
	var user_to_delete = user_list.get_item_text(user_list.get_selected())
	
	database.delete_rows(Global.users, "{} = '{}'".format([Global.user_db, user_to_delete], "{}"))
	database.delete_rows(Global.tasks, "{} = '{}'".format([Global.who_did, user_to_delete], "{}"))
	
	delete_user_label.text = "Пользователь удалён"
	do_delete_btn.visible = false
	do_not_delete_btn.visible = false
	
	user_list.clear()
	
	timer_data.start()

func _on_do_not_delete_pressed():
	delete_user_label.visible = false
	
	do_delete_btn.visible = false
	do_not_delete_btn.visible = false
	
	var btn_list = group.get_buttons()
	var count = settings_panel.get_child_count()
	
	for i in range(count):
		if settings_panel.get_child(i) in btn_list:
			settings_panel.get_child(i).disabled = false
	
	user_list.disabled = false
	delete_user.disabled = false

func _on_change_pressed():
	if user_list.get_selected() != -1 and old_password_line.text.strip_edges() != "" and new_password_line.text.strip_edges() != "":
		var password1 = old_password_line.text.sha256_text()
		var password2 = new_password_line.text.sha256_text()
		
		if password1 != password2:
			password_changed.text = "Пароли должны совпадать"
			password_changed.visible = true
			
			timer.start()
		else:
			var query = "{} ='{}'"
			var data = database.select_rows(Global.users, query.format([Global.password, password1], "{}"),["*"])
			
			if data.is_empty() == false:
				password_changed.text = "Новый пароль не должен совпадать со старым"
				password_changed.visible = true
				
				timer.start()
			else:
				var new_password = {
					Global.user_db : user_list.get_item_text(user_list.get_selected()),
					Global.password : password1
				}
				
				database.delete_rows(Global.users, query.format([Global.user_db, user_list.get_item_text(user_list.get_selected())], "{}"))
				database.insert_row(Global.users, new_password)
				
				password_changed.visible = true
				
				timer.start()
	elif user_list.get_selected() == -1:
		select_user_change_password.text = "Выберите пользователя"
		select_user_change_password.visible = true
		
		timer.start()
	elif len(old_password_line.text) == 0 or len(new_password_line.text) == 0:
		select_user_change_password.text = "Заполните все поля"
		select_user_change_password.visible = true
		
		timer.start()
