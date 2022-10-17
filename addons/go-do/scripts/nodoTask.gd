tool
extends GraphNode

onready var label = $VBoxContainer/HBoxContainer/Label
onready var warning = get_node("ConfirmationDialog")
onready var info_node = preload("res://addons/go-do/scenes/info_node.tscn")

var principal_node : Node

var parent_node : String 
var name_node : String
var version : int
var description : String
var subtasks : Array

#deafault functions
func _ready() -> void:
	add_groups()
	label.text = name_node

#functions
func delete_node() -> void:
	if parent_node:
		get_parent().disconnect_node(parent_node, 0, name, 0)
	queue_free()

func delete_node_with_item() -> void:
	if parent_node:
		get_parent().disconnect_node(parent_node, 0, name, 0)
	queue_free()
	Global.delete_task = [true, name]

func add_groups():

	add_to_group("all_nodes_task")
	add_to_group(self.name)

	#get node parent
	var parentNode : Node
	var nodes = get_tree().get_nodes_in_group("all_nodes_task")
	for n in nodes:
		if n.name == parent_node:
			parentNode = n


	if parentNode != null:
		var parents_groups = parentNode.get_groups()
		for group in parents_groups:
			if group != "all_nodes_task":
				add_to_group(group)

#signals
func _on_edit_pressed() -> void:
	
	var info  = info_node.instance()
	info.node_task_title = self.name
	principal_node.add_child(info)
	info.popup_centered()

func _on_delete_pressed() -> void:
	if get_tree().get_nodes_in_group(self.name).size() == 1:
		delete_node_with_item()
		print("nodo y item eliminado")
	else:
		warning.popup_centered()

func send_data() -> void:
	#check if global.data has data
	Global.data["nodes"].append({
		"position":var2str(Vector2(offset)),
		"name_task":name_node,
		"left":get("slot/0/left_enabled"),
		"parent":parent_node,
		"description" : description,
		"subtasks" : subtasks
		})
	#if not verified data 

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
