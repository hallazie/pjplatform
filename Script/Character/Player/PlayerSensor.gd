class_name PlayerSensor extends Node2D

enum OnWallType{
    None,
    Left,
    Right,
}

@onready var detector_ground_left: RayCast2D = $EnvDetector/GroundLeft
@onready var detector_ground_right: RayCast2D = $EnvDetector/GroundRight
@onready var detector_wall_left: RayCast2D = $EnvDetector/WallLeft
@onready var detector_wall_right: RayCast2D = $EnvDetector/WallRight
@onready var detector_area: Area2D = $EnvTrigger

var main: Player = null

var is_on_ground: bool = true
var on_wall_type: OnWallType = OnWallType.None
var mute_wall_cooldown: float = 0


func _init_signals():
    pass


func update_sensor(delta: float):
    if mute_wall_cooldown > 0:
        mute_wall_cooldown -= delta
    is_on_ground = ground_check()
    on_wall_type = wall_check()


func ground_check() -> bool:
    return detector_ground_left.is_colliding() or detector_ground_right.is_colliding()


func wall_check() -> OnWallType:
    if mute_wall_cooldown > 0:
        return OnWallType.None
    if detector_wall_left.is_colliding():
        return OnWallType.Left
    elif detector_wall_right.is_colliding():
        return OnWallType.Right
    else:
        return OnWallType.None


func mute_wall(duration: float):
    mute_wall_cooldown = duration
