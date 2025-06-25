extends Node

var playing = false
var view = false
var show = false
var show2 = false
var stop = false
var start = false
var is_there_info = false
var search = true

var last_set_btn = 0

var item_index = 0

var i = 0
var info_count = 0
var wait_time : float = 0.0
var info_arr = []

var not_added_info = []

var data_counter = 0
var counter = 0

var current_floor = 0
var current_button = ""

var step = 0.0

var pressed_btn = ""

var new_btn_name = "new_btn"
var floor_to_select = 0

var branch = "floorsb"
var office = "office_b"

var office_info = "office_b"

var office_m1 = "office_b"
var office_m2 = "office_b"

var last_btn = "none"
var last_btn_color = 0

var floors = 0

var user = ""
var right_btn = ""

var branches = "branches"
var users = "users"
var tasks = "tasks"
var task_date = "Дата"
var task_name = "Название"
var task_text = "Текст"
var status = "Статус"
var who_did = "Пользователь"
var task_spots = "Места"

var status_list = ["выполнено", "в процессе"]

var letters = ["A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z", "a", "b", "c", "d", "r", "f", "g", "h", "i", "j", "k", "l", "m", "n", "o", "p", "q", "r", "s", "t", "u", "v", "w", "x", "y", "z"]
var numbers = ["1", "2", "3", "4", "5", "6", "7", "8", "9", "0"]
var symbols = ["#", "/", " ", ".", "_", "-", "(", ")"]

var file = "file"
var user_db = "login"
var address = "address"
var password = "password"
var model = "Модель"
var model_mon = "Модель_монитора"
var button = "Кнопка"
var floor = "Этаж"
var cabinet = "Кабинет"
var spot = "Место"
var number = "Серийный_номер"
var pc_name = "Имя_ПК"
var number_mon = "Серийный_номер_монитора"

var empty_spot = ""
var empty_cab = ""
