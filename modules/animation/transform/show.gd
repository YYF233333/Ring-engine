class_name Show
extends Transform

## Transform Instance [Show]

# x
const LEFT := 0.2
const MIDDLE := 0.5
const RIGHT := 0.8
# (y, scale)
const NEAR := Vector2(1.0, 2.0)
const NORMAL := Vector2(0.75, 1.4)
const FAR := Vector2(0.6, 1.0)

var target_pos: Vector2
var scale_ratio: float
#TODO: towards continuous scale with anchor and dist to camera
var anchor: Vector2
var distance: float

# Constructor Presets

static func at_left() -> Show:
    var anim = Show.new(0.0, Tween.EASE_IN, Tween.TRANS_LINEAR)
    anim.target_pos = Vector2(LEFT, NORMAL.x)
    anim.scale_ratio = NORMAL.y
    return anim

static func at_middle() -> Show:
    var anim = Show.new(0.0, Tween.EASE_IN, Tween.TRANS_LINEAR)
    anim.target_pos = Vector2(MIDDLE, NORMAL.x)
    anim.scale_ratio = NORMAL.y
    return anim

static func at_right() -> Show:
    var anim = Show.new(0.0, Tween.EASE_IN, Tween.TRANS_LINEAR)
    anim.target_pos = Vector2(RIGHT, NORMAL.x)
    anim.scale_ratio = NORMAL.y
    return anim


## Transform function, apply animation to [layer] provided.
## Override base method in Transform.
func action(tween: Tween, layer: Layer) -> void:
    normalize(layer)
    layer.scale *= Vector2(scale_ratio, scale_ratio)
    layer.position = Vector2(1920, 1080) * target_pos

# fit in screen
func normalize(img: Sprite2D) -> void:
    var ratio = Vector2(1920.0, 1080.0) / img.texture.get_size()
    ratio = min(ratio.x, ratio.y)
    img.scale = Vector2(ratio, ratio)
