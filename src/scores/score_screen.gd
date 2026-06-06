class_name ScoreScreen
extends Control

@onready var day_1_row: HBoxContainer = %Day1Row
@onready var day_2_row: HBoxContainer = %Day2Row
@onready var day_3_row: HBoxContainer = %Day3Row

func _ready() -> void:
	for child: Node in day_1_row.get_children():
		child.requested_change.connect(func():
			request_change(child)
		)
	for child: Node in day_2_row.get_children():
		child.requested_change.connect(func():
			request_change(child)
		)
	for child: Node in day_3_row.get_children():
		child.requested_change.connect(func():
			request_change(child)
		)

func request_change(slot: Slot) -> void:
	var scene: PackedScene = preload("res://src/scores/exhibit_selection.tscn")
	var exhibit_selection: ExhibitSelection = scene.instantiate()
	get_tree().root.add_child(exhibit_selection)
	%Main.hide()
	exhibit_selection.selected_exhibit.connect(func(exhibit: ExhibitView):
		slot.set_exhibit(exhibit)
		%Main.show()
		exhibit_selection.queue_free()
	)
