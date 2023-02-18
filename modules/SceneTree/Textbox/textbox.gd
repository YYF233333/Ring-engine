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
    textbox.visible_characters = textbox.get_total_character_count()

func unload():
    get_parent().remove_child(self)
    self.queue_free()

func show_text(text: String, append := false) -> void:
    if append:
        textbox.text += text
    else:
        textbox.text = text
    if animation:
        if tween != null:
            tween.kill()
        tween = create_tween().set_parallel()
        if not append:
            textbox.visible_characters = 0
        tween.tween_property(
            textbox, "visible_characters", textbox.get_total_character_count(),
            _calc_time(text.length())
        )
    
func show_name(name: String) -> void:
    namebox.text = name

static func _calc_time(length: int) -> float:
    return length / GlobalVar.get_var("TextSpeed").expect("Cannot find TextSpeed")
