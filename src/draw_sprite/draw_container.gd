extends Resource

class_name  DrawContainer

@export var draw_image : Image
@export var name : String
@export var description : String


func _init(_img, _name, _descp) -> void:
	draw_image = _img
	name = _name
	description = _descp
