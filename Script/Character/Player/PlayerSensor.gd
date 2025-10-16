class_name PlayerSensor extends Node2D

enum SensorWallType{
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
var is_on_wall_type: SensorWallType = SensorWallType.None
var mute_wall_cooldown: float = 0
var is_on_ground_previous: bool = true
var is_on_wall_type_previous: SensorWallType = SensorWallType.None


func _init_signals():
    pass


func update_sensor(delta: float):
    if mute_wall_cooldown > 0:
        mute_wall_cooldown -= delta
    is_on_ground = ground_check()
    is_on_wall_type = wall_check()


func ground_check() -> bool:
    return detector_ground_left.is_colliding() or detector_ground_right.is_colliding()


func wall_check() -> SensorWallType:
    if mute_wall_cooldown > 0:
        return SensorWallType.None
    if detector_wall_left.is_colliding():
        return SensorWallType.Left
    elif detector_wall_right.is_colliding():
        return SensorWallType.Right
    else:
        return SensorWallType.None


func mute_wall(duration: float):
    mute_wall_cooldown = duration
