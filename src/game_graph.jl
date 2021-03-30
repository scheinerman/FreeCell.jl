export free_cell_graph


"""
`free_cell_graph()` returns an `ImplicitGraph` whose vertices 
are all possible FreeCell game positions in which there is an 
edge from `S` to `T` if there's a game move from `S` to `T`.
"""
function free_cell_graph()
    vcheck(::Tableau) = true
    return ImplicitGraph{Tableau}(vcheck, move_maker)
end
