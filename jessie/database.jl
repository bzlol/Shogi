# Functions related to SQLite database
# Create, insert values, extract table values
# Please add pkg "SQLite" and "DataArrays" before compiling
# database file once created stays on the folder path. In the test case below it's game1.db
# to remove .db file go to shell> rm game1.db
using DataArrays, DataFrames
using SQLite

#init database. for start.jl only
function init_database(f::AbstractString)
	db=SQLite.DB("$(f).db")

# create meta data table
	SQLite.query(db,"create table meta (key text primary key, value text)")
	SQLite.query(db,"insert into meta values('type',NULL)")
	SQLite.query(db,"insert into meta values('legality',NULL)")
	SQLite.query(db,"insert into meta values('seed',NULL)")
	println("\nmeta table set.")

# create moves data table
	SQLite.query(db,"create table moves (move_number integer primary key,
																							move_type text,
																							sourcex integer,
																							sourcey integer,
																							targetx integer,
																							targety integer,
																							option text,
																							i_am_cheating integer)")
	println("\nmoves table set.\n")
end

###################################################################################################
## SET META TABLE

function set_gameType(f::ASCIIString,gt::ASCIIString)
	db = SQLite.DB("$(f).db")
	query = "update meta set value = '$(gt)' where key = 'type'"
	#println(query)
	SQLite.query(db,query)
end

function set_legality(f::ASCIIString,l::ASCIIString)
	db = SQLite.DB("$(f).db")
	query = "update meta set value = '$(l)' where key = 'legality'"
	#println(query)
	SQLite.query(db,query)
end

function set_seed(f::ASCIIString,s::Int)
	db = SQLite.DB("$(f).db")
	query = "update meta set value = '$(s)' where key = 'seed'"
	df = SQLite.query(db,query)
end

#---------------------------------------------------------------------------------------------------
## SET MOVES TABLE
#insert new row
#input: str filename, str movetype,int sx,sy,tx,ty, int promo,cheat,str dropped piece
function set_move(f::ASCIIString,
									mType::ASCIIString,
									sx::Int,sy::Int,tx::Int,ty::Int,
									promo::Int,cheat::Int, # insert int 1 if the piece is promoted. same with cheat move
									droppedPiece::ASCIIString) # insert "" if the move is not a drop move
	db = SQLite.DB("$(f).db")
	mNum = get_totalMoves(f) + 1
	query_mNum = "insert into moves (move_number) values($(mNum))"
	SQLite.query(db,query_mNum) #update number of moves

	query_mType = "update moves set move_type = '$(mType)' where move_number = $(mNum)"
	SQLite.query(db,query_mType) #update move_type

	query_sx = "update moves set sourcex = $(sx) where move_number = $(mNum)"
	SQLite.query(db,query_sx) #update source x cord

	query_sy = "update moves set sourcey = $(sy) where move_number = $(mNum)"
	SQLite.query(db,query_sy) #update source y cord

	query_tx = "update moves set targetx = $(tx) where move_number = $(mNum)"
	SQLite.query(db,query_tx) #update target x cord

	query_ty = "update moves set targety = $(ty) where move_number = $(mNum)"
	SQLite.query(db,query_ty) #update target y cord

	# update option column
	# option <- "!"  when there's a promotion
	# option <- piece name when moveType is 'drop'
	# a dropped piece is unpromoted
	if promo == 1
		query_opt = "update moves set option = '!' where move_number = $(mNum)"
	elseif mType == "drop"
	  query_opt = "update moves set option = '$(droppedPiece)' where move_number = $(mNum)"
	else
		query_opt = "update moves set option = NULL where move_number = $(mNum)"
	end
	SQLite.query(db,query_opt)

	# update cheat
	if cheat == 1
		query_cheat = "update moves set i_am_cheating = 'yes' where move_number = $(mNum)"
	else
		query_cheat = "update moves set i_am_cheating = NULL where move_number = $(mNum)"
	end
	SQLite.query(db,query_cheat)
end


###################################################################################################
####EXTRACT VALUES FROM TABLES

#input:filename, table name. return the whole table, type dataframe
function get_table(f::ASCIIString,t::AbstractString) # the return type is DataFrame, treat it like a multi-dim array
	db = SQLite.DB("$(f).db")
	if t == "meta"									# https://dataframesjl.readthedocs.io/en/latest/
		df = SQLite.query(db,"select * from meta")
	else
		df = SQLite.query(db,"select * from moves")
	end
	return df
end

#---------------------------------------------------------------------------------------------------
## GET VALUES FROM META TABLE
#input: filename. return string game type
function get_gameType(f::ASCIIString)
	db = SQLite.DB("$(f).db")
	query = "SELECT value FROM meta where key = 'type'"
	df = SQLite.query(db,query)
	isnull(df[1,1]) == true ? (return "empty") : (return get(df[1,1]))
end


