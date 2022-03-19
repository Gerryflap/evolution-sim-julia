include("sim/Sim.jl")
include("rendering/GtkView.jl")
module EvoSim
    export run
    import ..Sim
    import ..GtkView

    fps_target = 60.0
    time_per_frame = 1.0/fps_target

    # For now, just draw an overview of the world
    function run()
        running = true
        GtkView.initialize(1200, 800)
        GtkView.set_on_close_callback(() -> running = false)
        world = Sim.generate_world((500, 500))
        GtkView.set_world(world)
        try
            prev_time = time()
            while running
                current_time = time()
                if prev_time + time_per_frame - current_time > 0.001
                    sleep(prev_time + time_per_frame - current_time)
                else
                    # We're not going ot reach the desired framerate
                    sleep(0.001)
                end

                current_time = time()
                step(current_time - prev_time)

                prev_time = current_time
                GtkView.trigger_render()

            end
        catch InterruptException
            GtkView.close_window()
        end
    end

    function step(delta_time::Float64)
        GtkView.step(delta_time)
    end
end # module
