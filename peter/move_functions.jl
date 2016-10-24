# pawn
function move_red_p(B::Board, set::Pieces, inactive::Pieces, piece, cords)
	# stores coordinates of legal moves
	legal = Tuple{Int,Int}[] 
	# initial legal cords
	x = set.active[piece][1]; y = set.active[piece][2]

	# check if given coordinates equal to current coordinates
	if cords == set.active[piece]
		return
	end

	# basic move both unpromoted and promoted can make
	if y != 9 && haskey(set.activeS,(x,y+1)) == 0
		push!(legal,(x,y+1)) # add this location to list of possible ones
	end

	# if pawn is unpromoted, there is only one possible move: (x,y+1)
	if piece[1] == 'p'
		cords == legal[1] ?	
			move_piece(B,set,inactive,piece,cords) :
			println("illegal move")
	else # pawn is promoted to gold general - shiiiet 
		if y != 9 && x != 9 && x != 1 
			haskey(set.activeS,(x+1,y+1)) == 0 && push!(legal,(x+1,y+1))
			haskey(set.activeS,(x-1,y+1)) == 0 && push!(legal,(x-1,y+1))
			# add left and right movement
			haskey(set.activeS,(x+1,y)) == 0 && push!(legal,(x+1,y))
			haskey(set.activeS,(x-1,y)) == 0 && push!(legal,(x-1,y))
		elseif y == 9 && x != 9 && x != 1
			haskey(set.activeS,(x-1,y)) == 0 && push!(legal,(x-1,y))
			haskey(set.activeS,(x+1,y)) == 0 && push!(legal,(x+1,y))
		elseif y != 9 && x == 9 # if piece is on left side of board, and y != 9
			haskey(set.activeS,(x-1,y+1)) == 0 && push!(legal,(x-1,y+1))
			haskey(set.activeS,(x,y+1)) == 0 && push!(legal,(x,y+1))
			haskey(set.activeS,(x-1,y)) == 0 && push!(legal,(x-1,y))
		elseif y != 9 && x == 1 # if piece is on right side of board, and y != 9
			haskey(set.activeS,(x+1,y+1)) == 0 && push!(legal,(x+1,y+1))
			haskey(set.activeS,(x,y+1)) == 0 && push!(legal,(x,y+1))
			haskey(set.activeS,(x+1,y)) == 0 && push!(legal,(x+1,y))
		elseif x == 9 # if y == 9 and x == 9
			haskey(set.activeS,(x-1,y)) == 0 && push!(legal,(x-1,y))
		elseif x == 1 # if x == 1 and y = 9
			haskey(set.activeS,(x+1,y)) == 0 && push!(legal,(x+1,y))
		end
		# adds the backsetp allowable coordinates
		if y != 1
			haskey(set.activeS,(x,y-1)) == 0 && push!(legal,(x,y-1))
		end
		# check if user input matches a legal move
		if findfirst(legal,cords) != 0 
			move_piece(B, set, inactive, piece, cords)
		else 
			println("illegal move")
			B.status = 0
		end
	end
end

