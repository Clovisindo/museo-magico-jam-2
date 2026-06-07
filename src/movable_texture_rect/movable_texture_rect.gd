class_name MovableTextureRect
extends TextureRect

@export var is_fixed := false
var being_dragged := false
var being_rotated := false
var being_scaled := false
var being_fliped_h := false
var being_fliped_v := false
var mouse_offset := Vector2.ZERO

signal began_dragging
signal ended_dragging


func init() -> void:
	set_deferred("size",Vector2i(texture.get_size().x,texture.get_size().y) ) 
	set_deferred("pivot_offset", Vector2i(texture.get_size().x/2, texture.get_size().y / 2))

var scale_time = 0.0
func _process(delta: float) -> void:
	if is_fixed:
		return
	if being_dragged:
		global_position = get_global_mouse_position() - mouse_offset
	if being_rotated:
		rotation = lerp_angle(rotation, (get_global_mouse_position() - global_position).angle() + deg_to_rad(90), 2.5 * delta)
	if being_scaled:
		scale_time += delta
		var period = 2.0
		scale = Vector2.ONE * 3.0 * (0.1 + abs(scale_time / period - floor(scale_time / period + 0.5)))
	else:
		scale_time = 0
	if being_fliped_h:
		flip_h =  not flip_h
		being_fliped_h = false
	if being_fliped_v:
		flip_v =  not flip_v
		being_fliped_v = false

func _on_gui_input(event: InputEvent) -> void:
	if is_fixed:
		return
	if event is InputEventMouseButton:
		var mouse_event := event as InputEventMouseButton
		if mouse_event.button_index == MOUSE_BUTTON_LEFT:
			if Global.drag_mode:
				toggle_drag(mouse_event.pressed)
			if Global.rotate_mode:
				toggle_rotate(mouse_event.pressed)
			if Global.scale_mode:
				toggle_scale(mouse_event.pressed)
			if Global.flip_mode_h:
				toggle_flip_h(mouse_event.pressed)
			if Global.flip_mode_v:
				toggle_flip_v(mouse_event.pressed)
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

func toggle_rotate(toggle_on: bool) -> void:
	being_rotated = toggle_on
	if being_rotated:
		%OiiaoOiiao.play()
	else:
		%OiiaoOiiao.stop()

func toggle_scale(toggle_on: bool) -> void:
	being_scaled = toggle_on

func toggle_flip_h(toggle_on: bool) -> void:
	being_fliped_h = toggle_on

func toggle_flip_v(toggle_on: bool) -> void:
	being_fliped_v = toggle_on
