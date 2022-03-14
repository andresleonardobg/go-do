extends Node

#save data 
var data = {
	"nodes":[]
}

var path_data = "res://test.json"

var node = preload("res://scenes/nodoTask.tscn")

var window_new_task

func _ready() -> void:
	print(data)

func add_new_node(pos:String, name_n:String, parent, enable_slot_left:bool, enable_slot_right:bool, parent_node:String):
	
	var node_child = node.instance()
	node_child.set_offset(str2var(pos))
	node_child.rect_position = str2var(pos)
	node_child.name_task = name_n
	node_child.parent_node = parent_node
	node_child.set_slot_enabled_left(0, enable_slot_left)
	node_child.set_slot_enabled_right(0, enable_slot_right)
	print(node_child.offset,node_child.rect_position,node_child.name_task,node_child.parent_node)
	parent.add_child(node_child)

func save_data() -> void:
	var file = File.new()
	file.open(path_data, 2)
	file.store_line(to_json(data))
	file.close()

func load_data() -> void:
	var file = File.new()
	file.open(path_data, 1)
	var text = file.get_as_text()
	data = parse_json(text)
	file.close()
