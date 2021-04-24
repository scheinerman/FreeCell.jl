using PlayingCards52, FreeCell, ImplicitGraphs


function game_solver(S::Tableau; depth::Int=1, verbose::Int=0)
    G = free_cell_graph()
    T = Victory()
    X = guided_path_finder(G,S,T,score=score,depth=depth,verbose=verbose)
    return X 
end


function display_solution(X::Vector{Tableau})
    for j=1:length(X)
        println("Step $j")
        println(X[j])
        println()
        sleep(1)
    end
    nothing
end
