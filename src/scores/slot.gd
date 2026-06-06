class_name Slot
extends PanelContainer

signal requested_change
@export var exhibit: Exhibit

func _on_button_pressed() -> void:
	requested_change.emit()

func set_exhibit(view: ExhibitView) -> void:
	for child: Node in get_children():
		if child is ExhibitView:
			child.queue_free()
	add_child(view)
	exhibit = view.exhibit
