# start.jl <filename> <type(S or M))> <cheating (T for cheating)>
# to remove .db file go to shell> rm file.db
include("database.jl")


filename = ASCIIString(ARGS[1])
gametype = ASCIIString(ARGS[2])
init_database(filename)

gametype == "S"? set_gameType(filename,"standard") : set_gameType(filename,"minishogi")

length(ARGS) < 3 || ARGS[3] != "T" ? set_legality(filename,"legal") : set_legality(filename,"cheating")

set_move(filename,1,"",0,0,0,0,0,0,"")

table_meta = get_table(filename,"meta")
table_moves = get_table(filename,"moves")

println(table_meta)
println(table_moves)

#print args in shell
# for x in ARGS
# 	println(x)
# end