function move_black_p(B::Board, set::Pieces, inactive::Pieces, piece, cords)
	# stores coordinates of legal moves
	legal = Tuple{Int,Int}[] 
	# initial legal cords
	x = set.active[piece][1]; y = set.active[piece][2]

	# check if given coordinates equal to current coordinates
	if cords == set.active[piece]
		return
	end

	# basic move both unpromoted and promoted can make
	if y != 1 && haskey(set.activeS,(x,y-1)) == 0
		push!(legal,(x,y-1)) # add this location to list of possible ones
	end

	# if pawn is unpromoted, there is only one possible move: (x,y-1)
	if piece[1] == 'p'
		cords == legal[1] ?
			move_piece(B,set,inactive,piece,cords) :
			println("illegal move")
	else # pawn is promoted to gold general - shiiiet 
		if y != 1 && x != 1 && x != 9 
			haskey(set.activeS,(x-1,y-1)) == 0 && push!(legal,(x-1,y-1))
			haskey(set.activeS,(x+1,y-1)) == 0 && push!(legal,(x+1,y-1))
			# add left and right movement
			haskey(set.activeS,(x+1,y)) == 0 && push!(legal,(x+1,y))
			haskey(set.activeS,(x-1,y)) == 0 && push!(legal,(x-1,y))
		elseif y == 1 && x != 1 && x != 9
			haskey(set.activeS,(x-1,y)) == 0 && push!(legal,(x-1,y))
			haskey(set.activeS,(x+1,y)) == 0 && push!(legal,(x+1,y))
		elseif y != 1 && x == 9 # if piece is on left side of board, and y != 1
			haskey(set.activeS,(x-1,y-1)) == 0 && push!(legal,(x-1,y+1))
			haskey(set.activeS,(x-1,y)) == 0 && push!(legal,(x-1,y))
		elseif y != 1 && x == 1 # if piece is on right side of board, and y != 1
			haskey(set.activeS,(x+1,y-1)) == 0 && push!(legal,(x+1,y-1))
			haskey(set.activeS,(x+1,y)) == 0 && push!(legal,(x+1,y))
		elseif x == 9 # if x == 9 and y == 1
			haskey(set.activeS,(x-1,y)) == 0 && push!(legal,(x-1,y))
		elseif x == 1 # if x == 1 and y = 1
			haskey(set.activeS,(x+1,y)) == 0 && push!(legal,(x+1,y))
		end
		# adds the backsetp allowable coordinates
		if y != 9
			haskey(set.activeS,(x,y+1)) == 0 && push!(legal,(x,y+1))
		end
		# check if user input matches a legal move
		if findfirst(legal,cords) != 0 
			println("hi")
			move_piece(B, set, inactive, piece, cords)
		else 
			println("illegal move")
			B.status = 0
		end
	end
end

# gold general
function move_red_g(B::Board, set::Pieces, inactive::Pieces, piece, cords)
	# stores coordinates of legal moves
	legal = Tuple{Int,Int}[] 
	# initial legal cords
	x = set.active[piece][1]; y = set.active[piece][2]

	# check if given coordinates equal to current coordinates
	if cords == set.active[piece]
		return
	end

	if y != 9 && x != 9 && x != 1 
		haskey(set.activeS,(x,y+1)) == 0 && push!(legal,(x,y+1))
		haskey(set.activeS,(x+1,y+1)) == 0 && push!(legal,(x+1,y+1))
		haskey(set.activeS,(x-1,y+1)) == 0 && push!(legal,(x-1,y+1))
		# add left and right movement
		haskey(set.activeS,(x+1,y)) == 0 && push!(legal,(x+1,y))
		haskey(set.activeS,(x-1,y)) == 0 && push!(legal,(x-1,y))
	elseif y == 9 && x != 9 && x != 1
		haskey(set.activeS,(x-1,y)) == 0 && push!(legal,(x-1,y))
		haskey(set.activeS,(x+1,y)) == 0 && push!(legal,(x+1,y))
	elseif y != 9 && x == 9 # if piece is on left side of board, and y != 9
		haskey(set.activeS,(x-1,y+1)) == 0 && push!(legal,(x-1,y+1))
		haskey(set.activeS,(x,y+1)) == 0 && push!(legal,(x,y+1))
		haskey(set.activeS,(x-1,y)) == 0 && push!(legal,(x-1,y))
	elseif y != 9 && x == 1 # if piece is on right side of board, and y != 9
		haskey(set.activeS,(x+1,y+1)) == 0 && push!(legal,(x+1,y+1))
		haskey(set.activeS,(x,y+1)) == 0 && push!(legal,(x,y+1))
		haskey(set.activeS,(x+1,y)) == 0 && push!(legal,(x+1,y))
	elseif x == 9 # if y == 9 and x == 9
		haskey(set.activeS,(x-1,y)) == 0 && push!(legal,(x-1,y))
	elseif x == 1 # if x == 1 and y = 9
		haskey(set.activeS,(x+1,y)) == 0 && push!(legal,(x+1,y))
	end
	if y != 1
		haskey(set.activeS,(x,y-1)) == 0 && push!(legal,(x,y-1))
	end
	# check if user input matches a legal move
	if findfirst(legal,cords) != 0 
		move_piece(B, set, inactive, piece, cords)
	else 
		println("illegal move")
		B.status = 0
	end
end

