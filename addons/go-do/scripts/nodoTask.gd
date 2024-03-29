tool
extends GraphNode

onready var title_node = get_node("VBoxContainer/HBoxContainer/title_node")
onready var warning_delete_childs = get_node("warning_delete_childs")
onready var panel_info = preload("res://addons/go-do/scenes/info_node.tscn")

var graph_edit : Node

var info_about_node : Dictionary 

#own signals
signal task_finished_state

#deafault functions
func _ready() -> void:
	set_finished_state_parent()
	set_info_about_node()
	add_groups()

#functions
func delete_node() -> void:
	if "parent_node" in info_about_node:
		get_parent().disconnect_node(info_about_node["parent_node"], 0, name, 0)
	queue_free()

func add_groups():

	add_to_group("all_nodes_task")
	add_to_group(info_about_node["parent_node"])
	add_to_group(self.name)

	#get node_parent's groups
	var nodes = get_tree().get_nodes_in_group("all_nodes_task")
	for n in nodes:
		if n.name == info_about_node["parent_node"]:
			var parents_groups = n.get_groups()
			for group in parents_groups:
				if group != "all_nodes_task" && group != info_about_node["parent_node"]:
					add_to_group(group)

func send_data() -> void:
	info_about_node["position"] = var2str(Vector2(rect_position))
	Global.data["nodes"].append(info_about_node)

func set_info_about_node() -> void:
	if "finished" in info_about_node:
		node_task_finished( info_about_node["finished"] )
	
	self.name = name + str(info_about_node["version"])
	
	title_node.text = info_about_node["name_task"]
	
	if typeof(info_about_node["position"]) == TYPE_STRING:
		offset = str2var(info_about_node["position"]) - (rect_size / 2)
	else:
		offset = info_about_node["position"]
	
	if "left" in info_about_node:
		set_slot_enabled_left(0, info_about_node["left"])
	else:
		info_about_node["left"] = true
		set_slot_enabled_left(0, info_about_node["left"])

func node_task_finished( state : bool ) -> void:
	
	info_about_node["finished"] = state
	
	if state == true:
		modulate = Color(0.0, 1.0, 0.0, 1.0)


func set_finished_state_parent() -> void:
	var nodes_on_grapht_edit = get_parent().get_children()
	var parent_node : Node
	
	if info_about_node["parent_node"] != "":
		for node in nodes_on_grapht_edit:
			if node.name == info_about_node["parent_node"]:
				parent_node = node
				parent_node.re_open()
	
	if parent_node != null:
		connect("task_finished_state", parent_node, "re_open")


func re_open() -> void:
	emit_signal("task_finished_state")
	modulate = Color(1.0, 1.0, 1.0, 1.0)
	info_about_node["finished"] = false

func change_name( new_name : String) -> void:
	info_about_node["name_task"] = new_name
	title_node.text = new_name

#signals
func _on_edit_pressed() -> void:
	var info_task  = panel_info.instance()
	info_task.node_task = self
	Global.mind_map_node.add_child(info_task)
	info_task.popup_centered()

func _on_delete_pressed() -> void:
	if get_tree().get_nodes_in_group(self.name).size() == 1:
		delete_node()
		print("nodo eliminado")
	else:
		warning_delete_childs.popup_centered()

func _on_warning_delete_childs_confirmed():
	delete_node()
	get_tree().call_group(self.name, "delete_node")
	print("nodo y nodos hijos eliminados")
