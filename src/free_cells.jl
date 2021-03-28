export free_cells, free_string
export add_check, add_card, rm_card

"""
`free_cells` is a set of (up to) four cards
"""
free_cells = Set{Card}

function free_string(FC::free_cells)
    cards = sort(collect(FC))
    nc = length(cards)
    result = ""

    for k = 1:nc
        result *= "[" * string(cards[k]) * "] "
    end
    for k = nc+1:4
        result *= "[--] "
    end
    return result
end


"""
`add_card(FC::free_cells, PC::Card)::Bool` adds the card `PC`
to the free cells, returning `true` is ok.
"""
function add_card(FC::free_cells, PC::Card)::Bool
    if length(FC) > 3
        return false
    end
    push!(FC, PC)
    return true
end

"""
`rm_card(FC::free_cells, PC::Card)::Bool` removes the card `PC`
from the free cells `FC`, returning `true` if successful. 
"""
function rm_card(FC::free_cells, PC::Card)::Bool
    if PC ∉ FC
        return false
    end
    delete!(FC, PC)
    return true
end

"""
`add_check(FC::free_cells,PC::Card)::Bool` checks if there's room 
in the freecells to add the card.
"""
function add_check(c::free_cells, ::Card)::Bool
    return length(c) < 4
end
