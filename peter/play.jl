# Play a game of shogi interactively b/t 
# User vs User or 
# User vs AI
# Established commands: 
#	move piece x,y - move piece towards the specified coordinates
#	drop piece x,y - drop piece on the specified coordinates
#	quit - concede the game

# input function
function input()
	return chomp(readline(STDIN))
end

println("What would you like to play? ('S' for Shogi, 'M' for Minishogi)")

game_type = input()

while game_type!="S" && game_type!="M"
	println("What would you like to play? ('S' for Shogi, 'M' for Minishogi)")
	game_type = input()
end

println("Who would you like to play with? ('AI' for AI, 'User' for User)")

opponent = input()

while opponent!="AI" && opponent!="User"
	println("Who would you like to play with? ('AI' for AI, 'User' for User)")
	opponent = input()
end

if game_type == "S" && opponent == "AI"
	include("shogi.jl")
	include("move_functions.jl")
	include("AI.jl")
	println("\nLet's play Shogi\n")

	# create instance of game board
	GB = Board() 
	# create red pieces for user
	red = Pieces("red") 
	# set starting coordinates of red pieces
	fill_red(red)
	# create black pieces 
	black = Pieces("black") 
	# set starting coordinates of black pieces
	fill_black(black) 
	# set AI to black
	julia = AI(black)
	# set red and black pieces onto the board
	init_board(GB,red,julia.set)


	while(GB.status != 0) # while game is not over
		@label start_shogi_AI
		display_board(GB,red,julia.set) # display current state of board
		if GB.turn % 2 == 0 # decide whos turn
			turn = 0 # black turn
			println("Black Turn:") 
		else
			turn = 1 # red turn
			# user instructions
			println("User Instructions:")
			println("Enter 'move' 'piece' 'x coordinate' 'y coordinate'")
			println("Enter 'cheat' 'piece' 'x coordinate' 'y coordinate'")
			println("Enter 'quit' to resign from the game\n")

			println("Red Turn:")
		end
		GB.turn += 1
		# AI turn
		if turn == 0
			if length(julia.set.captured) != 0
				piece = julia.set.captured[1]
				cords = drop_AI(julia.set,red,piece)
				if cords != (0,0)
					drop_piece(GB,julia.set,piece,cords)
					continue
				end
			end
			move = minimax_AB(julia.set,red,-Inf,Inf,0,3)
			piece = move[1][1]; cords = move[1][2];
			println(move[2])
			AI_move_piece(GB,julia.set,red,piece,cords)
			if GB.status == 0
				turn ==  0 ? 
					println("Red king slain, Black wins") :
					println("Black king slain, Red wins.") 
				display_board(GB,red,julia.set)		
	 		end 
	 	# User turn
	 	else 
			# obtain instruction from user
			user_input = input()
			#length(user_input) == 0 && continue # skip turn

			# check for invalid user input
			if length(user_input) < 6 && user_input!="quit"
				println("\nInvalid Input\n")
				GB.turn -= 1
				@goto start_shogi_AI
			elseif user_input[1:4]!="move" && user_input[1:4]!="quit" && contains(user_input,"cheat")==false
				println("Invalid Input\n")
				GB.turn -= 1
				@goto start_shogi_AI
			end

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
				turn == 0 ? move_piece(GB,julia.set,red,piece,cords) :
				move_piece(GB,red,julia.set,piece,cords)
				# king kill
				if GB.status == 0
					turn ==  0 ? 
						println("Red king slain, black wins") :
						println("black king slain, Red wins.") 
					display_board(GB,red,julia.set)		
		 		end 
			# parse instruction
			elseif move != "quit"
				# extract piece and determine which move function to call
				piece = strip(user_input[5:len-3]); t = piece[1] # type of piece
				if t == 'p' || t == 'P'
					turn == 0 ?
						move_julia.set_p(GB,julia.set,red,piece,cords) : 
						move_red_p(GB,red,julia.set,piece,cords)
				elseif t == 'k'
					turn == 0 ?
						move_king(GB,julia.set,red,piece,cords) : 
						move_king(GB,red,julia.set,piece,cords)
				elseif t == 'g'
					turn == 0 ?
						move_julia.set_g(GB,julia.set,red,piece,cords) : 
						move_red_g(GB,red,julia.set,piece,cords)
				elseif t == 's' || t == 'S'
					turn == 0 ? 
						move_julia.set_s(GB,julia.set,red,piece,cords) :
						move_red_s(GB,red,julia.set,piece,cords)
				elseif t == 'n'|| t == 'N'
					turn == 0 ?
						move_julia.set_n(GB,julia.set,red,piece,cords) : 
						move_red_n(GB,red,julia.set,piece,cords)
				elseif t == 'b' || t == 'B'
					turn == 0 ?
						move_bishop(GB,julia.set,red,piece,cords) :
						move_bishop(GB,red,julia.set,piece,cords)
				elseif t == 'r' || t == 'R'
					turn == 0 ?
						move_rook(GB,julia.set,red,piece,cords) :
						move_rook(GB,red,julia.set,piece,cords)
				elseif t == 'l' || t == 'L'
					turn == 0 ?
						move_lancerB(GB,julia.set,red,piece,cords) :
						move_lancerR(GB,red,julia.set,piece,cords)
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
	end
	println("Game Over")

