# AI for for the Japanese chess game Shogi.
# game logic provided by shogi.jl and move_functions.jl

include("shogi.jl")

# generate start of unix epoch
const UNIXEPOCH = DateTime(1970)
# takes current date time and returns number of seconds since unix epoch
function datetime2unix(dt::DateTime) = (dt - UNIXEPOCH)/1000
# generate current unix time for seed
seed = datetime2unix(now())




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
function king_AI(AI::AI, piece::ASCIIString)
    # initial x and y cords 
    x = AI.set.active[piece][1]; y = AI.set.active[piece][2] 
    cords::Tuple{Int64,Int64} # stores possible coordinates 
    # friendly units
    friends = AI.set.activeS
    cords = (x,y+1)  # move up
    if y != 9 && haskey(friends,cords) != true
        push!(AI.AI.legal,cords) 
    end
    cords = (x,y-1) # move down
    if y != 1 && haskey(friends,cords) != true
        push!(AI.AI.legal,cords)
    end
    cords = (x+1,y) # move right    
    if x != 9 && haskey(friends,cords) != true
        push!(AI.AI.legal,cords)
    end
    cords = (x-1,y) # move left
    if x != 0 && haskey(friends,cords) != true
        push!(AI.AI.legal,cords)
    end
end

# finds all the possible moves for bishop given its position
function bishop_AI(AI::AI, piece::ASCIIString)
    # initial x and y cords 
    x = AI.set.active[piece][1]; y = AI.set.active[piece][2] 
    cords = Tuple{Int64,Int64} # stores possible coordinates
    # friendly units
    friends = AI.set.activeS
    # if piece is promoted add additional moves of king
    piece == "B" && king_AI(AI,piece)
    # moves towards top right
    x > y ? (n = 9-x) : (n = 9-y)
    for i = 1:n
        cords = (x+i,y+i)
        if haskey(friends,cords) != true
            push!(AI.AI.legal,cords) # if move is open
        else break # no more possible moves in path
        end
    end
    # moves towards the bottom right
    x < y ? (n = x-1) : (n = y-1) # have to stop at 1 not 0
    for i = 1:n
        cords = (x+i,y-i)
        if haskey(friends,cords) != true
            push!(AI.AI.legal,cords) # if move is open
        else break # no more possible moves in path
        end
    end
    # moves towards bottom left
    x < y ? (n = x-1) : (n = y-1) # have to stop at 1 not 0
    for i = 1:n
        cords = (x-i,y-i)
        if haskey(friends,cords) != true
            push!(AI.AI.legal,cords) # if move is open
        else break # no more possible moves in path
        end
    end
    # moves towards top left
    x > y ? (n = 9-x) : (n = 9 - y)
    for i = 1:n
        cords = (x-i,y+i)
        if haskey(friends,cords) != true
            push!(AI.AI.legal,cords) # if move is open
        else break # no more possible moves in path
        end
    end
end

# finds all possible moves for rook given its current coordinates
function rook_AI(AI::AI, piece)
    # initial x and y cords 
    x = AI.set.active[piece][1]; y = AI.set.active[piece][2] 
    cords = Tuple{Int64,Int64} # stores possible coordinates
    # friendly units
    friends = AI.set.activeS
    # check if promoted
    piece == "R" && king_AI(AI,piece)
    for i = y+1:9 # move upwards
        cords = (x,i)
        if haskey(friends,cords) != true
            push!(AI.AI.legal,cords)
        else break
        end
    end
    for i = y-1:-1:1 # move downwards
        cords = (x,i)
        if haskey(friends,cords) != true
            push!(AI.AI.legal,cords)
        else break
        end
    end
    for i = x+1:9 # move rightwards
        cords = (i,y)
        if haskey(friends,cords) != true
            push!(AI.AI.legal,cords)
        else break
        end
    end
    for i = x-1:-1:1
     # move leftwards
        cords = (i,y)
        if haskey(friends,cords) != true
            push!(AI.AI.legal,cords)
        else break
        end
    end
