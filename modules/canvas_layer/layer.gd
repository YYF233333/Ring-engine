class_name Layer
extends Sprite2D

## Canvas Layer class, identified by z_index, should never be constructed manually

## Display an image in the assets
func display(name: String) -> Result:
    var res = AssetLoader.load_img(name)
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
