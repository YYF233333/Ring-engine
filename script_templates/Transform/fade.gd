# meta-name: Transform Instance
# meta-default: true
# meta-space-indent: 4
class_name _CLASS_
extends Transform

## Transform Instance [_CLASS_]

# Constructor Presets

static func preset(duration: float) -> _CLASS_:
    return _CLASS_.new(duration, null, Tween.EASE_IN, Tween.TRANS_LINEAR)


## Transform function, apply animation to layer provided.
## Override base method in Transform.
func action(tween: Tween, layer: Layer) -> void:
    pass