end

# finds all possible moves for black gold general given its current coordinates
function black_gold_general_AI(AI::AI, piece)
    # initial x and y cords 
    x = AI.set.active[piece][1]; y = AI.set.active[piece][2] 
    # friendly units
    friendly = AI.set.activeS
    if y != 1 && x != 1 && x != 9 
        haskey(friendly,(x,y-1)) == 0 && push!(AI.legal,(x,y-1))
        haskey(friendly,(x-1,y-1)) == 0 && push!(AI.legal,(x-1,y-1))
        haskey(friendly,(x+1,y-1)) == 0 && push!(AI.legal,(x+1,y-1))
        # add left and right movement
        haskey(friendly,(x+1,y)) == 0 && push!(AI.legal,(x+1,y))
        haskey(friendly,(x-1,y)) == 0 && push!(AI.legal,(x-1,y))
    elseif y == 1 && x != 1 && x != 9
        haskey(friendly,(x-1,y)) == 0 && push!(AI.legal,(x-1,y))
        haskey(friendly,(x+1,y)) == 0 && push!(AI.legal,(x+1,y))
    elseif y != 1 && x == 9 # if piece is on right side of board, and y != 1
        haskey(friendly,(x-1,y-1)) == 0 && push!(AI.legal,(x-1,y-1))
        haskey(friendly,(x-1,y)) == 0 && push!(AI.legal,(x-1,y))
    elseif y != 1 && x == 1 # if piece is on left side of board, and y != 1
        haskey(friendly,(x+1,y-1)) == 0 && push!(AI.legal,(x+1,y-1))
        haskey(friendly,(x+1,y)) == 0 && push!(AI.legal,(x+1,y))
    elseif x == 9 # if x == 9 and y == 1
        haskey(friendly,(x-1,y)) == 0 && push!(AI.legal,(x-1,y))
    elseif x == 1 # if x == 1 and y = 1
        haskey(friendly,(x+1,y)) == 0 && push!(AI.legal,(x+1,y))
    end
    # adds the backstep allowable coordinates
    if y != 9
        haskey(friendly,(x,y+1)) == 0 && push!(AI.legal,(x,y+1))
    end
end

# finds all possible moves for red gold general given its current coordinates
function red_gold_general_AI(AI::AI,piece)
    # initial x and y cords 
    x = AI.set.active[piece][1]; y = AI.set.active[piece][2] 
    # friendly units
    friendly = AI.set.activeS
    if y != 9 && x != 9 && x != 1 
        haskey(friendly,(x,y+1)) == 0 && push!(AI.legal,(x,y+1))
        haskey(friendly,(x+1,y+1)) == 0 && push!(AI.legal,(x+1,y+1))
        haskey(friendly,(x-1,y+1)) == 0 && push!(AI.legal,(x-1,y+1))
        # add left and right movement
        haskey(friendly,(x+1,y)) == 0 && push!(AI.legal,(x+1,y))
        haskey(friendly,(x-1,y)) == 0 && push!(AI.legal,(x-1,y))
    elseif y == 9 && x != 9 && x != 1
        haskey(friendly,(x-1,y)) == 0 && push!(AI.legal,(x-1,y))
        haskey(friendly,(x+1,y)) == 0 && push!(AI.legal,(x+1,y))
    elseif y != 9 && x == 9 # if piece is on left side of board, and y != 9
        haskey(friendly,(x-1,y+1)) == 0 && push!(AI.legal,(x-1,y+1))
        haskey(friendly,(x,y+1)) == 0 && push!(AI.legal,(x,y+1))
        haskey(friendly,(x-1,y)) == 0 && push!(AI.legal,(x-1,y))
    elseif y != 9 && x == 1 # if piece is on right side of board, and y != 9
        haskey(friendly,(x+1,y+1)) == 0 && push!(AI.legal,(x+1,y+1))
        haskey(friendly,(x,y+1)) == 0 && push!(AI.legal,(x,y+1))
        haskey(friendly,(x+1,y)) == 0 && push!(AI.legal,(x+1,y))
    elseif x == 9 # if y == 9 and x == 9
        haskey(friendly,(x-1,y)) == 0 && push!(AI.legal,(x-1,y))
    elseif x == 1 # if x == 1 and y = 9
        haskey(friendly,(x+1,y)) == 0 && push!(AI.legal,(x+1,y))
    end
    if y != 1
        haskey(set.activeS,(x,y-1)) == 0 && push!(AI.legal,(x,y-1))
    end