function move_black_g(B::Board, set::Pieces, inactive::Pieces, piece, cords)
	# stores coordinates of legal moves
	legal = Tuple{Int,Int}[] 
	# initial legal cords
	x = set.active[piece][1]; y = set.active[piece][2]

	# check if given coordinates equal to current coordinates
	if cords == set.active[piece]
		return
	end

	if y != 1 && x != 1 && x != 9 
        haskey(set.activeS,(x,y-1)) == 0 && push!(legal,(x,y-1))
        haskey(set.activeS,(x-1,y-1)) == 0 && push!(legal,(x-1,y-1))
        haskey(set.activeS,(x+1,y-1)) == 0 && push!(legal,(x+1,y-1))
        # add left and right movement
        haskey(set.activeS,(x+1,y)) == 0 && push!(legal,(x+1,y))
        haskey(set.activeS,(x-1,y)) == 0 && push!(legal,(x-1,y))
    elseif y == 1 && x != 1 && x != 9
        haskey(set.activeS,(x-1,y)) == 0 && push!(legal,(x-1,y))
        haskey(set.activeS,(x+1,y)) == 0 && push!(legal,(x+1,y))
    elseif y != 1 && x == 9 # if piece is on right side of board, and y != 1
        haskey(set.activeS,(x-1,y-1)) == 0 && push!(legal,(x-1,y-1))
        haskey(set.activeS,(x-1,y)) == 0 && push!(legal,(x-1,y))
    elseif y != 1 && x == 1 # if piece is on left side of board, and y != 1
        haskey(set.activeS,(x+1,y-1)) == 0 && push!(legal,(x+1,y-1))
        haskey(set.activeS,(x+1,y)) == 0 && push!(legal,(x+1,y))
    elseif x == 9 # if x == 9 and y == 1
        haskey(set.activeS,(x-1,y)) == 0 && push!(legal,(x-1,y))
    elseif x == 1 # if x == 1 and y = 1
        haskey(set.activeS,(x+1,y)) == 0 && push!(legal,(x+1,y))
    end
    # adds the backstep allowable coordinates
    if y != 9
        haskey(set.activeS,(x,y+1)) == 0 && push!(legal,(x,y+1))
    end

	# check if user input matches a legal move
	if findfirst(legal,cords) != 0 
		move_piece(B, set, inactive, piece, cords)
	else 
		println("illegal move")
		B.status = 0
	end
end

# king
function move_red_k(B::Board, set::Pieces, inactive::Pieces, piece, cords)
	# stores coordinates of legal moves
	legal = Tuple{Int,Int}[] 
	# initial legal cords
	x = set.active[piece][1]; y = set.active[piece][2]

	# check if given coordinates equal to current coordinates
	if cords == set.active[piece]
		return
	end

	if y != 9 && x != 9 && x != 1 
		haskey(set.activeS,(x,y+1)) == 0 && push!(legal,(x,y+1))
		haskey(set.activeS,(x+1,y+1)) == 0 && push!(legal,(x+1,y+1))
		haskey(set.activeS,(x-1,y+1)) == 0 && push!(legal,(x-1,y+1))
		# add left and right movement
		haskey(set.activeS,(x+1,y)) == 0 && push!(legal,(x+1,y))
		haskey(set.activeS,(x-1,y)) == 0 && push!(legal,(x-1,y))
	elseif y == 9 && x != 9 && x != 1
		haskey(set.activeS,(x-1,y)) == 0 && push!(legal,(x-1,y))
		haskey(set.activeS,(x+1,y)) == 0 && push!(legal,(x+1,y))
	elseif y != 9 && x == 9 # if piece is on left side of board, and y != 9
		haskey(set.activeS,(x-1,y+1)) == 0 && push!(legal,(x-1,y+1))
		haskey(set.activeS,(x,y+1)) == 0 && push!(legal,(x,y+1))
		haskey(set.activeS,(x-1,y)) == 0 && push!(legal,(x-1,y))
	elseif y != 9 && x == 1 # if piece is on right side of board, and y != 9
		haskey(set.activeS,(x+1,y+1)) == 0 && push!(legal,(x+1,y+1))
		haskey(set.activeS,(x,y+1)) == 0 && push!(legal,(x,y+1))
		haskey(set.activeS,(x+1,y)) == 0 && push!(legal,(x+1,y))
	elseif x == 9 # if y == 9 and x == 9
		haskey(set.activeS,(x-1,y)) == 0 && push!(legal,(x-1,y))
	elseif x == 1 # if x == 1 and y = 9
		haskey(set.activeS,(x+1,y)) == 0 && push!(legal,(x+1,y))
	end
	# check if steps back are allowable coordinates
	if y != 1
		haskey(set.activeS,(x,y-1)) == 0 && push!(legal,(x,y-1))
		haskey(set.activeS,(x-1,y-1)) == 0 && push!(legal,(x-1,y-1))
		haskey(set.activeS,(x+1,y-1)) == 0 && push!(legal,(x+1,y-1))
	end
	# check if user input matches a legal move
	if findfirst(legal,cords) != 0 
		move_piece(B, set, inactive, piece, cords)
	else 
		println("illegal move")
		B.status = 0
	end
