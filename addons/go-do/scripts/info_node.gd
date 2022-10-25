tool
extends WindowDialog

onready var title := get_node("Label")
onready var description := get_node("TextEdit")
onready var box_comentary_child := get_node("box_commentary/VBoxContainer")
onready var window_new_comment := get_node("new_comment_window")
onready var get_new_comment := get_node("new_comment_window/VBoxContainer/TextEdit")
var theme_commentary := preload("res://addons/go-do/resources/main_theme.tres")

var data : Dictionary
var node_task_title :String

#tree
onready var treee = get_node("Tree")
var root
onready var name_new_item = get_node("HBoxContainer/name_new_item")
var list_of_items : Array
var info_item : Array


func _ready():
	treee.set_hide_root(false)
	root = treee.create_item()
	root.set_text(0, "Subtareas")
	
	if Global.data:
		title.text = node_task_title
		
		for n in Global.data["nodes"]:
			if n["name_task"] == node_task_title:
				description.text = n["description"]
				info_item = n["subtasks"]
		
		for info in info_item:
			create_new_item(info[0], info[1])


func _on_info_node_popup_hide():
	
	var description_content : String = description.text
	var all_nodes = get_tree().get_nodes_in_group("all_nodes_task")
	var info = get_info_form_items()
	
	for node in all_nodes:
		if node.name == node_task_title:
			node.description = description_content
			node.subtasks = info
	
	for n in Global.data["nodes"]:
		if n["name_task"] == node_task_title:
			n["description"] = description_content
			n["subtasks"] = info
	queue_free()

#functions
func create_new_item(name : String, checked : bool = false) -> void:
	
	var child = treee.create_item(root)
	child.set_cell_mode(0, 1)
	child.set_text(0, name)
	child.set_editable(0, true)
	list_of_items.push_back(child)
	
	if info_item.size() > 0:
		child.set_checked(0, checked)

func get_info_form_items() -> Array:
	var info : Array	
	for i in list_of_items:
		info.push_back([i.get_text(0), i.is_checked(0)])	
	return info

func new_commentary( text : String ) -> void:
	var new_commentary = Label.new()
	new_commentary.theme = theme_commentary
	new_commentary.autowrap = true
	new_commentary.rect_min_size = Vector2(530, 50)
	new_commentary.text = text
	box_comentary_child.add_child(new_commentary)

#signals
func _on_add_new_item_pressed():
	if name_new_item.text != "":
		create_new_item(name_new_item.text)
		name_new_item.text = ""

func _on_Tree_item_selected():
	var item = treee.get_selected()
	print(list_of_items[0].get_text(0), list_of_items[0].is_checked(0))


func _on_add_new_commentary_pressed():
	window_new_comment.popup_centered()


func _on_add_comment_pressed():
	new_commentary( get_new_comment.text )
	get_new_comment.text = ""
	window_new_comment.visible = false
