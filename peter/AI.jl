# AI for for the Japanese chess game Shogi.
# game logic provided by shogi.jl and move_functions.jl

include("shogi.jl")

type AI
    set::Pieces
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
        push!(AI.legal,cords) 
    end
    cords = (x,y-1) # move down
    if y != 1 && haskey(friends,cords) != true
        push!(AI.legal,cords)
    end
    cords = (x+1,y) # move right    
    if x != 9 && haskey(friends,cords) != true
        push!(AI.legal,cords)
    end
    cords = (x-1,y) # move left
    if x != 0 && haskey(friends,cords) != true
        push!(AI.legal,cords)
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
            push!(AI.legal,cords) # if move is open
        else break # no more possible moves in path
        end
    end
    # moves towards the bottom right
    x < y ? (n = x-1) : (n = y-1) # have to stop at 1 not 0
    for i = 1:n
        cords = (x+i,y-i)
        if haskey(friends,cords) != true
            push!(AI.legal,cords) # if move is open
        else break # no more possible moves in path
        end
    end
    # moves towards bottom left
    x < y ? (n = x-1) : (n = y-1) # have to stop at 1 not 0
    for i = 1:n
        cords = (x-i,y-i)
        if haskey(friends,cords) != true
            push!(AI.legal,cords) # if move is open
        else break # no more possible moves in path
        end
    end
    # moves towards top left
    x > y ? (n = 9-x) : (n = 9 - y)
    for i = 1:n
        cords = (x-i,y+i)
        if haskey(friends,cords) != true
            push!(AI.legal,cords) # if move is open
        else break # no more possible moves in path
        end
    end
end

function rook_AI(AI::AI, piece)
    # initial x and y cords 
    x = AI.set.active[piece][1]; y = AI.set.active[piece][2] 
    cords = Tuple{Int64,Int64} # stores possible coordinates
    # friendly units
    friends = AI.set.activeS
    # move upwards
    for i = y+1:9

        cords = (x,i)
        if haskey(friends,cords) != true
            push!(AI.legal,cords)
        else break
        end
    end
    # move downwards
    for i = y-1:-1:1
        cords = (x,i)
        if haskey(friends,cords) != true
            push!(AI.legal,cords)
        else break
        end
    end
    # move rightwards
    for i = x+1:9
        cords = (i,y)
        if haskey(friends,cords) != true
            push!(AI.legal,cords)
        else break
        end
    end
    # move leftwards
    for i = x-1:-1:9
        cords = (i,y)
        if haskey(friends,cords) != true
            push!(AI.legal,cords)
        else break
        end
    end
end

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
# println(julia.legal)
# deleteat!(julia.legal,1:length(julia.legal))


# locate possible moves from promoted bishops coordinates 
# get!(julia.set.active,"B",(5,5))
# bishop_AI(julia,"B")
# println(julia.legal)
# deleteat!(julia.legal,1:length(julia.legal))
# pop!(julia.set.active,"B")

# located possible moves from rooks coordinates
julia.set.active["r"] = (5,5)
rook_AI(julia,"r")
println(julia.legal)
clear_array(julia.legal)





