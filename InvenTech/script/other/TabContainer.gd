extends TabContainer

@onready var object_cursor = get_node("/root/editor/editor_object")

func _on_mouse_entered():
	object_cursor.can_place = false
	object_cursor.hide()

func _on_mouse_exited():
	object_cursor.can_place = true
	object_cursor.show()
