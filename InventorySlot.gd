# InventorySlot.gd - Individual inventory slot
extends Control
class_name InventorySlot

@onready var background = $Background
@onready var item_icon = $ItemIcon
@onready var stack_label = $StackLabel

var item_data: ItemData
var stack_size: int = 0
var slot_index: int

signal slot_clicked(slot: InventorySlot)
signal item_dropped_on_slot(from_slot: InventorySlot, to_slot: InventorySlot)

func _ready():
	# Connect mouse events
	gui_input.connect(_on_gui_input)
	mouse_entered.connect(_on_mouse_entered)
	mouse_exited.connect(_on_mouse_exited)
	
	# Set up drag and drop
	set_drag_preview_visible(false)
	
	update_slot_display()

func _on_gui_input(event):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			slot_clicked.emit(self)

func _can_drop_data(position, data):
	return data is InventorySlot

func _drop_data(position, data):
	if data is InventorySlot:
		item_dropped_on_slot.emit(data, self)

func _get_drag_data(position):
	if item_data == null:
		return null
	
	# Create drag preview
	var preview = Control.new()
	var icon = TextureRect.new()
	icon.texture = item_data.icon
	icon.custom_minimum_size = Vector2(32, 32)
	preview.add_child(icon)
	set_drag_preview(preview)
	
	return self

func set_item(new_item_data: ItemData, amount: int = 1):
	item_data = new_item_data
	stack_size = amount
	update_slot_display()

func add_item(amount: int) -> int:
	if item_data == null:
		return amount
	
	var can_add = min(amount, item_data.max_stack_size - stack_size)
	stack_size += can_add
	update_slot_display()
	return amount - can_add

func remove_item(amount: int) -> int:
	var removed = min(amount, stack_size)
	stack_size -= removed
	
	if stack_size <= 0:
		clear_slot()
	else:
		update_slot_display()
	
	return removed

func clear_slot():
	item_data = null
	stack_size = 0
	update_slot_display()

func update_slot_display():
	if item_data == null:
		item_icon.texture = null
		stack_label.text = ""
		modulate = Color.WHITE
	else:
		item_icon.texture = item_data.icon
		if stack_size > 1:
			stack_label.text = str(stack_size)
		else:
			stack_label.text = ""
		modulate = Color.WHITE

func _on_mouse_entered():
	modulate = Color(1.2, 1.2, 1.2)

func _on_mouse_exited():
	modulate = Color.WHITE

func is_empty() -> bool:
	return item_data == null

func can_accept_item(new_item: ItemData) -> bool:
	if is_empty():
		return true
	return item_data.id == new_item.id and stack_size < item_data.max_stack_size
