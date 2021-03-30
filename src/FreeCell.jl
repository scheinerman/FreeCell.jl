module FreeCell
using PlayingCards, ImplicitGraphs

import Base: show, string, length, isempty, hash, (==)

# A FreeCell tableau consists of:
# * four free cells
# * four foundations
# * eight cascades

ace_high(false)


function row_string(list::Vector{Card})::String
    if length(list) == 0
        return "--"
    end
    result = ""
    for c in list
        result *= string(c)
        if c != list[end]
            result *= " "
        end
    end
    return result
end

export score


include("free_cells.jl")
include("foundation.jl")
include("cascade.jl")
include("tableau.jl")
include("mover.jl")


end # module
