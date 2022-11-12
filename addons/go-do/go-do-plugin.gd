tool
extends EditorPlugin

const mindmap = preload("res://addons/go-do/scenes/mindMap.tscn")

var mind_map_instance

func _enter_tree():
	mind_map_instance = mindmap.instance()
	get_editor_interface().get_editor_viewport().add_child(mind_map_instance)
	make_visible(false)


func _exit_tree():
	if mind_map_instance:
		mind_map_instance.queue_free()


func has_main_screen():
	return true


func make_visible(visible):
	if mind_map_instance:
		mind_map_instance.visible = visible


func get_plugin_name():
	return "Go-Do"


func get_plugin_icon():
	return get_editor_interface().get_base_control().get_icon("Node", "EditorIcons")
