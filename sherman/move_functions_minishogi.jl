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
	if y != 5 && haskey(set.activeS,(x,y+1)) == 0
		push!(legal,(x,y+1)) # add this location to list of possible ones
	end

	# if pawn is unpromoted, there is only one possible move: (x,y+1)
	if piece[1] == 'p'
		cords == legal[1] ?	
			move_piece(B,set,inactive,piece,cords) :
			println("illegal move")
	else # pawn is promoted to gold general - shiiiet 
		if y != 5 && x != 5 && x != 1 
			haskey(set.activeS,(x+1,y+1)) == 0 && push!(legal,(x+1,y+1))
			haskey(set.activeS,(x-1,y+1)) == 0 && push!(legal,(x-1,y+1))
			# add left and right movement
			haskey(set.activeS,(x+1,y)) == 0 && push!(legal,(x+1,y))
			haskey(set.activeS,(x-1,y)) == 0 && push!(legal,(x-1,y))
		elseif y == 5 && x != 5 && x != 1
			haskey(set.activeS,(x-1,y)) == 0 && push!(legal,(x-1,y))
			haskey(set.activeS,(x+1,y)) == 0 && push!(legal,(x+1,y))
		elseif y != 5 && x == 5 # if piece is on left side of board, and y != 5
			haskey(set.activeS,(x-1,y+1)) == 0 && push!(legal,(x-1,y+1))
			haskey(set.activeS,(x,y+1)) == 0 && push!(legal,(x,y+1))
			haskey(set.activeS,(x-1,y)) == 0 && push!(legal,(x-1,y))
		elseif y != 5 && x == 1 # if piece is on right side of board, and y != 5
			haskey(set.activeS,(x+1,y+1)) == 0 && push!(legal,(x+1,y+1))
			haskey(set.activeS,(x,y+1)) == 0 && push!(legal,(x,y+1))
			haskey(set.activeS,(x+1,y)) == 0 && push!(legal,(x+1,y))
		elseif x == 5 # if y == 5 and x == 5
			haskey(set.activeS,(x-1,y)) == 0 && push!(legal,(x-1,y))
		elseif x == 1 # if x == 1 and y = 5
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
		if y != 1 && x != 1 && x != 5
			haskey(set.activeS,(x-1,y-1)) == 0 && push!(legal,(x-1,y-1))
			haskey(set.activeS,(x+1,y-1)) == 0 && push!(legal,(x+1,y-1))
			# add left and right movement
			haskey(set.activeS,(x+1,y)) == 0 && push!(legal,(x+1,y))
			haskey(set.activeS,(x-1,y)) == 0 && push!(legal,(x-1,y))
		elseif y == 1 && x != 1 && x != 5
			haskey(set.activeS,(x-1,y)) == 0 && push!(legal,(x-1,y))
			haskey(set.activeS,(x+1,y)) == 0 && push!(legal,(x+1,y))
		elseif y != 1 && x == 5 # if piece is on left side of board, and y != 1
			haskey(set.activeS,(x-1,y-1)) == 0 && push!(legal,(x-1,y+1))
			haskey(set.activeS,(x-1,y)) == 0 && push!(legal,(x-1,y))
		elseif y != 1 && x == 1 # if piece is on right side of board, and y != 1
			haskey(set.activeS,(x+1,y-1)) == 0 && push!(legal,(x+1,y-1))
			haskey(set.activeS,(x+1,y)) == 0 && push!(legal,(x+1,y))
		elseif x == 5 # if x == 5 and y == 1
			haskey(set.activeS,(x-1,y)) == 0 && push!(legal,(x-1,y))
		elseif x == 1 # if x == 1 and y = 1
			haskey(set.activeS,(x+1,y)) == 0 && push!(legal,(x+1,y))
		end
		# adds the backsetp allowable coordinates
		if y != 5
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

	if y != 5 && x != 5 && x != 1 
		haskey(set.activeS,(x,y+1)) == 0 && push!(legal,(x,y+1))
		haskey(set.activeS,(x+1,y+1)) == 0 && push!(legal,(x+1,y+1))
		haskey(set.activeS,(x-1,y+1)) == 0 && push!(legal,(x-1,y+1))
		# add left and right movement
		haskey(set.activeS,(x+1,y)) == 0 && push!(legal,(x+1,y))
		haskey(set.activeS,(x-1,y)) == 0 && push!(legal,(x-1,y))
	elseif y == 5 && x != 5 && x != 1
		haskey(set.activeS,(x-1,y)) == 0 && push!(legal,(x-1,y))
		haskey(set.activeS,(x+1,y)) == 0 && push!(legal,(x+1,y))
	elseif y != 5 && x == 5 # if piece is on left side of board, and y != 5
		haskey(set.activeS,(x-1,y+1)) == 0 && push!(legal,(x-1,y+1))
		haskey(set.activeS,(x,y+1)) == 0 && push!(legal,(x,y+1))
		haskey(set.activeS,(x-1,y)) == 0 && push!(legal,(x-1,y))
	elseif y != 5 && x == 1 # if piece is on right side of board, and y != 5
		haskey(set.activeS,(x+1,y+1)) == 0 && push!(legal,(x+1,y+1))
		haskey(set.activeS,(x,y+1)) == 0 && push!(legal,(x,y+1))
		haskey(set.activeS,(x+1,y)) == 0 && push!(legal,(x+1,y))
	elseif x == 5 # if y == 5 and x == 5
		haskey(set.activeS,(x-1,y)) == 0 && push!(legal,(x-1,y))
	elseif x == 1 # if x == 1 and y = 5
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

	if y != 1 && x != 1 && x != 5 
		haskey(set.activeS,(x,y-1)) == 0 && push!(legal,(x,y-1))
		haskey(set.activeS,(x-1,y-1)) == 0 && push!(legal,(x-1,y-1))
		haskey(set.activeS,(x+1,y-1)) == 0 && push!(legal,(x+1,y-1))
		# add left and right movement
		haskey(set.activeS,(x+1,y)) == 0 && push!(legal,(x+1,y))
		haskey(set.activeS,(x-1,y)) == 0 && push!(legal,(x-1,y))
	elseif y == 1 && x != 1 && x != 5
		haskey(set.activeS,(x-1,y)) == 0 && push!(legal,(x-1,y))
		haskey(set.activeS,(x+1,y)) == 0 && push!(legal,(x+1,y))
	elseif y != 1 && x == 5 # if piece is on left side of board, and y != 1
		haskey(set.activeS,(x-1,y-1)) == 0 && push!(legal,(x-1,y+1))
		haskey(set.activeS,(x,y-1)) == 0 && push!(legal,(x,y+1))
		haskey(set.activeS,(x-1,y)) == 0 && push!(legal,(x-1,y))
	elseif y != 1 && x == 1 # if piece is on right side of board, and y != 1
		haskey(set.activeS,(x+1,y-1)) == 0 && push!(legal,(x+1,y+1))
		haskey(set.activeS,(x,y-1)) == 0 && push!(legal,(x,y+1))
		haskey(set.activeS,(x+1,y)) == 0 && push!(legal,(x+1,y))
	elseif x == 5 # if x == 5 and y == 1
		haskey(set.activeS,(x-1,y)) == 0 && push!(legal,(x-1,y))
	elseif x == 1 # if x == 1 and y = 1
		haskey(set.activeS,(x+1,y)) == 0 && push!(legal,(x+1,y))
	end
	# adds the backstep allowable coordinates
	if y != 5
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

