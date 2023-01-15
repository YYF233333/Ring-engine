class_name Transform

## Type 1 animation, used to animate single standing.
##
##  These are high order functions which return real animation functions.
##  Signature of their [b]RETURN VALUE[/b]: [code]Fn(Tween, Layer) -> void[/code]

# Presets

func fade_in(duration: float) -> Callable:
    return fade(duration, 1.0, Tween.EASE_IN, Tween.TRANS_LINEAR)


func fade_out(duration: float) -> Callable:
    return fade(duration, 0.0, Tween.EASE_IN, Tween.TRANS_LINEAR)

    
# Base function

func fade(
    duration: float,
    final_alpha: float,
    ease_type: Tween.EaseType,
    transition_type: Tween.TransitionType
) -> Callable:
    # TODO: strict layer type to Layer
    return func(tween: Tween, layer: Sprite2D):
        tween.tween_property(
            layer, "modulate:a", final_alpha, duration
        ).set_ease(ease_type).set_trans(transition_type)

