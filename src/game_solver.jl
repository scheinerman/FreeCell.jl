export free_cell_solver, display_solution

"""
    free_cell_solver(T::Tableau; depth::Int=1, verbose::Int=0)

Solve a free_cell game `T` using the `guided_path_finder` function from
`ImplicitGraphs`.

* `depth` is the amount of look ahead
* `verbose` sets reporting frequency (0 for no reporting)
"""
function free_cell_solver(S::Tableau; depth::Int = 1, verbose::Int = 0)
    G = free_cell_graph()
    T = Victory()
    X = guided_path_finder(G, S, T, score = score, depth = depth, verbose = verbose)
    return X
end


"""
    display_solution(X::Vector{Tableau}, pause=0.5)

Print out a list of free_cell positions (presumably output from `free_cell_solver`)
with `pause` seconds of delay between each step.
"""
function display_solution(X::Vector{Tableau}, pause = 0.5)
    n = length(X)
    for j = 1:n
        println("Step $j of $n")
        println(X[j])
        println()
        sleep(pause)
    end
    nothing
end


function solver_test(T::Tableau, max_depth::Int = 2)
    XX = []
    for d = 1:max_depth
        println("Solving at depth = $d")
        @time X = free_cell_solver(T, depth = d)
        println("Solution has $(length(X)) moves\n")
        push!(XX, X)
    end
    return XX
end
