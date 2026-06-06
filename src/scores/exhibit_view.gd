class_name ExhibitView
extends VBoxContainer

@export var exhibit: Exhibit
signal clicked

func init(exhibit_: Exhibit) -> void:
	var texture_rect: TextureRect
	exhibit = exhibit_
	%Label.text = exhibit.name
	for i in range(exhibit.textures.size()):
		texture_rect = TextureRect.new()
		texture_rect.texture = exhibit.textures[i]
		texture_rect.size = exhibit.sizes[i]
		%SubViewport.add_child(texture_rect)
		#texture_rect.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
		#texture_rect.size *= 0.5
		texture_rect.position = exhibit.positions[i]
		await RenderingServer.frame_post_draw
	var img: Image = %SubViewport.get_texture().get_image()
	DirAccess.make_dir_absolute("user://exhibit_images")
	img.save_png("user://exhibit_images/" + exhibit.name + ".png")
	%SubViewportContainer.queue_free()
	%Panel.custom_minimum_size = Vector2(256, 256)
	%Panel.size = Vector2(256, 256)
	img.resize(256, 256)
	texture_rect = TextureRect.new()
	texture_rect.texture = ImageTexture.create_from_image(img)
	%Panel.add_child(texture_rect)

func _on_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		clicked.emit()
		print("clicked")
