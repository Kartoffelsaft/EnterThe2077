extends Camera

export var rotateSensitivity = 0.003;
export var minZoom = 5.0;
export var maxZoom = 30.0;
export var zoomSensitivity = 0.1;

export var screenShakeAmountPos = 0.2
export var screenShakeAmountRot = 0.03
export var screenShakeRecoverSpeed = 4.0


var restingPosition = Transform.IDENTITY

func _ready():
    restingPosition = self.transform
    randomize()

func _process(delta):
    var screenShakeRecover = exp(-delta * screenShakeRecoverSpeed)
    self.transform = self.transform.interpolate_with(restingPosition, (1 - screenShakeRecover))

func _unhandled_input(event):
    if(event is InputEventMouseMotion
    && Input.is_action_pressed("camera_rotate")):
        restingPosition = restingPosition.rotated(Vector3(0, 1, 0), event.relative.x * rotateSensitivity)
    
    if(event.is_action("camera_in")):
        restingPosition = Transform(restingPosition.basis, restingPosition.origin * (1 - zoomSensitivity))
    if(event.is_action("camera_out")):
        restingPosition = Transform(restingPosition.basis, restingPosition.origin * (1 + zoomSensitivity))
    
    if(restingPosition.origin.length_squared() < minZoom * minZoom):
        restingPosition = Transform(restingPosition.basis, restingPosition.origin.normalized() * minZoom)
    if(restingPosition.origin.length_squared() > maxZoom * maxZoom):
        restingPosition = Transform(restingPosition.basis, restingPosition.origin.normalized() * maxZoom)



func shake():
    var posOffset = Vector3(rand_range(-screenShakeAmountPos, screenShakeAmountPos), rand_range(-screenShakeAmountPos, screenShakeAmountPos), rand_range(-screenShakeAmountPos, screenShakeAmountPos))
    var rotOffset = Vector3(randf(), randf(), randf()).normalized()
    translate(posOffset)
    rotate(rotOffset, rand_range(-screenShakeAmountRot, screenShakeAmountRot))
    update_gizmo()
