# black pawn
function move_black_p(B::Board, set::Pieces, inactive::Pieces, piece, cords)
	# stores coordinates of legal moves
	legal = Tuple{Int,Int}[] 
	# initial legal cords
	x = set.active[piece][1]; y = set.active[piece][2]

	# basic move both unpromoted and promoted can make
	if y != 9 && haskey(set.activeS,(x,y+1)) == 0
		push!(legal,(x,y+1)) # add this location to list of possible ones
	end

	# if pawn is unpromoted, there is only one possible move: (x,y+1)
	if piece[1] == 'p'
		cords == legal[1] && move_piece(Board,set,inactive,piece,cords)
	else # pawn is promoted to gold general - shiiiet 
		if y != 9 && x != 9 && x != 1 
			haskey(set.activeS,(x+1,y+1)) == 0 && push!(legal,(x+1,y+1))
			haskey(set.activeS,(x-1,y+1)) == 0 && push!(legal,(x-1,y+1))
			# add left and right movement
			haskey(set.activeS,(x+1,y)) == 0 && push!(legal,(x+1,y))
			haskey(set.activeS,(x-1,y)) == 0 && push!(legal,(x-1,y))
		elseif y == 9 && x != 9 && x != 1
			haskey(set.activeS,(x-1,y)) == 0 && push!(legal,(x-1,y))
			haskey(set.activeS,(x+1),y)) == 0 && push!(legal,(x+1,y))
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
			move_piece(Board, set, inactive, piece, cords)
		else 
			println("illegal move")
			B.status = 0
		end
	end
end

# red pawn
function move_red_p(B::Board, set::Pieces, inactive::Pieces, piece, cords)
	# stores coordinates of legal moves
	legal = Tuple{Int,Int}[] 
	# initial legal cords
	x = set.active[piece][1]; y = set.active[piece][2]

	# basic move both unpromoted and promoted can make
	if y != 1 && haskey(set.activeS,(x,y-1)) == 0
		push!(legal,(x,y-1)) # add this location to list of possible ones
	end

	# if pawn is unpromoted, there is only one possible move: (x,y-1)
	if piece[1] == 'p'
		cords == legal[1] && move_piece(Board,set,inactive,piece,cords)
	else # pawn is promoted to gold general - shiiiet 
		if y != 1 && x != 1 && x != 9 
			haskey(set.activeS,(x-1,y-1)) == 0 && push!(legal,(x-1,y-1))
			haskey(set.activeS,(x+1,y-1)) == 0 && push!(legal,(x+1,y-1))
			# add left and right movement
			haskey(set.activeS,(x+1,y)) == 0 && push!(legal,(x+1,y))
			haskey(set.activeS,(x-1,y)) == 0 && push!(legal,(x-1,y))
		elseif y == 1 && x != 1 && x != 9
			haskey(set.activeS,(x-1,y)) == 0 && push!(legal,(x-1,y))
			haskey(set.activeS,(x+1),y)) == 0 && push!(legal,(x+1,y))
		elseif y != 1 && x == 9 # if piece is on left side of board, and y != 1
			haskey(set.activeS,(x-1,y-1)) == 0 && push!(legal,(x-1,y+1))
			haskey(set.activeS,(x,y-1)) == 0 && push!(legal,(x,y+1))	#extra?
			haskey(set.activeS,(x-1,y)) == 0 && push!(legal,(x-1,y))
		elseif y != 1 && x == 1 # if piece is on right side of board, and y != 1
			haskey(set.activeS,(x+1,y-1)) == 0 && push!(legal,(x+1,y+1))
			haskey(set.activeS,(x,y-1)) == 0 && push!(legal,(x,y+1))	#extra?
			haskey(set.activeS,(x+1,y)) == 0 && push!(legal,(x+1,y))
		elseif x == 9 # if x == 9 and y == 1
			haskey(set.activeS,(x-1,y)) == 0 && push!(legal,(x-1,y))
		elseif x == 1 # if x == 1 and y = 1
			haskey(set.activeS,(x+1,y)) == 0 && push!(legal,(x+1,y))
		end
		# adds the backsetp allowable coordinates
		if y != 9
			haskey(set.activeS,(x,y-1)) == 0 && push!(legal,(x,y-1))
		end
		# check if user input matches a legal move
		if findfirst(legal,cords) != 0 
			move_piece(Board, set, inactive, piece, cords)
		else 
			println("illegal move")
			B.status = 0
		end
	end
end

