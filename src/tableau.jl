export Tableau, Victory

"""
A `Tableau` is a full position in FreeCell with four free cells,
a foundation, and a cascade. 
+ `Tableau()` creates an empty Tableau 
+ `Tableau(deck())` is the way to start with a shuffled deck
"""
struct Tableau
    Free::free_cells
    Found::foundation
    Casc::cascade
    function Tableau()
        FC = free_cells()
        FD = foundation()
        CC = cascade()
        new(FC, FD, CC)
    end
end

"""
`Victory()` returns the tableau in which all cards have been 
moved into the foundation.
"""
function Victory()::Tableau
    T = Tableau()
    for k = 1:52
        add_card(T.Found, Card(k))
    end
    return T
end


function Tableau(d::Vector{Card})
    C = cascade(d)
    T = Tableau()
    for k = 1:8
        T.Casc.piles[k] = C.piles[k]
    end
    return T
end


function show(io::IO, T::Tableau)
    wide = 38
    println(io, "-"^wide)
    println(io, "Free Cells: $(free_string(T.Free))")
    println(io, "Foundation:")
    println(io, T.Found)
    println(io, "Cascade:")
    println(io, T.Casc)
    print(io, "="^wide)
end


"""
`score(T::Tableau)` is the number of cards moved into the foundation.
"""
function score(T::Tableau)::Number
    return -(10*score(T.Free) + 10 * score(T.Found) + score(T.Casc))
 end

function hash(T::Tableau, h::UInt)
    a = hash(T.Free, h)
    b = hash(T.Found.piles, h)
    c = hash(T.Casc.piles, h)

    hash([a, b, c])
end

function (==)(T::Tableau, TT::Tableau)
    T.Free == TT.Free && T.Found.piles == TT.Found.piles && T.Casc.piles == TT.Casc.piles
end
