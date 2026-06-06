class_name ExhibitView
extends VBoxContainer

@export var exhibit: Exhibit

func init(exhibit_: Exhibit) -> void:
	exhibit = exhibit_
	%Label.text = exhibit.name
	for i in range(exhibit.textures.size()):
		var texture_rect := TextureRect.new()
		texture_rect.texture = exhibit.textures[i]
		texture_rect.size = exhibit.sizes[i]
		%Panel.add_child(texture_rect)
		#texture_rect.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
		#texture_rect.size *= 0.5
		texture_rect.position = exhibit.positions[i]