# black gold general
function move_black_g(B::Board, set::Pieces, inactive::Pieces, piece, cords)
	# stores coordinates of legal moves
	legal = Tuple{Int,Int}[] 
	# initial legal cords
	x = set.active[piece][1]; y = set.active[piece][2]

	if y != 9 && x != 9 && x != 1 
		hashkey(set.activeS,(x,y+1)) == 0 && push!(legal,(x,y+1))
		haskey(set.activeS,(x+1,y+1)) == 0 && push!(legal,(x+1,y+1))
		haskey(set.activeS,(x-1,y+1)) == 0 && push!(legal,(x-1,y+1))
		# add left and right movement
		haskey(set.activeS,(x+1,y)) == 0 && push!(legal,(x+1,y))
		haskey(set.activeS,(x-1,y)) == 0 && push!(legal,(x-1,y))
	elseif y == 9 && x != 9 && x != 1
		haskey(set.activeS,(x-1,y)) == 0 && push!(legal,(x-1,y))
		haskey(set.activeS,(x+1),y)) == 0 && push!(legal,(x+1,y))
	elseif y != 9 && x == 9 # if piece is on left side of board, and y != 9
		haskey(set.activeS,(x-1,y+1)) == 0 && push!(legal,(x-1,y+1))
		haskey(set.activeS,(x,y+1)) == 0 && push!(legal,(x,y+1))
		haskey(set.activeS,(x-1,y)) == 0 && push!(legal,(x-1,y))
	else if y != 9 && x == 1 # if piece is on right side of board, and y != 9
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
		move_piece(Board, set, inactive, piece, cords)
	else 
		println("illegal move")
		B.status = 0
	end
end

# red gold general
function move_red_g(B::Board, set::Pieces, inactive::Pieces, piece, cords)
	# stores coordinates of legal moves
	legal = Tuple{Int,Int}[] 
	# initial legal cords
	x = set.active[piece][1]; y = set.active[piece][2]

	if y != 1 && x != 1 && x != 9 
		haskey(set.activeS,(x,y-1)) == 0 && push!(legal,(x,y-1))
		haskey(set.activeS,(x-1,y-1)) == 0 && push!(legal,(x-1,y-1))
		haskey(set.activeS,(x+1,y-1)) == 0 && push!(legal,(x+1,y-1))
		# add left and right movement
		haskey(set.activeS,(x+1,y)) == 0 && push!(legal,(x+1,y))
		haskey(set.activeS,(x-1,y)) == 0 && push!(legal,(x-1,y))
	elseif y == 1 && x != 1 && x != 9
		haskey(set.activeS,(x-1,y)) == 0 && push!(legal,(x-1,y))
		haskey(set.activeS,(x+1),y)) == 0 && push!(legal,(x+1,y))
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
	# adds the backstep allowable coordinates
	if y != 9
		haskey(set.activeS,(x,y-1)) == 0 && push!(legal,(x,y-1))
	end
	# check if user input matches a legal move
	if findfirst(legal,cords) != 0 
		move_piece(Board, set, inactive, piece, cords)
	else 
		println("illegal move")
		B.status = 0
	end
end

# black king
function move_black_k(B::Board, set::Pieces, inactive::Pieces, piece, cords)
	# stores coordinates of legal moves
	legal = Tuple{Int,Int}[] 
	# initial legal cords
	x = set.active[piece][1]; y = set.active[piece][2]

	if y != 9 && x != 9 && x != 1 
		hashkey(set.activeS,(x,y+1)) == 0 && push!(legal,(x,y+1))
		haskey(set.activeS,(x+1,y+1)) == 0 && push!(legal,(x+1,y+1))
		haskey(set.activeS,(x-1,y+1)) == 0 && push!(legal,(x-1,y+1))
		# add left and right movement
		haskey(set.activeS,(x+1,y)) == 0 && push!(legal,(x+1,y))
		haskey(set.activeS,(x-1,y)) == 0 && push!(legal,(x-1,y))
	elseif y == 9 && x != 9 && x != 1
		haskey(set.activeS,(x-1,y)) == 0 && push!(legal,(x-1,y))
		haskey(set.activeS,(x+1),y)) == 0 && push!(legal,(x+1,y))
	elseif y != 9 && x == 9 # if piece is on left side of board, and y != 9
		haskey(set.activeS,(x-1,y+1)) == 0 && push!(legal,(x-1,y+1))
		haskey(set.activeS,(x,y+1)) == 0 && push!(legal,(x,y+1))
		haskey(set.activeS,(x-1,y)) == 0 && push!(legal,(x-1,y))
	else if y != 9 && x == 1 # if piece is on right side of board, and y != 9
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
		move_piece(Board, set, inactive, piece, cords)
	else 
		println("illegal move")
		B.status = 0
	end
