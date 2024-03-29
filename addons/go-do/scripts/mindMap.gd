tool
extends Control

#window new task
onready var window_new_task := get_node("new_task")
onready var window_text_task := get_node("new_task/VBoxContainer/window_text_task")
onready var file_window := get_node("FileDialog")
#nodes containers
onready var panel_graph := get_node("GraphEdit")
#buttons
onready var new_proyect_button := get_node("menu/new")

#conection
var connect_to :String

#propieties new node
var position_new_node : Vector2
var node_parent : String

#load node
const node_task := preload("res://addons/go-do/scenes/nodoTask.tscn")

func _ready() -> void:
	Global.mind_map_node = self
	file_window.add_filter("*.json ; JSON files")


func _process(_delta: float) -> void:
	if panel_graph:
		if panel_graph.get_child_count() < 3:
			new_proyect_button.disabled = false
		else:
			new_proyect_button.disabled = true


func _input(event: InputEvent) -> void:

	if window_new_task:
		if window_new_task.visible && window_text_task.text != "":
			if Input.is_key_pressed(KEY_ENTER):
				create_new_nodeTask()

#functions
func display_data() -> void:

	for i in Global.data["nodes"]:
		Global.add_new_node( i, panel_graph )
	
	for c in Global.data["conections"]:
		panel_graph.connect_node(c["from"],c["from_port"],c["to"],c["to_port"])

	if "data" in Global.data:
		Global.count = Global.data["data"]

	Global.data = {}

func create_new_nodeTask() -> void:
	print(get_tree().get_nodes_in_group("all_nodes_task").size())
	
	var data : Dictionary
	
	if panel_graph.get_child_count() == 2:
		data = {
			"name_task" : window_text_task.text,
			"parent_node" : node_parent,
			"position" : Vector2( 0.0, 0.0 ) - Vector2( 100.0, 42.5 ),
			"finished" : false
		}
		
		Global.add_new_node( data, panel_graph )
	else:
		data = {
			"name_task": window_text_task.text,
			"parent_node": node_parent,
			"position": position_new_node,
			"finished" : false
		}
		
		Global.add_new_node( data, panel_graph )
		var name_node = get_tree().get_nodes_in_group("all_nodes_task")
		panel_graph.connect_node(connect_to, 0, name_node[-1].name, 0)
	
	window_text_task.text = ""
	window_new_task.visible = false


func send_data_to_save() -> void:
	Global.data = {
		"count" : Global.count,
		"nodes":[]
		}
	
	Global.data["conections"] = panel_graph.get_connection_list()
	
	var nodetasks = get_tree().get_nodes_in_group("all_nodes_task")
	
	for n in nodetasks:
		n.send_data()


#signals
func _on_new_pressed() -> void:
	window_new_task.popup_centered()
	window_text_task.grab_focus()


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
	window_text_task.grab_focus()
	position_new_node = panel_graph.get_local_mouse_position() + panel_graph.scroll_offset
	connect_to = from


func _on_save_as_pressed() -> void:
	file_window.mode = FileDialog.MODE_SAVE_FILE
	file_window.popup_centered()


func _on_FileDialog_confirmed() -> void:
	if file_window.mode == 4:
		send_data_to_save()
		Global.save_data(file_window.current_file)
		print("guardar como")
	elif file_window.mode == 0:
		Global.save_data_log(file_window.current_file)
		Global.load_data(file_window.current_file)
		display_data()
		print("data loaded")


func _on_delete_all_nodes_pressed() -> void:
	var nodes_task = get_tree().get_nodes_in_group("all_nodes_task")
	Global.count = 0
	for node in nodes_task:
		node.delete_node()
