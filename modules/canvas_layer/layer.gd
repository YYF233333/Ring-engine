class_name Layer
extends Sprite2D

## Canvas Layer class, identified by z_index, should never be constructed manually

## Display an image in the assets
func display(name: String) -> Result:
    #var res = AssetLoader.load_img(name)
    var res = Result.Err("unimplemented")
    if res.is_err():
        return res
    self.texture = res.unwrap()
    return Result.Ok()

## Display an arbitrary texture
func display_img(texture: Texture) -> void:
    self.texture = texture

## reinitialize this layer
func clear() -> void:
    self.texture = null
    self.position = Vector2.ZERO

## Provide functionality to animate single layer.[br]
## Usage:
##  [codeblock]
##  var layers = Layers.new()
##  layers.add_layer()
##  layers.get_layer(0).animate(Fade.fade_in(1.0))
##  [/codeblock]
func animate(animation: Transform, interrupt_prev := false) -> void:
    var parent := get_parent() as Layers
    assert(parent)
    if interrupt_prev:
        if parent.tween != null:
            parent.tween.kill()
        parent.tween = parent.create_tween().set_parallel()
    animation.action(parent.tween, self)
    
