@enum SurfaceType begin
    water=1
    sand=2
    grass=3
end

function get_surface_color(surface_type::SurfaceType) :: Tuple{Float64, Float64, Float64}
    if surface_type == water
        return (0.1, 0.2, 0.9)
    elseif surface_type == sand
        return (0.9, 0.7, 0.2)
    elseif surface_type == grass
        return (0.2, 0.8, 0.1)
    else
        return (0, 0, 0)    # Should never happen :)
    end
end
