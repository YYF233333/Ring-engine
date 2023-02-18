# meta-name: Transition Instance
# meta-default: true
# meta-space-indent: 4
class_name _CLASS_
extends Transition

## Transition Instance [_CLASS_]

# Constructor Presets

static func preset(duration: float) -> _CLASS_:
    return _CLASS_.new(duration, Tween.EASE_IN, Tween.TRANS_LINEAR)


## Transition function, apply animation to [layers] provided.
## Override base method in Transition.
func action(layers: Layers) -> void:
    pass
