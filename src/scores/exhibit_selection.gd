class_name ExhibitSelection
extends PanelContainer

@onready var container: HFlowContainer = %Container

func _ready() -> void:
	for file in DirAccess.get_files_at("user://exhibits"):
		var path: String = "user://exhibits".path_join(file)
		var exhibit := load(path) as Exhibit
		var scene: PackedScene = preload("res://src/scores/exhibit_view.tscn")
		var view: ExhibitView = scene.instantiate()
		view.init(exhibit)
		container.add_child(view)
