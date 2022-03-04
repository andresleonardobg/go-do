extends GraphNode

onready var label = $VBoxContainer/HBoxContainer/Label
var name_task
var parent_node

func _ready() -> void:
	add_to_group("nodes")
	label.text = name_task
	
	Global.data["nodes"][name] = {
		'position_node': var2str(Vector2(offset)),
		'title_node': name_task,
		'left_slot': get("slot/0/left_enabled"),
		'right_slot': get("slot/0/right_enabled"),
		'parent': parent_node}
	
	print(Global.data)
	
	

func _on_edit_pressed() -> void:
	print('Editar')

func _on_delete_pressed() -> void:
	queue_free()
