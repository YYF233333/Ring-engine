class_name Move
extends Transform

## Transform Instance [Move]

var dest_pos: Vector2

#TODO: find a way to get current window size
var window_size := Vector2(1920.0, 1080.0)

const LEFT := 0.2
const MIDDLE := 0.5
const RIGHT := 0.8
const NEAR := 0.8
const NORMAL := 0.5
const FAR := 0.2

# Constructor Presets

static func to_pos(duration: float, position: Vector2) -> Move:
    var anim = Move.new(duration, Tween.EASE_IN_OUT, Tween.TRANS_QUAD)
    anim.dest_pos = position
    return anim


## Transform function, apply animation to [layer] provided.
## Override base method in Transform.
func action(tween: Tween, layer: Layer) -> void:
    tween.tween_property(
        layer, "position", dest_pos*window_size, duration
    ).set_ease(ease_type).set_trans(trans_type)

