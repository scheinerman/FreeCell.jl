export Tableau, score

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


function Tableau(d::Vector{Card})
    C = cascade(d)
    T = Tableau()
    for k = 1:8
        T.Casc.piles[k] = C.piles[k]
    end
    return T
end


function show(io::IO, T::Tableau)
    println(io, "Free Cells: $(free_string(T.Free))")
    println(io, "Foundation:")
    println(io, T.Found)
    println(io, "Cascade:")
    print(T.Casc)
end


"""
`score(T::Tableau)` is the number of cards moved into the foundation.
"""
function score(T::Tableau)::Int
    return length(T.Found)
end

function hash(T::Tableau, h::UInt)
    a = hash(T.Free, h)
    b = hash(T.Found.piles, h)
    c = hash(T.Casc.piles, h)

    hash([a, b, c])
end

function (==)(T::Tableau, TT::Tableau)
    T.Free == TT.Free && TT.Found.piles == TT.Found.piles && TT.Casc.piles == TT.Casc.piles
end
