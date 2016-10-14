# Functions related to SQLite database
# Create, insert values, and drop (delete) tables once the game exits

using SQLite

db=SQLite.DB("oj_shogi.db")

function meta() # create meta data table
	SQLite.query(db,"create table meta (key text primary key, value text)")
	SQLite.query(db,"insert into meta values('type',NULL)")
	SQLite.query(db,"insert into meta values('legality',NULL)")
	SQLite.query(db,"insert into meta values('seed',NULL)")
end

function set_gameType(str::String)
	if str == "standard"
		SQLite.query(db,"update meta set value = 'standard' where key = 'type'")
	else
		SQLite.query(db,"update meta set value = 'minishogi' where key = 'type'")
	end
end

function set_legality(str::String)
	if str == "cheating"
		SQLite.query(db,"update meta set value = 'cheating' where key = 'legality'")
	else
		SQLite.query(db,"update meta set value = 'legal' where key = 'legality'")
	end
end

#test
meta()
set_gameType("standard")
set_legality("legal")

#SQLite.drop!(db,"meta") #delete table
# if want to see result, comment the drop command out
# and type " SQLite.query(db,"select * from meta") " on REPL
# remember to delete table if you want to re-run the file
