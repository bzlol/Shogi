# Board class encapsulates the game board and keeps a Dict of all 
# the current pieces on the board along with their coordinates.

type Board
	# game board
	board::Array
	# keeps track of active pieces and coordinates
	red_pieces::Dict
	black_pieces::Dict
	# keeps track of pieces in each hand
	red_drop::Array
	black_drop::Array
	# used to update gameboard
	red_cords::Array
	black_cords::Array
	Board() = new(fill('X',9,9),Dict(),Dict())
end

function fill_piece{Board}(B::Board)
		# fill rooks
		for i = 1:9
			get!(B.red_pieces,"p$(i)","7$i")
			get!(B.black_pieces,"p$(i)","3$i")
		end
		# fill bishops
		get!(B.red_pieces,"b1","82"); get!(B.red_pieces,"b2","88")
		get!(B.black_pieces,"b1","22"); get!(B.black_pieces,"b2","28")
		# fill lancers
		get!(B.red_pieces,"l1","91"); get!(B.red_pieces,"l2","99")
		get!(B.black_pieces,"l1","11"); get!(B.black_pieces,"l2","19")
		# fill knights
		get!(B.red_pieces,"k1","92"); get!(B.red_pieces,"k2","98")
		get!(B.black_pieces,"k1","12"); get!(B.black_pieces,"k2","18")
		# fill silver generals
		get!(B.red_pieces,"s1","93"); get!(B.red_pieces,"s2","97")
		get!(B.black_pieces,"s1","13"); get!(B.black_pieces,"s2","17")
		# fill gold generals
		get!(B.red_pieces,"g1","94"); get!(B.red_pieces,"g2","96")
		get!(B.black_pieces,"g1","14"); get!(B.black_pieces,"g2","16")
		# place kings
		get!(B.red_pieces,"k","95")
		get!(B.black_pieces,"k","15")

		B.red_cords = collect(values(test.red_pieces))
		B.black_cords = collect(values(test.black_pieces))

end

# sets the pieces onto the board
function set_piece(B::Board, pair::Pair)
	piece = pair[1][1]
	x = parse(Int,pair[2][1])
	y = parse(Int,pair[2][2])
	B.board[x,y] = piece

	# # set red side
	# pieces = collect(keys(B.red_pieces))
	# for i = 1:length(pieces) 
	# 	piece = pieces[i] # piece to be added to the board
	# 	x = parse(Int,B.red_cords[i][1]) # X coordinate
	# 	y = parse(Int,B.red_cords[i][2]) # Y coordinate
	# 	B.board[x,y] = piece[1];
	# end
	# # set black side
	# pieces = collect(keys(B.black_pieces))
	# for i = 1:length(pieces) 
	# 	piece = pieces[i] # piece to be added to the board
	# 	x = parse(Int,B.black_cords[i][1]) # X coordinate
	# 	y = parse(Int,B.black_cords[i][2]) # Y coordinate
	# 	B.board[x,y] = piece[1];
	# end
end

function move_piece(B::Board, turn, piece, x, y)
	if turn == "red"
		cords = B.red_pieces[piece]
		old_x = parse(Int,cords[1]); old_y = parse(Int,cords[2])
		B.board[old_x,old_y] = 'X'
		B.red_pieces[piece] = "$x$y"
		B.board[x,y] = piece[1]
		B.red_cords = collect(values(test.red_pieces))
	else
		cords = B.black_pieces[piece]
		old_x = parse(Int,cords[1]); old_y = parse(Int,cords[2])
		B.board[old_x,old_y] = 'X'
		B.black_pieces[piece] = "$x$y"
		B.board[x,y] = piece[1]
		B.black_cords = collect(values(test.black_pieces))
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

# place red pieces onto board
for key in test.red_pieces
	#println(key)
	set_piece(test,key)
end
# place black pieces onto board
for key in test.black_pieces
	set_piece(test,key)
end

# print initial state of game board
display_board(test)

# move some pieces
move_piece(test,"red","p4",6,4)
move_piece(test,"black","p1",4,1)
move_piece(test,"black","p1",5,1)
move_piece(test,"black","l1",4,1)
move_piece(test,"red","k",2,5) # illegal move

# print current state of game board
display_board(test)





