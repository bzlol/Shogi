# Board class encapsulates the game board and keeps a Dict of all 
# the current pieces on the board along with their coordinates.

type Board
	# game board
	board::Array

	# current turn
	turn::Int # black = even, red = odd

	# game status
	status::Bool # in play = 1, game over = 0

	# constructor
	Board() = new(fill("x",5,5),0,1)
end

# collection of all the active pieces and their coordinates
# promoted pieces are uppercase
type Pieces
	color::ASCIIString
	active::Dict # pieces currently on board, piece => cords
	activeS::Dict # cords => pieces 
	promoted::Dict # promoted pieces
	captured::Array # pieces in hand
	# constructor
	Pieces(color::ASCIIString) = new(color,Dict(),Dict(),Dict(),Array{ASCIIString}(0))
end

### INITIALIZATION/SETUP FUNCTIONS

# input function
function input()
	return chomp(readline(STDIN))
end

function fill_black{Pieces}(set::Pieces)
	# fill pawn
	get!(set.active,"p",(5,4)); get!(set.activeS,(5,4),"p")
	# fill bishop
	get!(set.active,"b",(2,5)); get!(set.activeS,(2,5),"b")
	# fill rook
	get!(set.active,"r",(1,5)); get!(set.activeS,(1,5),"r")
	# fill silver generals
	get!(set.active,"s",(3,5)); get!(set.activeS,(3,5),"s")
	# fill gold generals
	get!(set.active,"g",(4,5)); get!(set.activeS,(4,5),"g")
	# place king
	get!(set.active,"k",(5,5)); get!(set.activeS,(5,5),"k")
end

function fill_red{Pieces}(set::Pieces)
	#fill pawn
	get!(set.active,"p",(1,2)); get!(set.activeS,(1,2),"p")
	# fill bishop
	get!(set.active,"b",(4,1)); get!(set.activeS,(4,1),"b")
	# fill rook
	get!(set.active,"r",(5,1)); get!(set.activeS,(5,1),"r")
	# fill silver generals
	get!(set.active,"s",(3,1)); get!(set.activeS,(3,1),"s")
	# fill gold generals
	get!(set.active,"g",(2,1)); get!(set.activeS,(2,1),"g")
	# place king
	get!(set.active,"k",(1,1)); get!(set.activeS,(1,1),"k")
end

# sets a piece onto the board
function set_board(B::Board, pair::Pair)
	piece = pair[1]
	if length(piece) == 1 && piece!= "x"
		piece = "$piece "
	end
	c = pair[2][1]
	r = shift(pair[2][2])
	B.board[r,c] = piece
end

function init_board(B::Board, red::Pieces, black::Pieces)
	# place red pieces onto board
	for pair in red.active
		set_board(B,pair)
	end
	# place black pieces onto board
	for pair in black.active
		set_board(B,pair)
	end
end

# returns a shifted shogi board coordinate to the array coordinates of B.board
function shift(i::Int)
	return 5-i+1
end

# updates the coordinates of a piece 
function update_piece(B::Board, set::Pieces, piece, cords)
	old = set.active[piece] 
	# update cords dict
	pop!(set.activeS,old)
	get!(set.activeS,cords,piece)
	# update piece dict
	set.active[piece] = cords 
	set_board(B,Pair(piece,cords)) # update gameboard
end

# add captured piece to hand
function update_hand(set::Pieces, piece)
	push!(set.captured,piece)
	
end

# 5-i+1 - arranges coordinates in terms of rows and column
function display_board(B::Board,red::Pieces,black::Pieces)
	for i = 1:5
		for j = 1:5
			unit = B.board[i,j]; r = shift(i); c = j
			if unit != "x"
				if unit == "k"
					print_with_color(:yellow,"$unit  ")
				elseif haskey(red.activeS,(c,r)) == true
					print_with_color(:red,"$unit  ")
				else
					print_with_color(:blue,"$unit  ")
				end
			else
				print("$unit   ")
			end
		end
		println()			
	end
	println()
end

### MOVE FUNCTIONS FOR SPECIFIC PIECE TYPES + GENERAL MOVE FUNCTION

function move_piece(B::Board, active::Pieces, inactive::Pieces, piece, cords)
	# replace old location of piece with 'x' on gameboard
	old_cords = active.active[piece]
	set_board(B,Pair("x",old_cords))

	# shift coords
	x = cords[1]; y = shift(cords[2])

	# check for kill
	if B.board[y,x] != "x"
		dead = kill(B,inactive,cords)
		update_hand(active,dead)
		update_piece(B,active, piece, cords)
		# show unpromoted piece before promotion
		active.color == "black" ?
			display_board(B,inactive,active) :
			display_board(B,active,inactive)
	end
	if piece != "g" && piece != "k"
		piece = promote_check(active,piece,cords)
	end
	# update location of piece in dict and board
	update_piece(B,active, piece, cords)
	println("piece equals $piece")
	println(active.active[piece]); println(active.activeS[cords])
end

function promote(set::Pieces,piece,cords)
	println("Promote $(piece)? Type 'yes' or 'no'.")
	user_input = input()
	if user_input == "yes"	
		# remove unpromoted piece
		old = set.active[piece]
		pop!(set.active,piece) 
		pop!(set.activeS,old)
		piece = ucfirst(piece) # promotion
		# add promoted piece
		get!(set.active,piece,cords) 
		get!(set.activeS,cords,piece)
	end
	return piece
end

# check for promotion
function promote_check(set::Pieces, piece, cords)
	if set.color == "black"
		if cords[2] < 3 # if piece is on red side
			piece = promote(set,piece,cords)
		end
	else
		if cords[2] > 3 # if piece is on black side
			piece = promote(set,piece,cords)	
		end
	end
	return piece
end

# check for kill 
function kill(B::Board, set::Pieces, cords)
	dead = set.activeS[cords]
	# remove piece from both collections 		
	pop!(set.activeS,cords)
	pop!(set.active,dead)
	dead == "k" && (B.status = 0) # check if king was slain	
	return dead
end

function drop_piece(B::Board, set::Pieces, piece, cords)
		# pop piece from hand
		i = findfirst(set.captured,piece)
		set.captured[i] = last(set.captured)
		set.captured[length(set.captured)] = piece
		pop!(set.captured)

		# add piece to active list
		i = 0
		for pair in set
			pair[1][1] == piece[1] && (i += 1)
		end
		piece = "$(piece[1])$count" # piece will be the i'th piece of its type on the board

		# add piece to active list
		get!(set.active,piece,cords)
		# set piece onto board
		set_board(B,Pair(piece,cords))
end

### TESTING FUNCTIONS

# test = Board()
# fill_pieces(test) # give pieces their starting coordinates
# set_board(test)

# # print initial state of game board
# display_board(test)

# # move some pieces
# move_piece(test,"p9","49") 
# test.turn = 1 # red turn
# move_piece(test,"k","25") # illegal move
# test.turn = 0 # black turn
# move_piece(test,"p8","48")
# test.turn = 1 # red turn
# move_piece(test,"k",[1,5]) # kill black king
# test.turn = 0 # black turn
# move_piece(test,"g2","27")
# test.turn = 1 # red turn
# drop_piece(test,"k_b",[9,5]) # drop black king


# # print current state of game board
# display_board(test)



