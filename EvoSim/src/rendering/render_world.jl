import ..Sim
import .Camera

function render_world(ctx, camera::Camera.CameraData, world::Sim.World)
    (min_x, min_y), (max_x, max_y) = Camera.get_tile_range(camera)
    for x in min_x:max_x
        for y in min_y:max_y
            if x > 0 && y > 0 && x <= world.width && y <= world.height
                r,g,b = Sim.get_surface_color(world.surface_map[x, y])
            else
                r,g,b = 0.0, 0.0, 0.0
            end

            set_source_rgb(ctx, r, g, b)
            sx, sy = Camera.to_screen_pos(camera, x, y)
            int_x = convert(Int64, floor(sx))
            int_y = convert(Int64, floor(sy))
            rectangle(ctx, int_x,  int_y, camera.scale, camera.scale)
            fill(ctx)
        end
    end
end