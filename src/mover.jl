export move_maker

"""
`move_maker(T::Tableau)` generates the list of all possible next positions.
"""
function move_maker(T::Tableau)::Vector{Tableau}
    # out = Set{Tableau}()   # place to put the answer
    out = Tableau[]

    # PART 1: Move last card in cascade piles

    for k = 1:8
        p = T.Casc.piles[k]
        if length(p) == 0
            continue
        end
        C = p[end]  # last card in this pile 

        # 1a Move to another cascade pile 

        for j = 1:8
            if j != k
                if add_check(T.Casc.piles[j], C)  # see if we can add C to pile j
                    TT = deepcopy(T)
                    rm_card(TT.Casc, k)
                    add_card(TT.Casc, j, C)
                    push!(out, TT)
                end

            end
        end

        # 1b Move to foundation

        if add_check(T.Found, C)
            TT = deepcopy(T)
            rm_card(TT.Casc, k)
            add_card(TT.Found, C)
            push!(out, TT)
        end

        # 1c Move to a freecell 

        if add_check(T.Free, C)
            TT = deepcopy(T)
            rm_card(TT.Casc, k)
            add_card(TT.Free, C)
            push!(out, TT)
        end

    end


    # Part 2: Move a card from a Free Cell

    for C in T.Free

        # 2a move to Tableau 

        for k = 1:8
            if add_check(T.Casc.piles[k], C)
                TT = deepcopy(T)
                rm_card(TT.Free, C)
                add_card(TT.Casc, k, C)
                push!(out, TT)
            end
        end

        # 2b move to Foundation 
        if add_check(T.Found, C)
            TT = deepcopy(T)
            rm_card(TT.Free, C)
            add_card(TT.Found, C)
            push!(out, TT)
        end


    end



    return collect(out) # report as a list for ImplicitGraph
end
