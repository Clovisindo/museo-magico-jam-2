class_name ExhibitSelection
extends PanelContainer

@onready var container: HFlowContainer = %Container

signal selected_exhibit(exhibit: ExhibitView)

func _ready() -> void:
	for file in DirAccess.get_files_at("user://exhibits"):
		var path: String = "user://exhibits".path_join(file)
		var exhibit := load(path) as Exhibit
		var scene: PackedScene = preload("res://src/scores/exhibit_view.tscn")
		var view: ExhibitView = scene.instantiate()
		view.init(exhibit)
		container.add_child(view)
		view.clicked.connect(_on_view_clicked, CONNECT_APPEND_SOURCE_OBJECT)

func _on_view_clicked(view: ExhibitView) -> void:
	container.remove_child(view)
	selected_exhibit.emit(view)
