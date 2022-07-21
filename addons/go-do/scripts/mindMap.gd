extends Control

const node = preload("res://addons/go-do/scenes/GraphNode.tscn")
onready var graph_edit = get_node("Panel/GraphEdit")

#own functions
func add_node() -> void:
	var node_child = node.instance()
	graph_edit.add_child(node_child)

#signals
func _on_Button_pressed() -> void:
	add_node()
