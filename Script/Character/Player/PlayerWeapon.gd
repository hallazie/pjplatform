class_name PlayerWeapon extends Node2D

var main: Player = null
var state: PlayerFSM = null

var aiming_direction: Vector2 = Vector2.ZERO

func _init_signals():
    pass


func update_weapon(delta: float):
    aiming_direction = aiming_direction.lerp((get_global_mouse_position() - global_position).normalized(), 0.5)
