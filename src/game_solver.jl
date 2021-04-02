using PlayingCards52, FreeCell, DataStructures, ImplicitGraphs

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

    best_Tab = T 
    best_Found = length(T.Found)

    while length(PQ) > 0
        count += 1
        S = dequeue!(PQ)
        push!(visited, S)    # note that we expanded this node 
        found_size = length(S.Found)

        if found_size > best_Found 
            best_Tab = T 
            best_Found = found_size
        end 




        stepper = 3

        if found_size > 15
            stepper = 2
            report = 500
        end
        
        if found_size > 48
            break 
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
                println("Maximum Foundation:     $best_Found")
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

    if verbose
        println("Switching to end-game mode")
    end

    TT = Victory()

    G = free_cell_graph()
    P = find_path(G, best_Tab, TT)
    
    for k=1:length(P)-1
        trace_back[P[k+1]] = P[k]
    end


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

    println()
    println("="^60)
    println("Solution path has $(length(result)) positions")
    println("="^60)
    println()

    for TT in result
        println(TT)
    end 
        
        

    # return trace_back


end



## DEBUG ##

function almost()::Tableau
    T = Tableau()
    D = deck(false)
    for j=1:48
        add_card(T.Found,D[j])
    end
    add_card(T.Casc,1,D[end])
    push!(T.Casc.piles[1], D[end-2])
    push!(T.Casc.piles[1], D[end-1])
    add_card(T.Free,D[end-3])

    return T 
end 