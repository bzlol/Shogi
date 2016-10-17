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

	red_active::Dict() # pieces currently on board, piece => cords
	red_activeS::Dict() # cords => pieces 
	red_promoted::Dict() # promoted pieces
	red_captured::Array # pieces in hand
	# constructor
	Pieces() = new(Dict(),Dict(),Array{ASCIIString}(0))
end


function fill_black{Pieces}(set::Pieces)
	# fill rooks
	for i = 9:-1:1
		get!(set.active,"p$(9-i+1)",[7,i])
		get!(set.activeS,[7,i],"p$(9-i+1)")
	end
	# fill bishops
	get!(set.active,"b2",[8,2]); get!(set.active,"b1",[8,8])
	get!(set.activeS,[8,2],"b2"); get!(set.activeS,[8,8],"b1")
	# fill lancerss
	get!(set.active,"l2",[9,1]); get!(set.active,"l1",[9,9])
	get!(set.activeS,[9,1],"l2"); get!(set.activeS,[9,9],"l1")
	#fill knights
	get!(set.active,"n2",[9,2]); get!(set.active,"n1",[9,8])
	get!(set.activeS,[9,2],"n2"); get!(set.activeS,[9,8],"n1")
	# fill silver generals
	get!(set.active,"s2",[9,3]); get!(set.active,"s1",[9,7])
	get!(set.activeS,[9,3],"s2"); get!(set.activeS,[9,7],"s1")
	# fill gold generals
	get!(set.active,"g2",[9,4]); get!(set.active,"g1",[9,6])
	get!(set.activeS,[9,4],"g2"); get!(set.activeS,[9,6],"g1")
	# place king
	get!(set.active,"k","95"); get!(set.activeS,"95","k")
end

function fill_red{Pieces}(set::pieces)
	for i = 9:-1:1
		get!(set.active,"p$(9-i+1)",[3,i])
		get!(set.activeS,[3,i],"p$(9-i+1)")
	end
	get!(set.active,"b2",[2,2]); get!(set.active,"b1",[2,8])
	get!(set.activeS,[2,2],"b2"); get!(set.activeS,[2,8],"b1")
	get!(set.active,"l2",[1,1]); get!(set.active,"l1",[1,9])
	get!(set.activeS,[1,1],"l2"); get!(set.activeS,[1,9],"l1")
	get!(set.active,"n2",[1,2]); get!(set.active,"n1",[1,8])
	get!(set.activeS,[1,2],"n2"); get!(set.activeS,[1,8],"n1")
	get!(set.active,"s2",[1,3]); get!(set.active,"s1",[1,7])
	get!(set.activeS,[1,3],"s2"); get!(set.activeS,[1,7],"s1")
	get!(set.active,"g2",[1,4]); get!(set.active,"g1",[1,6])
	get!(set.activeS,[1,4],"g2"); get!(set.activeS,[1,6],"g1")
	get!(set.active,"k",[1,5]); get!(set.activeS,[1,5],"k")
end
end

# sets a piece onto the board
function set_board(B::Board, pair::Pair)
	piece = pair[1]
	x = shift(pair[2][1])
	y = shift(pair[2][2])
	B.board[x,y] = piece
end

function init_board(B::Board, black::Pieces, red::Pieces)
	# place red pieces onto board
	for pair in red.active
		set_piece(B,pair)
	end
	# place black pieces onto board
	for pair in black.active
		set_piece(B,pair)
	end
end

# returns a shifted shogi board coordinate to the array coordinates of B.board
function shift(i::Int)
	return 9-i+1
end

# updates the coordinates of a piece 
function update_piece(B::board, set::Pieces, piece, cords)
	set[piece] = cords # update piece
	set_piece(B,Pair(piece,cords))
end

# check for kill 
function kill(B::Board, set::Pieces, cords)
	dead = set.activeS[cords]
	# remove piece from both collections 		
	pop!(set.activeS,cords)
	pop!(set.active,dead)
	dead = "k" && (B.status = 0) # check if king was slain	
	return dead
end

# add captured piece to hand
function update_hand(set::Pieces, piece)
	push!(set.captured,piece)
	
end

function move_piece(B::Board, active::Pieces, inactive::Pieces, piece, cords)
	# replace old location of piece with 'x' on gameboard
	cords = active.active[piece]
	set_board(B,Pair("x",cords)

	x = shift(cords[1]); y = shift(cords[2]) # shift coords
	# check for kill
	if B.board[x,y] != "x"
		dead = kill(B,inactive,cords)
		update_hand(active,dead)
	end
	update_piece(B,active, piece, cords) # update location of piece in dict and board
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

# 9-i+1 - arranges coordinates in terms of rows and column
function display_board(B::Board,red::Pieces,black::Pieces)
	for i = 1:9
		for j = 1:9
			unit = B.board[i,j]; x = shift(i); y = shift(j)
			if unit != "x"
				if unit == "k"
					print_with_color(:yellow,"$unit  ")
				elseif haskey(red.activeS,[x,y]) == true
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
# drop_piece(test,"k_b","95") # drop black king


# # print current state of game board
# display_board(test)