end

function move_black_k(B::Board, set::Pieces, inactive::Pieces, piece, cords)
	# stores coordinates of legal moves
	legal = Tuple{Int,Int}[] 
	# initial legal cords
	x = set.active[piece][1]; y = set.active[piece][2]

	# check if given coordinates equal to current coordinates
	if cords == set.active[piece]
		return
	end

	if y != 1 && x != 1 && x != 9 
		haskey(set.activeS,(x,y-1)) == 0 && push!(legal,(x,y-1))
		haskey(set.activeS,(x-1,y-1)) == 0 && push!(legal,(x-1,y-1))
		haskey(set.activeS,(x+1,y-1)) == 0 && push!(legal,(x+1,y-1))
		# add left and right movement
		haskey(set.activeS,(x+1,y)) == 0 && push!(legal,(x+1,y))
		haskey(set.activeS,(x-1,y)) == 0 && push!(legal,(x-1,y))
	elseif y == 1 && x != 1 && x != 9
		haskey(set.activeS,(x-1,y)) == 0 && push!(legal,(x-1,y))
		haskey(set.activeS,(x+1,y)) == 0 && push!(legal,(x+1,y))
	elseif y != 1 && x == 9 # if piece is on left side of board, and y != 1
		haskey(set.activeS,(x-1,y-1)) == 0 && push!(legal,(x-1,y+1))
		haskey(set.activeS,(x,y-1)) == 0 && push!(legal,(x,y+1))
		haskey(set.activeS,(x-1,y)) == 0 && push!(legal,(x-1,y))
	elseif y != 1 && x == 1 # if piece is on right side of board, and y != 1
		haskey(set.activeS,(x+1,y-1)) == 0 && push!(legal,(x+1,y+1))
		haskey(set.activeS,(x,y-1)) == 0 && push!(legal,(x,y+1))
		haskey(set.activeS,(x+1,y)) == 0 && push!(legal,(x+1,y))
	elseif x == 9 # if x == 9 and y == 1
		haskey(set.activeS,(x-1,y)) == 0 && push!(legal,(x-1,y))
	elseif x == 1 # if x == 1 and y = 1
		haskey(set.activeS,(x+1,y)) == 0 && push!(legal,(x+1,y))
	end
	# check if steps back are allowable coordinates
	if y != 9
		haskey(set.activeS,(x,y-1)) == 0 && push!(legal,(x,y-1))
		haskey(set.activeS,(x+1,y-1)) == 0 && push!(legal,(x+1,y-1))
		haskey(set.activeS,(x-1,y-1)) == 0 && push!(legal,(x-1,y-1))
	end
	# check if user input matches a legal move
	if findfirst(legal,cords) != 0 
		move_piece(B, set, inactive, piece, cords)
	else 
		println("illegal move")
		B.status = 0
	end
end