elseif game_type == "M" && opponent == "AI"
	include("minishogi.jl")
	include("move_functions_minishogi.jl")
	include("AI_minishogi.jl")
	println("\nLet's play Shogi\n")

	# create instance of game board
	GB = Board() 
	# create red pieces for user
	red = Pieces("red") 
	# set starting coordinates of red pieces
	fill_red(red)
	# create black pieces 
	black = Pieces("black") 
	# set starting coordinates of black pieces
	fill_black(black) 
	# set AI to black
	julia = AI(black)
	# set red and black pieces onto the board
	init_board(GB,red,julia.set)


	while(GB.status != 0) # while game is not over
		@label start_minishogi_AI
		display_board(GB,red,julia.set) # display current state of board
		if GB.turn % 2 == 0 # decide whos turn
			turn = 0 # black turn
			println("Black Turn:") 
		else
			turn = 1 # red turn
			# user instructions
			println("User Instructions:")
			println("Enter 'move' 'piece' 'x coordinate' 'y coordinate'")
			println("Enter 'cheat' 'piece' 'x coordinate' 'y coordinate'")
			println("Enter 'quit' to resign from the game\n")

			println("Red Turn:")
		end
		GB.turn += 1
		# AI turn
		if turn == 0
			if length(julia.set.captured) != 0
				piece = julia.set.captured[1]
				cords = drop_AI(julia.set,red,piece)
				if cords != (0,0)
					drop_piece(GB,julia.set,piece,cords)
					continue
				end
			end
			move = minimax_AB(julia.set,red,-Inf,Inf,0,3)
			piece = move[1][1]; cords = move[1][2];
			println(move[2])
			AI_move_piece(GB,julia.set,red,piece,cords)
			if GB.status == 0
				turn ==  0 ? 
					println("Red king slain, Black wins") :
					println("Black king slain, Red wins.") 
				display_board(GB,red,julia.set)		
	 		end 
	 	# User turn
	 	else 
			# obtain instruction from user
			user_input = input()
			#length(user_input) == 0 && continue # skip turn

			# check for invalid user input
			if length(user_input) < 6 && user_input!="quit"
				println("\nInvalid Input\n")
				GB.turn -= 1
				@goto start_minishogi_AI
			elseif user_input[1:4]!="move" && user_input[1:4]!="quit" && contains(user_input,"cheat")==false
				println("Invalid Input\n")
				GB.turn -= 1
				@goto start_minishogi_AI
			end

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
				turn == 0 ? move_piece(GB,julia.set,red,piece,cords) :
				move_piece(GB,red,julia.set,piece,cords)
				# king kill
				if GB.status == 0
					turn ==  0 ? 
						println("Red king slain, black wins") :
						println("black king slain, Red wins.") 
					display_board(GB,red,julia.set)		
		 		end 
			# parse instruction
			elseif move != "quit"
				# extract piece and determine which move function to call
				piece = strip(user_input[5:len-3]); t = piece[1] # type of piece
				if t == 'p' || t == 'P'
					turn == 0 ?
						move_julia.set_p(GB,julia.set,red,piece,cords) : 
						move_red_p(GB,red,julia.set,piece,cords)
				elseif t == 'k'
					turn == 0 ?
						move_king(GB,julia.set,red,piece,cords) : 
						move_king(GB,red,julia.set,piece,cords)
				elseif t == 'g'
					turn == 0 ?
						move_julia.set_g(GB,julia.set,red,piece,cords) : 
						move_red_g(GB,red,julia.set,piece,cords)
				elseif t == 's' || t == 'S'
					turn == 0 ? 
						move_julia.set_s(GB,julia.set,red,piece,cords) :
						move_red_s(GB,red,julia.set,piece,cords)
				elseif t == 'n'|| t == 'N'
					turn == 0 ?
						move_julia.set_n(GB,julia.set,red,piece,cords) : 
						move_red_n(GB,red,julia.set,piece,cords)
				elseif t == 'b' || t == 'B'
					turn == 0 ?
						move_bishop(GB,julia.set,red,piece,cords) :
						move_bishop(GB,red,julia.set,piece,cords)
				elseif t == 'r' || t == 'R'
					turn == 0 ?
						move_rook(GB,julia.set,red,piece,cords) :
						move_rook(GB,red,julia.set,piece,cords)
				elseif t == 'l' || t == 'L'
					turn == 0 ?
						move_lancerB(GB,julia.set,red,piece,cords) :
						move_lancerR(GB,red,julia.set,piece,cords)
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
	end

	println("Game Over")


