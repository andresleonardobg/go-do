tool
extends GraphNode

onready var title_node = get_node("VBoxContainer/HBoxContainer/title_node")
onready var warning_delete_childs = get_node("warning_delete_childs")
onready var panel_info = preload("res://addons/go-do/scenes/info_node.tscn")

var graph_edit : Node

#main data to save
var parent_node : String 
var name_node : String
var version : int
var description : String
var subtasks : Array
var comments : Array

#info about the task node
var info_about_node : Dictionary 

#deafault functions
func _ready() -> void:
	
	self.name = info_about_node["name_task"]
	
#	if info_about_node["version"] != 0:
#		self.name = info_about_node["name_task"] + var2str(info_about_node["version"])
#	else:
#		self.name = info_about_node["name_task"]
	
	title_node.text = info_about_node["name_task"]
	
	if typeof(info_about_node["position"]) == TYPE_STRING:
		var position_node_task = str2var("Vector2" + info_about_node["position"])
		print(typeof(position_node_task))
		#offset = Vector2(str2var(info_about_node["position"]))   - (rect_size / 2)
	else:
		offset = info_about_node["position"]
	
	if "left" in info_about_node.values():
		set_slot_enabled_left(0, info_about_node["left"])
	else:
		info_about_node["left"] = true
		set_slot_enabled_left(0, info_about_node["left"])
	
	add_groups()
	
	print(name)
	print(info_about_node)
	print("\n")

#functions
func delete_node() -> void:
	if parent_node:
		get_parent().disconnect_node(parent_node, 0, name, 0)
	queue_free()

func add_groups():

	add_to_group("all_nodes_task")
	add_to_group(parent_node)
	add_to_group(self.name)

	#get node parent
	var parentNode : Node
	var nodes = get_tree().get_nodes_in_group("all_nodes_task")
	for n in nodes:
		if n.name == parent_node:
			var parents_groups = n.get_groups()
			for group in parents_groups:
				if group != "all_nodes_task" && group != parent_node:
					add_to_group(group)

func send_data() -> void:
	#check if global.data has data
#	Global.data["nodes"].append({
#		"position":var2str(Vector2(offset)),
#		"name_task":name_node,
#		"left":get("slot/0/left_enabled"),
#		"parent_node":parent_node,
#		"description" : description,
#		"subtasks" : subtasks,
#	}
	
	Global.data["nodes"].append(info_about_node)

#signals
func _on_edit_pressed() -> void:	
	var info_task  = panel_info.instance()
	info_task.node_task_title = self.name
	graph_edit.add_child(info_task)
	info_task.popup_centered()

func _on_delete_pressed() -> void:
	if get_tree().get_nodes_in_group(self.name).size() == 1:
		delete_node()
		print("nodo y item eliminado")
	else:
		warning_delete_childs.popup_centered()

func _on_warning_delete_childs_confirmed():
	delete_node()
	get_tree().call_group(self.name, "delete_node")
	print("nodo y nodos hijos eliminados")