# silver general
function move_red_s(B::Board, set::Pieces, inactive::Pieces, piece, cords)
	# stores coordinates of legal moves
	legal = Tuple{Int,Int}[] 
	# initial legal cords
	x = set.active[piece][1]; y = set.active[piece][2]

	# check if given coordinates equal to current coordinates
	if cords == set.active[piece]
		return
	elseif piece[1] == 'S' # if silver general is promoted
		move_red_g(B,set,inactive,piece,cords)
	elseif piece[1] == 's' # if silver general is unpromoted
		if y != 9 && x != 9 && x != 1 
			haskey(set.activeS,(x,y+1)) == 0 && push!(legal,(x,y+1))
			haskey(set.activeS,(x+1,y+1)) == 0 && push!(legal,(x+1,y+1))
			haskey(set.activeS,(x-1,y+1)) == 0 && push!(legal,(x-1,y+1))
		elseif y != 9 && x == 9 # if piece is on left side of board, and y != 9
			haskey(set.activeS,(x-1,y+1)) == 0 && push!(legal,(x-1,y+1))
			haskey(set.activeS,(x,y+1)) == 0 && push!(legal,(x,y+1))
		elseif y != 9 && x == 1 # if piece is on right side of board, and y != 9
			haskey(set.activeS,(x+1,y+1)) == 0 && push!(legal,(x+1,y+1))
			haskey(set.activeS,(x,y+1)) == 0 && push!(legal,(x,y+1))
		end
		# check if steps back are allowable coordinates
		if y != 1
			haskey(set.activeS,(x-1,y-1)) == 0 && push!(legal,(x-1,y-1))
			haskey(set.activeS,(x+1,y-1)) == 0 && push!(legal,(x+1,y-1))
		end
	end
	# check if user input matches a legal move
	if findfirst(legal,cords) != 0 
		move_piece(B, set, inactive, piece, cords)
	else 
		println("illegal move")
	end	
end

function move_black_s(B::Board, set::Pieces, inactive::Pieces, piece, cords)
	# stores coordinates of legal moves
	legal = Tuple{Int,Int}[] 
	# initial legal cords
	x = set.active[piece][1]; y = set.active[piece][2]

	# check if given coordinates equal to current coordinates
	if cords == set.active[piece]
		return
	elseif piece[1] == 'S'
		move_black_g(B,set,inactive,piece,cords)
		return
	elseif piece[1] == 's'
		if y != 1 && x != 1 && x != 9 
			haskey(set.activeS,(x,y-1)) == 0 && push!(legal,(x,y-1))
			haskey(set.activeS,(x-1,y-1)) == 0 && push!(legal,(x-1,y-1))
			haskey(set.activeS,(x+1,y-1)) == 0 && push!(legal,(x+1,y-1))
		elseif y != 9 && x == 9 # if piece is on left side of board, and y != 9
			haskey(set.activeS,(x-1,y-1)) == 0 && push!(legal,(x-1,y-1))
			haskey(set.activeS,(x,y-1)) == 0 && push!(legal,(x,y-1))
		elseif y != 1 && x == 1 # if piece is on left side of board, and y != 1
			haskey(set.activeS,(x+1,y-1)) == 0 && push!(legal,(x+1,y-1))
			haskey(set.activeS,(x,y-1)) == 0 && push!(legal,(x,y-1))
		end
		# check if steps back are allowable coordinates
		if y != 9
			haskey(set.activeS,(x+1,y+1)) == 0 && push!(legal,(x+1,y+1))
			haskey(set.activeS,(x-1,y+1)) == 0 && push!(legal,(x-1,y+1))
		end
		# check if user input matches a legal move
		if findfirst(legal,cords) != 0 
			move_piece(B, set, inactive, piece, cords)
		else 
			println("illegal move")
		end
    end
end

# knight
function move_red_n(B::Board, set::Pieces, inactive::Pieces, piece, cords)
	# stores coordinates of legal moves
	legal = Tuple{Int,Int}[] 
	# initial legal cords
	x = set.active[piece][1]; y = set.active[piece][2]
	# check if given coordinates equal to current coordinates
	if cords == set.active[piece]
		return
	elseif piece[1] == 'N' # check for promotion
		move_red_g(B,set,inactive,piece,cords)
		return
	elseif y < 8 && x != 9 && x != 1
		haskey(set.activeS,(x-1,y+2)) == 0 && push!(legal,(x-1,y+2))
		haskey(set.activeS,(x+1,y+2)) == 0 && push!(legal,(x+1,y+2))
	elseif y < 8 && x == 9 # if piece is on left side of board, and y <= 8
		haskey(set.activeS,(x-1,y+2)) == 0 && push!(legal,(x-1,y+2))
	elseif y < 8 && x == 1 # if piece is on right side of board, and y <= 8
		haskey(set.activeS,(x+1,y+2)) == 0 && push!(legal,(x+1,y+2))
	end
	# check if user input matches a legal move
	if findfirst(legal,cords) != 0 
		move_piece(B, set, inactive, piece, cords)
	else 
		println("illegal move")
	end
end

