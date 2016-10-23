# AI for for the Japanese chess game Shogi.
# game logic provided by shogi.jl and move_functions.jl

include("shogi.jl")

# generate current unix time for seed
seed = Int64(datetime2unix(now()))
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

# finds all the possible moves for king given its position
function king_AI(set::Pieces, legal::Array, piece::ASCIIString)
    # initial x and y cords 
    x = set.active[piece][1]; y = set.active[piece][2] 
    cords::Tuple{Int64,Int64} # stores possible coordinates 
    # friendly units
    friends = set.activeS
    cords = (x,y+1)  # move up
    if y != 9 && haskey(friends,cords) != true
        push!(legal,cords) 
    end
    cords = (x,y-1) # move down
    if y != 1 && haskey(friends,cords) != true
        push!(legal,cords)
    end
    cords = (x+1,y) # move right    
    if x != 9 && haskey(friends,cords) != true
        push!(legal,cords)
    end
    cords = (x-1,y) # move left
    if x != 0 && haskey(friends,cords) != true
        push!(legal,cords)
    end
    return legal
end

# finds all the possible moves for bishop given its position
function bishop_AI(set::Pieces, legal::Array, piece::ASCIIString)
    # initial x and y cords 
    x = set.active[piece][1]; y = set.active[piece][2] 
    cords = Tuple{Int64,Int64} # stores possible coordinates
    # friendly units
    friends = set.activeS
    # if piece is promoted add additional moves of king
    piece == "B" && king_AI(AI,piece)
    # moves towards top right
    x > y ? (n = 9-x) : (n = 9-y)
    for i = 1:n
        cords = (x+i,y+i)
        if haskey(friends,cords) != true
            push!(legal,cords) # if move is open
        else break # no more possible moves in path
        end
    end
    # moves towards the bottom right
    x < y ? (n = x-1) : (n = y-1) # have to stop at 1 not 0
    for i = 1:n
        cords = (x+i,y-i)
        if haskey(friends,cords) != true
            push!(legal,cords) # if move is open
        else break # no more possible moves in path
        end
    end
    # moves towards bottom left
    x < y ? (n = x-1) : (n = y-1) # have to stop at 1 not 0
    for i = 1:n
        cords = (x-i,y-i)
        if haskey(friends,cords) != true
            push!(legal,cords) # if move is open
        else break # no more possible moves in path
        end
    end
    # moves towards top left
    x > y ? (n = 9-x) : (n = 9 - y)
    for i = 1:n
        cords = (x-i,y+i)
        if haskey(friends,cords) != true
            push!(legal,cords) # if move is open
        else break # no more possible moves in path
        end
    end
    return legal
end

# finds all possible moves for rook given its current coordinates
function rook_AI(set::Pieces, legal::Array, piece::ASCIIString)
    # initial x and y cords 
    x = set.active[piece][1]; y = set.active[piece][2] 
    cords = Tuple{Int64,Int64} # stores possible coordinates
    # friendly units
    friends = set.activeS
    # check if promoted
    piece == "R" && king_AI(AI,piece)
    for i = y+1:9 # move upwards
        cords = (x,i)
        if haskey(friends,cords) != true
            push!(legal,cords)
        else break
        end
    end
    for i = y-1:-1:1 # move downwards
        cords = (x,i)
        if haskey(friends,cords) != true
            push!(legal,cords)
        else break
        end
    end
    for i = x+1:9 # move rightwards
        cords = (i,y)
        if haskey(friends,cords) != true
            push!(legal,cords)
        else break
        end
    end
    for i = x-1:-1:1
     # move leftwards
        cords = (i,y)
        if haskey(friends,cords) != true
            push!(legal,cords)
        else break
        end
    end
    return legal
end

