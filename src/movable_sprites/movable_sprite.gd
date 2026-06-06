class_name MovableSprite
extends Sprite2D

var being_dragged := false

func _process(_delta: float) -> void:
	if being_dragged:
		global_position = get_global_mouse_position()

func _on_area_2d_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if event is InputEventMouseButton:
		var mouse_event := event as InputEventMouseButton
		if mouse_event.button_index == MOUSE_BUTTON_LEFT:
			being_dragged = mouse_event.pressed
