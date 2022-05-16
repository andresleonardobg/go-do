extends GraphNode

onready var label = $VBoxContainer/HBoxContainer/Label

var parent_node : String 
var name_node : String

func _ready() -> void:
	add_to_group("nodetask")
	label.text = name_node

func _on_edit_pressed() -> void:
	print('Editar')

func _on_delete_pressed() -> void:
	queue_free()

func send_data() -> void:
	Global.data["nodes"].append({
		"position":var2str(Vector2(offset)),
		"name_task":name_node,
		"left":get("slot/0/left_enabled"),
		"right":get("slot/0/right_enabled"),
		"parent":parent_node,
		})
