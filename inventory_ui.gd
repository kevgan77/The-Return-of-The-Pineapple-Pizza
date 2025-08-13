# InventoryUI.gd - Main inventory interface
extends Control
class_name InventoryUI

@export var slot_scene: PackedScene  # Assign InventorySlot.tscn
@export var grid_container: GridContainer

var inventory_slots: Array[InventorySlot] = []
var inventory_size: int = 36  # 9x4 like Minecraft

signal inventory_updated

func _ready():
	setup_inventory_grid()

func setup_inventory_grid():
	# Create inventory slots
	for i in range(inventory_size):
		var slot = create_inventory_slot(i)
		inventory_slots.append(slot)
		grid_container.add_child(slot)

func create_inventory_slot(index: int) -> InventorySlot:
	var slot: InventorySlot
	
	if slot_scene:
		slot = slot_scene.instantiate()
	else:
		# Create slot programmatically if no scene assigned
		slot = InventorySlot.new()
		slot.custom_minimum_size = Vector2(48, 48)
		
		# Create child nodes
		var bg = NinePatchRect.new()
		bg.name = "Background"
		bg.anchors_preset = Control.PRESET_FULL_RECT
		slot.add_child(bg)
		
		var icon = TextureRect.new()
		icon.name = "ItemIcon"
		icon.anchors_preset = Control.PRESET_FULL_RECT
		icon.expand_mode = TextureRect.EXPAND_FIT_WIDTH_PROPORTIONAL
		slot.add_child(icon)
		
		var label = Label.new()
		label.name = "StackLabel"
		label.anchors_preset = Control.PRESET_BOTTOM_RIGHT
		label.add_theme_font_size_override("font_size", 12)
		label.add_theme_color_override("font_color", Color.WHITE)
		label.add_theme_color_override("font_shadow_color", Color.BLACK)
		slot.add_child(label)
	
	slot.slot_index = index
	slot.slot_clicked.connect(_on_slot_clicked)
	slot.item_dropped_on_slot.connect(_on_item_dropped)
	
	return slot

func _on_slot_clicked(slot: InventorySlot):
	print("Clicked slot ", slot.slot_index)
	if slot.item_data:
		print("Contains: ", slot.item_data.name, " x", slot.stack_size)

func _on_item_dropped(from_slot: InventorySlot, to_slot: InventorySlot):
	# Handle item swapping/moving
	if to_slot.is_empty():
		# Move item to empty slot
		to_slot.set_item(from_slot.item_data, from_slot.stack_size)
		from_slot.clear_slot()
	elif to_slot.can_accept_item(from_slot.item_data):
		# Stack items
		var remaining = to_slot.add_item(from_slot.stack_size)
		if remaining > 0:
			from_slot.stack_size = remaining
			from_slot.update_slot_display()
		else:
			from_slot.clear_slot()
	else:
		# Swap items
		var temp_item = to_slot.item_data
		var temp_stack = to_slot.stack_size
		
		to_slot.set_item(from_slot.item_data, from_slot.stack_size)
		from_slot.set_item(temp_item, temp_stack)
	
	inventory_updated.emit()

func add_item(item: ItemData, amount: int = 1) -> int:
	var remaining = amount
	
	# First, try to stack with existing items
	for slot in inventory_slots:
		if slot.item_data != null and slot.item_data.id == item.id:
			remaining = slot.add_item(remaining)
			if remaining <= 0:
				break
	
	# Then, try to add to empty slots
	if remaining > 0:
		for slot in inventory_slots:
			if slot.is_empty():
				var can_add = min(remaining, item.max_stack_size)
				slot.set_item(item, can_add)
				remaining -= can_add
				if remaining <= 0:
					break
	
	inventory_updated.emit()
	return remaining

func remove_item(item_id: String, amount: int) -> int:
	var remaining = amount
	
	for slot in inventory_slots:
		if slot.item_data != null and slot.item_data.id == item_id:
			var removed = slot.remove_item(remaining)
			remaining -= removed
			if remaining <= 0:
				break
	
	inventory_updated.emit()
	return amount - remaining

func get_item_count(item_id: String) -> int:
	var total = 0
	for slot in inventory_slots:
		if slot.item_data != null and slot.item_data.id == item_id:
			total += slot.stack_size
	return total

func has_space_for_item(item: ItemData, amount: int) -> bool:
	var space_needed = amount
	
	# Check existing stacks
	for slot in inventory_slots:
		if slot.item_data != null and slot.item_data.id == item.id:
			var can_stack = item.max_stack_size - slot.stack_size
			space_needed -= can_stack
			if space_needed <= 0:
				return true
	
	# Check empty slots
	var empty_slots = 0
	for slot in inventory_slots:
		if slot.is_empty():
			empty_slots += 1
	
	var slots_needed = ceil(float(space_needed) / float(item.max_stack_size))
	return empty_slots >= slots_needed