# finds all possible moves for black gold general given its current coordinates
function black_gold_general_AI(set::Pieces, legal::Array, piece::ASCIIString)
    # initial x and y cords 
    x = set.active[piece][1]; y = set.active[piece][2] 
    # friendly units
    friendly = set.activeS
    if y != 1 && x != 1 && x != 9 
        haskey(friendly,(x,y-1)) == 0 && push!(legal,(x,y-1))
        haskey(friendly,(x-1,y-1)) == 0 && push!(legal,(x-1,y-1))
        haskey(friendly,(x+1,y-1)) == 0 && push!(legal,(x+1,y-1))
        # add left and right movement
        haskey(friendly,(x+1,y)) == 0 && push!(legal,(x+1,y))
        haskey(friendly,(x-1,y)) == 0 && push!(legal,(x-1,y))
    elseif y == 1 && x != 1 && x != 9
        haskey(friendly,(x-1,y)) == 0 && push!(legal,(x-1,y))
        haskey(friendly,(x+1,y)) == 0 && push!(legal,(x+1,y))
    elseif y != 1 && x == 9 # if piece is on right side of board, and y != 1
        haskey(friendly,(x-1,y-1)) == 0 && push!(legal,(x-1,y-1))
        haskey(friendly,(x-1,y)) == 0 && push!(legal,(x-1,y))
    elseif y != 1 && x == 1 # if piece is on left side of board, and y != 1
        haskey(friendly,(x+1,y-1)) == 0 && push!(legal,(x+1,y-1))
        haskey(friendly,(x+1,y)) == 0 && push!(legal,(x+1,y))
    elseif x == 9 # if x == 9 and y == 1
        haskey(friendly,(x-1,y)) == 0 && push!(legal,(x-1,y))
    elseif x == 1 # if x == 1 and y = 1
        haskey(friendly,(x+1,y)) == 0 && push!(legal,(x+1,y))
    end
    # adds the backstep allowable coordinates
    if y != 9
        haskey(friendly,(x,y+1)) == 0 && push!(legal,(x,y+1))
    end
    return legal
end

# finds all possible moves for red gold general given its current coordinates
function red_gold_general_AI(set::Pieces, legal::Array, piece::ASCIIString)
    # initial x and y cords 
    x = set.active[piece][1]; y = set.active[piece][2] 
    # friendly units
    friendly = set.activeS
    if y != 9 && x != 9 && x != 1 
        haskey(friendly,(x,y+1)) == 0 && push!(legal,(x,y+1))
        haskey(friendly,(x+1,y+1)) == 0 && push!(legal,(x+1,y+1))
        haskey(friendly,(x-1,y+1)) == 0 && push!(legal,(x-1,y+1))
        # add left and right movement
        haskey(friendly,(x+1,y)) == 0 && push!(legal,(x+1,y))
        haskey(friendly,(x-1,y)) == 0 && push!(legal,(x-1,y))
    elseif y == 9 && x != 9 && x != 1
        haskey(friendly,(x-1,y)) == 0 && push!(legal,(x-1,y))
        haskey(friendly,(x+1,y)) == 0 && push!(legal,(x+1,y))
    elseif y != 9 && x == 9 # if piece is on left side of board, and y != 9
        haskey(friendly,(x-1,y+1)) == 0 && push!(legal,(x-1,y+1))
        haskey(friendly,(x,y+1)) == 0 && push!(legal,(x,y+1))
        haskey(friendly,(x-1,y)) == 0 && push!(legal,(x-1,y))
    elseif y != 9 && x == 1 # if piece is on right side of board, and y != 9
        haskey(friendly,(x+1,y+1)) == 0 && push!(legal,(x+1,y+1))
        haskey(friendly,(x,y+1)) == 0 && push!(legal,(x,y+1))
        haskey(friendly,(x+1,y)) == 0 && push!(legal,(x+1,y))
    elseif x == 9 # if y == 9 and x == 9
        haskey(friendly,(x-1,y)) == 0 && push!(legal,(x-1,y))
    elseif x == 1 # if x == 1 and y = 9
        haskey(friendly,(x+1,y)) == 0 && push!(legal,(x+1,y))
    end
    if y != 1
        haskey(set.activeS,(x,y-1)) == 0 && push!(legal,(x,y-1))
    end
    return legal
end

# this function will be called in the main, and calls correct gold general function 
function gold_general_AI(set::Pieces, legal::Array, piece::ASCIIString)
    AI.set.color == "black" ? 
        black_gold_general_AI(set,legal,piece) : 
        red_gold_general_AI(set,legal,piece)
