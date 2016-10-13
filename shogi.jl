# Board class encapsulates the game board and keeps a Dict of all 
# the current pieces on the board along with their coordinates.

type Board
	board::Array
	red_pieces::Dict
	black_pieces::Dict
	Board() = new(fill(' ',9,9),Dict(),Dict())
end

function set_piece{Board}(B::Board)
		# fill rooks
		for i = 1:9
			get!(B.red_pieces,"p$(i)","7,$i")
			get!(B.black_pieces,"p$(i)","3,$i")
		end
		# fill bishops
		get!(B.red_pieces,"b1","8,2"); get!(B.red_pieces,"b2","8,8")
		get!(B.black_pieces,"b1","2,2"); get!(B.black_pieces,"b2","2,8")
		# fill lancers
		get!(B.red_pieces,"l1","9,1"); get!(B.red_pieces,"l2","9,9")
		get!(B.black_pieces,"l1","1,1"); get!(B.black_pieces,"l2","1,9")
		# fill knights
		get!(B.red_pieces,"k1","9,2"); get!(B.red_pieces,"k2","9,8")
		get!(B.black_pieces,"k1","1,2"); get!(B.black_pieces,"k2","1,8")
		# fill silver generals
		get!(B.red_pieces,"s1","9,3"); get!(B.red_pieces,"s2","9,7")
		get!(B.black_pieces,"s1","1,3"); get!(B.black_pieces,"s2","1,7")
		# fill gold generals
		get!(B.red_pieces,"g1","9,4"); get!(B.red_pieces,"g2","9,6")
		get!(B.black_pieces,"g1","1,4"); get!(B.black_pieces,"g2","1,6")
		# place kings
		get!(B.red_pieces,"k","9,5")
		get!(B.black_pieces,"k","1,5")

end

# sets the pieces onto the board
function set_board{Board}(B::Board)
	#  set red pieces
	pieces = collect(keys(B.red_pieces)); # an array of all the red pieces
	cords = collect(values(B.red_pieces)) # an array of all the red cords
	for i = 1:length(pieces) 
		piece = pieces[i][1] # piece to be added to the board
		x = parse(Int,cords[i][1]) # X coordinate
		y = parse(Int,cords[i][3]) # Y coordinate
		B.board[x,y] = piece;
	end
	#  set red pieces
	pieces = collect(keys(B.black_pieces)); # an array of all the red pieces
	cords = collect(values(B.black_pieces)) # an array of all the red cords
	for i = 1:length(pieces) 
		piece = pieces[i][1] # piece to be added to the board
		x = parse(Int,cords[i][1]) # X coordinate
		y = parse(Int,cords[i][3]) # Y coordinate
		B.board[x,y] = piece;
	end
end

test = Board()
set_piece(test)
set_board(test)
display(test.board)



