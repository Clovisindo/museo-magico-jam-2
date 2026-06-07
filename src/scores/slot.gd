class_name Slot
extends PanelContainer

signal requested_change
@export var exhibit: Exhibit

func _ready() -> void:
	%RichTextLabel.hide()

func _on_button_pressed() -> void:
	requested_change.emit()

func disable():
	$Button.disabled = true
	$Button.text = ""

func set_exhibit(view: ExhibitView) -> void:
	for child: Node in get_children():
		if child is ExhibitView:
			child.queue_free()
	add_child(view)
	exhibit = view.exhibit

func set_score(score: int):
	%RichTextLabel.text = "[wave]+%d[/wave]" % score
	if score < 150:
		%RichTextLabel.modulate = Color.ORANGE_RED
	elif score < 200:
		%RichTextLabel.modulate = Color.YELLOW
	elif score < 300:
		%RichTextLabel.modulate = Color.GREEN_YELLOW
	else:
		%RichTextLabel.modulate = Color.GREEN
	%RichTextLabel.show()
