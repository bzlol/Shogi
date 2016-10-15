# Board class encapsulates the game board and keeps a Dict of all 
# the current pieces on the board along with their coordinates.

type Board
	# game board
	board::Array

	# current turn
	turn::Bool # black = 0, red = 1

	# keeps track of active pieces and coordinates
	red_active::Dict
	black_active::Dict

	# keeps track of pieces in each hand available for drop
	red_hand::Array{ASCIIString,1}
	black_hand::Array{ASCIIString,1}

	# used to display gameboard
	red_cords::Array
	black_cords::Array

	# constructor
	Board() = new(fill('x',9,9),0,Dict(),Dict(),Array{ASCIIString}(0),Array{ASCIIString}(0))
end

function fill_piece{Board}(B::Board)
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
	get!(B.red_active,"k1","92"); get!(B.red_active,"k2","98")
	get!(B.black_active,"k1","12"); get!(B.black_active,"k2","18")
	# fill silver generals
	get!(B.red_active,"s1","93"); get!(B.red_active,"s2","97")
	get!(B.black_active,"s1","13"); get!(B.black_active,"s2","17")
	# fill gold generals
	get!(B.red_active,"g1","94"); get!(B.red_active,"g2","96")
	get!(B.black_active,"g1","14"); get!(B.black_active,"g2","16")
	# place kings
	get!(B.red_active,"k","95")
	get!(B.black_active,"k","15")
	# update piece coordinates for display function
	B.red_cords = collect(values(B.red_active))
	B.black_cords = collect(values(B.black_active))

end

# sets a piece onto the board
function set_piece(B::Board, pair::Pair)
	piece = pair[1][1]
	x = parse(Int,pair[2][1])
	y = parse(Int,pair[2][2])
	B.board[x,y] = piece
end

function initialize_board(B::Board)
	# place red pieces onto board
	for key in B.red_active
		set_piece(B,key)
	end
	# place black pieces onto board
	for key in B.black_active
		set_piece(B,key)
	end
end

function move_piece(B::Board, piece, x, y)
	new_cords = "$x$y"
	if B.turn == 1
		# replace old location of piece with 'x' on gameboard
		old_cords = B.red_active[piece]
		old_x = parse(Int,old_cords[1]); old_y = parse(Int,old_cords[2])
		B.board[old_x,old_y] = 'x'
		# update new location of piece on gameboard
		B.red_active[piece] = new_cords 
		B.board[x,y] = piece[1] # ie, p from p1
		# check for kill
		for Pair in B.black_active
			if Pair[2] == new_cords 
				dead = "$(Pair[1])_b"
				pop!(B.black_active,Pair[1])
				push!(B.red_hand,dead)
			end
		end
		B.red_cords = collect(values(B.red_active)) # update for display
	else
		# replace old location of piece with 'x' on gameboard
		old_cords = B.black_active[piece]
		old_x = parse(Int,old_cords[1]); old_y = parse(Int,old_cords[2])
		B.board[old_x,old_y] = 'x'
		# update new location of piece on gameboard
		B.black_active[piece] = new_cords
		B.board[x,y] = piece[1]
		# check for kill
		for Pair in B.red_active
			if Pair[2] == new_cords 
				dead = "$(Pair[1])_r"
				pop!(B.red_active,Pair[1])
				push!(B.black_hand,dead)
			end
		end
		B.black_cords = collect(values(B.black_active)) # update for display
	end
end

function drop_piece(B::Board, piece, cords)
	if B.turn == 1
		# pop piece from hand
		i = findfirst(B.red_hand,piece)
		B.red_hand[i] = last(B.red_hand)
		B.red_hand[length(B.red_hand)] = piece
		pop!(B.red_hand)
		# add piece to active list
		get!(B.red_active,piece,cords)
		B.red_cords = collect(values(B.red_active)) # update for display
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
		B.black_cords = collect(values(B.black_active)) # update for display
		# set piece onto board
		set_piece(B,Pair(piece,cords))
	end
end

function display_board(B::Board)
	for i = 1:9
		for j = 1:9
			cords = "$i$j"
			if findfirst(B.red_cords,cords) != 0
				print_with_color(:red,"$(B.board[i,j])")
				print("  ")
			elseif findfirst(B.black_cords,cords) != 0
				print_with_color(:blue,"$(B.board[i,j])")
				print("  ")
			else
				print("$(B.board[i,j])  ")
			end
		end
		println()
	end
	println()
end

### MAIN	

test = Board()
fill_piece(test) # give pieces their starting coordinates
initialize_board(test)

# print initial state of game board
display_board(test)

# move some pieces
move_piece(test,"p9",4,9) 
test.turn = 1 # red turn
move_piece(test,"k",2,5) # illegal move
test.turn = 0 # black turn
move_piece(test,"p8",4,8)
test.turn = 1 # red turn
move_piece(test,"k",1,5) # kill black king
test.turn = 0 # black turn
move_piece(test,"g2",2,7)
test.turn = 1 # red turn
drop_piece(test,"k_b","95") # drop black king


# print current state of game board
display_board(test)





