class_name Exhibit
extends Resource

@export var name: String
@export var textures: Array[Texture2D]
@export var positions: Array[Vector2]

func _init(texture_rects: Array[TextureRect], name_: String) -> void:
	for texture: TextureRect in texture_rects:
		textures.push_back(texture.texture)
		positions.push_back(texture.position)
		name = name_
