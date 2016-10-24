# AI for for the Japanese chess game Shogi.
# game logic provided by shogi.jl and move_functions.jl

include("shogi.jl")

# generate current unix time for seed
UT = DateTime(1970)
function datetime2unix()
    return Int64((DateTime(now())-UT)/1000)
end
seed = datetime2unix()
println(seed)
# reseed RNG w/ seed
srand(seed)

type AI
    set::Pieces # piece class holds the AI's pieces and cords
    legal::Array # holds legal moves for the current turn
    AI(side::Pieces) = new(side,Tuple{Int,Int}[])
end

function clear_array(A::Array)
    len = length(A)
    deleteat!(julia.legal,1:len)
end




function choose_piece(set::Pieces) 
    A = collect(keys(AI.set.active))
    piece = rand(A)
    return piece
end

function choose_move(set::Pieces, legal::Array, enemy::Pieces)
    kills = Dict() 
    for i = 1:length(legal)
        piece = enemy.activeS[legal[i]]
        if haskey(enemy.activeS,legal[i]) == true
            AI.kill = 1
            if piece[1] == 'p'
                get!(kills,1,legal[i])
            elseif piece[1] == 'n'
                get!(kills,2,legal[i])
            elseif piece[1] == 's'
                get!(kills,1,legal[i])
            elseif piece[1] == 'l'
                get!(kills,4,legal[i])
            elseif piece[1] == 'r' 
                get!(kills,6,legal[i])
            elseif piece[1] == 'b' 
                get!(kills,7,legal[i])
            elseif piece[1] == 'R'
                get!(kills,8,legal[i])
            elseif piece[1] == 'B'
                get!(kills,9,legal[i])
            elseif piece[1] == 'k'
                get!(kills,10,legal[i])
            else
                get!(kills,5,legal[i])
            end
        end
    end
    if length(kills) != 0
        max = 0
        for pair in kills
            pair[1] > max && (max = pair[1])
        end
        return Pair(max,kills[max])
    else
        cords = rand(legal)
        return Pair(0,cords)
    end  
end

# generates all possible moves, stores into entire legal array
function generate_moves(set::Pieces, legal::Array, piece)
    if piece[1] == 'k'
        legal = king_AI(set,legal,piece)
    elseif piece[1] == 'r' || piece[1] == 'R'
        legal = rook_AI(set,legal,piece)
    elseif piece[1] == 'b' || piece[1] == 'B'
        legal = bishop_AI(set,legal,piece)
    elseif piece[1] == 'g'
        legal = gold_general_AI(set,legal,piece)
    elseif piece[1] == 's' || piece[1] == 'S'
        legal = silver_general_AI(set,legal,piece)
    elseif piece[1] == 'n' || piece[1] == 'N'
        legal = knight_AI(set,legal,piece)
    elseif piece[1] == 'p' || piece[1] == 'P'
        legal = pawn_AI(set,legal,piece)
    elseif piece[1] == 'l' || piece[1] == 'L'
        legal = lancer_AI(set,legal,piece)
    end
    return legal
end

# returns the score
function score(active::Pieces, inactive::Pieces)
    # black pieces left on board +1
    # red pieces left on board -1
    if active.color == "black"
        pos = length(active.active)
        neg = -length(inactive.active)
        # return the score
        return pos+neg
    else    # active.color == "red"
        pos = length(inactive.active)
        neg = -length(active.active)
        # return the score
        return pos+neg
    end
end

# Minimax w/ alpha-beta pruning algorithm for AI
function minimax_AB(active::Pieces, inactive::Pieces, alpha, beta, depth, limit)
    # maximizer
    if active.color == "black"
        return max_AB(active,inactive,alpha,beta,depth,limit)
    # minimizer
    else 
        return min_AB(active,inactive,alpha,beta,depth,limit)
    end
end

