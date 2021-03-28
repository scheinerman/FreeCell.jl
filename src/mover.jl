export move_maker

"""
`move_maker(T::Tableau)` generates a list of all possible next positions.
"""
function mover_maker(T::Tableau)
    out = Set{Tableau}()   # place to put the answer



    return collect(out) # report as a list for ImplicitGraph
end