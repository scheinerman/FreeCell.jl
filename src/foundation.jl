export foundation, add_check, add_card

"""
A `foundation` consists of the four piles (one per suit) built up 
starting with aces and ending with kings.
"""
struct foundation
    piles::Dict{Symbol,Vector{Card}}
    function foundation()
        p = Dict{Symbol,Vector{Card}}()
        for s in PlayingCards.suit_list
            p[s] = Card[]
        end
        new(p)
    end
end

function length(F::foundation)::Int
    return sum(length(p[end]) for p in F.piles)
end



function string(F::foundation)::String
    result = ""
    for k = 1:4
        s = PlayingCards.suit_list[k]
        result *= row_string(F.piles[s])
        if k < 4
            result *= "\n"
        end
    end
    return result
end



function show(io::IO, F::foundation)
    print(io, string(F))
end

"""
`add_check(F::foundation, C::Card)::Bool`
checks to see if `C` may be added to `F`.
"""
function add_check(F::foundation, PC::Card)::Bool
    s = suit(PC)
    r = rank(PC)

    pile = F.piles[s]
    if length(pile) == 0  # may only add an Ace to an empty pile
        if r == 1
            return true
        else
            return false
        end
    end

    if rank(pile[end]) + 1 == r  # may add if our rank is 1 larger than last card
        return true
    end

    return false
end

"""
`add_card(F::foundation, PC::Card)` adds the card `PC`
to `F` returning `true` if successful.
"""
function add_card(F::foundation, PC::Card)::Bool
    if !add_check(F, PC)
        return false
    end
    s = suit(PC)
    push!(F.piles[s], PC)
    return true
end
