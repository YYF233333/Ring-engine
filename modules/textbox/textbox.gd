extends Control

## assign in editor
@export var textbox: Label
## assign in editor
@export var namebox: Label

var tween: Tween

## 是否启用文本动画
var animation: bool = true

func _ready() -> void:
    # force setting root control size
    self.size = get_tree().root.size

func unload():
    get_parent().remove_child(self)
    self.queue_free()

func show_text(text: String, append := false) -> void:
    textbox.text = text
    if animation:
        if tween != null:
            tween.kill()
        tween = create_tween().set_parallel()
        textbox.visible_characters = 0
        tween.tween_property(
            textbox, "visible_characters", textbox.get_total_character_count(), 1.0)
    
func show_name(name: String) -> void:
    namebox.text = name
