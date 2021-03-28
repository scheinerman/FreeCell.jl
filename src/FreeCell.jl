module FreeCell
using PlayingCards, ImplicitGraphs

import Base: show, string, length

# A FreeCell tableau consists of:
# * four free cells
# * four foundations
# * eight cascades




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



include("free_cell.jl")
include("foundation.jl")
include("cascade.jl")

end # module
