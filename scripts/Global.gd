extends Node

#save data 
var data = {
	"nodes":[],
	"current_path_data" : ""
}

var local_path_data = "res://test.json"
var data_log = "res://files_loaded.log"
var last_file = ""
var current_path_data : String

var delete_task = [false, ""]

var node = preload("res://scenes/nodoTask.tscn")

#default functions
func _ready() -> void:
	
	var directory = Directory.new();
	var doFileExists = directory.file_exists(data_log)
	
	if doFileExists:
		load_data_log()


#functions created
func add_new_node(pos:Vector2, name_n:String, graphEdit, enable_slot_left:bool, enable_slot_right:bool, parent_node:String):
	
	var node_child = node.instance()
	node_child.name_node = name_n
	
	if parent_node != "":
		node_child.name = parent_node + "-" + name_n
	else:
		node_child.name = name_n
	
	node_child.parent_node = parent_node
	node_child.set_slot_enabled_left(0, enable_slot_left)
	node_child.set_slot_enabled_right(0, enable_slot_right)
	graphEdit.add_child(node_child)
	node_child.offset = pos - Vector2(0, 40)


func save_data(path_data : String) -> void:
	var file = File.new()
	file.open(path_data + ".json", 2)
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
