# Orange Julias
# move_user_resign.jl <filename> makes the current player resign the game.

include("database.jl")

toGo = 0
while toGo != 1
	# Check for invalid input aka too few/many ARGS
	if length(ARGS) < 1 || length(ARGS) > 1
		println("\nInput is not valid. Please run the file again! 凸(｀ﾛ´)凸")
		break
	end
	toGo = 1
	filename = ASCIIString(ARGS[1])

	# Use function set_move() from database.jl
	# set_move(f::ASCIIString,mType::ASCIIString,
	#					sx::Int,sy::Int,tx::Int,ty::Int,
	#					promo::Int,cheat::Int,            # if promoted or cheated, insert int 1
	#					droppedPiece::ASCIIString)
	set_move(filename,"resign",0,0,0,0,0,0,"")

	# Print current table
	# table_moves = get_table(filename,"moves")
	# println(table_moves)

end
