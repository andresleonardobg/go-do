extends Control

#window new task
onready var window_new_task = $new_task
onready var text_task = $new_task/VBoxContainer/TextEdit
onready var file_window = $FileDialog

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

func _ready() -> void:
	
	file_window.add_filter("*.json ; JSON files")
	
	#load last file edited
	if Global.last_file != "":
		Global.load_data(Global.last_file)
		display_data()

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
	
	Global.add_new_node(position_new_node, text_task.text, panel_graph, true, true, node_parent)
	list_tasks.add_new_items(node_parent, text_task.text)
	var name_node = get_tree().get_nodes_in_group("all_nodes_task")
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


func send_data_to_save() -> void:
	Global.data = {
		"nodes":[]
		}
	
	Global.data["conections"] = panel_graph.get_connection_list()
	
	var nodetasks = get_tree().get_nodes_in_group("all_nodes_task")
	
	for n in nodetasks:
		n.send_data()


#signals
func _on_new_pressed() -> void:
	window_new_task.popup_centered()
	get_node("new_task/VBoxContainer/TextEdit").grab_focus()


func _on_save_pressed() -> void:
	if Global.last_file != "":
		send_data_to_save()
		Global.save_data(Global.last_file)
		print("guardado rapido")
	else:
		file_window.mode = FileDialog.MODE_SAVE_FILE
		file_window.popup_centered()


func _on_load_pressed() -> void:
	file_window.mode = FileDialog.MODE_OPEN_FILE
	file_window.popup_centered()


func _on_Accept_pressed() -> void:
	create_new_nodeTask()


func _on_GraphEdit_connection_to_empty(from: String, _from_slot: int, _release_position: Vector2) -> void:
	window_new_task.popup_centered()
	node_parent = panel_graph.get_node(from).name
	get_node("new_task/VBoxContainer/TextEdit").grab_focus()
	position_new_node = panel_graph.get_local_mouse_position() + panel_graph.scroll_offset
	connect_to = from


func _on_save_as_pressed() -> void:
	file_window.mode = FileDialog.MODE_SAVE_FILE
	file_window.popup_centered()


func _on_screenshot_pressed() -> void:
	var img = panel_graph.get_viewport().get_texture().get_data()
	img.flip_y()
	img.save_png("mindmap.png")


func _on_FileDialog_confirmed() -> void:
	if file_window.mode == 4:
		send_data_to_save()
		Global.save_data(file_window.current_file)
		print("guardar como")
	elif file_window.mode == 0:
		Global.save_data_log(file_window.current_file)
		Global.load_data(file_window.current_file)
		display_data()
		print("data cargada")


func _on_delete_all_nodes_pressed() -> void:
	var nodes_task = get_tree().get_nodes_in_group("all_nodes_task")
	list_tasks.delete_all_items()
	for node in nodes_task:
		node.delete_node()
