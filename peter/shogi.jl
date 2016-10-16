# Board class encapsulates the game board and keeps a Dict of all 
# the current pieces on the board along with their coordinates.

type Board
	# game board
	board::Array

	# current turn
	turn::Int # black = even, red = odd

	# game status
	status::Bool # in play = 1, game over = 0

	# keeps track of active pieces and coordinates
	red_active::Dict
	black_active::Dict

	# keeps track of pieces in each hand available for drop
	red_hand::Array{ASCIIString,1}
	black_hand::Array{ASCIIString,1}

	# constructor
	Board() = new(fill("x",9,9),0,1,Dict(),Dict(),Array{ASCIIString}(0),Array{ASCIIString}(0));
end

function fill_pieces{Board}(B::Board)
	# fill rooks
	for i = 1:9
		get!(B.red_active,"p$(i)","7$i")
		get!(B.black_active,"p$(i)","3$i")
	end
	# fill bishops
	get!(B.red_active,"b1","82"); get!(B.red_active,"b2","88")
	get!(B.black_active,"b1","22"); get!(B.black_active,"b2","28")
	# fill lancers
	get!(B.red_active,"l1","91"); get!(B.red_active,"l2","99")
	get!(B.black_active,"l1","11"); get!(B.black_active,"l2","19")
	# fill knights
	get!(B.red_active,"n1","92"); get!(B.red_active,"n2","98")
	get!(B.black_active,"n1","12"); get!(B.black_active,"n2","18")
	# fill silver generals
	get!(B.red_active,"s1","93"); get!(B.red_active,"s2","97")
	get!(B.black_active,"s1","13"); get!(B.black_active,"s2","17")
	# fill gold generals
	get!(B.red_active,"g1","94"); get!(B.red_active,"g2","96")
	get!(B.black_active,"g1","14"); get!(B.black_active,"g2","16")
	# place kings
	get!(B.red_active,"k","95")
	get!(B.black_active,"k","15")
end

# sets a piece onto the board
function set_piece(B::Board, pair::Pair)
	piece = pair[1]
	r = parse(Int,pair[2][1])
	c = parse(Int,pair[2][2])
	B.board[r,c] = piece
end

function set_board(B::Board)
	# place red pieces onto board
	for key in B.red_active
		set_piece(B,key)
	end
	# place black pieces onto board
	for key in B.black_active
		set_piece(B,key)
	end
end

# updates a red piece
function update_red(B::Board, piece, cords)
	# extract coordinates
	r = parse(Int,cords[1]); c = parse(Int,cords[2])
	B.red_active[piece] = cords # update piece
	B.board[r,c] = piece # update board
end

# updates a black piece
function update_black(B::Board, piece, cords)
	# extract coordinates
	r = parse(Int,cords[1]); c = parse(Int,cords[2])
	B.black_active[piece] = cords # update piece
	B.board[r,c] = piece # update board
end

# check for red kill 
function red_kill(B::Board, cords)
	for Pair in B.black_active
		if Pair[2] == cords
			Pair[1] == "k" && (B.status = 0) # check if king was slain
			dead = Pair[1]
			pop!(B.black_active,Pair[1])
			push!(B.red_hand,dead)
		end
	end
end

# check for black kill
function black_kill(B::Board, cords)
	for Pair in B.red_active
		if Pair[2] == cords 
			Pair[1] == "k" && (B.status = 0) # check if king was slain
			dead = Pair[1]
			pop!(B.red_active,Pair[1])
			push!(B.black_hand,dead)
		end
	end	
end

function move_piece(B::Board, piece, cords)
	if B.turn % 2 != 0 
		# replace old location of piece with 'x' on gameboard
		set_piece(B,Pair("x",B.red_active[piece]))
		# update new location of piece on gameboard
		update_piece(B,piece,cords)
		# check for kill
		red_kill(B,cords)
	else
		# replace old location of piece with 'x' on gameboard
		set_piece(B,Pair("x",B.black_active[piece]))
		# update new location of piece on gameboard
		update_black(B,piece,cords)
		# check for kill
		black_kill(B,cords)
	end	
end

function drop_piece(B::Board, piece, cords)
	if B.turn % 2 != 0
		# pop piece from hand
		i = findfirst(B.red_hand,piece)
		B.red_hand[i] = last(B.red_hand)
		B.red_hand[length(B.red_hand)] = piece
		pop!(B.red_hand)
		# add piece to active list
		get!(B.red_active,piece,cords)
		# set piece onto board
		set_piece(B,Pair(piece,cords))
	else
		# pop piece from hand
		i = findfirst(B.black_hand,piece)
		B.red_hand[i] = last(B.black_hand)
		B.red_hand[length(B.black_hand)] = piece
		pop!(B.black_hand)
		# add piece to active list
		get!(B.black_active,piece,cords)
		# set piece onto board
		set_piece(B,Pair(piece,cords))
	end
end

function display_board(B::Board)
	for i = 1:9
		for j = 1:9
			unit = B.board[i,j]; cords = "$i$j" 
			if unit != "x"
				if unit == "k"
					print_with_color(:yellow,"$unit  ")
				else
					for pair in B.red_active
						if pair[2] == cords
							print_with_color(:red,"$unit  ")
							continue
						end
					end
					for pair in B.black_active
						if pair[2] == cords
							print_with_color(:blue,"$unit  ")
							continue
						end   
					end
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
# move_piece(test,"k","15") # kill black king
# test.turn = 0 # black turn
# move_piece(test,"g2","27")
# test.turn = 1 # red turn
# drop_piece(test,"k_b","95") # drop black king


# # print current state of game board
# display_board(test)





