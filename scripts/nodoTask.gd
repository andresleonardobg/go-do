extends GraphNode

onready var label = $VBoxContainer/HBoxContainer/Label
onready var warning = get_node("ConfirmationDialog")


var parent_node : Node 
var name_node : String
var family : Array
var version : int

func _ready() -> void:

	add_groups()
	
	label.text = name_node

#functions
func delete_node() -> void:
	if parent_node:
		get_parent().disconnect_node(parent_node.name, 0, name, 0)
	queue_free()

func delete_node_with_item() -> void:
	# get_parent().disconnect_node(parent_node.name, 0, name, 0)
	# queue_free()
	# Global.delete_task = [true, name]
	pass

func add_groups():

	add_to_group("all_nodes_task")
	add_to_group(self.name)

	if parent_node != null:

		var parents_groups = parent_node.get_groups()

		for group in parents_groups:
			if group != "all_nodes_task":
				add_to_group(group)

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
		"parent":parent_node,
		})

func _on_nodoTask_close_request() -> void:
	if get_tree().get_nodes_in_group(self.name).size() == 1:
		delete_node_with_item()
		print("nodo y item eliminado")
	else:
		warning.popup_centered()


func _on_ConfirmationDialog_confirmed() -> void:
	delete_node_with_item()
	get_tree().call_group(self.name, "delete_node")
	print("nodos hijos eliminados")
