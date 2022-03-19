
module GtkView
    include("Camera.jl")
    include("render_world.jl")
    using Gtk
    using Match
    import ..Sim
    import .Camera
    export initialize, set_world, close_window, step

    world = nothing
    c = nothing
    win = nothing
    camera = nothing

    # WSAD
    pressed_keys = [false, false, false, false]
    
    function initialize(width::Int64=500, height::Int64=500)
        global win
        global c
        global camera
        win = GtkWindow("EvoSim")
        c = @GtkCanvas(width, height)
        camera = Camera.CameraData(0, 0, 4, width, height)
        
        @guarded draw(c) do widget    
            ctx = getgc(c)
            render_world(ctx, camera, world)
        end

        push!(win,c)
        showall(win)


        #=
            WSAD, Up, Down, Left, Right
            Released key: 119
            Released key: 115
            Released key: 97
            Released key: 100
            Released key: 65362
            Released key: 65364
            Released key: 65361
            Released key: 65363
        =#
        signal_connect(win, "key-release-event") do widget, event
            global pressed_keys
            @match event.keyval begin
                119 || 65362 => set_key_held(1, false)
                115 || 65364 => set_key_held(2, false)
                97  || 65361 => set_key_held(3, false)
                100 || 65363 => set_key_held(4, false)
            end
        end

        signal_connect(win, "key-press-event") do widget, event
            global pressed_keys
            @match event.keyval begin
            119 || 65362 => set_key_held(1, true)
            115 || 65364 => set_key_held(2, true)
            97  || 65361 => set_key_held(3, true)
            100 || 65363 => set_key_held(4, true)
            end
        end
    end
    
    function set_key_held(index::Int64, val::Bool)
        pressed_keys[index] = val
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

    function step(delta_time::Float64)
        global pressed_keys
        global camera

        x_delta::Float64 = 0.0
        y_delta::Float64 = 0.0
        speed = 350.0

        if pressed_keys[1]
            y_delta -= speed * delta_time
        end

        if pressed_keys[2]
            y_delta += speed * delta_time
        end

        if pressed_keys[3]
            x_delta -= speed * delta_time
        end

        if pressed_keys[4]
            x_delta += speed * delta_time
        end
        Camera.move_camera_relative(camera, x_delta, y_delta)      
    end

end