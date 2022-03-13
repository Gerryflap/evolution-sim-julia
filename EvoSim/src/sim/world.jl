using Random
using Match
using Statistics
include("surfaces.jl")
include("entity.jl")

struct World
    width::Int64
    height::Int64
    # For quick iteration over all entities
    entity_set::Set{Entity}
    # For quick positional access to entities (ie. for entities in the area)
    entity_map::Array{Union{Entity, Nothing}, 2}
    # Encodes the type of surface (ie. grass, sand, water) on this tile
    surface_map::Array{Union{SurfaceType, Nothing}, 2}
    # FoodMap, how much food is on this tile (if any)
    food_map::Array{Float64, 2}
end

"""
    `generate_world(size, entities)`

    Create a world of the given size (width, height) by generating the surface tiles,
        food placement, and entities.
"""
function generate_world(size::Tuple{Int64, Int64}) :: World
    w, h = size
    world::World = World(
        w, h,
        Set{Entity}(),
        Array{Union{Entity, Nothing}, 2}(nothing, w, h),
        generate_surface_map(size),
        zeros(Int64, w, h)
    )

    return world
end

"""
    Generate the surface type per tile for the world map, given a size.

    Currently, this function generates a lot of overlapping sines at different angles and
        of different frequencies, normalizes the output 2-dim array and then makes everything above
        0 land (grass or sand) and everything below 0 water.
"""
function generate_surface_map(size::Tuple{Int64, Int64}) :: Array{Union{SurfaceType, Nothing}, 2}
    w,h = size
    indices_x = Vector(1:w)
    indices_y = Vector(1:h)'
    dmap = zeros(Float64, w, h)

    for period in 1:0.5:w*2
        # Pick a random angle
        angle = 2*pi*rand()
        # "Rotate" indices to the angle
        t_values = cos(angle) .* indices_x .+ sin(angle) .* indices_y
        # Randomize phase and amplitude
        phase = rand() * 2 * pi
        amplitude = log(period) * (0.1 + 0.9 * rand())
        # Add values to depth map
        dmap .+= amplitude * sin.(t_values .* (2*pi/period) .+ phase)
    end

    dmap = (dmap .- mean(dmap)) ./ std(dmap)

    return generate_surface_from_depth.(dmap)
end

generate_surface_from_depth(depth::Float64)::SurfaceType = @match depth begin
    d, if d >= 0.2 end => grass
    d, if d >= 0.0 end => sand
    _ => water
end
