# Functions related to SQLite database
# Create, insert values, and drop (delete) tables once the game exits
# Please add pkg "SQLite" and "DataArrays" before compiling
using DataArrays, DataFrames
using SQLite

db=SQLite.DB("oj_shogi.db")

## META TABLE
# create metaTable data table
function set_metaTable()
	SQLite.query(db,"create table metaTable (key text primary key, value text)")
	SQLite.query(db,"insert into metaTable values('type',NULL)")
	SQLite.query(db,"insert into metaTable values('legality',NULL)")
	SQLite.query(db,"insert into metaTable values('seed',NULL)")
end

function set_gameType(str::AbstractString)
	query = "update metaTable set value = '$(str)' where key = 'type'"
	println(query)
	SQLite.query(db,query)
end

function set_legality(str::AbstractString)
	query = "update metaTable set value = '$(str)' where key = 'legality'"
	println(query)
	SQLite.query(db,query)
end

#---------------------------------------------------------------------------------------
## MOVES TABLE
# create movesTable data table
function set_movesTable()
	SQLite.query(db,"create table movesTable (move_number integer primary key,
																						move_type text,
																						sourcex integer,
																						sourcey integer,
																						targetx integer,
																						targety integer,
																						option text,
																						i_am_cheating integer)")
 println("\nmovesTable set.")
end

#insert new row
function set_move(moveNum::Int,moveType::AbstractString,
									sx::Int,sy::Int,tx::Int,ty::Int,
									promo::Int,cheat::Int, # insert int 1 if the piece is promoted. same with cheat move
									droppedPiece::AbstractString) # insert "" if the move is not a drop move

	query_moveNum = "insert into movesTable (move_number) values($(moveNum))"
	SQLite.query(db,query_moveNum) #update number of moves

	query_moveType = "update movesTable set move_type = '$(moveType)' where move_number = $(moveNum)"
	SQLite.query(db,query_moveType) #update move_type

	query_sx = "update movesTable set sourcex = $(sx) where move_number = $(moveNum)"
	SQLite.query(db,query_sx) #update source x cord

	query_sy = "update movesTable set sourcey = $(sy) where move_number = $(moveNum)"
	SQLite.query(db,query_sy) #update source y cord

	query_tx = "update movesTable set targetx = $(tx) where move_number = $(moveNum)"
	SQLite.query(db,query_tx) #update target x cord

	query_ty = "update movesTable set targety = $(ty) where move_number = $(moveNum)"
	SQLite.query(db,query_ty) #update target y cord

	# update option column
	# option <- "!"  when there's a promotion
	# option <- piece name when moveType is 'drop'
	# a dropped piece is unpromoted
	if promo == 1
		query_opt = "update movesTable set option = '!' where move_number = $(moveNum)"
	elseif moveType == "drop"
	  query_opt = "update movesTable set option = '$(droppedPiece)' where move_number = $(moveNum)"
	else
		query_opt = "update movesTable set option = NULL where move_number = $(moveNum)"
	end
	SQLite.query(db,query_opt)

	# update cheat
	if cheat == 1
		query_cheat = "update movesTable set i_am_cheating = 'yes' where move_number = $(moveNum)"
	else
		query_cheat = "update movesTable set i_am_cheating = NULL where move_number = $(moveNum)"
	end
	SQLite.query(db,query_cheat)
end


#---------------------------------------------------------------------------------------
#EXTRACT VALUES FROM TABLES

# return the whole table. table("meta")/table("moves")
function table(t::AbstractString) # the return type is dataframe, treat it like a multi-dim array
	if t == "meta"									# https://dataframesjl.readthedocs.io/en/latest/
		df = SQLite.query(db,"select * from metaTable")
	else
		df = SQLite.query(db,"select * from movesTable")
	end
	return df
end

#return details of a row
function moveDetail(moveNum::Int)
	df = table("moves")
	dv = @data([NA,NA,NA,NA,NA,NA,NA,NA])
	for i in 1:8
		dv[i] = df[moveNum,i]
	end
	return dv
end


#---------------------------------------------------------------------------------------
##TESTS
#test movesTable
set_movesTable()
set_move(1,"move",0,0,0,0,0,0,"")
set_move(2,"drop",0,0,0,0,0,0,"b")
set_move(3,"move",1,2,3,4,0,1,"")
set_move(4,"resign",0,0,0,0,1,0,"")


#test metaTable
set_metaTable()
set_gameType("standard")
set_legality("legal")

#test table extraction
df1 = table("meta")
df2 = table("moves") #df stands for dataframe
println(df1)
println(df2)

#test row and value extraction
println("\nDetails of move 3 is:")
arr = moveDetail(3)
println(arr)
println("Type of move 3 array is $(typeof(arr))")
println("Cheating is $(get(arr[8]))")

# values are nullable => need to use get(df1[1,2])
println()
println("Before using get() type is $(typeof(df1[1,2]))") #row1,col2 of df1 is game type
println("After using get() type is $(typeof(get(df1[1,2])))")
println("Game type is $(get(df1[1,2]))")



#delete tables
#comment out if you want to retain result in .db file
SQLite.drop!(db,"metaTable")
SQLite.drop!(db,"movesTable")
println("\nTables have been deleted.")
