class_name Fade
extends Transform

var final_alpha: float

# Constructor Presets

static func fade_in(duration: float) -> Fade:
    var anim = Fade.new(duration, Tween.EASE_IN, Tween.TRANS_LINEAR)
    anim.final_alpha = 1.0
    return anim

static func fade_out(duration: float) -> Fade:
    var anim = Fade.new(duration, Tween.EASE_IN, Tween.TRANS_LINEAR)
    anim.final_alpha = 0.0
    return anim

## Transform function, apply animation to [layer] provided.
## Override base method in Transform.
func action(tween: Tween, layer: Layer) -> void:
    tween.tween_property(
        layer, "modulate:a", final_alpha, duration
    ).set_ease(ease_type).set_trans(trans_type)
