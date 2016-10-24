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
    set.color == "black" ? 
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
        haskey(friendly,(x,y+1)) == 0 && push!(legal,(x,y+1))
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
    set.color == "black" ?
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
        haskey(friendly,(x-1,y+2)) == 0 && push!(legal,(x-1,y+2))
        haskey(friendly,(x+1,y+2)) == 0 && push!(legal,(x+1,y+2))
    elseif y < 8 && x == 9 # if piece is on left side of board, and y <= 8
        haskey(friendly,(x-1,y+2)) == 0 && push!(legal,(x-1,y+2))
    elseif y < 8 && x == 1 # if piece is on right side of board, and y <= 8
        haskey(friendly,(x+1,y+2)) == 0 && push!(legal,(x+1,y+2))
    end
    return legal
end

function knight_AI(set::Pieces, legal::Array, piece::ASCIIString)
    set.color == "black" ?
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
    set.color == "black" ? 
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