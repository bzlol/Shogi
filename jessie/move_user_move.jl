# Orange Julias
# move_user_move.jl <filename> <xsource> <ysource> <xtarget> <ytarget> <promote>
# moves the piece at the source into the target area. If promote
# is equal to ”T” then promote the piece after
# it has completed the move. Do not attempt to
# validate the move, enter it into the game state regardless
# of the move’s validity.
include("database.jl")

toGo = 0
while toGo != 1
	# Check for invalid input aka too few/many ARGS or coords <1 or >9
	if length(ARGS) < 5 || length(ARGS) > 6
		println("\nInput is not valid. Please run the file again! 凸(｀ﾛ´)凸")
		break
	end
	for i in 2:5
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
		sx = parse(ARGS[2])
		sy = parse(ARGS[3])
		tx = parse(ARGS[4])
		ty = parse(ARGS[5])

		# Use function set_move() from database.jl
		# set_move(f::String,mType::AbstractString,
		#					sx::Int,sy::Int,tx::Int,ty::Int,
		#					promo::Int,cheat::Int, # insert int 1 if the piece is promoted or cheated
		#					droppedPiece::AbstractString)
		length(ARGS) < 6 || ARGS[6] != "T"? (set_move(filename,"move",sx,sy,tx,ty,0,0,"")) :
		(set_move(filename,"move",sx,sy,tx,ty,1,0,""))

		# Print current table
		# table_moves = get_table(filename,"moves")
		# println(table_moves)

end