function move_king(B::Board, set::Pieces, enemy::Pieces, piece, cords)
	# initial x and y cords 
	xi = set.active[piece][1]; yi = set.active[piece][2] 
	# target coordinates
	x = cords[1]; y = cords[2]
	# check for out of bounds
	if x < 1 || x > 5 
		println("illegal move"); return
	elseif y < 1 || y > 5
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


# silver general
function move_red_s(B::Board, set::Pieces, inactive::Pieces, piece, cords)
	# stores coordinates of legal moves
	legal = Tuple{Int,Int}[] 
	# initial legal cords
	x = set.active[piece][1]; y = set.active[piece][2]

	# check if given coordinates equal to current coordinates
	if cords == set.active[piece]
		return
	end

	# if silver general is unpromoted
	if piece[1] == 's'
		if y != 5 && x != 5 && x != 1 
			haskey(set.activeS,(x,y+1)) == 0 && push!(legal,(x,y+1))
			haskey(set.activeS,(x+1,y+1)) == 0 && push!(legal,(x+1,y+1))
			haskey(set.activeS,(x-1,y+1)) == 0 && push!(legal,(x-1,y+1))
		# silver general cannot move left or right one space
		#elseif y == 5 && x != 5 && x != 1
			#haskey(set.activeS,(x-1,y)) == 0 && push!(legal,(x-1,y))
			#haskey(set.activeS,(x+1),y)) == 0 && push!(legal,(x+1,y))
		elseif y != 5 && x == 5 # if piece is on left side of board, and y != 5
			haskey(set.activeS,(x-1,y+1)) == 0 && push!(legal,(x-1,y+1))
			haskey(set.activeS,(x,y+1)) == 0 && push!(legal,(x,y+1))
		elseif y != 5 && x == 1 # if piece is on right side of board, and y != 5
			haskey(set.activeS,(x+1,y+1)) == 0 && push!(legal,(x+1,y+1))
			haskey(set.activeS,(x,y+1)) == 0 && push!(legal,(x,y+1))
		# silver general cannot move left or right one space
		#elseif x == 5 # if y == 5 and x == 5
			#haskey(set.activeS,(x-1,y)) == 0 && push!(legal,(x-1,y))
		#elseif x == 1 # if x == 1 and y = 5
			#haskey(set.activeS,(x+1,y)) == 0 && push!(legal,(x+1,y))
		end
		# check if steps back are allowable coordinates
		if y != 1
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
	else 	# if silver general is promoted, becomes gold general
		move_black_g(B,set,inactive,piece,(y,x-1))
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
	end

	if piece[1] == 's'
		if y != 1 && x != 1 && x != 5 
			haskey(set.activeS,(x,y-1)) == 0 && push!(legal,(x,y-1))
			haskey(set.activeS,(x-1,y-1)) == 0 && push!(legal,(x-1,y-1))
			haskey(set.activeS,(x+1,y-1)) == 0 && push!(legal,(x+1,y-1))
			# add left and right movement
		# elseif y == 1 && x != 1 && x != 5
		# 	haskey(set.activeS,(x-1,y)) == 0 && push!(legal,(x-1,y))
		# 	haskey(set.activeS,(x+1),y)) == 0 && push!(legal,(x+1,y))
		elseif y != 1 && x == 5 # if piece is on left side of board, and y != 1
			haskey(set.activeS,(x-1,y-1)) == 0 && push!(legal,(x-1,y+1))
			haskey(set.activeS,(x,y-1)) == 0 && push!(legal,(x,y+1))
		elseif y != 1 && x == 1 # if piece is on right side of board, and y != 1
			haskey(set.activeS,(x+1,y-1)) == 0 && push!(legal,(x+1,y+1))
			haskey(set.activeS,(x,y-1)) == 0 && push!(legal,(x,y+1))
		# elseif x == 5 # if x == 5 and y == 1
		# 	haskey(set.activeS,(x-1,y)) == 0 && push!(legal,(x-1,y))
		# elseif x == 1 # if x == 1 and y = 1
		# 	haskey(set.activeS,(x+1,y)) == 0 && push!(legal,(x+1,y))
		end
		# check if steps back are allowable coordinates
		if y != 5
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
	else 	# if silver general is promoted, becomes gold general
		if y != 1 && x != 1 && x != 5 
			haskey(set.activeS,(x,y-1)) == 0 && push!(legal,(x,y-1))
			haskey(set.activeS,(x-1,y-1)) == 0 && push!(legal,(x-1,y-1))
			haskey(set.activeS,(x+1,y-1)) == 0 && push!(legal,(x+1,y-1))
			# add left and right movement
			haskey(set.activeS,(x+1,y)) == 0 && push!(legal,(x+1,y))
			haskey(set.activeS,(x-1,y)) == 0 && push!(legal,(x-1,y))
		elseif y == 1 && x != 1 && x != 5
			haskey(set.activeS,(x-1,y)) == 0 && push!(legal,(x-1,y))
			haskey(set.activeS,(x+1,y)) == 0 && push!(legal,(x+1,y))
		elseif y != 1 && x == 5 # if piece is on left side of board, and y != 1
			haskey(set.activeS,(x-1,y-1)) == 0 && push!(legal,(x-1,y+1))
			haskey(set.activeS,(x,y-1)) == 0 && push!(legal,(x,y+1))
			haskey(set.activeS,(x-1,y)) == 0 && push!(legal,(x-1,y))
		elseif y != 1 && x == 1 # if piece is on right side of board, and y != 1
			haskey(set.activeS,(x+1,y-1)) == 0 && push!(legal,(x+1,y+1))
			haskey(set.activeS,(x,y-1)) == 0 && push!(legal,(x,y+1))
			haskey(set.activeS,(x+1,y)) == 0 && push!(legal,(x+1,y))
		elseif x == 5 # if x == 5 and y == 1
			haskey(set.activeS,(x-1,y)) == 0 && push!(legal,(x-1,y))
		elseif x == 1 # if x == 1 and y = 1
			haskey(set.activeS,(x+1,y)) == 0 && push!(legal,(x+1,y))
		end
		# adds the backstep allowable coordinates
		if y != 5
			haskey(set.activeS,(x,y-1)) == 0 && push!(legal,(x,y-1))
		end
		# check if user input matches a legal move
		if findfirst(legal,cords) != 0 
			move_piece(B, set, inactive, piece, cords)
		else 
			println("illegal move")
		end
	end
