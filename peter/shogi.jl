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
	Board() = new(fill("x",9,9),0,1)
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

function fill_black{Pieces}(set::Pieces)
	# fill rooks
	for i = 1:9
		get!(set.active,"p$(i)",(i,7))
		get!(set.activeS,(i,7),"p$(9-i+1)")
	end
	# fill bishops
	get!(set.active,"b2",(8,8)); get!(set.active,"b1",(2,8))
	get!(set.activeS,(8,8),"b2"); get!(set.activeS,(2,8),"b1")
	# fill lancerss
	get!(set.active,"l2",(9,9)); get!(set.active,"l1",(1,9))
	get!(set.activeS,(9,9),"l2"); get!(set.activeS,(1,9),"l1")
	#fill knights
	get!(set.active,"n2",(8,9)); get!(set.active,"n1",(2,9))
	get!(set.activeS,(8,9),"n2"); get!(set.activeS,(2,9),"n1")
	# fill silver generals
	get!(set.active,"s2",(7,9)); get!(set.active,"s1",(3,9))
	get!(set.activeS,(7,9),"s2"); get!(set.activeS,(3,9),"s1")
	# fill gold generals
	get!(set.active,"g2",(6,9)); get!(set.active,"g1",(4,9))
	get!(set.activeS,(6,9),"g2"); get!(set.activeS,(4,9),"g1")
	# place king
	get!(set.active,"k",(5,9)); get!(set.activeS,(5,9),"k")
end

function fill_red{Pieces}(set::Pieces)
	for i = 1:9
		get!(set.active,"p$(i)",(i,3))
		get!(set.activeS,(i,3),"p$(9-i+1)")
	end
	get!(set.active,"b2",(8,2)); get!(set.active,"b1",(2,2))
	get!(set.activeS,(8,2),"b2"); get!(set.activeS,(2,2),"b1")
	get!(set.active,"l2",(9,1)); get!(set.active,"l1",(1,1))
	get!(set.activeS,(9,1),"l2"); get!(set.activeS,(1,1),"l1")
	get!(set.active,"n2",(8,1)); get!(set.active,"n1",(2,1))
	get!(set.activeS,(8,1),"n2"); get!(set.activeS,(2,1),"n1")
	get!(set.active,"s2",(3,1)); get!(set.active,"s1",(7,1))
	get!(set.activeS,(3,1),"s2"); get!(set.activeS,(7,1),"s1")
	get!(set.active,"g2",(4,1)); get!(set.active,"g1",(6,1))
	get!(set.activeS,(6,1),"g2"); get!(set.activeS,(4,1),"g1")
	get!(set.active,"k",(5,1)); get!(set.activeS,(5,1),"k")
end

# sets a piece onto the board
function set_board(B::Board, pair::Pair)
	piece = pair[1]
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
	return 9-i+1
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

# 9-i+1 - arranges coordinates in terms of rows and column
function display_board(B::Board,red::Pieces,black::Pieces)
	for i = 1:9
		for j = 1:9
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
	r = shift(cords[2]); c = cords[1]

	# check for kill
	if B.board[r,c] != "x"
		dead = kill(B,inactive,cords)
		update_hand(active,dead)
		piece = promote(active,piece,cords)
	end
	# update location of piece in dict and board
	update_piece(B,active, piece, cords) 
end

# check for promotion
function promote(set::Pieces, piece, cords)
	promoted::ASCIIString = piece
	if set.color == "black"
		if cords[1] < 4 # if piece is on red side
			promoted = ucfirst(piece) # promotion
			pop!(set.active,piece) # remove unpromoted piece
			get!(set.active,promoted,cords) # add promoted piece
			set.activeS[cords] = promoted # update cords dict
		end
	else
		if cords[1] > 6 # if piece is on black side
			promoted = ucfirst(piece) # promotion
			pop!(set.active,piece) # remove unpromoted piece
			get!(set.active,promoted,cords) # add promoted piece
			set.activeS[cords] = promoted # update cords dict
		end
	end
	return promoted
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





