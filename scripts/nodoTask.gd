extends GraphNode

onready var label = $VBoxContainer/HBoxContainer/Label
var name_task
var parent_node : String

func _ready() -> void:
	add_to_group("nodetask")
	label.text = name_task
	
	Global.data["nodes"].append({
		"position":var2str(Vector2(offset)),
		"name_task":name_task,
		"left":get("slot/0/left_enabled"),
		"right":get("slot/0/right_enabled"),
		"parent":parent_node,
		})


func _on_edit_pressed() -> void:
	print('Editar')

func _on_delete_pressed() -> void:
	queue_free()
