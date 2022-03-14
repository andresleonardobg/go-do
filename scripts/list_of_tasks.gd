extends Control

func _ready() -> void:
	var tree = Tree.new()
	var root = tree.create_item()
	root.set_text(0, "proyecto")
	tree.set_hide_root(true)
	var child1 = tree.create_item(root)
	child1.set_text(0,"hijo uno")
	var child2 = tree.create_item(root)
	child2.set_text(0,"hijo dos")
	var subchild1 = tree.create_item(child1)
	subchild1.set_text(0, "Subchild1")