end

# red king
function move_red_k(B::Board, set::Pieces, inactive::Pieces, piece, cords)
	# stores coordinates of legal moves
	legal = Tuple{Int,Int}[] 
	# initial legal cords
	x = set.active[piece][1]; y = set.active[piece][2]

	if y != 1 && x != 1 && x != 9 
		haskey(set.activeS,(x,y-1)) == 0 && push!(legal,(x,y-1))
		haskey(set.activeS,(x-1,y-1)) == 0 && push!(legal,(x-1,y-1))
		haskey(set.activeS,(x+1,y-1)) == 0 && push!(legal,(x+1,y-1))
		# add left and right movement
		haskey(set.activeS,(x+1,y)) == 0 && push!(legal,(x+1,y))
		haskey(set.activeS,(x-1,y)) == 0 && push!(legal,(x-1,y))
	elseif y == 1 && x != 1 && x != 9
		haskey(set.activeS,(x-1,y)) == 0 && push!(legal,(x-1,y))
		haskey(set.activeS,(x+1),y)) == 0 && push!(legal,(x+1,y))
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
		askey(set.activeS,(x+1,y-1)) == 0 && push!(legal,(x+1,y-1))
		askey(set.activeS,(x-1,y-1)) == 0 && push!(legal,(x-1,y-1))
	end
	# check if user input matches a legal move
	if findfirst(legal,cords) != 0 
		move_piece(Board, set, inactive, piece, cords)
	else 
		println("illegal move")
		B.status = 0
	end
end

# black silver general
function move_black_s(B::Board, set::Pieces, inactive::Pieces, piece, cords)
	# stores coordinates of legal moves
	legal = Tuple{Int,Int}[] 
	# initial legal cords
	x = set.active[piece][1]; y = set.active[piece][2]

	# if silver general is unpromoted
	if piece[1] = 's'
		if y != 9 && x != 9 && x != 1 
			hashkey(set.activeS,(x,y+1)) == 0 && push!(legal,(x,y+1))
			haskey(set.activeS,(x+1,y+1)) == 0 && push!(legal,(x+1,y+1))
			haskey(set.activeS,(x-1,y+1)) == 0 && push!(legal,(x-1,y+1))
		# silver general cannot move left or right one space
		#elseif y == 9 && x != 9 && x != 1
			#haskey(set.activeS,(x-1,y)) == 0 && push!(legal,(x-1,y))
			#haskey(set.activeS,(x+1),y)) == 0 && push!(legal,(x+1,y))
		elseif y != 9 && x == 9 # if piece is on left side of board, and y != 9
			haskey(set.activeS,(x-1,y+1)) == 0 && push!(legal,(x-1,y+1))
			haskey(set.activeS,(x,y+1)) == 0 && push!(legal,(x,y+1))
		else if y != 9 && x == 1 # if piece is on right side of board, and y != 9
			haskey(set.activeS,(x+1,y+1)) == 0 && push!(legal,(x+1,y+1))
			haskey(set.activeS,(x,y+1)) == 0 && push!(legal,(x,y+1))
		# silver general cannot move left or right one space
		#elseif x == 9 # if y == 9 and x == 9
			#haskey(set.activeS,(x-1,y)) == 0 && push!(legal,(x-1,y))
		#elseif x == 1 # if x == 1 and y = 9
			#haskey(set.activeS,(x+1,y)) == 0 && push!(legal,(x+1,y))
		end
		# check if steps back are allowable coordinates
		if y != 1
			haskey(set.activeS,(x-1,y-1)) == 0 && push!(legal,(x-1,y-1))
			haskey(set.activeS,(x+1,y-1)) == 0 && push!(legal,(x+1,y-1))
		end
		# check if user input matches a legal move
		if findfirst(legal,cords) != 0 
			move_piece(Board, set, inactive, piece, cords)
		else 
			println("illegal move")
			B.status = 0
		end
	else 	# if silver general is promoted, becomes gold general
		if y != 9 && x != 9 && x != 1 
			hashkey(set.activeS,(x,y+1)) == 0 && push!(legal,(x,y+1))
			haskey(set.activeS,(x+1,y+1)) == 0 && push!(legal,(x+1,y+1))
			haskey(set.activeS,(x-1,y+1)) == 0 && push!(legal,(x-1,y+1))
			# add left and right movement
			haskey(set.activeS,(x+1,y)) == 0 && push!(legal,(x+1,y))
			haskey(set.activeS,(x-1,y)) == 0 && push!(legal,(x-1,y))
		elseif y == 9 && x != 9 && x != 1
			haskey(set.activeS,(x-1,y)) == 0 && push!(legal,(x-1,y))
			haskey(set.activeS,(x+1),y)) == 0 && push!(legal,(x+1,y))
		elseif y != 9 && x == 9 # if piece is on left side of board, and y != 9
			haskey(set.activeS,(x-1,y+1)) == 0 && push!(legal,(x-1,y+1))
			haskey(set.activeS,(x,y+1)) == 0 && push!(legal,(x,y+1))
			haskey(set.activeS,(x-1,y)) == 0 && push!(legal,(x-1,y))
		else if y != 9 && x == 1 # if piece is on right side of board, and y != 9
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
			move_piece(Board, set, inactive, piece, cords)
		else 
			println("illegal move")
			B.status = 0
		end
	end