function ischeatGame(f::ASCIIString)
	db = SQLite.DB("$(f).db")
	query = "SELECT value FROM meta where key = 'legality'"
	df = SQLite.query(db,query)
	isnull(df[1,1]) == true ? (return "empty") : (l = get(df[1,1]))
	l == "cheating" ? (return true) : (return false)
end

#input: filename. return string legality
function get_legality(f::ASCIIString)
	db = SQLite.DB("$(f).db")
	query = "SELECT value FROM meta where key = 'legality'"
	df = SQLite.query(db,query)
	isnull(df[1,1]) == true ? (return "empty") : (return get(df[1,1]))
end
#input: filename. return int seed
function get_seed(f::ASCIIString)
	db = SQLite.DB("$(f).db")
	query = "SELECT value FROM meta where key = 'seed'"
	df = SQLite.query(db,query)
	isnull(df[1,1]) == true ? (return 0) : (return parse(get(df[1,1])))
end

#---------------------------------------------------------------------------------------------------
## GET VALUES FROM MOVES TABLE

#input:filename, move number. return details of a row in a DataArray type. moveDetail(4)
function get_row(f::ASCIIString,mNum::Int)
	df = get_table(f,"moves")
	dv = @data([NA,NA,NA,NA,NA,NA,NA,NA])
	for i in 1:8
			dv[i] = df[mNum,i]
	end
	return dv
end
#input: filename. return an int total rows/moves in the moves
function get_totalMoves(f::ASCIIString)
	db = SQLite.DB("$(f).db")
	query = "SELECT Count(*) FROM moves"
	df = SQLite.query(db, query)
	return get(df[1,1])
end
#input:filename, move number. return a string move type at a specific move_num
function get_moveType(f::ASCIIString,mNum::Int)
	db = SQLite.DB("$(f).db")
	query = "SELECT move_type FROM moves where move_number = $(mNum)"
	df = SQLite.query(db, query)
	return get(df[1,1])
end

#input:filename, move number. return a tuple source coord at a specific move_num
function get_sourceCords(f::ASCIIString,mNum::Int)
	db = SQLite.DB("$(f).db")
	query_getSourcex = "SELECT sourcex FROM moves where move_number = $(mNum)"
	query_getSourcey = "SELECT sourcey FROM moves where move_number = $(mNum)"
	dfx = SQLite.query(db, query_getSourcex)
	dfy = SQLite.query(db, query_getSourcey)

	x = get(dfx[1,1])
	y = get(dfy[1,1])
	cords =(x,y)
	return cords
end

#input:filename, move number. return a tuple target coord at a specific move_num
function get_targetCords(f::ASCIIString,mNum::Int)
	db = SQLite.DB("$(f).db")
	query_getTargetx = "SELECT targetx FROM moves where move_number = $(mNum)"
	query_getTargety = "SELECT targety FROM moves where move_number = $(mNum)"
	dfx = SQLite.query(db, query_getTargetx)
	dfy = SQLite.query(db, query_getTargety)

	x = get(dfx[1,1])
	y = get(dfy[1,1])
	cords =(x,y)
	return cords
end
#input:filename, move number. return bool if cheating at a specific move_num
function ischeatMove(f::ASCIIString,mNum::Int)
	db = SQLite.DB("$(f).db")
	query = "SELECT i_am_cheating FROM moves where move_number = $(mNum)"
	df = SQLite.query(db, query)
	isnull(df[1,1]) == true ? (return false) : (return true)
end

#input:filename, move number. return bool if a piece is promoted at a specific move_num
function ispromoted(f::ASCIIString,mNum::Int)
	db = SQLite.DB("$(f).db")
	query = "SELECT option FROM moves where move_number = $(mNum)"
	df = SQLite.query(db, query)
	isnull(df[1,1]) == true || get(df[1,1]) != "!"? (return false) : (return true)
end

#input:filename, move number. return bool if a piece is dropped at a specific move_num
function isdropped(f::ASCIIString,mNum::Int)
	db = SQLite.DB("$(f).db")
	query = "SELECT option FROM moves where move_number = $(mNum)"
	df = SQLite.query(db, query)
	isnull(df[1,1]) == true || get(df[1,1]) == "!" ? (return false) : (return true)
end
#input:filename, move number. return string piece name of the dropped piece at a specific move_num
function get_droppedPiece(f::ASCIIString,mNum::Int)
	db = SQLite.DB("$(f).db")
	query = "SELECT option FROM moves where move_number = $(mNum)"
	df = SQLite.query(db, query)
	isdropped(f,mNum) == true? ( return get( df[1,1] ) ) : (return "")
end


###################################################################################################
##TESTS

#Erase hash tag below for tests

#=
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

#Test get functions
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

=#

# values are nullable => need to use get(df1[1,2])
# println("Before using get() type is $(typeof(df1[1,2]))") #row1,col2 of df1 is game type
# println("After using get() type is $(typeof(get(df1[1,2])))")
#println("If value is NULL don't use get()")
