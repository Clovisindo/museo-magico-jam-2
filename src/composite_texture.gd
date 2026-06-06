class_name CompositeTexture
extends TextureRect

func init(textures: Array[TextureRect], positions: Array[Vector2]) -> void:
	for i in range(textures.size()):
		add_child(textures[i])
		textures[i].position = positions[i]
