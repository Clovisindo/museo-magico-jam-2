extends Node

var day: int = 1
var score: int = 0
var n_creations: int = 0
var saved_exhibits: Array[Exhibit] = []
var rotate_mode : bool = false
var scale_mode : bool = false
var flip_mode : bool = false
var drag_mode : bool = true

func _ready() -> void:
	if !DirAccess.dir_exists_absolute("user://exhibits"):
		DirAccess.make_dir_absolute("user://exhibits")
	for file in DirAccess.get_files_at("user://exhibits"):
		DirAccess.remove_absolute("user://exhibits".path_join(file))

func _activate_rotate():
	rotate_mode = true
	scale_mode = false
	flip_mode = false
	drag_mode = false

func _activate_scale():
	rotate_mode = false
	scale_mode = true
	flip_mode = false
	drag_mode = false

func _activate_flip():
	rotate_mode = false
	scale_mode = false
	flip_mode = true
	drag_mode = false

func _activate_drag():
	rotate_mode = false
	scale_mode = false
	flip_mode = false
	drag_mode = true