end

# red silver general
function move_red_s(B::Board, set::Pieces, inactive::Pieces, piece, cords)
	# stores coordinates of legal moves
	legal = Tuple{Int,Int}[] 
	# initial legal cords
	x = set.active[piece][1]; y = set.active[piece][2]

	if piece[1] = 's'
		if y != 1 && x != 1 && x != 9 
			haskey(set.activeS,(x,y-1)) == 0 && push!(legal,(x,y-1))
			haskey(set.activeS,(x-1,y-1)) == 0 && push!(legal,(x-1,y-1))
			haskey(set.activeS,(x+1,y-1)) == 0 && push!(legal,(x+1,y-1))
			# add left and right movement
		# elseif y == 1 && x != 1 && x != 9
		# 	haskey(set.activeS,(x-1,y)) == 0 && push!(legal,(x-1,y))
		# 	haskey(set.activeS,(x+1),y)) == 0 && push!(legal,(x+1,y))
		elseif y != 1 && x == 9 # if piece is on left side of board, and y != 1
			haskey(set.activeS,(x-1,y-1)) == 0 && push!(legal,(x-1,y+1))
			haskey(set.activeS,(x,y-1)) == 0 && push!(legal,(x,y+1))
		elseif y != 1 && x == 1 # if piece is on right side of board, and y != 1
			haskey(set.activeS,(x+1,y-1)) == 0 && push!(legal,(x+1,y+1))
			haskey(set.activeS,(x,y-1)) == 0 && push!(legal,(x,y+1))
		# elseif x == 9 # if x == 9 and y == 1
		# 	haskey(set.activeS,(x-1,y)) == 0 && push!(legal,(x-1,y))
		# elseif x == 1 # if x == 1 and y = 1
		# 	haskey(set.activeS,(x+1,y)) == 0 && push!(legal,(x+1,y))
		end
		# check if steps back are allowable coordinates
		if y != 9
			askey(set.activeS,(x+1,y-1)) == 0 && push!(legal,(x+1,y-1))
			askey(set.activeS,(x-1,y-1)) == 0 && push!(legal,(x-1,y-1))
		end
		# check if user input matches a legal move
		if findfirst(legal,cords) != 0 
			move_piece(Board, set, inactive, piece, cords)
		else 
			println("illegal move")
			B.status = 0
		end
	else 	# if silver general is promoted, becomes gold general
		if y != 1 && x != 1 && x != 9 
			haskey(set.activeS,(x,y-1)) == 0 && push!(legal,(x,y-1))
			haskey(set.activeS,(x-1,y-1)) == 0 && push!(legal,(x-1,y-1))
			haskey(set.activeS,(x+1,y-1)) == 0 && push!(legal,(x+1,y-1))
			# add left and right movement
			haskey(set.activeS,(x+1,y)) == 0 && push!(legal,(x+1,y))
			haskey(set.activeS,(x-1,y)) == 0 && push!(legal,(x-1,y))
		elseif y == 1 && x != 1 && x != 9
			haskey(set.activeS,(x-1,y)) == 0 && push!(legal,(x-1,y))
			haskey(set.activeS,(x+1),y)) == 0 && push!(legal,(x+1,y))
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
		# adds the backstep allowable coordinates
		if y != 9
			haskey(set.activeS,(x,y-1)) == 0 && push!(legal,(x,y-1))
		end
		# check if user input matches a legal move
		if findfirst(legal,cords) != 0 
			move_piece(Board, set, inactive, piece, cords)
		else 
			println("illegal move")
			B.status = 0
		end
	end
end

