class_name CommonUtils


static func get_scene_name(scene_path: String):
    """
    path like: res://Scenes/Levels/TestSceneConstructionEntry.tscn
    """
    var scene_name = scene_path.split(".")[0].split("/")[-1]
    print("NAME: ", scene_path, " ===> ", scene_name)
    return scene_name


static func get_scene_name_in_node(node):
    if node == null:
        return "NULL"
    return node.scene_file_path


static func get_screen_edge_position(object_position: Vector2, screen_size: Vector2, camera_position: Vector2) -> Vector2:    
    var offset_size = object_position - camera_position
    var end_position = Vector2.ZERO
    print("[em] offset / screen = %s / %s, object: %s, camera: %s" % [offset_size, screen_size, object_position, camera_position])
    if abs(offset_size.x) <= screen_size.x and abs(offset_size.y) <= screen_size.y:
        return object_position
    else:
        if abs(offset_size.x / offset_size.y) > abs(screen_size.x / screen_size.y):
            # 水平溢出屏幕
            var y = screen_size.x * abs(offset_size.y / offset_size.x)
            var x_flag = 1 if offset_size.x > 0 else -1
            var y_flag = 1 if offset_size.y > 0 else -1
            end_position = camera_position + Vector2(x_flag * screen_size.x, y_flag * y)
        else:
            var x = screen_size.y * abs(offset_size.x / offset_size.y)
            var x_flag = 1 if offset_size.x > 0 else -1
            var y_flag = 1 if offset_size.y > 0 else -1
            end_position = camera_position + Vector2(x_flag * x, y_flag * screen_size.y)
    print("[em] kill confirm, screen size: %s / %s, obj pos: %s, camera pos: %s, edgepoint: %s" % [screen_size, offset_size, object_position, camera_position, end_position]) 
    return end_position


static func random_fetch(list: Array):
    if list.size() <= 0:
        return
    var index = randi_range(0, list.size() - 1)
    return list[index]