function max_AB(active::Pieces, inactive::Pieces, alpha, beta, depth, limit)
    println("maximizer turn")
    best_move::Tuple{Tuple{ASCIIString,Tuple{Int64,Int64}},Int64} 
    best_move = (("NULL",(0,0)),score(active,inactive))
    # if depth is reached, recurse back
    if depth == limit 
        return best_move
    else
        A = collect(keys(active.active)) 
        #println(A)
        # generate all possible moves for each piece on black
        for j = 1:length(A) 
            piece = A[j]; legal = Tuple{Int,Int}[] 
            generate_moves(active,legal,piece) 
            # println(piece)
            # println(legal)
            cords = active.active[piece]
            # analyse each possible move
            for i = 1:length(legal) 
                old_alpha::Float64 = alpha
                old_cords = active.active[piece] # save old coordinates
                # simulate move
                update_piece(active,piece,legal[i])
                dead::ASCIIString = check_kill(inactive,legal[i])
                #println("dead = $dead")
                # recursive call to minimizer
                AB = min_AB(inactive,active,alpha,beta,depth+1,limit)
                alpha = max(alpha,AB[2])
                # update best_move
                old_alpha < alpha && (best_move = ((piece,legal[i]),alpha))  
                # reverse simulation
                update_piece(active,piece,old_cords)
                dead != "NULL" && raise_dead(inactive,dead,legal[i])
                # check for alpha-beta pruning
                if alpha >= beta 
                    println("pruned")
                    return best_move
                end     
            end
        end
    end
    return best_move
end

function min_AB(active::Pieces, inactive::Pieces, alpha, beta, depth, limit)
    println("minimizer turn")
    best_move::Tuple{Tuple{ASCIIString,Tuple{Int64,Int64}},Int64} 
    best_move = (("NULL",(0,0)),score(active,inactive))
    # if depth is reached, recurse back
    if depth == limit 
        return best_move
    else
        # generate all possible moves for each piece on black
        A = collect(keys(active.active)) 
        for j = 1:length(A) 
            piece = A[j]; legal = Tuple{Int,Int}[] 
            generate_moves(active,legal,piece) 
            # println(piece)
            # println(legal)
            # analyse each possible move
            for i = 1:length(legal)
                old_beta::Float64 = beta
                old_cords = active.active[piece] # save old coordinates
                # simulate move
                update_piece(active,piece,legal[i])
                dead::ASCIIString = check_kill(inactive,legal[i])
                #println("$piece killed $dead")
                # recursive call to minimizer
                AB = max_AB(inactive,active,alpha,beta,depth+1,limit)
                beta = min(beta,AB[2])
                # update best_move
                old_beta > beta && (best_move = ((piece,legal[i]),beta))
                # reverse simulation
                update_piece(active,piece,old_cords)
                dead != "NULL" && raise_dead(inactive,dead,legal[i])
                # check for alpha-beta pruning
                if alpha >= beta
                    println("pruned")
                    return best_move
                end  
            end
        end
    end
    return best_move
 end

### TESTING

# initialize sides and AI - with its side
red = Pieces("red")
fill_red(red)
black = Pieces("black")
fill_black(black)

# legal = Tuple{Int,Int}[] 
# legal = generate_moves(black,legal,"s2")
# println(legal)
#julia = AI(black)

# update_piece(red,"p1",(1,6))
# update_piece(red,"p2",(2,6))
# update_piece(red,"p3",(3,6))
# update_piece(red,"p4",(4,6))
# update_piece(red,"p5",(5,6))
# update_piece(red,"p6",(6,6))
# update_piece(red,"p7",(7,6))
# update_piece(red,"p8",(8,6))
# update_piece(red,"p9",(9,6))

minimax_AB(black,red,-Inf,Inf,0,3)
# for Pair in black.active
#     println(Pair)
# end

# cords = black.active["n1"]
# println(black.active["n1"])
# println(black.activeS[cords])

# fill the AI pieces 
# fill_black(julia.set)









