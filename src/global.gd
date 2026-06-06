extends Node

var day: int = 1
var score: int = 0
var n_creations: int = 0
var saved_exhibits: Array[Exhibit] = []

func _ready() -> void:
	for file in DirAccess.get_files_at("user://exhibits"):
		DirAccess.remove_absolute("user://exhibits".path_join(file))
