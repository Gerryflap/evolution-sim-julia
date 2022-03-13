abstract type Entity end

"""
    Perform a step for this entity
"""
function entity_step(entity::Entity) :: Void
    # Do nothing
end

"""
    Draw the entity, given the Cairo context ctx of the canvas
"""
function entity_draw(entity::Entity, ctx) :: Void
    # Do Nothing
end