extends Control

onready var tree_task = $PanelContainer/Tree

var items : Array

func _ready() -> void:
	pass
	
#signals
#func _on_createItem_pressed() -> void:
#	var item_selected = tree_task.get_selected()
#	var new_item = tree_task.create_item(item_selected)
#	new_item.set_text(0, 'item creado')

func _process(_delta: float) -> void:
	pass
	
#functions
func add_new_items( node_parent, name_item:String ) -> void:
	
	if node_parent == null:
		var item = tree_task.create_item()
		item.set_text(0, name_item)
		items.append(item)
	else:
		for item in items:
			if item.get_text(0) == node_parent:
				var new_item = tree_task.create_item(item)
				new_item.set_cell_mode(0, 1)
				new_item.set_editable(0, true)
				new_item.set_text( 0, name_item )
				items.append(new_item)
	


func select_item(t: String) -> void:
	if tree_task.get_root() != null:
		var child = tree_task.get_root().get_children()
		while child != null: 
			
			if child.get_text(0) == t:
				child.free()
			else:
				child = child.get_next()
			

func add_new_item(node_parent, name_new_item):
	for item in items:
		if item.get_text() == node_parent.name_task:
			var i = tree_task.create_item(item)
			i.set_text(name_new_item)
