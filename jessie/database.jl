# Functions related to SQLite database
# Create, insert values, and drop (delete) tables once the game exits
using SQLite

db=SQLite.DB("oj_shogi.db")

## META TABLE
function metaTable() # create metaTable data table
	SQLite.query(db,"create table metaTable (key text primary key, value text)")
	SQLite.query(db,"insert into metaTable values('type',NULL)")
	SQLite.query(db,"insert into metaTable values('legality',NULL)")
	SQLite.query(db,"insert into metaTable values('seed',NULL)")
end

function set_gameType(str::String)
	query = "update metaTable set value = '$(str)' where key = 'type'"
	println(query)
	SQLite.query(db,query)
end

function set_legality(str::String)
	query = "update metaTable set value = '$(str)' where key = 'legality'"
	println(query)
	SQLite.query(db,query)
end

######################################################################
## MOVES TABLE
# create movesTable data table
function movesTable()
	SQLite.query(db,"create table movesTable (move_number integer primary key,
																						move_type text,
																						sourcex integer,
																						sourcey integer,
																						targetx integer,
																						targety integer,
																						option text,
																						i_am_cheating integer)")
 println("movesTable set.")
end

#set the values in the rows of table
function set_move(moveNum::Int,moveType::String,
									sx::Int,sy::Int,tx::Int,ty::Int,
									promo::Int,cheat::Int,
									droppedPiece::String)
	query_moveNum = "insert into movesTable (move_number) values($(moveNum))"
	SQLite.query(db,query_moveNum) #update number of moves

	query_moveType = "update movesTable set move_type = '$(moveType)' where move_number = $(moveNum)"
	SQLite.query(db,query_moveType) # so on so forth

	query_sx = "update movesTable set sourcex = $(sx) where move_number = $(moveNum)"
	SQLite.query(db,query_sx)

	query_sy = "update movesTable set sourcey = $(sy) where move_number = $(moveNum)"
	SQLite.query(db,query_sy)

	query_tx = "update movesTable set targetx = $(tx) where move_number = $(moveNum)"
	SQLite.query(db,query_tx)

	query_ty = "update movesTable set targety = $(ty) where move_number = $(moveNum)"
	SQLite.query(db,query_ty)

	# ! -> option  when there's a promotion, piece name -> option when moveType is 'drop'
	# can't be both
	if promo == 1
		query_opt = "update movesTable set option = '!' where move_number = $(moveNum)"
	elseif moveType == "drop"
	  query_opt = "update movesTable set option = '$(droppedPiece)' where move_number = $(moveNum)"
	else
		query_opt = "update movesTable set option = NULL where move_number = $(moveNum)"
	end
	SQLite.query(db,query_opt)

	if cheat == 1
		query_cheat = "update movesTable set i_am_cheating = 'yes' where move_number = $(moveNum)"
	else
		query_cheat = "update movesTable set i_am_cheating = NULL where move_number = $(moveNum)"
	end
	SQLite.query(db,query_cheat)

end


#test movesTable
movesTable()
set_move(1,"move",0,0,0,0,0,0,"")
set_move(2,"drop",0,0,0,0,0,0,"b")
set_move(3,"move",1,2,3,4,0,1,"")
set_move(4,"resign",0,0,0,0,1,0,"")


#test metaTable
metaTable()
set_gameType("standard")
set_legality("legal")

#delete tables
SQLite.drop!(db,"metaTable")
SQLite.drop!(db,"movesTable")
# if want to see result, comment the drop commands out
# and type " SQLite.query(db,"select * from meta/movesTable") " on REPL
# remember to delete tables if you want to re-run the file