end

# finds all possible moves for black silver general given its current coordinates
function black_silver_general_AI(set::Pieces, legal::Array, piece::ASCIIString)
    # initial x and y cords 
    x = set.active[piece][1]; y = set.active[piece][2] 
    # friendly units
    friendly = set.activeS
    if piece[1] == 'S'
        legal = black_gold_general_AI(set,legal,piece)
        return legal
    elseif y != 1 && x != 1 && x != 9 # if piece is not on a boundary
        haskey(friendly,(x,y-1)) == 0 && push!(legal,(x,y-1))
        haskey(friendly,(x-1,y-1)) == 0 && push!(legal,(x-1,y-1))
        haskey(friendly,(x+1,y-1)) == 0 && push!(legal,(x+1,y-1))
    elseif y != 1 && x == 9 # if piece is on right side of board, and y != 1
        haskey(friendly,(x-1,y-1)) == 0 && push!(legal,(x-1,y-1))
        haskey(friendly,(x,y-1)) == 0 && push!(legal,(x,y-1))
    elseif y != 1 && x == 1 # if piece is on left side of board, and y != 1
        haskey(friendly,(x+1,y-1)) == 0 && push!(legal,(x+1,y-1))
        haskey(friendly,(x,y-1)) == 0 && push!(legal,(x,y-1))
    end
    if y != 9 # check for allowable backwards movement
        haskey(friendly,(x+1,y+1)) == 0 && push!(legal,(x+1,y+1))
        haskey(friendly,(x-1,y+1)) == 0 && push!(legal,(x-1,y+1))
    end
    return legal
end

# finds all possible moves for red silver general given its current coordinates
function red_silver_general_AI(set::Pieces, legal::Array, piece::ASCIIString)
    # initial x and y cords 
    x = set.active[piece][1]; y = set.active[piece][2] 
    # friendly units
    friendly = set.activeS
    if piece[1] == 'S' # if silver general is promoted
        legal = red_gold_general_AI(AI,piece)
        return legal
    elseif y != 9 && x != 9 && x != 1 
        hashkey(friendly,(x,y+1)) == 0 && push!(legal,(x,y+1))
        haskey(friendly,(x+1,y+1)) == 0 && push!(legal,(x+1,y+1))
        haskey(friendly,(x-1,y+1)) == 0 && push!(legal,(x-1,y+1))
    elseif y != 9 && x == 9 # if piece is on left side of board, and y != 9
        haskey(friendly,(x-1,y+1)) == 0 && push!(legal,(x-1,y+1))
        haskey(friendly,(x,y+1)) == 0 && push!(legal,(x,y+1))
    elseif y != 9 && x == 1 # if piece is on right side of board, and y != 9
        haskey(friendly,(x+1,y+1)) == 0 && push!(legal,(x+1,y+1))
        haskey(friendly,(x,y+1)) == 0 && push!(legal,(x,y+1))
    end
    # check if steps back are allowable coordinates
    if y != 1
        haskey(friendly,(x-1,y-1)) == 0 && push!(legal,(x-1,y-1))
        haskey(friendly,(x+1,y-1)) == 0 && push!(legal,(x+1,y-1))
    end
    return legal
end

# general silver general function calls correct colored silver general function
function silver_general_AI(set::Pieces, legal::Array, piece::ASCIIString)
    AI.set.color == "black" ?
        black_silver_general_AI(set,legal,piece) :
        red_silver_general_AI(set,legal,piece)
end

# determines all possible moves of black knight from given location
function black_knight_AI(set::Pieces, legal::Array, piece::ASCIIString)
    # initial x and y cords 
    x = set.active[piece][1]; y = set.active[piece][2] 
    # friendly units
    friendly = set.activeS
    if piece[1] == 'N' # check for promotion
       legal = black_gold_general_AI(AI,piece)
        return legal
    elseif y > 2 && x != 1 && x != 9 
        haskey(friendly,(x-1,y-2)) == 0 && push!(legal,(x-1,y-2))
        haskey(friendly,(x+1,y-2)) == 0 && push!(legal,(x+1,y-2))
    elseif y > 2 && x == 9 # if piece is on right side of board, and y >= 2
        haskey(friendly,(x-1,y-2)) == 0 && push!(legal,(x-1,y-2))
    elseif y > 2 && x == 1 # if piece is on left side of board, and y >= 2
        haskey(friendly,(x+1,y-2)) == 0 && push!(legal,(x+1,y-2))
    end
    return legal
