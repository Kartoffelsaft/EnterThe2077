extends KinematicBody


export var speed: float = 0.5

const SCN_BULLET = preload("res://scenes/bullet.tscn")

func _ready():
    pass 

func _process(_delta):
    var velocity = Vector3()
    if Input.is_action_pressed("player_left"):
        velocity.x -= 1
    if Input.is_action_pressed("player_right"):
        velocity.x += 1
    if Input.is_action_pressed("player_up"):
        velocity.z -= 1
    if Input.is_action_pressed("player_down"):
        velocity.z += 1

    if velocity.length_squared() > 0.1:
        velocity = velocity.normalized() * speed
        var _coll = move_and_collide(velocity)


func shoot_at(target: Vector3):
    var nBullet = SCN_BULLET.instance()
    nBullet.look_at_from_position(translation, target, Vector3.UP)

    get_parent().add_child(nBullet)
    

func _on_ClickDetector_input_event(
    _camera, 
    event, 
    click_position, 
    _click_normal, 
    _shape_idx
):
    if event.is_action_pressed("player_shoot"):
        shoot_at(click_position)
