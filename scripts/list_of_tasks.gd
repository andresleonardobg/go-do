extends Control

onready var tree_task = $PanelContainer/Tree

var items : Array

var tree

#default functions
func _physics_process(delta: float) -> void:
	if Global.delete_task[0]:
		delete_items(Global.delete_task[1])


#functions
func add_new_items( node_parent : String, name_item : String ) -> void:

	if node_parent.length() > 0:
		tree = node_parent.split("-", true)
	
	if node_parent == "":
		var item = tree_task.create_item()
		item.set_text(0, name_item)
		items.append(item)
	else:
		for item in items:
			if tree.size() < 2:
				if item.get_text(0) == node_parent:
					create_new_item(item, name_item)
			else:
				if item.get_text(0) == tree[-1] and item.get_parent().get_text(0) == tree[-2]:
					create_new_item(item, name_item)
	


func create_new_item(item_parent, name_item) -> void:
	var new_item = tree_task.create_item(item_parent)
	new_item.set_cell_mode(0, 1)
	new_item.set_editable(0, true)
	new_item.set_text( 0, name_item )
	items.append(new_item)

func delete_items(node_task : String ) -> void:
	var content = node_task.split("-", true)
	print(content)
	
	if content.size() > 1:
		for item in items:
			if item.get_parent():
				
				var parent_item = item.get_parent()
				var grandparent_item
				
				if parent_item.get_parent():
					grandparent_item = parent_item.get_parent()
					if item.get_text(0) == content[-1] and parent_item.get_text(0) == content[-2] and grandparent_item.get_text(0) == content[-3]:
						print("tenia abuelo " + item.get_text(0))
						parent_item.remove_child(item)
				else:
					if item.get_text(0) == content[-1] and parent_item.get_text(0) == content[-2]:
						print("solo tenia padre "  + item.get_text(0))
						parent_item.remove_child(item)
	
	Global.delete_task = [false, ""]

func has_parent(item):
	
	pass
