# Functions related to SQLite database
# Create, insert values, and drop (delete) tables once the game exits
# Please add pkg "SQLite" and "DataArrays" before compiling
using DataArrays, DataFrames
using SQLite

function init_database(f::AbstractString)
	db=SQLite.DB("$(f).db")
	# db=SQLite.DB("oj_shogi.db")

# create metaTable data table
	SQLite.query(db,"create table metaTable (key text primary key, value text)")
	SQLite.query(db,"insert into metaTable values('type',NULL)")
	SQLite.query(db,"insert into metaTable values('legality',NULL)")
	SQLite.query(db,"insert into metaTable values('seed',NULL)")
	println("\nmetaTable set.")

# create movesTable data table
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

#---------------------------------------------------------------------------------------
## META TABLE

function set_gameType(f::ASCIIString,gt::AbstractString)
	db = SQLite.DB("$(f).db")
	query = "update metaTable set value = '$(gt)' where key = 'type'"
	#println(query)
	SQLite.query(db,query)
end

function set_legality(f::ASCIIString,l::AbstractString)
	db = SQLite.DB("$(f).db")
	query = "update metaTable set value = '$(l)' where key = 'legality'"
	#println(query)
	SQLite.query(db,query)
end

#---------------------------------------------------------------------------------------
## MOVES TABLE
#insert new row
function set_move(f::ASCIIString,
									mNum::Int,mType::AbstractString,
									sx::Int,sy::Int,tx::Int,ty::Int,
									promo::Int,cheat::Int, # insert int 1 if the piece is promoted. same with cheat move
									droppedPiece::AbstractString) # insert "" if the move is not a drop move
	db = SQLite.DB("$(f).db")
	query_mNum = "insert into movesTable (move_number) values($(mNum))"
	SQLite.query(db,query_mNum) #update number of moves

	query_mType = "update movesTable set move_type = '$(mType)' where move_number = $(mNum)"
	SQLite.query(db,query_mType) #update move_type

	query_sx = "update movesTable set sourcex = $(sx) where move_number = $(mNum)"
	SQLite.query(db,query_sx) #update source x cord

	query_sy = "update movesTable set sourcey = $(sy) where move_number = $(mNum)"
	SQLite.query(db,query_sy) #update source y cord

	query_tx = "update movesTable set targetx = $(tx) where move_number = $(mNum)"
	SQLite.query(db,query_tx) #update target x cord

	query_ty = "update movesTable set targety = $(ty) where move_number = $(mNum)"
	SQLite.query(db,query_ty) #update target y cord

	# update option column
	# option <- "!"  when there's a promotion
	# option <- piece name when moveType is 'drop'
	# a dropped piece is unpromoted
	if promo == 1
		query_opt = "update movesTable set option = '!' where move_number = $(mNum)"
	elseif mType == "drop"
	  query_opt = "update movesTable set option = '$(droppedPiece)' where move_number = $(mNum)"
	else
		query_opt = "update movesTable set option = NULL where move_number = $(mNum)"
	end
	SQLite.query(db,query_opt)

	# update cheat
	if cheat == 1
		query_cheat = "update movesTable set i_am_cheating = 'yes' where move_number = $(mNum)"
	else
		query_cheat = "update movesTable set i_am_cheating = NULL where move_number = $(mNum)"
	end
	SQLite.query(db,query_cheat)
end


#---------------------------------------------------------------------------------------
#EXTRACT VALUES FROM TABLES

# return the whole table. table("meta")/table("moves")
function get_table(f::ASCIIString,t::AbstractString) # the return type is DataFrame, treat it like a multi-dim array
	db = SQLite.DB("$(f).db")
	if t == "meta"									# https://dataframesjl.readthedocs.io/en/latest/
		df = SQLite.query(db,"select * from metaTable")
	else
		df = SQLite.query(db,"select * from movesTable")
	end
	return df
end

#return details of a row in a DataArray type. moveDetail(3)
function get_move(f::ASCIIString,mNum::Int)
	df = get_table(f,"moves")
	dv = @data([NA,NA,NA,NA,NA,NA,NA,NA])
	for i in 1:8
		#if isnull(df[mNum,i])
			#dv[i] = NULL
		#else
			dv[i] = df[mNum,i]
		#end
	end
	return dv
end


#---------------------------------------------------------------------------------------
##TESTS
filename = "game1"
init_database(filename)
#test movesTable

set_move(filename,1,"move",0,0,0,0,0,0,"")
set_move(filename,2,"drop",0,0,0,0,0,0,"b")
set_move(filename,3,"move",1,2,3,4,0,1,"")
set_move(filename,4,"resign",0,0,0,0,1,0,"")


#test metaTable
set_gameType(filename,"standard")
set_legality(filename,"legal")

#test table extraction
df1 = get_table(filename,"meta")
df2 = get_table(filename,"moves") #df stands for dataframe
println(df1)
println(df2)

#test row and value extraction
println("\nDetails of move 4 is:")
arr = get_move(filename,4)
println(arr)
println("Type of move 4 array is $(typeof(arr))") # we use DataArray type because it's multi-type
#println("Cheating is $(get(arr[8]))")
println("Cheating is $(arr[8])")

# values are nullable => need to use get(df1[1,2])
println()
println("Before using get() type is $(typeof(df1[1,2]))") #row1,col2 of df1 is game type
println("After using get() type is $(typeof(get(df1[1,2])))")
println("If value is NULL don't use get()")
println("Game type is $(get(df1[1,2]))")