elseif game_type == "S"
	include("shogi.jl")
	include("move_functions.jl")
	println("\nLet's play Shogi\n")

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

	### BEGIN GAME - black moves first

	while(GB.status != 0) # while a game ending move has not been played

		@label start_shogi

		display_board(GB,red,black) # output current state of the board
		if GB.turn % 2 == 0 # decide whos turn
			turn = 0 # black turn

			# user instructions
			println("User Instructions:")
			println("Enter 'move' 'piece' 'x coordinate' 'y coordinate'")
			println("Enter 'cheat' 'piece' 'x coordinate' 'y coordinate'")
			println("Enter 'quit' to resign from the game\n")

			println("Black Turn:") 
		else
			turn = 1 # red turn

			# user instructions
			println("User Instructions:")
			println("Enter 'move' 'piece' 'x coordinate' 'y coordinate'")
			println("Enter 'cheat' 'piece' 'x coordinate' 'y coordinate'")
			println("Enter 'quit' to resign from the game\n")

			println("Red Turn:")

		end
		GB.turn += 1

		# obtain instruction from user
		user_input = input()
		#length(user_input) == 0 && continue # skip turn

		# check for invalid user input
		if length(user_input) < 6 && user_input!="quit"
			println("\nInvalid Input\n")
			GB.turn -= 1
			@goto start_shogi
		elseif user_input[1:4]!="move" && user_input[1:4]!="quit" && contains(user_input,"cheat")==false
			println("Invalid Input\n")
			GB.turn -= 1
			@goto start_shogi
		end

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

elseif game_type == "M"
	include("minishogi.jl")
	include("mov_functions_minishogi.jl")
	println("\nLet's play Minishogi\n")
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

	### BEGIN GAME - black moves first

	while(GB.status != 0) # while a game ending move has not been played

		@label start_minishogi

		display_board(GB,red,black) # output current state of the board
		if GB.turn % 2 == 0 # decide whos turn
			turn = 0 # black turn

			# user instructions
			println("User Instructions:")
			println("Enter 'move' 'piece' 'x coordinate' 'y coordinate'")
			println("Enter 'cheat' 'piece' 'x coordinate' 'y coordinate'")
			println("Enter 'quit' to resign from the game\n")

			println("Black Turn:") 
		else
			turn = 1 # red turn

			# user instructions
			println("User Instructions:")
			println("Enter 'move' 'piece' 'x coordinate' 'y coordinate'")
			println("Enter 'cheat' 'piece' 'x coordinate' 'y coordinate'")
			println("Enter 'quit' to resign from the game\n")

			println("Red Turn:")
		end
		GB.turn += 1

		# obtain instruction from user
		user_input = input()
		# length(user_input) == 0 && continue # skip turn

		# check for invalid user input
		if length(user_input) < 6 && user_input!="quit"
			println("\nInvalid Input\n")
			GB.turn -= 1
			@goto start_minishogi
		elseif user_input[1:4]!="move" && user_input[1:4]!="quit" && contains(user_input,"cheat")==false
			println("Invalid Input\n")
			GB.turn -= 1
			@goto start_minishogi
		end

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
			elseif t == 'b' || t == 'B'
				turn == 0 ?
					move_bishop(GB,black,red,piece,cords) :
					move_bishop(GB,red,black,piece,cords)
			elseif t == 'r' || t == 'R'
				turn == 0 ?
					move_rook(GB,black,red,piece,cords) :
					move_rook(GB,red,black,piece,cords)
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

end