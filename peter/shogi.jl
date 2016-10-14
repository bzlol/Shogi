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

end

# sets the pieces onto the board
function set_board{Board}(B::Board)
	#  set red pieces
	pieces = collect(keys(B.red_pieces)); # an array of all the red pieces
	red_cords = collect(values(B.red_pieces)) # an array of all the red cords
	for i = 1:length(pieces) 
		piece = pieces[i][1] # piece to be added to the board
		x = parse(Int,cords[i][1]) # X coordinate
		y = parse(Int,cords[i][2]) # Y coordinate
		B.board[x,y] = piece;
	end
	#  set red pieces
	pieces = collect(keys(B.black_pieces)); # an array of all the red pieces
	black_cords = collect(values(B.black_pieces)) # an array of all the red cords
	for i = 1:length(pieces) 
		piece = pieces[i][1] # piece to be added to the board
		x = parse(Int,cords[i][1]) # X coordinate
		y = parse(Int,cords[i][2]) # Y coordinate
		B.board[x,y] = piece;
	end
end

function display_board(B::Board)
	#count = 1
	for i = 1:9
		for j = 1:9
			cords = "$i$j"
			if contains(red_pieces,cords) == true
				print_with_color(:red,B.board[i,j])
			print("$(B.board[i,j]) ")
		end
		println()
	end
end

test = Board()
set_piece(test)
set_board(test)
display_board(test)
#print_with_color(:red,test.board)