end

# this function will be called in the main, and calls correct gold general function 
function gold_general_AI(AI::AI,piece)
    AI.set.color == "black" ? 
        black_gold_general_AI(AI,piece) : 
        red_gold_general_AI(AI,piece)
end

# finds all possible moves for black silver general given its current coordinates
function black_silver_general_AI(AI::AI,piece)
    # initial x and y cords 
    x = AI.set.active[piece][1]; y = AI.set.active[piece][2] 
    # friendly units
    friendly = AI.set.activeS
    if piece[1] == 'S'
        black_gold_general_AI(AI,piece)
        return
    elseif y != 1 && x != 1 && x != 9 # if piece is not on a boundary
        haskey(friendly,(x,y-1)) == 0 && push!(AI.legal,(x,y-1))
        haskey(friendly,(x-1,y-1)) == 0 && push!(AI.legal,(x-1,y-1))
        haskey(friendly,(x+1,y-1)) == 0 && push!(AI.legal,(x+1,y-1))
    elseif y != 1 && x == 9 # if piece is on right side of board, and y != 1
        haskey(friendly,(x-1,y-1)) == 0 && push!(AI.legal,(x-1,y-1))
        haskey(friendly,(x,y-1)) == 0 && push!(AI.legal,(x,y-1))
    elseif y != 1 && x == 1 # if piece is on left side of board, and y != 1
        haskey(friendly,(x+1,y-1)) == 0 && push!(AI.legal,(x+1,y-1))
        haskey(friendly,(x,y-1)) == 0 && push!(AI.legal,(x,y-1))
    end
    if y != 9 # check for allowable backwards movement
        haskey(friendly,(x+1,y+1)) == 0 && push!(AI.legal,(x+1,y+1))
        haskey(friendly,(x-1,y+1)) == 0 && push!(AI.legal,(x-1,y+1))
    end
end

# finds all possible moves for red silver general given its current coordinates
function red_silver_general_AI(AI::AI,piece)
    # initial x and y cords 
    x = AI.set.active[piece][1]; y = AI.set.active[piece][2] 
    # friendly units
    friendly = AI.set.activeS
    if piece[1] == 'S' # if silver general is promoted
        red_gold_general_AI(AI,piece)
        return
    elseif y != 9 && x != 9 && x != 1 
        hashkey(friendly,(x,y+1)) == 0 && push!(AI.legal,(x,y+1))
        haskey(friendly,(x+1,y+1)) == 0 && push!(AI.legal,(x+1,y+1))
        haskey(friendly,(x-1,y+1)) == 0 && push!(AI.legal,(x-1,y+1))
    elseif y != 9 && x == 9 # if piece is on left side of board, and y != 9
        haskey(friendly,(x-1,y+1)) == 0 && push!(AI.legal,(x-1,y+1))
        haskey(friendly,(x,y+1)) == 0 && push!(AI.legal,(x,y+1))
    elseif y != 9 && x == 1 # if piece is on right side of board, and y != 9
        haskey(friendly,(x+1,y+1)) == 0 && push!(AI.legal,(x+1,y+1))
        haskey(friendly,(x,y+1)) == 0 && push!(AI.legal,(x,y+1))
    end
    # check if steps back are allowable coordinates
    if y != 1
        haskey(friendly,(x-1,y-1)) == 0 && push!(AI.legal,(x-1,y-1))
        haskey(friendly,(x+1,y-1)) == 0 && push!(AI.legal,(x+1,y-1))
    end
