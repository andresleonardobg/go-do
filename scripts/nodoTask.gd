extends GraphNode

onready var label = $VBoxContainer/HBoxContainer/Label
onready var warning = get_node("ConfirmationDialog")


var parent_node : String 
var name_node : String
var parents : Array

func _ready() -> void:
	add_to_group(name_node)
	
	parents = parent_node.split("-", true)
	
	for parent in parents:
		if parent != "":
			add_to_group(parent)
	
	label.text = name_node

#functions
func delete_node() -> void:
	get_parent().disconnect_node(parent_node, 0, name, 0)
	queue_free()

func delete_node_with_item() -> void:
	get_parent().disconnect_node(parent_node, 0, name, 0)
	queue_free()
	Global.delete_task = [true, name]

#signals
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


func _on_nodoTask_close_request() -> void:
	if get_tree().get_nodes_in_group(name_node).size() == 1:
		delete_node_with_item()
	else:
		warning.popup_centered()


func _on_ConfirmationDialog_confirmed() -> void:
	delete_node_with_item()
	get_tree().call_group(name_node, "delete_node")
	print("nodos hijos eliminados")
