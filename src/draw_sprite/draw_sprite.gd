extends Sprite2D

@export var paint_color : Color = Color.RED
@export var img_size : = Vector2i(640,480)
@export var brush_size := 3
var img : Image

func _ready() -> void:
	img = Image.create_empty(img_size.x,img_size.y,false,Image.FORMAT_RGBA8)
	img.fill(Color.WHITE)
	texture = ImageTexture.create_from_image(img)


func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.pressed and event.is_echo() == false:
			# Pintar en click izquierdo
			if event.button_index == MOUSE_BUTTON_MASK_LEFT:
				_print_mouse_click(event)
				
			# con click derecho habilitamos borrar
			if event.button_index == MOUSE_BUTTON_RIGHT:
				var impos = _get_mouse_position(event)
				paint_color = img.get_pixelv(impos)
				
	#pintar manteniendo click
	if event is InputEventMouseMotion:
		if event.button_mask == MOUSE_BUTTON_LEFT:
			_print_mouse_movement(event)
			texture.update(img)
			
	#boton para guardar imagen
	if event is InputEventKey:
		if event.pressed and event.is_echo() == false:
			if event.keycode == KEY_SPACE:
				_export_paint_to_image()

func _export_paint_to_image() -> void:
	var draw = DrawContainer.new(img,"name test","descp test")
	DirAccess.make_dir_absolute("user://Drawings")
	ResourceSaver.save(draw, "user://Drawings/test1.tres")

func _print_mouse_click( event : InputEvent) -> void:
	var impos = _get_mouse_position(event)
	_paint_text(impos)
	texture.update(img)

func _get_mouse_position(event: InputEvent):
	var lpos = to_local(event.position)
	return lpos - offset + get_rect().size/2.0

func _print_mouse_movement(event: InputEvent) -> void:
	var impos = _get_mouse_position(event)
	if event.relative.length_squared() > 0:
			var num:= ceili(event.relative.length())
			var target_pos = impos - (event.relative)
			for i in num:
				impos = impos.move_toward(target_pos, 1.0)
				_paint_text(impos)

func _paint_text(pos) -> void:
	img.fill_rect(Rect2i(pos, Vector2i(1,1)).grow(brush_size), paint_color)
