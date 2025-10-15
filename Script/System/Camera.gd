class_name MainCamera extends Camera2D

#@onready var gm: GameManager = get_node("/root/Game")
@export var gm: GameManager = null

@export var zoom_min: float = 0.6
@export var zoom_max: float = 1.4

var free_control: bool = false                  # when true, not forcely focus on player
var zoom_factor: float = 1
var zoom_target: Vector2 = Vector2.ONE
var zoom_base: float = 2.5
#var zoom_base: float = 2
#var zoom_base: float = 3
var curr_offset: Vector2 = Vector2.ZERO
var focus_position: Vector2 = Vector2.ZERO
var shake_fade: float = 0.2
var max_shake_duration: float = 2
var shaking_expire_time: float = 0
var original_smooth_speed: float = 0

var hard_following: bool = false
var hard_follow_target: Node2D = null

var shake_current: float = 0
var shake_amount: float = 0
var shake_delta: float = 0
var shake_offset: Vector2 = Vector2.ZERO
var shake_direction: Vector2 = Vector2.ZERO 
var damping_speed: float = 1

var inited: bool = false
var ui_mode: bool = false


func _ready() -> void:
    original_smooth_speed = position_smoothing_speed
    zoom_target = Vector2(zoom_base * zoom_factor, zoom_base * zoom_factor)
    zoom = zoom_target
    #to_free_mode()

    
func _lazy_init():
    if inited:
        return
    if gm == null or gm.player == null:
        return
    #gm.player.PLAYER_SHOOT.connect(on_player_shoot)
    inited = true
    
func to_player_mode():
    free_control = false
    
func to_free_mode():
    free_control = true


func focus_to(pos: Vector2, no_smooth: bool = false):    
    focus_position = pos   
    global_position = focus_position
    if no_smooth:
        reset_smoothing()
        
        
func hard_follow(target: Node2D, no_smooth: bool = false):
    hard_following = true
    hard_follow_target = target
    
    
func hard_follow_release():
    hard_following = false
    

func direct_move_to(pos: Vector2):
    global_position = pos
    reset_smoothing()


func _physics_process(delta: float) -> void:
    
    _lazy_init()
    
    if ui_mode:
        return
    
    if hard_following and hard_follow_target != null:
        global_position = hard_follow_target.global_position
        return
    
    if free_control:
        var moving_direction = Vector2(
            Input.get_action_strength("Right") - Input.get_action_strength("Left"),
            Input.get_action_strength("Down") - Input.get_action_strength("Up")
        ).normalized()
        focus_position += moving_direction * delta * 150
    
    #if gm.slow_mode:
        #position_smoothing_speed = original_smooth_speed / Engine.time_scale
    #else:
        #position_smoothing_speed = original_smooth_speed
        
    if free_control:
        global_position = focus_position
    else:
        if gm != null and gm.player != null:
            # OTXO like, no need to press shift
            if true or not gm.player.focusing:
                focus_position = get_global_mouse_position() * 0.5 + gm.player.global_position * 0.5
            else:
                focus_position = get_global_mouse_position() * 0.5 + gm.player.global_position * 0.5
            global_position = focus_position
        process_shake(delta)
    # =============== lerp zoom ===============
    update_zoom()
    

func process_shake(delta):
    if abs(shake_amount) > 0.1:
        shake_current += shake_delta * delta
        if abs(shake_current) > abs(shake_amount):
            shake_amount *= -0.5
            shake_delta *= -1
            shake_current = shake_amount * -1
        offset = shake_direction * shake_current
    else:
        shake_amount = 0
        shake_current = 0
        shake_offset = Vector2.ZERO
        shake_direction = Vector2.ZERO
        offset = Vector2.ZERO


func update_zoom():
    if not MathUtils.approximately_equal(zoom, zoom_target, 0.01):
        #print("[camera] new zoom %s to target %s" % [zoom, zoom_target])
        zoom = zoom.lerp(zoom_target, 0.1)


func lerp_to_zoom(zoom_factor):
    self.zoom_factor = zoom_factor
    zoom_target = Vector2(zoom_factor * zoom_base, zoom_factor * zoom_base)
    

func shake(amount: float, shake_direction: Vector2 = Vector2.ZERO, shake_randomness: float = 0):
    # TODO: shake_direction指定具体的shake方向，提升射击手感
    # TODO: 添加相机的旋转震动，避免只有位移震动的单一感
    self.shake_amount = amount / 10
    self.shake_current = 0
    self.shake_delta = amount
    self.shake_direction = (MathUtils.random_vector2(0.2) + -1 * shake_direction).normalized()

 
func set_zoom_factor(factor: float):
    zoom_factor = factor
    
    
# ----------------------------------------------------------    

func on_player_shoot(weapon_name, weapon_type, shoot_direction, sound_range, bullet_left):
    """
    让Player自己来触发
    """
    shake(sound_range / 4, -1 * shoot_direction)
    

func on_scene_enter():
    var border = gm.scene.map_manager.get_map_border()
    limit_left = border.position.x + 20
    limit_top = border.position.y + 20
    limit_right = border.position.x + border.size.x - 20
    limit_bottom = border.position.y + border.size.y - 20
    print("[camera] set camera bounds to (%s, %s, %s, %s)" % [limit_left, limit_top, limit_right, limit_bottom])
