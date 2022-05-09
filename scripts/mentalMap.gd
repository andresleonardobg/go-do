extends Control

#window new task
onready var window_new_task = $new_task
onready var text_task = $new_task/VBoxContainer/TextEdit

#nodes containers
onready var panel_graph = $HSplitContainer/PanelContainer/GraphEdit
onready var list_tasks = $HSplitContainer/list_of_tasks

#buttons
onready var new_proyect = $menu/new

#conection
var connect_to

#propieties new node
var position_new_node
var node_parent = ""

#load node
const node_task = preload("res://scenes/nodoTask.tscn")

var center_window = OS.window_size / 2

func _process(_delta: float) -> void:
	if panel_graph.get_child_count() < 3:
		new_proyect.disabled = false
	else:
		new_proyect.disabled = true

func _input(_event: InputEvent) -> void:
	if window_new_task.visible && text_task.text != "":
		if Input.is_action_just_pressed("ui_accept"):
			create_new_nodeTask()


#functions
func connection_nodes_right() -> void:
	
	Global.add_new_node(position_new_node, text_task.text, panel_graph, true, true, node_parent.name)
	list_tasks.add_new_items(node_parent.name, text_task.text )
	var name_node = get_tree().get_nodes_in_group("nodetask")
	panel_graph.connect_node(connect_to, 0, name_node[-1].name, 0)


func display_data() -> void:
	
	for i in Global.data["nodes"]:
		
		Global.add_new_node(
			str2var(i["position"]),
			i["name_task"],
			panel_graph,
			i["left"],
			i["right"],
			i["parent"]
			)
			
		list_tasks.add_new_items(i["parent"], i["name_task"] )
	
	for c in Global.data["conections"]:
		panel_graph.connect_node(c["from"],c["from_port"],c["to"],c["to_port"])
		
	Global.data = {
		"nodes":[]
		}


func create_new_nodeTask() -> void:
	if panel_graph.get_child_count() == 2:
		Global.add_new_node(
			Vector2(50, 200),
			text_task.text,
			panel_graph,
			false,
			true,
			node_parent
			)

		list_tasks.add_new_items("", text_task.text )
	else:
		connection_nodes_right()
	
	text_task.text = ""
	window_new_task.visible = false


#signals
func _on_new_pressed() -> void:
	window_new_task.popup()
	get_node("new_task/VBoxContainer/TextEdit").grab_focus()
	window_new_task.rect_position = center_window - Vector2(150, 40)


func _on_save_pressed() -> void:
	#save connections nodes
	Global.data["conections"] = panel_graph.get_connection_list()
	
	var nodetasks = get_tree().get_nodes_in_group("nodetask")
	
	for n in nodetasks:
		n.send_data()
	
	Global.save_data()


func _on_load_pressed() -> void:
	
	Global.load_data()
	display_data()


func _on_Accept_pressed() -> void:
	
	create_new_nodeTask()


func _on_GraphEdit_node_selected(node: Node) -> void:
	if node:
		node_parent = node


func _on_GraphEdit_connection_to_empty(from: String, _from_slot: int, _release_position: Vector2) -> void:
	window_new_task.popup()
	get_node("new_task/VBoxContainer/TextEdit").grab_focus()
	position_new_node = panel_graph.get_local_mouse_position() + panel_graph.scroll_offset
	connect_to = from