function move_black_n(B::Board, set::Pieces, inactive::Pieces, piece, cords)
	# stores coordinates of legal moves
	legal = Tuple{Int,Int}[] 
	# initial legal cords
	x = set.active[piece][1]; y = set.active[piece][2]

	# check if given coordinates equal to current coordinates
	if cords == set.active[piece]
		return
	elseif piece[1] == 'N' # check for promotion
		move_black_g(B,set,inactive,piece,cords)
	elseif y > 2 && x != 1 && x != 9 
		haskey(set.activeS,(x-1,y-2)) == 0 && push!(legal,(x-1,y-2))
		haskey(set.activeS,(x+1,y-2)) == 0 && push!(legal,(x+1,y-2))
	elseif y > 2 && x == 9 # if piece is on right side of board, and y >= 2
		haskey(set.activeS,(x-1,y-2)) == 0 && push!(legal,(x-1,y-2))
	elseif y > 2 && x == 1 # if piece is on left side of board, and y >= 2
		haskey(set.activeS,(x+1,y-2)) == 0 && push!(legal,(x+1,y-2))
	end
	# check if user input matches a legal move
	if findfirst(legal,cords) != 0 
		move_piece(B, set, inactive, piece, cords)
	else 
		println("illegal move")
		B.status = 0
	end
end

function move_king(B::Board, set::Pieces, enemy::Pieces, piece, cords)
	# initial x and y cords 
	xi = set.active[piece][1]; yi = set.active[piece][2] 
	# target coordinates
	x = cords[1]; y = cords[2]
	# check for out of bounds
	if x < 1 || x > 9 
		println("illegal move"); return
	elseif y < 1 || y > 9
		println("illegal move"); return
	end
	# take differences 
	delta_x = abs(x-xi); delta_y = abs(y-yi)
	if delta_x > 1 || delta_y > 1 
		println("illegal move"); return
	elseif haskey(set.activeS,cords) == true
		println("illegal move"); return
	else # legal move
		move_piece(B,set,enemy,piece,cords)
	end
end

function move_bishop(B::Board, set::Pieces, enemy::Pieces, piece, cords)
	# initial x and y cords 
	xi = set.active[piece][1]; yi = set.active[piece][2] 
	# target coordinates
	x = cords[1]; y = cords[2]
	# check for out of bounds
	if x < 1 || x > 9 
		println("illegal move"); return
	elseif y < 1 || y > 9
		println("illegal move"); return
	end
	# take differences 
	delta_x = abs(x-xi); delta_y = abs(y-yi)
	# check if promoted to DRAGON HORSE!!!
	if piece[1] == 'B'
	  if delta_x <= 1 && delta_y <= 1
	  	move_piece(B,set,enemy,piece,new_cords); return
	  end
	end
	# otherwise compare if unequal => illegal
	if delta_x != delta_y
		println("illegal move"); return
	end
	# if moving towards top right (9,9)
	if x > xi && y > yi
		for i = 1:delta_x
			new_cords::Tuple{Int64,Int64} = (xi+i,yi+i)
			if haskey(enemy.activeS,new_cords) == true # if enemy is in the way
				move_piece(B,set,enemy,piece,new_cords)
				return
			elseif haskey(set.activeS,new_cords) == true
				println("illegal move"); return
			end
		end
		# if execution falls here then move is legal
		move_piece(B,set,enemy,piece,cords)
	# if moving towards bottom right (9,1)
	elseif x > xi && y < yi
		for i = 1:(delta_x-1)
			new_cords::Tuple{Int64,Int64} = (xi+i,yi-i)
			if haskey(enemy.activeS,new_cords) == true
				move_piece(B,set,enemy,piece,new_cords); return
			elseif haskey(set.activeS,new_cords) == true
				println("illegal move"); return
			end
		end
		move_piece(B,set,enemy,piece,cords)
	# if moving towards bottom left (1,1)
	elseif x < xi && y < yi 
		for i = 1:(delta_x-1)
			new_cords::Tuple{Int64,Int64} = (xi-i,yi-i)
			if haskey(enemy.activeS,new_cords) == true
				move_piece(B,set,enemy,piece,new_cords); return
			elseif haskey(set.activeS,new_cords) == true
				println("illegal move"); return
			end
		end
		move_piece(B,set,enemy,piece,cords)
	# if moving towards top left (1,9)
	elseif x < xi && y > yi 
		for i = 1:delta_x
			new_cords::Tuple{Int64,Int64} = (xi-i,yi+i)
			if haskey(enemy.activeS,new_cords) == true
				move_piece(B,set,enemy,piece,new_cords); return
			elseif haskey(set.activeS,new_cords) == true
				println("illegal move"); return
			end
		end
		move_piece(B,set,enemy,piece,cords)
	end
	# IF EXECUTION FALLS HERE: target cords == current cords => skip move
