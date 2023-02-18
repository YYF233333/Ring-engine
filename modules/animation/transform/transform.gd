class_name Transform

## Type 1 animation, used to animate single ImageGroup.
##
##  This is the base class. To create a Transform:[br]
##  1. Create a new class extend this base class.[br]
##  2. Override [method action] to implement specific logic.[br]
##  3. Create convenient presets.

## Transform last time in seconds.
var duration: float
## see [member Tween.EaseType]
var ease_type: Tween.EaseType
## see [member Tween.TransitionType]
var trans_type: Tween.TransitionType

func _init(
    duration: float,
    ease_type: Tween.EaseType,
    transition_type: Tween.TransitionType
) -> void:
    self.duration = duration
    self.ease_type = ease_type
    self.trans_type = transition_type


## Transform function, apply animation to [layer] provided.
## Should be overriden in sub class to implement specific logic.
func action(_tween: Tween, _layer: Layer) -> void:
    Assert.unimplemented("Calling transform action from base class")
