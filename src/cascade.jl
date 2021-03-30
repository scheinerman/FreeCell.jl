export cascade

"""
A `cascade` consists of the eight piles of cards on the main
part of a FreeCell tableau.
+ `cascade()` creates an empty cascade
+ `cascade(deck())` creates a full cascade from a deck of cards
"""
struct cascade
    piles::Vector{Vector{Card}}
    function cascade()
        p = Vector{Vector{Card}}(undef, 8)
        for k = 1:8
            p[k] = Card[]
        end
        new(p)
    end
end

function cascade(d::Vector{Card})
    C = cascade()
    for i = 1:4
        a = 7 * (i - 1) + 1
        b = 7i
        C.piles[i] = d[a:b]
    end

    for k = 5:8
        i = k - 4
        a = 28 + 6 * (i - 1) + 1
        b = 28 + 6i
        C.piles[k] = d[a:b]
    end

    return C
end

function string(C::cascade)::String
    result = ""
    for k = 1:8
        result *= row_string(C.piles[k])
        if k < 8
            result *= "\n"
        end
    end
    return result
end

function show(io::IO, C::cascade)
    print(io, string(C))
end


"""
`add_check(C::cascade, k::Int, PC::Card)::Bool`
checks to see if card `PC` may be added to pile `k`
of the cascade `C`.
"""
function add_check(C::cascade, k::Int, PC::Card)::Bool
    if k < 0 || k > 8      # no such pile!
        return false
    end

    if length(C.piles[k]) == 0  # may always add to an empty 
        return true
    end

    LC = C.piles[k][end]   # get last card in this pile 
    return rank(LC) == rank(PC) + 1 && color(LC) != color(PC)
end

"""
`add_card(C::cascade, k::Int, PC::Card)::Bool` adds the card `PC` 
to pile `k` of `C`.
"""
function add_card(C::cascade, k::Int, PC::Card)::Bool
    if !add_check(C, k, PC)
        return false
    end
    push!(C.piles[k], PC)
    return true
end

"""
`get_card(C::cascade,k)` returns the bottom card in pile `k` of 
cascade `C`.
"""
function get_card(C::cascade, k::Int)::Card
    p = C.piles[k]
    if length(p) == 0
        error("Attempt to get card from empty cascade pile $k")
    end
    return p[end]
end

"""
`rm_card(C::cascade, k::Int)::Card` removes the last card from pile `k`
of cascade `C`.
"""
function rm_card(C::cascade, k::Int)::Card
    PC = get_card(C, k)
    C.piles[k] = C.piles[k][1:end-1]
    return PC
end

"""
`score(pile::Vector{Card})` subtacts 1 for each card on the pile, 
but adds 1 back in for builds at the bottom.
"""
function score(pile::Vector{Card})
    n = length(pile)
    result = -n

    if n<2
        return result 
    end 

    for k=n:-1:2 
        if color(pile[k]) != color(pile[k-1]) && rank(pile[k]) == rank(pile[k-1])-1
            result += 1 
        else 
            break 
        end
    end
    return result

end

"""
`score(C::cascade)` is the sum of the scores of the piles in `C` 
"""
score(C::cascade) = sum(score(p) for p in C.piles)