end

function red_knight_AI(set::Pieces, legal::Array, piece::ASCIIString)
    # initial x and y cords 
    x = set.active[piece][1]; y = set.active[piece][2] 
    # friendly units
    friendly = set.activeS
    if piece[1] == 'N' # check for promotion
        legal = red_gold_general_AI(AI,piece)
        return legal
    elseif y < 8 && x != 9 && x != 1
        haskey(friendly,(x-1,y+2)) == 0 && push!(AI.legal,(x-1,y+2))
        haskey(friendly,(x+1,y+2)) == 0 && push!(legal,(x+1,y+2))
    elseif y < 8 && x == 9 # if piece is on left side of board, and y <= 8
        haskey(friendly,(x-1,y+2)) == 0 && push!(legal,(x-1,y+2))
    elseif y < 8 && x == 1 # if piece is on right side of board, and y <= 8
        haskey(friendly,(x+1,y+2)) == 0 && push!(legal,(x+1,y+2))
    end
    return legal
end

function knight_AI(set::Pieces, legal::Array, piece::ASCIIString)
    AI.set.color == "black" ?
        black_knight_AI(set,legal,piece) :
        red_knight_AI(set,legal,piece)
end

# lancer
function black_lancer_AI(set::Pieces, legal::Array, piece::ASCIIString)
    # initial x and y cords
    x = set.active[piece][1]; y = set.active[piece][2] 
    cords = Tuple{Int64,Int64} # stores possible coordinates
    # friendly units
    friendly = set.activeS
    if piece[1] == 'L' # check for promotion
        legal = black_gold_general_AI(set,legal,piece)
        return legal
    else
        for i = y-1:-1:1 # move downwards
            cords = (x,i)
            if haskey(friendly,cords) != true
                push!(legal,cords)
            else break
            end
        end
    end
    return legal
end

function red_lancer_AI(set::Pieces, legal::Array, piece::ASCIIString)
    # initial x and y cords
    x = set.active[piece][1]; y = set.active[piece][2] 
    cords = Tuple{Int64,Int64} # stores possible coordinates
    # friendly units
    friendly = set.activeS
    if piece[1] == 'L' # check for promotion
        legal = red_gold_general_AI(set,legal,piece)
        return legal
    else
        for i = y+1:9 # move upwards
            cords = (x,i)
            if haskey(friendly,cords) != true
                push!(legal,cords)
            else break
            end
        end
    end
    return legal
end

# this function will be called in the main, and calls correct lancer function 
function lancer_AI(set::Pieces, legal::Array, piece::ASCIIString)
    AI.set.color == "black" ? 
        black_lancer_AI(set,legal,piece) : 
        red_lancer_AI(set,legal,piece)
end

# pawn
function black_pawn_AI(set::Pieces, legal::Array, piece::ASCIIString)
    # initial x and y cords
    x = set.active[piece][1]; y = set.active[piece][2]
    # friendly units
    friendly = set.activeS
    if piece[1] == 'P' # check for promotion
        legal = black_gold_general_AI(set,legal,piece)
        return legal
    else
        if y != 1
            haskey(friendly,(x,y-1)) == 0 && push!(legal,(x,y-1))
        end
    end
    return legal
end

function red_pawn_AI(set::Pieces, legal::Array, piece::ASCIIString)
    # initial x and y cords
    x = set.active[piece][1]; y = set.active[piece][2]
    # friendly units
    friendly = set.activeS
    if piece[1] == 'P' # check for promotion
        legal = red_gold_general_AI(set,legal,piece)
        return legal
    else
        if y != 9
            haskey(friendly,(x,y+1)) == 0 && push!(legal,(x,y+1))
        end
    end
    return legal
