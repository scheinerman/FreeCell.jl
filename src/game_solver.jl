using PlayingCards52, FreeCell, DataStructures

"""
`edge_generator(T,depth)` creates forward edges from `T`
to the given `depth`.
"""
function edge_generator(T::Tableau, depth::Int = 1)
    @assert depth > 0

    if depth == 1
        outs = move_maker(T)
        return [(T, S) for S in outs]
    end

    edges = edge_generator(T, depth - 1)
    result = Tuple{Tableau,Tableau}[]
    for (A, B) in edges
        push!(result, (A, B))
        NB = move_maker(B)
        for C in NB
            push!(result, (B, C))
        end
    end
    return result
end



function game_solver(T::Tableau, verbose::Bool = true)
    PQ = PriorityQueue{Tableau,Int}()     # List of nodes to consider
    visited = Set{Tableau}()               # Visited game positions
    trace_back = Dict{Tableau,Tableau}()  # Reverse edges 
    trace_back[T] = T
    stop = Victory()    # winning position

    PQ[T] = -score(T)    # push the initial position into the queue

    count = 0
    report = 100

    while length(PQ) > 0
        count += 1
        S = dequeue!(PQ)
        push!(visited, S)    # note that we expanded this node 
        # NS = move_maker(S)   # all out nodes from S 

        stepper = 3
        found_size = sum(length.(values(S.Found.piles)))
        if found_size > 10
            stepper = 2
        end
        if found_size > 26
            stepper = 1
        end


        edges = edge_generator(S, stepper)


        for (P, R) in edges
            if R ∈ visited
                continue
            end
            push!(visited, R)
            trace_back[R] = P

            if R == stop
                break
            end

            PQ[R] = -score(R)
        end

        if verbose
            if count % report == 0
                println("Stepper:                $stepper")
                println("Number of iterations:   $count")
                println("Size of queue:          $(length(PQ))")
                println("Number visited:         $(length(visited))")
                println("Traceback edges:        $(length(trace_back))")
                H, s = peek(PQ)
                println("Head of queue score:    $(-s)")
                println(H)
                println()
            end
        end


    end

    TT = Victory()
    result = Tableau[]
    while true 
        push!(result, TT)
        TT = trace_back[TT]
        if TT == T 
            break 
        end
    end
    push!(result, T)
    reverse!(result)

    for TT in result
        println(TT)
    end 
        
        

    return trace_back


end



## DEBUG ##

function almost()::Tableau
    T = Tableau()
    D = deck(false)
    for j=1:50
        add_card(T.Found,D[j])
    end
    add_card(T.Casc,1,D[end])
    add_card(T.Casc,2,D[end-1])
    return T 
end 