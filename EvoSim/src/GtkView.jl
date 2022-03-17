
module GtkView
    using Gtk
    import ..Sim
    export initialize, set_world, close_window

    world = nothing
    c = nothing
    win = nothing
    
    function initialize() 
        global win
        global c
        win = GtkWindow("EvoSim")
        c = @GtkCanvas(500, 500)
        
        @guarded draw(c) do widget
            if world === nothing
                return
            end
    
            ctx = getgc(c)
    
            for x in 0:499
                for y in 0:499
                    r,g,b = Sim.get_surface_color(world.surface_map[x+1, y+1])
                    set_source_rgb(ctx, r, g, b)
                    rectangle(ctx, x,  y, 1, 1)
                    fill(ctx)
                end
            end
        end

        push!(win,c)
        showall(win)
    end
    

    function trigger_render()
        global c
        if c !== nothing
            draw(c)
        else
            error("Canvas not initializized!")
        end
    end

    function set_world(new_world)
        global world
        world = new_world
    end

    function close_window()
        global c
        global win
        if c !== nothing
            c = nothing
            Gtk.destroy(win)
            win = nothing
        end
    end

    function set_on_close_callback(fn)
        signal_connect(win, "delete-event") do widget, event
            fn()
        end
    end

end