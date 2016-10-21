# Play a game of shogi interactively b/t 
# User vs User or 
# User vs AI
# Established commands: 
#	move piece x,y - move piece towards the specified coordinates
#	drop piece x,y - drop piece on the specified coordinates
#	quit - concede the game

include("shogi.jl")
include("move_functions.jl")
println("\nLets play Shogi\n")

### INITIALIZE GAME 

# create instance of game board
GB = Board() 
# create red pieces
red = Pieces("red") 
 # set starting coordinates of red pieces
fill_red(red)
# create black pieces
black = Pieces("black") 
# set starting coordinates of black pieces
fill_black(black) 
# set red and black pieces onto the board
init_board(GB,red,black)

println(red.activeS); println(black.activeS)

### BEGIN GAME - black moves first

while(GB.status != 0) # while a game ending move has not been played

	display_board(GB,red,black) # output current state of the board
	if GB.turn % 2 == 0 # decide whos turn
		turn = 0 # black turn
		println("Black Turn:") 
	else
		turn = 1 # red turn
		println("Red Turn:")
	end
	GB.turn += 1

	# obtain instruction from user
	user_input = input()
	length(user_input) == 0 && continue # skip turn
	user_input = chomp(user_input) # remove newline char
	len = length(user_input)

	cords::Tuple{Int,Int}
	# extract coordinates 
	x = parse(Int,user_input[len-2])
	y = parse(Int,user_input[len])
	cords = (x,y)
	# extract move
	move = user_input[1:4] 

	# for testing
	if contains(user_input,"cheat")
		piece = strip(user_input[6:len-3])
		turn == 0 ? move_piece(GB,black,red,piece,cords) :
		move_piece(GB,red,black,piece,cords)
		# king kill
		if GB.status == 0
			turn ==  0 ? 
				println("Red king slain, Black wins") :
				println("Black king slain, Red wins.") 
			display_board(GB,red,black)		
 		end 
	# parse instruction
	elseif move != "quit"
		# extract piece and determine which move function to call
		piece = strip(user_input[5:len-3]); t = piece[1] # type of piece
		if t == 'p' || t == 'P'
			turn == 0 ?
				move_black_p(GB,black,red,piece,cords) : 
				move_red_p(GB,red,black,piece,cords)
		elseif t == 'k'
			turn == 0 ?
			move_king(GB,black,red,piece,cords) : 
			move_king(GB,red,black,piece,cords)
		elseif t == 'g'
			turn == 0 ?
			move_black_g(GB,black,red,piece,cords) : 
			move_red_g(GB,red,black,piece,cords)
		elseif t == 's' || t == 'S'
			turn == 0 ? 
			move_black_s(GB,black,red,piece,cords) :
			move_red_s(GB,red,black,piece,cords)
		elseif t == 'n'|| t == 'T'
			turn == 0 ?
			move_black_n(GB,black,red,piece,cords) : 
			move_red_n(GB,red,black,piece,cords)
		elseif t == 'b' || t == 'B'
			turn == 0 ?
			move_bishop(GB,black,red,piece,cords) :
			move_bishop(GB,red,black,piece,cords)
		elseif t == 'r' || t == 'R'
			turn == 0 ?
			move_rook(GB,black,red,piece,cords) :
			move_rook(GB,red,black,piece,cords)
		elseif t == 'l' || t == 'L'
			turn == 0 ?
			move_lancerB(GB,black,red,piece,cords) :
			move_lancerR(GB,red,black,piece,cords)
		else
			println("Invalid Input")
		end

		if GB.status == 0
			turn ==  0 ? 
				println("Red king slain, Black wins") :
				println("Black king slain, Red wins.") 
			display_board(GB,red,black)		
 		end 
	else 
		GB.status = 0 # user resigns
		turn == 0 ? 
			println("Black concedes, Red wins.") :
			println("Red concedes, Black wins.")
	end

end

println("Game Over")



	
