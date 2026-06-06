class_name MovableTextureRect
extends TextureRect

@export var is_fixed := false
var being_dragged := false
var mouse_offset := Vector2.ZERO

signal began_dragging
signal ended_dragging

func _process(_delta: float) -> void:
	if is_fixed:
		return
	if being_dragged:
		global_position = get_global_mouse_position() - mouse_offset

func _on_gui_input(event: InputEvent) -> void:
	if is_fixed:
		return
	if event is InputEventMouseButton:
		var mouse_event := event as InputEventMouseButton
		if mouse_event.button_index == MOUSE_BUTTON_LEFT:
			toggle_drag(mouse_event.pressed)
			get_viewport().set_input_as_handled()

func toggle_drag(toggle_on: bool) -> void:
	being_dragged = toggle_on
	#print(get_instance_id())
	#print(being_dragged)
	if being_dragged:
		mouse_offset = get_global_mouse_position() - global_position
		began_dragging.emit()
	else:
		ended_dragging.emit()