end

# this function will be called in the main, and calls correct pawn function 
function pawn_AI(set::Pieces, legal::Array, piece::ASCIIString)
    set.color == "black" ? 
        black_pawn_AI(set,legal,piece) : 
        red_pawn_AI(set,legal,piece)
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
        append!(legal, king_AI(set,legal,piece))
    elseif piece[1] == 'r' || piece[1] == 'R'
        append!(legal, rook_AI(set,legal,piece))
    elseif piece[1] == 'b' || piece[1] == 'B'
        append!(legal,bishop_AI(set,legal,piece))
    elseif piece[1] == 'g'
        append!(legal,gold_general_AI(set,legal,piece))
    elseif piece[1] == 's' || piece[1] == 'S'
        append!(legal,silver_general_AI(set,legal,piece))
    elseif piece[1] == 'n' || piece[1] == 'N'
        append!(legal,knight_AI(set,legal,piece))
    elseif piece[1] == 'p' || piece[1] == 'P'
        append!(legal,pawn_AI(set,legal,piece))
    elseif piece[1] == 'l' || piece[1] == 'L'
        append!(legal,lancer_AI(set,legal,piece))
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
    # if depth is reached, recurse back
    if depth == limit 
        return (("NULL",(0,0)),score(active,inactive))
    else 
        prune::Int64 = 0
        best_move = Tuple{Tuple{ASCIIString,Tuple{Int64,Int64}},Int64}
        # generate all possible moves for each piece on black
        for pair in active.active
            prune == 1 && break # check for pruning
            piece = pair[1]; legal = Tuple{Int,Int}[] 
            generate_moves(active,legal,piece) 
            # analyse each possible move
            for i = 1:length(legal) 
                old_alpha::Float64 = alpha
                old_cords = active.active[piece] # save old coordinates
                # simulate move
                update_piece(active,piece,legal[i])
                dead::ASCIIString = check_kill(inactive,legal[i])
                # recursive call to minimizer
                AB = min_AB(inactive,active,alpha,beta,depth+1,limit)
                alpha = max(alpha,AB[2])
                old_alpha < alpha && (best_move = ((piece,legal[i]),alpha))
                # reverse move
                update_piece(active,piece,old_cords)
                dead != "NULL" && raise_dead(inactive,dead,old_cords)
                # check for alpha-beta pruning
                if alpha >= beta 
                    prune = 1;
                    break
                end
            end
        end
    end
    return best_move
end

function min_AB(active::Pieces, inactive::Pieces, alpha, beta, depth, limit)
    println("minimizer turn")
    # if depth is reached, recurse back
    if depth == limit 
        return (("NULL",(0,0)),score(active,inactive))
    else
        prune::Int64 = 0
        best_move = Tuple{Tuple{ASCIIString,Tuple{Int64,Int64}},Int64}
        # generate all possible moves for each piece on black
        for pair in active.active
            prune == 1 && break # check for pruning
            piece = pair[1]; legal = Tuple{Int,Int}[] 
            generate_moves(active,legal,piece) 
            # analyse each possible move
            for i = 1:length(legal) 
                old_beta::Float64 = beta
                old_cords = active.active[piece] # save old coordinates
                # simulate move
                update_piece(active,piece,legal[i])
                dead::ASCIIString = check_kill(inactive,legal[i])
                # recursive call to minimizer
                AB = max_AB(inactive,active,alpha,beta,depth+1,limit)
                beta = min(beta,AB[2])
                old_beta > beta && (best_move = ((piece,legal[i]),beta))
                # reverse move
                update_piece(active,piece,old_cords)
                dead != "NULL" && raise_dead(inactive,dead,old_cords)
                # check for alpha-beta pruning
                if alpha >= beta 
                    prune = 1;
                    break
                end
            end
        end
    end
    println(best_move)
    return best_move
 end

### TESTING

# initialize sides and AI - with its side
red = Pieces("red")
fill_red(red)
black = Pieces("black")
fill_black(black)
#julia = AI(black)
minimax_AB(black,red,-Inf,Inf,0,2)


# fill the AI pieces 
# fill_black(julia.set)









