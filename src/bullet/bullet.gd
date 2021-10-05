extends Area

export var speed = 50

func _ready():
    pass

func _process(delta):
    var velocity = Vector3.FORWARD
    velocity = velocity.normalized() * speed
    translate(velocity * delta)
