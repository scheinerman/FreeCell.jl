export free_cell, is_empty, get_card, add_card, rm_card


"""
A `free_cell` is one of the free cells in FreeCell.
"""
mutable struct free_cell
    card::Card
    empty::Bool
    function free_cell()
        new(Card(1), true)
    end
end

"""
`is_empty(c::free_cell)` returns `true` if the free cell is unoccupied.
"""
is_empty(c::free_cell) = c.empty

"""
`get_card(c::free_cell)` returns the Card in that cell or throws 
and error if the cell is empty.
"""
function get_card(c::free_cell)::Card
    if is_empty(c)
        error("No card in this free cell")
    end
    return c.card
end

"""
`add_card(c::free_cell, PC::Card)::Bool` places the card `PC`
into the cell (if it is empty) and returns `true`. Otherwise
(if the cell is empty) returns `false`.
"""
function add_card(c::free_cell, PC::Card)::Bool
    if !is_empty(c)
        return false
    end
    c.card = PC
    c.empty = false
    return true
end

"""
`rm_card(c::free_cell)` removes the card held in `c` and 
returns that card. Note that an error is thrown if the cell
is empty.
"""
function rm_card(c::free_cell)::Card
    PC = get_card(c)
    c.empty = true
    return PC
end

function show(io::IO, c::free_cell)
    str = "  "
    if is_empty(c)
        print(io, "[--]")
    else
        PC = get_card(c)
        print(io, "[$PC]")
    end
end
