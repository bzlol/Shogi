# Play a game of shogi interactively b/t 
# User vs User or 
# User vs AI
# Established commands: 
#	move piece x,y - move piece towards the specified coordinates
#	drop piece x,y - drop piece on the specified coordinates
#	resign - concede the game

# input function
function input()
	return chomp(readline(STDIN))
end

include("shogi.jl")
println("\nLets play Shogi\n")

### INITIALIZE GAME 

# create instance of game board
GB = Board() 
# create red pieces
red = Pieces() 
 # set starting coordinates of red pieces
fill_red(red)
# create black pieces
black = Pieces() 
# set starting coordinates of black pieces
fill_black(black) 
# set red and black pieces onto the board
init_board(GB,red,black)

### BEGIN GAME - black moves first

while(GB.status != 0) # while a game ending move has not been played

	display_board(GB,) # output current state of the board
	GB.turn % 2 == 0 ? println("Black Turn:") : println("Red Turn:")

	user_input = input()
	user_input = chomp(user_input) # remove newline char
	len = length(user_input)

	if contains(user_input,"resign") == false
		move = user_input[1:4] # extract move
		x = parse(Int,user_input[len-2]; y = parse(Int,user_input[len])
		cords = [x,y]
# 	
# 		
# 		piece = strip(user_input[5:len-3]) # extract piece 
# 		cords = "$(user_input[len-2])$(user_input[len])" # extract coordinates
# 		move == "move" ? move_piece(GB,piece,cords) : drop_piece(GB,piece,cords)
# 		if GB.status == 0
# 			(GB.turn) % 2 == 0 ? 
# 				println("Red king slain, Black wins") : 
# 				println("Black king slain, Red wins.")
# 		end
# 	else 
# 		GB.status = 0 # user resigns
# 		GB.turn % 2 == 0 ? 
# 			println("Black concedes, Red wins.") :
# 			println("Red concedes, Black wins.")
# 	end

# 	GB.turn += 1 # increment turn
# end

# println("Game Over")
		













