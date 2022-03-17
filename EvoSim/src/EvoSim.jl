include("sim/Sim.jl")
include("./GtkView.jl")
module EvoSim
    export run
    import ..Sim
    import ..GtkView

    # For now, just draw an overview of the world
    function run()
        running = true
        GtkView.initialize()
        GtkView.set_on_close_callback(() -> running = false)
        world = Sim.generate_world((500, 500))
        GtkView.set_world(world)
        try
            while running
                sleep(1)
                world = Sim.generate_world((500, 500))
                GtkView.set_world(world)
                GtkView.trigger_render()        
            end
        catch InterruptException
            GtkView.close_window()
        end
    end
end # module
