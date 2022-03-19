module Camera
    export CameraData, move_camera_absolute, move_camera_relative, get_tile_range, to_screen_pos
    mutable struct CameraData
        x::Float64
        y::Float64
        scale::Int64
        w::Int64
        h::Int64
    end

    function move_camera_relative(camera::CameraData, dx::Float64, dy::Float64)
        camera.x += dx
        camera.y += dy
    end

    function move_camera_absolute(camera::CameraData, x::Float64, y::Float64)
        camera.x = x
        camera.y = y
    end

    function set_scale(camera::CameraData, scale::Int64)
        camera.scale = scale
    end

    """
        Gives (min_x, min_y), (max_x, max_y) indices for tiles to draw, will not perform boundary check
    """
    function get_tile_range(camera::CameraData) :: Tuple{Tuple{Int64, Int64}, Tuple{Int64, Int64}}
        min_x = convert(Int64, floor(camera.x/camera.scale))
        min_y = convert(Int64, floor(camera.y/camera.scale))
        max_x = convert(Int64, ceil((camera.x + camera.w)/camera.scale))
        max_y = convert(Int64, ceil((camera.y + camera.h)/camera.scale))
        return ((min_x, min_y), (max_x, max_y))
    end

    function to_screen_pos(camera::CameraData, tile_x::Int64, tile_y::Int64) :: Tuple{Float64, Float64}
        x = tile_x * camera.scale - camera.x
        y = tile_y * camera.scale - camera.y
        return x, y
    end
end