###################################################################################################
##TESTS
# Please add pkg "SQLite" and "DataArrays" before compiling
# database file once created stays on the folder path.
# In the test case below it's game1.db
# Please remove game1.db if you want to re-run the test
# go to shell> rm game1.db

include("database.jl")

filename = "game1"
init_database(filename)

#test set meta
set_gameType(filename,"standard")
set_legality(filename,"legal")
set_seed(filename,2)

#test set moves
set_move(filename,"move",3,5,5,7,0,0,"")
set_move(filename,"drop",2,7,6,4,0,0,"b")
set_move(filename,"move",1,2,3,4,0,1,"")
set_move(filename,"resign",0,0,0,0,1,0,"")


#test table extraction
df1 = get_table(filename,"meta")
df2 = get_table(filename,"moves") #df stands for dataframe
println(df1)
println(df2)
println()

#Test get functions in meta
println("Game type is ", get_gameType(filename))
println("Legality is ", get_legality(filename))
total = get_totalMoves(filename) #total number of moves
println("Total number of moves is ",total)
ischeatGame(filename) == true? println("This game allows cheating") : println("This game doesn't allow cheating")
println("Seed is ",get_seed(filename))
println("Type of seed is ",typeof(get_seed(filename)))


for i in 1:total
	println(" -------------------------------------------------------------------")
	println("At move $i:")
	mt = get_moveType(filename,i) # move type
	println("Move type is ",mt)
	sCords = get_sourceCords(filename,i) # source coord
	println("sCords is ",sCords)
	tCords = get_targetCords(filename,i) # target coord
	println("tCords is ",tCords)
# test ischeatMove()
	ischeatMove(filename,i) == true? println("I am cheating"):println("I am not cheating")
# test omoted()
	ispromoted(filename,i) == true? println("A piece is promoted.") : println("no promotion")
# test isdropped()
	isdropped(filename,i) == true? println("A piece is dropped") : println("no drop")
	println("The dropped piece is:",get_droppedPiece(filename,i))

end

#test row and value extraction
println("\nDetails of move 4 is:")

arr = get_row(filename,4)

println(arr)
println()
println("Type of move 4 array is",typeof(arr)) # we use DataArray type because it's multi-type



# values are nullable => need to use get(df1[1,2])
# println("Before using get() type is $(typeof(df1[1,2]))") #row1,col2 of df1 is game type
# println("After using get() type is $(typeof(get(df1[1,2])))")
#println("If value is NULL don't use get()")
