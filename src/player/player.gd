extends KinematicBody

export var speed: float = 20
export var gravity: float = 5

var fallingSpeed: float = 0

const SCN_BULLET = preload("res://scenes/bullet.tscn")

func _ready():
    pass 

func _process(delta):
    var velocity = Vector3()
    if Input.is_action_pressed("player_left"):
        velocity.x -= 1
    if Input.is_action_pressed("player_right"):
        velocity.x += 1
    if Input.is_action_pressed("player_up"):
        velocity.z -= 1
    if Input.is_action_pressed("player_down"):
        velocity.z += 1
    
    if is_on_floor():
        fallingSpeed = 0
    else:
        fallingSpeed += gravity * delta

    if velocity.length_squared() > 0.1 || fallingSpeed > 0:
        velocity = $Camera.transform.basis.xform(velocity)
        velocity.y = 0
    
        velocity = velocity.normalized() * speed
        velocity.y = -fallingSpeed
        var _coll = move_and_slide(velocity, Vector3.UP)


func shoot_at(target: Vector3):
    var nBullet = SCN_BULLET.instance()
    nBullet.look_at_from_position(translation, target, Vector3.UP)

    get_parent().add_child(nBullet)

    get_tree().call_group("shakeable", "shake")
    

func _on_ClickDetector_input_event(
    _camera, 
    event, 
    click_position, 
    _click_normal, 
    _shape_idx
):
    if event.is_action_pressed("player_shoot"):
        shoot_at(click_position)
    
    $PlayerVisual.look_at_from_position(
        translation, 
        click_position,
        Vector3.UP
    )
    $PlayerVisual.transform = $PlayerVisual.transform.rotated(Vector3(0, 1, 0), -1.5) 