end

function move_rook(B::Board, set::Pieces, enemy::Pieces, piece, cords)
	# initial x and y cords 
	xi = set.active[piece][1]; yi = set.active[piece][2] 
	# target coordinates
	x = cords[1]; y = cords[2]
	# take differences
	delta_x = x - xi; delta_y = y - yi;

	inc::Int64 # used in for loops
	if piece[1] == 'R'
	  if delta_x <= 1 && delta_y <= 1
	  	move_piece(B,set,enemy,piece,new_cords); return
	  end
	elseif delta_x != 0 && delta_y != 0 # illegal movement
		println("illegal move"); return
	elseif delta_x != 0 # horizontal movemement
		delta_x < 0 ? inc = -1 : inc = 1
		for i = (xi+inc):inc:x
			new_cords::Tuple{Int64,Int64} = (i,y)
			if haskey(enemy.activeS,new_cords) == true # if enemy blocking path
				move_piece(B,set,enemy,piece,new_cords) 
			elseif haskey(set.activeS,new_cords) == true # if friendly blocking path
				println("illegal move"); return
			end
		end
		# if execution falls here then move is legal
		move_piece(B,set,enemy,piece,cords)
	elseif delta_y != 0 # vertival movement
		delta_y < 0 ? inc = -1 : inc = 1
		for i = (yi+inc):inc:y
			new_cords::Tuple{Int64,Int64} = (x,i)
			if haskey(enemy.activeS,new_cords) == true
				move_piece(B,set,enemy,piece,new_cords)
			elseif haskey(set.activeS,new_cords) == true
				println("illegal move"); return
			end
		end
		move_piece(B,set,enemy,piece,cords)
	end
	# IF EXECUTION FALLS HERE: target cords == current cords => skip move
end

function move_lancerB(B::Board, set::Pieces, enemy::Pieces, piece, cords)
	# check if promoted
	if piece[1] == 'L'
		move_black_g(B,set,enemy,piece,cords); return 
	end
	# initial x and y cords 
	xi = set.active[piece][1]; yi = set.active[piece][2] 
	# target coordinates
	x = cords[1]; y = cords[2]
	# take differences
	delta_x = x - xi; delta_y = y - yi;
	
	if delta_x != 0 # illegal movement
		println("illegal move"); return
	elseif delta_y > 0 # backwards movement
		println("illegal move"); return
	else
		for i = (yi-1):-1:y
			new_cords::Tuple{Int64,Int64} = (x,i)
			if haskey(enemy.activeS,new_cords) == true
				move_piece(B,set,enemy,piece,new_cords); return
			elseif haskey(set.activeS,new_cords) == true
				println("illegal move"); return
			end
		end
		# if execution falls here then move is legal
		move_piece(B,set,enemy,piece,cords)
	end
	# IF EXECUTION FALLS HERE: target cords == current cords => skip move
end

function move_lancerR(B::Board, set::Pieces, enemy::Pieces, piece, cords)
	# check if promoted
	if piece[1] == 'L'
		move_black_g(B,set,enemy,piece,cords); return 
	end
	# initial x and y cords 
	xi = set.active[piece][1]; yi = set.active[piece][2] 
	# target coordinates
	x = cords[1]; y = cords[2]
	# take differences
	delta_x = x - xi; delta_y = y - yi;

	if delta_x != 0 # illegal movement
		println("illegal move"); return
	elseif delta_y < 0 # backwards movement
			println("illegal"); return
	else
		for i = (yi+1):1:y
			new_cords::Tuple{Int64,Int64} = (x,i)
			if haskey(enemy.activeS,new_cords) == true
				move_piece(B,set,enemy,piece,new_cords); return
			elseif haskey(set.activeS,new_cords) == true
				println("illegal move"); return
			end
		end
		# if execution falls here then move is legal
		move_piece(B,set,enemy,piece,cords)
	end
	# IF EXECUTION FALLS HERE: target cords == current cords => skip move
end
