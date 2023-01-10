extends Control

## assign in editor
@export var textbox: Label
## assign in editor
@export var namebox: Label

func unload():
    get_parent().remove_child(self)
    self.queue_free()