end

# general silver general function calls correct colored silver general function
function silver_general_AI(AI::AI,piece)
    AI.set.color == "black" ?
        black_silver_general_AI(AI,piece) :
        red_silver_general_AI(AI,piece)
end

# determines all possible moves of black knight from given location
function black_knight_AI(AI::AI,piece)
    # initial x and y cords 
    x = AI.set.active[piece][1]; y = AI.set.active[piece][2] 
    # friendly units
    friendly = AI.set.activeS
    if piece[1] == 'N' # check for promotion
        black_gold_general_AI(AI,piece)
        return
    elseif y > 2 && x != 1 && x != 9 
        haskey(friendly,(x-1,y-2)) == 0 && push!(AI.legal,(x-1,y-2))
        haskey(friendly,(x+1,y-2)) == 0 && push!(AI.legal,(x+1,y-2))
    elseif y > 2 && x == 9 # if piece is on right side of board, and y >= 2
        haskey(friendly,(x-1,y-2)) == 0 && push!(AI.legal,(x-1,y-2))
    elseif y > 2 && x == 1 # if piece is on left side of board, and y >= 2
        haskey(friendly,(x+1,y-2)) == 0 && push!(AI.legal,(x+1,y-2))
    end
end

function red_knight_AI(AI::AI,piece)
    # initial x and y cords 
    x = AI.set.active[piece][1]; y = AI.set.active[piece][2] 
    # friendly units
    friendly = AI.set.activeS
    if piece[1] == 'N' # check for promotion
        red_gold_general_AI(AI,piece)
        return
    elseif y < 8 && x != 9 && x != 1
        haskey(friendly,(x-1,y+2)) == 0 && push!(AI.AI.legal,(x-1,y+2))
        haskey(friendly,(x+1,y+2)) == 0 && push!(AI.legal,(x+1,y+2))
    elseif y < 8 && x == 9 # if piece is on left side of board, and y <= 8
        haskey(friendly,(x-1,y+2)) == 0 && push!(AI.legal,(x-1,y+2))
    elseif y < 8 && x == 1 # if piece is on right side of board, and y <= 8
        haskey(friendly,(x+1,y+2)) == 0 && push!(AI.legal,(x+1,y+2))
    end
end

function choose_piece

### TESTING

# initialize sides and AI - with its side
red = Pieces("red")
black = Pieces("black")
julia = AI(black)

# fill the AI pieces 
fill_black(julia.set)
println(julia.set.color) 

# print out coordinates of the kings AI
println(julia.set.active["k"]) 

# locate possible moves from kings starting coordinates
# king_AI(julia,"k") 
# println(julia.AI.legal)
# deleteat!(julia.AI.legal,1:length(julia.AI.legal))


# locate possible moves from promoted bishops coordinates 
# get!(julia.set.active,"B",(5,5))
# bishop_AI(julia,"B")
# println(julia.AI.legal)
# deleteat!(julia.AI.legal,1:length(julia.AI.legal))
# pop!(julia.set.active,"B")

# # located possible moves from rooks coordinates
# julia.set.active["r"] = (5,5)
# rook_AI(julia,"r")
# println(julia.AI.legal)
# clear_array(julia.AI.legal)


# # locate possible moves from knights coordinates
# julia.set.active["n1"] = (5,5)
# black_knight_AI(julia,"n1")
# println(julia.legal)
#clear_array(julia.legal)

# # locate possible moves from silver general coordinates
# julia.set.active["s1"] = (5,5)
# black_silver_general_AI(julia,"s1")
# println(julia.legal)
#clear_array(julia.legal)

# locate possible moves from gold general coordinates
julia.set.active["g1"] = (5,5)
black_gold_general_AI(julia,"g1")
println(julia.legal)
clear_array(julia.legal)






