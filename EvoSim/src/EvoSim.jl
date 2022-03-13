module EvoSim

using Gtk
include("sim/Sim.jl")

export run

# For now, just draw an overview of the world
function run()
    win = GtkWindow("EvoSim", 400, 400)
    c = @GtkCanvas()
    push!(win,c)

    world = Sim.generate_world((200, 200))

    @guarded draw(c) do widget
        ctx = getgc(c)

        for x in 0:199
            for y in 0:199
                r,g,b = Sim.get_surface_color(world.surface_map[x+1, y+1])
                set_source_rgb(ctx, r, g, b)
                rectangle(ctx, x * 2,  y * 2, 2, 2)
                fill(ctx)
            end
        end
    end
    showall(win)

    while true
        sleep(1)
        world = Sim.generate_world((200, 200))
        draw(c)
    end
end

end # module