end



# bishop
function move_bishop(B::Board, set::Pieces, enemy::Pieces, piece, cords)
	# initial x and y cords 
	xi = set.active[piece][1]; yi = set.active[piece][2] 
	# target coordinates
	x = cords[1]; y = cords[2]
	# check for out of bounds
	if x < 1 || x > 5 
		println("illegal move"); return
	elseif y < 1 || y > 5
		println("illegal move"); return
	end
	# take differences 
	delta_x = abs(x-xi); delta_y = abs(y-yi)
	# check if promoted to DRAGON HORSE!!!
	if piece[1] == 'B'
	  if delta_x == 1 && delta_y == 1
	  	move_piece(B,set,enemy,piece,new_cords); return
	  end
	end
	# otherwise compare if unequal => illegal
	if delta_x != delta_y
		println("illegal move"); return
	end
	# if moving towards top right (5,5)
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
	# if moving towards bottom right (5,1)
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
	# if moving towards top left (1,5)
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

# rook
function move_rook(B::Board, set::Pieces, enemy::Pieces, piece, cords)
	# initial x and y cords 
	xi = set.active[piece][1]; yi = set.active[piece][2] 
	# target coordinates
	x = cords[1]; y = cords[2]
	# take differences
	delta_x = x - xi; delta_y = y - yi;

	inc::Int64 # used in for loops
	if delta_x != 0 && delta_y != 0 # illegal movement
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
