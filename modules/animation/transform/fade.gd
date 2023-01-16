class_name Fade
extends Transform

# Constructor Presets

static func fade_in(duration: float) -> Fade:
    return Fade.new(duration, 1.0, Tween.EASE_IN, Tween.TRANS_LINEAR)


static func fade_out(duration: float) -> Fade:
    return Fade.new(duration, 0.0, Tween.EASE_IN, Tween.TRANS_LINEAR)


## Transform function, apply animation to layer provided.
## Override base method in Transform.
func action(tween: Tween, layer: Layer) -> void:
    tween.tween_property(
        layer, "modulate:a", final_val, duration
    ).set_ease(ease_type).set_trans(trans_type)
