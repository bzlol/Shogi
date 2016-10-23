# Orange Julias
# start.jl <filename> <type(S or M))> <cheating (T for cheating)>
# to remove .db file go to shell> rm file.db
include("database.jl")

toGo = 0
while toGo != 1
	if length(ARGS) < 2 || length(ARGS) > 3 || (ARGS[2] != "S" && ARGS[2] != "M")
		println("\nInput is not valid. Please run the file again! 凸(｀ﾛ´)凸")
		break
	else
		toGo = 1
		filename = ASCIIString(ARGS[1])
		gametype = ASCIIString(ARGS[2])
		#create database
		init_database(filename)
		#set game type (standard or minishogi)
		gametype == "S"? set_gameType(filename,"standard") : set_gameType(filename,"minishogi")
		#set if cheating allow or not
		length(ARGS) < 3 || ARGS[3] != "T" ? set_legality(filename,"legal") : set_legality(filename,"cheating")

		#set seed for AI
		# generate start of unix epoch
		const UNIXEPOCH = DateTime(1970)
		# takes current date time and returns number of seconds since unix epoch
		datetime2unix(dt::DateTime) = (dt - UNIXEPOCH)/1000
		# generate current unix time for seed
		seed = Int(datetime2unix(now()))
		set_seed(filename,seed)

		table_meta = get_table(filename,"meta")
		table_moves = get_table(filename,"moves")
		println(table_meta)
		println(table_moves)
	end
end
