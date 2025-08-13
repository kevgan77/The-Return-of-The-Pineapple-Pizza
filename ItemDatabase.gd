
extends Node

var items: Dictionary = {}

func _ready():
	load_items()

func load_items():
	
	create_item("pizza", "Pizza", "Delicious pizza slice", "res://icons/pizza.png", 16)
	create_item("sword", "Iron Sword", "A sturdy iron sword", "res://icons/sword.png", 1, false)
	create_item("wood", "Wood", "Basic building material", "res://icons/wood.png", 64)

func create_item(id: String, name: String, desc: String, icon_path: String, max_stack: int, stackable: bool = true):
	var item_data = ItemData.new()
	item_data.id = id
	item_data.name = name
	item_data.description = desc
	item_data.icon = load(icon_path)
	item_data.max_stack_size = max_stack
	item_data.is_stackable = stackable
	
	items[id] = item_data

func get_item(id: String) -> ItemData:
	return items.get(id)
