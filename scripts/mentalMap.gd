extends Control

#window new task
onready var window_new_task = $new_task
onready var text_task = $new_task/VBoxContainer/TextEdit

#propieties new node
var position_new_node
var node_parent = ""

#panel graph edit
onready var panel_graph = $PanelContainer/GraphEdit

#load node
const node_task = preload("res://scenes/nodoTask.tscn")

var center_window = OS.window_size / 2

func _ready() -> void:
	Global.window_new_task = window_new_task

func _process(_delta: float) -> void:
	if panel_graph.get_child_count() < 3:
		$menu/new.disabled = false
	else:
		$menu/new.disabled = true

func _on_new_pressed() -> void:
	window_new_task.popup()
	window_new_task.rect_position = center_window - Vector2(150, 40)

func _on_GraphEdit_node_selected(node: Node) -> void:
	print(node)

func _on_Accept_pressed() -> void:
	if panel_graph.get_child_count() == 2:
		Global.add_new_node(var2str(center_window - Vector2(100, 40)), text_task.text, panel_graph, true, true, node_parent)
	else:
		connection_nodes_right()
	
	text_task.text = ""
	window_new_task.visible = false

func connection_nodes_right() -> void:
	
	Global.add_new_node(var2str(position_new_node), text_task.text, panel_graph, true, true, node_parent)
	#print(name_node[-1].name_task)
	var name_node = get_tree().get_nodes_in_group("nodetask")
	panel_graph.connect_node(node_parent, 0, name_node[-1].name, 0)
	

func _on_GraphEdit_connection_to_empty(from: String, _from_slot: int, release_position: Vector2) -> void:
	window_new_task.popup()
	position_new_node = release_position
	node_parent = from
	window_new_task.rect_position = release_position - Vector2(150, -40)


func _on_save_pressed() -> void:
	Global.data["conections"] = panel_graph.get_connection_list()
	Global.save_data()

func load_data_connections() -> void:
	Global.load_data()
	


func _on_load_pressed() -> void:
	Global.load_data()
	
	
	for i in Global.data["nodes"]:
		
		Global.add_new_node(
			i["position"],
			i["name_task"],
			get_node("PanelContainer/GraphEdit"),
			i["left"],
			i["right"],
			i["parent"]
			)
#
#	if count == 3:
#		print("Creando conexiones")
#		for c in Global.data["conections"]:
#			panle_graph.connect_node(c["from"],c["from_port"],c["to"],c["to_port"])
