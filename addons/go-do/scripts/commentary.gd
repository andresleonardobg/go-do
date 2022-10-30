tool
extends Control

var text_commentary : String
var panel_info : Node
onready var text_container := get_node("PanelContainer/VBoxContainer/Label")

func _ready() -> void:
	text_container.text = text_commentary


func _on_Button_pressed() -> void:
	var index = panel_info.comments.find(text_container.text)
	panel_info.comments.remove(index)
	queue_free()