# black knight
function move_black_n(B::Board, set::Pieces, inactive::Pieces, piece, cords)
	# stores coordinates of legal moves
	legal = Tuple{Int,Int}[] 
	# initial legal cords
	x = set.active[piece][1]; y = set.active[piece][2]

	# if knight is unpromoted
	if piece[1] = 'n'
		if y <= 8 && x != 9 && x != 1
			haskey(set.activeS,(x-1,y+2)) == 0 && push!(legal,(x-1,y+2))
			haskey(set.activeS,(x+1,y+2)) == 0 && push!(legal,(x+1,y+2))
		elseif y <= 8 && x == 9 # if piece is on left side of board, and y <= 8
			haskey(set.activeS,(x-1,y+2)) == 0 && push!(legal,(x-1,y+2))
		elseif y <= 8 && x == 1 # if piece is on right side of board, and y <= 8
			haskey(set.activeS,(x+1,y+2)) == 0 && push!(legal,(x+1,y+2))
		end
	else 	# if knight is promoted, becomes gold general
		if y != 9 && x != 9 && x != 1 
			hashkey(set.activeS,(x,y+1)) == 0 && push!(legal,(x,y+1))
			haskey(set.activeS,(x+1,y+1)) == 0 && push!(legal,(x+1,y+1))
			haskey(set.activeS,(x-1,y+1)) == 0 && push!(legal,(x-1,y+1))
			# add left and right movement
			haskey(set.activeS,(x+1,y)) == 0 && push!(legal,(x+1,y))
			haskey(set.activeS,(x-1,y)) == 0 && push!(legal,(x-1,y))
		elseif y == 9 && x != 9 && x != 1
			haskey(set.activeS,(x-1,y)) == 0 && push!(legal,(x-1,y))
			haskey(set.activeS,(x+1),y)) == 0 && push!(legal,(x+1,y))
		elseif y != 9 && x == 9 # if piece is on left side of board, and y != 9
			haskey(set.activeS,(x-1,y+1)) == 0 && push!(legal,(x-1,y+1))
			haskey(set.activeS,(x,y+1)) == 0 && push!(legal,(x,y+1))
			haskey(set.activeS,(x-1,y)) == 0 && push!(legal,(x-1,y))
		else if y != 9 && x == 1 # if piece is on right side of board, and y != 9
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
			move_piece(Board, set, inactive, piece, cords)
		else 
			println("illegal move")
			B.status = 0
		end
	end
end

# red knight
function move_red_n(B::Board, set::Pieces, inactive::Pieces, piece, cords)
	# stores coordinates of legal moves
	legal = Tuple{Int,Int}[] 
	# initial legal cords
	x = set.active[piece][1]; y = set.active[piece][2]
	
	# if knight is unpromoted
	if piece[1] = 'n'

		if y >= 2 && x != 1 && x != 9 
			haskey(set.activeS,(x-1,y-2)) == 0 && push!(legal,(x-1,y-2))
			haskey(set.activeS,(x+1,y-2)) == 0 && push!(legal,(x+1,y-2))
		elseif y >= 2 && x == 9 # if piece is on left side of board, and y >= 2
			haskey(set.activeS,(x-1,y-2)) == 0 && push!(legal,(x-1,y-2))
		elseif y >= 2 && x == 1 # if piece is on right side of board, and y >= 2
			haskey(set.activeS,(x+1,y-2)) == 0 && push!(legal,(x+1,y-2))
		end
	else 	# if knight is promoted, becomes gold general
		if y != 1 && x != 1 && x != 9 
			haskey(set.activeS,(x,y-1)) == 0 && push!(legal,(x,y-1))
			haskey(set.activeS,(x-1,y-1)) == 0 && push!(legal,(x-1,y-1))
			haskey(set.activeS,(x+1,y-1)) == 0 && push!(legal,(x+1,y-1))
			# add left and right movement
			haskey(set.activeS,(x+1,y)) == 0 && push!(legal,(x+1,y))
			haskey(set.activeS,(x-1,y)) == 0 && push!(legal,(x-1,y))
		elseif y == 1 && x != 1 && x != 9
			haskey(set.activeS,(x-1,y)) == 0 && push!(legal,(x-1,y))
			haskey(set.activeS,(x+1),y)) == 0 && push!(legal,(x+1,y))
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
		# adds the backstep allowable coordinates
		if y != 9
			haskey(set.activeS,(x,y-1)) == 0 && push!(legal,(x,y-1))
		end
		# check if user input matches a legal move
		if findfirst(legal,cords) != 0 
			move_piece(Board, set, inactive, piece, cords)
		else 
			println("illegal move")
			B.status = 0
		end
	end
end