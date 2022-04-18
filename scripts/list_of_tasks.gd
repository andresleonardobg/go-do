extends Control

onready var tree_task = $PanelContainer/Tree

var items : Array

signal know_item(item)

func _ready() -> void:
	pass
	
#signals
#func _on_createItem_pressed() -> void:
#	var item_selected = tree_task.get_selected()
#	var new_item = tree_task.create_item(item_selected)
#	new_item.set_text(0, 'item creado')

func _process(delta: float) -> void:
	if tree_task.get_root() != null:
		var child = tree_task.get_root().get_children()
		while child != null:
				# put code here
			print(child)
			child = child.get_next()
	
#functions
func add_new_items( n:String ) -> void:
	
	if tree_task.get_selected():
		var item = tree_task.create_item(tree_task.get_selected())
		item.set_text(0, n)
	else:
		var item = tree_task.create_item()
		item.set_text(0, n)
		items.append(item)
