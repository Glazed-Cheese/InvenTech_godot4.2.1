extends TextureRect

@export var this_scene : PackedScene
@onready var object_cursor = get_node("/root/editor/editor_object")

@onready var cursor_sprite = object_cursor.get_node("Sprite2D")
# Called when the node enters the scene tree for the first time.
func _ready():
	connect("gui_input", Callable(self, "item_clicked"))

func item_clicked(event):
	if event is InputEvent:
		if event.is_action_pressed("mb_left"):
			object_cursor.current_item = this_scene
			cursor_sprite.texture = texture
	pass
