tool
extends Node

var directory = Directory.new()
var can_display_data = false

#save data 
var data : Dictionary

var data_log = "res://files_loaded.log"
var last_file = ""
var current_path_data : String
var task_node = preload("res://addons/go-do/scenes/nodoTask.tscn")

var mind_map_node : Node

var count := 0

#default functions
func _ready() -> void:

	if directory.file_exists(data_log):
		load_data_log()
	
	if directory.file_exists(last_file):
		can_display_data = true
		load_data(last_file)


func add_new_node( node_task_data : Dictionary, graph_panel : Node ):
	
	var new_node_task = task_node.instance()
	new_node_task.info_about_node = node_task_data

	if !node_task_data.has("version"):
		print("no tiene una versión")
		new_node_task.info_about_node["version"] = count

	graph_panel.add_child(new_node_task)

	count += 1


func save_data(path_data : String) -> void:
	var file = File.new()
	file.open(path_data, 2)
	file.store_line(to_json(data))
	file.close()


func load_data(path_data : String) -> void:
	var file = File.new()
	file.open(path_data, 1)
	var text = file.get_as_text()
	data = parse_json(text)
	file.close()

#data log
func save_data_log(path_file) -> void:
	var file = File.new()
	file.open(data_log, 2)
	file.store_string(path_file)
	file.close()


func load_data_log() -> void:
	var file = File.new()
	file.open(data_log, 1)
	last_file = file.get_as_text()
	file.close()
