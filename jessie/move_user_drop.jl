# Orange Julias
# move_user_drop.jl <filename> <piece><xtarget> <ytarget>
# drops the piece at the coordinates given. Do not attempt to validate the move,
# enter it into the game state regardless of the drop’s validity.

include("database.jl")

toGo = 0
pieces = ["p","r","l","g","k","b","n","s"]
while toGo != 1
	# Check for invalid input aka too few/many ARGS or coords <1 or >9 or not a piece name
	if length(ARGS) < 4 || length(ARGS) > 4 || in(lowercase(ARGS[2]),pieces) == false 
		println("\nInput is not valid. Please run the file again! 凸(｀ﾛ´)凸")
		break
	end
	for i in 3:4
			if parse(ARGS[i]) < 1 || parse(ARGS[i]) > 9
				println("\nInput is not valid. Please run the file again! 凸(｀ﾛ´)凸")
				toGo = 0
				break
			else
				toGo = 1
			end
	end
	toGo == 0? break :

		filename = ASCIIString(ARGS[1])
		piecename = ASCIIString(lowercase(ARGS[2]))
		tx = parse(ARGS[3])
		ty = parse(ARGS[4])

		# Use function set_move() from database.jl
		# set_move(f::ASCIIString,mType::ASCIIString,
		#					sx::Int,sy::Int,tx::Int,ty::Int,
		#					promo::Int,cheat::Int,            # if promoted or cheated, insert int 1
		#					droppedPiece::ASCIIString)
		set_move(filename,"drop",0,0,tx,ty,0,0,piecename)

		# Print current table
		# table_moves = get_table(filename,"moves")
		# println(table_moves)

end
