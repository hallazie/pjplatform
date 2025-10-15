class_name MathUtils

const epsilon = 0.0001

static func vector_dot(a: Vector2, b: Vector2):
    return a.x * b.x + a.y * b.y;


static func direction_to_rotation(direction: Vector2):
    return direction.angle() + PI / 2


static func random_vector2(radiance: float):
    if radiance == 0:
        return Vector2.ZERO
    return Vector2(randf_range(-radiance, radiance), randf_range(-radiance, radiance))


static func random_vector2_circle(radiance: float, distribution: String = "uniform"):
    """
    distribution: gaussian, uniform
    """
    if distribution == "uniform":
        var angle = randf() * TAU
        var radius = sqrt(randf()) * radiance
        return Vector2(cos(angle), sin(angle)) * radius
    elif distribution == "gaussian":
        var x = randf()  # 正态分布随机数，均值0，标准差1
        var y = randf()
        var point = Vector2(x, y).normalized() * abs(randf()) * radiance
        return point
    else:
        return Vector2.ZERO


static func project_a_on_norm_b(a: Vector2, b: Vector2):
    return a.dot(b) * b


static func random_fetch(item_list: Array):
    if item_list.size() <= 0:
        return null
    var rand_index = randi_range(0, item_list.size()-1)
    return item_list[rand_index]
    

static func rotate_torwards(src_dir: Vector2, tar_dir: Vector2, delta: float):
    var radian_delta = deg_to_rad(delta)
    var angle_to_target = src_dir.angle_to(tar_dir)
    var rotation_angle = clamp(angle_to_target, -radian_delta, radian_delta)
    var rot_dir = src_dir.rotated(rotation_angle)
    return rot_dir


static func approximately_equal(vec1: Vector2, vec2: Vector2, thresh: float = 0.01):
    return abs(vec1.x - vec2.x) < thresh and abs(vec1.y - vec2.y) < thresh


static func vector_symmetric_for_a_about_b(a: Vector2, b: Vector2):
    var factor = 2 * (a.x * b.x + a.y * b.y) / (b.x * b.x + b.y * b.y) 
    var symm = factor * b - a
    return symm
    
    
static func get_side_coordinate_of_two_points(p1: Vector2, p2: Vector2, dist: float):
    if approximately_equal(p1, p2, 0.1):
        return [p2, p2]
    var diff = p2 - p1
    var perp = Vector2(-diff.y, diff.x).normalized()
    var left = p2 + perp * dist
    var right = p2 - perp * dist
    return [left, right]
    

static func angle_between_rotations(rot1: float, rot2: float):
    var v1 = Vector2.RIGHT.rotated(rot1)
    var v2 = Vector2.RIGHT.rotated(rot2)
    return rad_to_deg(acos(clamp(v1.normalized().dot(v2.normalized()), -1.0, 1.0)))
    
    
static func angle_between_vectors(vec1: Vector2, vec2: Vector2):
    return rad_to_deg(acos(clamp(vec1.normalized().dot(vec2.normalized()), -1.0, 1.0)))
    

static func angle_between_vector_and_rotation(vec: Vector2, rot: float):
    var v1 = Vector2.RIGHT.rotated(rot)
    return rad_to_deg(acos(clamp(v1.normalized().dot(vec.normalized()), -1.0, 1.0)))   


static func mahattan_distance(pos1: Vector2, pos2: Vector2):
    return abs(pos1.x - pos2.x) + abs(pos1.y - pos2.y)
