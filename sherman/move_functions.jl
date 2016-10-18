function move_black_p(B::Board, set::Pieces, inactive::Pieces, piece, cords)
	# check if pawn is promoted or not

	# if pawn is not promoted
	if set.active(piece) == "p"
		# initialize empty coordinates
		legal_cords = zeros(1,2)

		# set legal coordinates
		if (active(piece)[2] + 1) <= 9
			legal_cords[1] = active(piece)[1]
			legal_cords[2] = active(piece)[2] + 1

			# check if given coordinates are legal AND no friendly unit is blocking
			unit = B.board[ legal_cords[1],legal_cords[2] ]
			if cords == legal_cords && unit == "x"
				move_piece(Board, set, inactive, piece, cords)
			end
		end

	# if pawn is promoted (piece == "P"), it becomes gold general
	else
		# initialize empty coordinates
		legal_cords = zeros(1,2)

		# set legal coordinates
		if (active(piece)[2] + 1) <= 9
			legal_cords[1] = active(piece)[1]
			legal_cords[2] = active(piece)[2] + 1

			# check if given coordinates are legal AND no friendly unit is blocking
			unit = B.board[ legal_cords[1],legal_cords[2] ]
			if cords == legal_cords && unit == "x"
				move_piece(Board, set, inactive, piece, cords)
			end
		end

		if (active(piece)[1] - 1) >= 1 && (active(piece)[2] + 1)  <=9
			legal_cords[1] = active(piece)[1] - 1
			legal_cords[2] = active(piece)[2] + 1

			# check if given coordinates are legal AND no friendly unit is blocking
			unit = B.board[ legal_cords[1],legal_cords[2] ]
			if cords == legal_cords && unit == "x"
				move_piece(Board, set, inactive, piece, cords)
			end
		end

		if (active(piece)[1] + 1) <= 9 && (active(piece)[2] + 1) <= 9
			legal_cords[1] = active(piece)[1] + 1
			legal_cords[2] = active(piece)[2] + 1

			# check if given coordinates are legal AND no friendly unit is blocking
			unit = B.board[ legal_cords[1],legal_cords[2] ]
			if cords == legal_cords && unit == "x"
				move_piece(Board, set, inactive, piece, cords)
			end
		end

		if (active(piece)[1] - 1) >= 1
			legal_cords[1] = active(piece)[1] - 1
			legal_cords[2] = active(piece)[2]

			# check if given coordinates are legal AND no friendly unit is blocking
			unit = B.board[ legal_cords[1],legal_cords[2] ]
			if cords == legal_cords && unit == "x"
				move_piece(Board, set, inactive, piece, cords)
			end
		end

		if (active(piece)[1] + 1) <= 9
			legal_cords[1] = active(piece)[1] + 1
			legal_cords[2] = active(piece)[2]

			# check if given coordinates are legal AND no friendly unit is blocking
			unit = B.board[ legal_cords[1],legal_cords[2] ]
			if cords == legal_cords && unit == "x"
				move_piece(Board, set, inactive, piece, cords)
			end
		end

		if (active(piece)[2] - 1) >= 1
			legal_cords[1] = active(piece)[1]
			legal_cords[2] = active(piece)[2] - 1

			# check if given coordinates are legal AND no friendly unit is blocking
			unit = B.board[ legal_cords[1],legal_cords[2] ]
			if cords == legal_cords && unit == "x"
				move_piece(Board, set, inactive, piece, cords)
			end
		end
	end
end

function move_red_p(B::Board, set::Pieces, inactive::Pieces, piece, cords)
	# check if pawn is promoted or not

	# if pawn is not promoted
	if set.active(piece) == "p"
		# initialize empty coordinates
		legal_cords = zeros(1,2)

		# set legal coordinates
		if (active(piece)[2] - 1) >= 1
			legal_cords[1] = active(piece)[1]
			legal_cords[2] = active(piece)[2] - 1

			# check if given coordinates are legal AND no friendly unit is blocking
			unit = B.board[ legal_cords[1],legal_cords[2] ]
			if cords == legal_cords && unit == "x"
				move_piece(Board, set, inactive, piece, cords)
			end
		end

	# if pawn is promoted (piece == "P"), it becomes gold general
	else
		# initialize empty coordinates
		legal_cords = zeros(1,2)

		# set legal coordinates
		if (active(piece)[2] - 1) >= 1
			legal_cords[1] = active(piece)[1]
			legal_cords[2] = active(piece)[2] - 1

			# check if given coordinates are legal AND no friendly unit is blocking
			unit = B.board[ legal_cords[1],legal_cords[2] ]
			if cords == legal_cords && unit == "x"
				move_piece(Board, set, inactive, piece, cords)
			end
		end

		if (active(piece)[1] - 1) >= 1 && (active(piece)[2] - 1)  >= 1
			legal_cords[1] = active(piece)[1] - 1
			legal_cords[2] = active(piece)[2] - 1

			# check if given coordinates are legal AND no friendly unit is blocking
			unit = B.board[ legal_cords[1],legal_cords[2] ]
			if cords == legal_cords && unit == "x"
				move_piece(Board, set, inactive, piece, cords)
			end
		end

		if (active(piece)[1] - 1) >= 1 && (active(piece)[2] - 1) >= 1
			legal_cords[1] = active(piece)[1] - 1
			legal_cords[2] = active(piece)[2] - 1

			# check if given coordinates are legal AND no friendly unit is blocking
			unit = B.board[ legal_cords[1],legal_cords[2] ]
			if cords == legal_cords && unit == "x"
				move_piece(Board, set, inactive, piece, cords)
			end
		end

		if (active(piece)[1] - 1) >= 1
			legal_cords[1] = active(piece)[1] - 1
			legal_cords[2] = active(piece)[2]

			# check if given coordinates are legal AND no friendly unit is blocking
			unit = B.board[ legal_cords[1],legal_cords[2] ]
			if cords == legal_cords && unit == "x"
				move_piece(Board, set, inactive, piece, cords)
			end
		end

		if (active(piece)[1] + 1) <= 9
			legal_cords[1] = active(piece)[1] + 1
			legal_cords[2] = active(piece)[2]

			# check if given coordinates are legal AND no friendly unit is blocking
			unit = B.board[ legal_cords[1],legal_cords[2] ]
			if cords == legal_cords && unit == "x"
				move_piece(Board, set, inactive, piece, cords)
			end
		end

		if (active(piece)[2] + 1) <= 9
			legal_cords[1] = active(piece)[1]
			legal_cords[2] = active(piece)[2] + 1

			# check if given coordinates are legal AND no friendly unit is blocking
			unit = B.board[ legal_cords[1],legal_cords[2] ]
			if cords == legal_cords && unit == "x"
				move_piece(Board, set, inactive, piece, cords)
			end
		end
	end
end


function move_black_k(B::Board, set::Pieces, inactive::Pieces, piece, cords)
	# initialized empty coordinates
	legal_cords = zeros(1,2)

	# set legal coordinates
	if (active(piece)[1] - 1) >= 1 && (active(piece)[2] + 1) <= 9
		legal_cords[1] = active(piece)[1] - 1
		legal_cords[2] = active(piece)[2] + 1

		# check if given coordinates are legal AND no friendly unit is blocking
		unit = B.board[ legal_cords[1],legal_cords[2] ]
		if cords == legal_cords && unit == "x"
			move_piece(Board, piece, cords)
		end
	end

	if (active(piece)[2] + 1) <= 9
		legal_cords[1] = active(piece)[1]
		legal_cords[2] = active(piece)[2] + 1

		# check if given coordinates are legal AND no friendly unit is blocking
		unit = B.board[ legal_cords[1],legal_cords[2] ]
		if cords == legal_cords && unit == "x"
			move_piece(Board, piece, cords)
		end
	end

	if (active(piece)[1] + 1) <= 9 && (active(piece)[2] + 1) <= 9
		legal_cords[1] = active(piece)[1] + 1
		legal_cords[2] = active(piece)[2] + 1

		# check if given coordinates are legal AND no friendly unit is blocking
		unit = B.board[ legal_cords[1],legal_cords[2] ]
		if cords == legal_cords && unit == "x"
			move_piece(Board, piece, cords)
		end
	end

	if (active(piece)[1] - 1) >= 1
		legal_cords[1] = active(piece)[1] - 1
		legal_cords[2] = active(piece)[2]

		# check if given coordinates are legal AND no friendly unit is blocking
		unit = B.board[ legal_cords[1],legal_cords[2] ]
		if cords == legal_cords && unit == "x"
			move_piece(Board, piece, cords)
		end
	end

	if (active(piece)[1] + 1) <= 9
		legal_cords[1] = active(piece)[1] + 1
		legal_cords[2] = active(piece)[2]

		# check if given coordinates are legal AND no friendly unit is blocking
		unit = B.board[ legal_cords[1],legal_cords[2] ]
		if cords == legal_cords && unit == "x"
			move_piece(Board, piece, cords)
		end
	end

	if (active(piece)[1] - 1) >= 1 && (active(piece)[2] - 1) >= 1
		legal_cords[1] = active(piece)[1] - 1
		legal_cords[2] = active(piece)[2] - 1

		# check if given coordinates are legal AND no friendly unit is blocking
		unit = B.board[ legal_cords[1],legal_cords[2] ]
		if cords == legal_cords && unit == "x"
			move_piece(Board, piece, cords)
		end
	end

	if (active(piece)[2] - 1) >= 1
		legal_cords[1] = active(piece)[1]
		legal_cords[2] = active(piece)[2] - 1

		# check if given coordinates are legal AND no friendly unit is blocking
		unit = B.board[ legal_cords[1],legal_cords[2] ]
		if cords == legal_cords && unit == "x"
			move_piece(Board, piece, cords)
		end
	end

	if (active(piece)[1] + 1) <= 9 && (active(piece)[2] - 1) >= 1
		legal_cords[1] = active(piece)[1] + 1
		legal_cords[2] = active(piece)[2] - 1

		# check if given coordinates are legal AND no friendly unit is blocking
		unit = B.board[ legal_cords[1],legal_cords[2] ]
		if cords == legal_cords && unit == "x"
			move_piece(Board, piece, cords)
		end
	end
end

function move_red_k(B::Board, set::Pieces, inactive::Pieces, piece, cords)
	# initialized empty coordinates
	legal_cords = zeros(1,2)

	# set legal coordinates
	if (active(piece)[1] + 1) <= 9 && (active(piece)[2] - 1) >= 1
		legal_cords[1] = active(piece)[1] + 1
		legal_cords[2] = active(piece)[2] - 1

		# check if given coordinates are legal AND no friendly unit is blocking
		unit = B.board[ legal_cords[1],legal_cords[2] ]
		if cords == legal_cords && unit == "x"
			move_piece(Board, piece, cords)
		end
	end

	if (active(piece)[2] - 1) >= 1
		legal_cords[1] = active(piece)[1]
		legal_cords[2] = active(piece)[2] - 1

		# check if given coordinates are legal AND no friendly unit is blocking
		unit = B.board[ legal_cords[1],legal_cords[2] ]
		if cords == legal_cords && unit == "x"
			move_piece(Board, piece, cords)
		end
	end

	if (active(piece)[1] - 1) >= 1 && (active(piece)[2] - 1) >= 1
		legal_cords[1] = active(piece)[1] - 1
		legal_cords[2] = active(piece)[2] - 1

		# check if given coordinates are legal AND no friendly unit is blocking
		unit = B.board[ legal_cords[1],legal_cords[2] ]
		if cords == legal_cords && unit == "x"
			move_piece(Board, piece, cords)
		end
	end

	if (active(piece)[1] + 1) <= 9
		legal_cords[1] = active(piece)[1] + 1
		legal_cords[2] = active(piece)[2]

		# check if given coordinates are legal AND no friendly unit is blocking
		unit = B.board[ legal_cords[1],legal_cords[2] ]
		if cords == legal_cords && unit == "x"
			move_piece(Board, piece, cords)
		end
	end

	if (active(piece)[1] - 1) >= 1
		legal_cords[1] = active(piece)[1] - 1
		legal_cords[2] = active(piece)[2]

		# check if given coordinates are legal AND no friendly unit is blocking
		unit = B.board[ legal_cords[1],legal_cords[2] ]
		if cords == legal_cords && unit == "x"
			move_piece(Board, piece, cords)
		end
	end

	if (active(piece)[1] + 1) <= 9 && (active(piece)[2] + 1) <= 9
		legal_cords[1] = active(piece)[1] + 1
		legal_cords[2] = active(piece)[2] + 1

		# check if given coordinates are legal AND no friendly unit is blocking
		unit = B.board[ legal_cords[1],legal_cords[2] ]
		if cords == legal_cords && unit == "x"
			move_piece(Board, piece, cords)
		end
	end

	if (active(piece)[2] + 1) <= 9
		legal_cords[1] = active(piece)[1]
		legal_cords[2] = active(piece)[2] + 1

		# check if given coordinates are legal AND no friendly unit is blocking
		unit = B.board[ legal_cords[1],legal_cords[2] ]
		if cords == legal_cords && unit == "x"
			move_piece(Board, piece, cords)
		end
	end

	if (active(piece)[1] - 1) >= 1 && (active(piece)[2] + 1) <= 9
		legal_cords[1] = active(piece)[1] - 1
		legal_cords[2] = active(piece)[2] + 1

		# check if given coordinates are legal AND no friendly unit is blocking
		unit = B.board[ legal_cords[1],legal_cords[2] ]
		if cords == legal_cords && unit == "x"
			move_piece(Board, piece, cords)
		end
	end
end

function move_black_g(B::Board, set::Pieces, inactive::Pieces, piece, cords)
	# initialize empty coordinates
	legal_cords = zeros(1,2)

	# set legal coordinates
	if (active(piece)[2] + 1) <= 9
		legal_cords[1] = active(piece)[1]
		legal_cords[2] = active(piece)[2] + 1

		# check if given coordinates are legal AND no friendly unit is blocking
		unit = B.board[ legal_cords[1],legal_cords[2] ]
		if cords == legal_cords && unit == "x"
			move_piece(Board, set, inactive, piece, cords)
		end
	end

	if (active(piece)[1] - 1) >= 1 && (active(piece)[2] + 1)  <=9
		legal_cords[1] = active(piece)[1] - 1
		legal_cords[2] = active(piece)[2] + 1

		# check if given coordinates are legal AND no friendly unit is blocking
		unit = B.board[ legal_cords[1],legal_cords[2] ]
		if cords == legal_cords && unit == "x"
			move_piece(Board, set, inactive, piece, cords)
		end
	end

	if (active(piece)[1] + 1) <= 9 && (active(piece)[2] + 1) <= 9
		legal_cords[1] = active(piece)[1] + 1
		legal_cords[2] = active(piece)[2] + 1

		# check if given coordinates are legal AND no friendly unit is blocking
		unit = B.board[ legal_cords[1],legal_cords[2] ]
		if cords == legal_cords && unit == "x"
			move_piece(Board, set, inactive, piece, cords)
		end
	end

	if (active(piece)[1] - 1) >= 1
		legal_cords[1] = active(piece)[1] - 1
		legal_cords[2] = active(piece)[2]

		# check if given coordinates are legal AND no friendly unit is blocking
		unit = B.board[ legal_cords[1],legal_cords[2] ]
		if cords == legal_cords && unit == "x"
			move_piece(Board, set, inactive, piece, cords)
		end
	end

	if (active(piece)[1] + 1) <= 9
		legal_cords[1] = active(piece)[1] + 1
		legal_cords[2] = active(piece)[2]

		# check if given coordinates are legal AND no friendly unit is blocking
		unit = B.board[ legal_cords[1],legal_cords[2] ]
		if cords == legal_cords && unit == "x"
			move_piece(Board, set, inactive, piece, cords)
		end
	end

	if (active(piece)[2] - 1) >= 1
		legal_cords[1] = active(piece)[1]
		legal_cords[2] = active(piece)[2] - 1

		# check if given coordinates are legal AND no friendly unit is blocking
		unit = B.board[ legal_cords[1],legal_cords[2] ]
		if cords == legal_cords && unit == "x"
			move_piece(Board, set, inactive, piece, cords)
		end
	end
end

function move_red_g(B::Board, set::Pieces, inactive::Pieces, piece, cords)
	# initialize empty coordinates
	legal_cords = zeros(1,2)

	# set legal coordinates
	if (active(piece)[2] - 1) >= 1
		legal_cords[1] = active(piece)[1]
		legal_cords[2] = active(piece)[2] - 1

		# check if given coordinates are legal AND no friendly unit is blocking
		unit = B.board[ legal_cords[1],legal_cords[2] ]
		if cords == legal_cords && unit == "x"
			move_piece(Board, set, inactive, piece, cords)
		end
	end

	if (active(piece)[1] + 1) <= 9 && (active(piece)[2] - 1)  >= 1
		legal_cords[1] = active(piece)[1] + 1
		legal_cords[2] = active(piece)[2] - 1

		# check if given coordinates are legal AND no friendly unit is blocking
		unit = B.board[ legal_cords[1],legal_cords[2] ]
		if cords == legal_cords && unit == "x"
			move_piece(Board, set, inactive, piece, cords)
		end
	end

	if (active(piece)[1] - 1) >= 1 && (active(piece)[2] - 1) >= 1
		legal_cords[1] = active(piece)[1] - 1
		legal_cords[2] = active(piece)[2] - 1

		# check if given coordinates are legal AND no friendly unit is blocking
		unit = B.board[ legal_cords[1],legal_cords[2] ]
		if cords == legal_cords && unit == "x"
			move_piece(Board, set, inactive, piece, cords)
		end
	end

	if (active(piece)[1] + 1) <= 9
		legal_cords[1] = active(piece)[1] + 1
		legal_cords[2] = active(piece)[2]

		# check if given coordinates are legal AND no friendly unit is blocking
		unit = B.board[ legal_cords[1],legal_cords[2] ]
		if cords == legal_cords && unit == "x"
			move_piece(Board, set, inactive, piece, cords)
		end
	end

	if (active(piece)[1] - 1) >= 1
		legal_cords[1] = active(piece)[1] - 1
		legal_cords[2] = active(piece)[2]

		# check if given coordinates are legal AND no friendly unit is blocking
		unit = B.board[ legal_cords[1],legal_cords[2] ]
		if cords == legal_cords && unit == "x"
			move_piece(Board, set, inactive, piece, cords)
		end
	end

	if (active(piece)[2] + 1) <= 9
		legal_cords[1] = active(piece)[1]
		legal_cords[2] = active(piece)[2] + 1

		# check if given coordinates are legal AND no friendly unit is blocking
		unit = B.board[ legal_cords[1],legal_cords[2] ]
		if cords == legal_cords && unit == "x"
			move_piece(Board, set, inactive, piece, cords)
		end
	end
end

function move_black_s(B::Board, set::Pieces, inactive::Pieces, piece, cords)
	# initialize empty coordinates
	legal_cords = zeros(1,2)

	# set legal coordinates
	if (active(piece)[2] + 1) <= 9
		legal_cords[1] = active(piece)[1]
		legal_cords[2] = active(piece)[2] + 1

		# check if given coordinates are legal AND no friendly unit is blocking
		unit = B.board[ legal_cords[1],legal_cords[2] ]
		if cords == legal_cords && unit == "x"
			move_piece(Board, set, inactive, piece, cords)
		end
	end

	if (active(piece)[1] - 1) >= 1 && (active(piece)[2] + 1)  <=9
		legal_cords[1] = active(piece)[1] - 1
		legal_cords[2] = active(piece)[2] + 1

		# check if given coordinates are legal AND no friendly unit is blocking
		unit = B.board[ legal_cords[1],legal_cords[2] ]
		if cords == legal_cords && unit == "x"
			move_piece(Board, set, inactive, piece, cords)
		end
	end

	if (active(piece)[1] + 1) <= 9 && (active(piece)[2] + 1) <= 9
		legal_cords[1] = active(piece)[1] + 1
		legal_cords[2] = active(piece)[2] + 1

		# check if given coordinates are legal AND no friendly unit is blocking
		unit = B.board[ legal_cords[1],legal_cords[2] ]
		if cords == legal_cords && unit == "x"
			move_piece(Board, set, inactive, piece, cords)
		end
	end

	if (active(piece)[1] - 1) >= 1 && (active(piece)[2] - 1) >= 1
		legal_cords[1] = active(piece)[1] - 1
		legal_cords[2] = active(piece)[2] - 1

		# check if given coordinates are legal AND no friendly unit is blocking
		unit = B.board[ legal_cords[1],legal_cords[2] ]
		if cords == legal_cords && unit == "x"
			move_piece(Board, set, inactive, piece, cords)
		end
	end

	if (active(piece)[1] + 1) <= 9 && (active(piece)[2] - 1) >= 1
		legal_cords[1] = active(piece)[1] + 1
		legal_cords[2] = active(piece)[2] - 1

		# check if given coordinates are legal AND no friendly unit is blocking
		unit = B.board[ legal_cords[1],legal_cords[2] ]
		if cords == legal_cords && unit == "x"
			move_piece(Board, set, inactive, piece, cords)
		end
	end
end

function move_red_s(B::Board, set::Pieces, inactive::Pieces, piece, cords)
	# initialize empty coordinates
	legal_cords = zeros(1,2)

	# set legal coordinates
	if (active(piece)[2] - 1) >= 1
		legal_cords[1] = active(piece)[1]
		legal_cords[2] = active(piece)[2] - 1

		# check if given coordinates are legal AND no friendly unit is blocking
		unit = B.board[ legal_cords[1],legal_cords[2] ]
		if cords == legal_cords && unit == "x"
			move_piece(Board, set, inactive, piece, cords)
		end
	end

	if (active(piece)[1] + 1) <= 9 && (active(piece)[2] - 1)  >= 1
		legal_cords[1] = active(piece)[1] - 1
		legal_cords[2] = active(piece)[2] + 1

		# check if given coordinates are legal AND no friendly unit is blocking
		unit = B.board[ legal_cords[1],legal_cords[2] ]
		if cords == legal_cords && unit == "x"
			move_piece(Board, set, inactive, piece, cords)
		end
	end

	if (active(piece)[1] - 1) >= 1 && (active(piece)[2] - 1) >= 1
		legal_cords[1] = active(piece)[1] - 1
		legal_cords[2] = active(piece)[2] - 1

		# check if given coordinates are legal AND no friendly unit is blocking
		unit = B.board[ legal_cords[1],legal_cords[2] ]
		if cords == legal_cords && unit == "x"
			move_piece(Board, set, inactive, piece, cords)
		end
	end

	if (active(piece)[1] + 1) <= 9 && (active(piece)[2] + 1) <= 9
		legal_cords[1] = active(piece)[1] + 1
		legal_cords[2] = active(piece)[2] + 1

		# check if given coordinates are legal AND no friendly unit is blocking
		unit = B.board[ legal_cords[1],legal_cords[2] ]
		if cords == legal_cords && unit == "x"
			move_piece(Board, set, inactive, piece, cords)
		end
	end

	if (active(piece)[1] - 1) >= 1 && (active(piece)[2] + 1) <= 9
		legal_cords[1] = active(piece)[1] - 1
		legal_cords[2] = active(piece)[2] + 1

		# check if given coordinates are legal AND no friendly unit is blocking
		unit = B.board[ legal_cords[1],legal_cords[2] ]
		if cords == legal_cords && unit == "x"
			move_piece(Board, set, inactive, piece, cords)
		end
	end
end

function move_black_h(B::Board, set::Pieces, inactive::Pieces, piece, cords)
	# initialize empty coordinates
	legal_cords = zeros(1,2)

	# set legal coordinates
	if (active(piece)[1] - 1) >= 1 && (active(piece)[2] + 2) <= 9
		legal_cords[1] = active(piece)[1] - 1
		legal_cords[2] = active(piece)[2] + 2

		# check if given coordinates are legal AND no friendly unit is blocking
		unit = B.board[ legal_cords[1],legal_cords[2] ]
		if cords == legal_cords && unit == "x"
			move_piece(Board, set, inactive, piece, cords)
		end
	end

	if (active(piece)[1] + 1) <= 9 && (active(piece)[2] + 2) <= 9
		legal_cords[1] = active(piece)[1] + 1
		legal_cords[2] = active(piece)[2] + 2

		# check if given coordinates are legal AND no friendly unit is blocking
		unit = B.board[ legal_cords[1],legal_cords[2] ]
		if cords == legal_cords && unit == "x"
			move_piece(Board, set, inactive, piece, cords)
		end
	end
end

function move_red_h(B::Board, set::Pieces, inactive::Pieces, piece, cords)
	# initialize empty coordinates
	legal_cords = zeros(1,2)

	# set legal coordinates
	if (active(piece)[1] + 1) <= 9 && (active(piece)[2] - 2) >= 1
		legal_cords[1] = active(piece)[1] + 1
		legal_cords[2] = active(piece)[2] - 2

		# check if given coordinates are legal AND no friendly unit is blocking
		unit = B.board[ legal_cords[1],legal_cords[2] ]
		if cords == legal_cords && unit == "x"
			move_piece(Board, set, inactive, piece, cords)
		end
	end

	if (active(piece)[1] - 1) >= 1 && (active(piece)[2] - 2) >= 1
		legal_cords[1] = active(piece)[1] - 1
		legal_cords[2] = active(piece)[2] - 2

		# check if given coordinates are legal AND no friendly unit is blocking
		unit = B.board[ legal_cords[1],legal_cords[2] ]
		if cords == legal_cords && unit == "x"
			move_piece(Board, set, inactive, piece, cords)
		end
	end
end

### UNFINISHED
function move_black_l(B::Board, set::Pieces, inactive::Pieces, piece, cords)
	# check if lancer is promoted or not

	# if lancer is not promoted
	if set.active(piece) == "p"
		# initialize empty coordinates
		legal_cords = zeros(1,2)

		# set legal coordinates
		### DOOOO THISSS!!!!!


		

	# if lancer is promoted (piece == "L"), it becomes gold general
	else
		# initialize empty coordinates
		legal_cords = zeros(1,2)

		# set legal coordinates
		if (active(piece)[2] + 1) <= 9
			legal_cords[1] = active(piece)[1]
			legal_cords[2] = active(piece)[2] + 1

			# check if given coordinates are legal AND no friendly unit is blocking
			unit = B.board[ legal_cords[1],legal_cords[2] ]
			if cords == legal_cords && unit == "x"
				move_piece(Board, set, inactive, piece, cords)
			end
		end

		if (active(piece)[1] - 1) >= 1 && (active(piece)[2] + 1)  <=9
			legal_cords[1] = active(piece)[1] - 1
			legal_cords[2] = active(piece)[2] + 1

			# check if given coordinates are legal AND no friendly unit is blocking
			unit = B.board[ legal_cords[1],legal_cords[2] ]
			if cords == legal_cords && unit == "x"
				move_piece(Board, set, inactive, piece, cords)
			end
		end

		if (active(piece)[1] + 1) <= 9 && (active(piece)[2] + 1) <= 9
			legal_cords[1] = active(piece)[1] + 1
			legal_cords[2] = active(piece)[2] + 1

			# check if given coordinates are legal AND no friendly unit is blocking
			unit = B.board[ legal_cords[1],legal_cords[2] ]
			if cords == legal_cords && unit == "x"
				move_piece(Board, set, inactive, piece, cords)
			end
		end

		if (active(piece)[1] - 1) >= 1
			legal_cords[1] = active(piece)[1] - 1
			legal_cords[2] = active(piece)[2]

			# check if given coordinates are legal AND no friendly unit is blocking
			unit = B.board[ legal_cords[1],legal_cords[2] ]
			if cords == legal_cords && unit == "x"
				move_piece(Board, set, inactive, piece, cords)
			end
		end

		if (active(piece)[1] + 1) <= 9
			legal_cords[1] = active(piece)[1] + 1
			legal_cords[2] = active(piece)[2]

			# check if given coordinates are legal AND no friendly unit is blocking
			unit = B.board[ legal_cords[1],legal_cords[2] ]
			if cords == legal_cords && unit == "x"
				move_piece(Board, set, inactive, piece, cords)
			end
		end

		if (active(piece)[2] - 1) >= 1
			legal_cords[1] = active(piece)[1]
			legal_cords[2] = active(piece)[2] - 1

			# check if given coordinates are legal AND no friendly unit is blocking
			unit = B.board[ legal_cords[1],legal_cords[2] ]
			if cords == legal_cords && unit == "x"
				move_piece(Board, set, inactive, piece, cords)
			end
		end
	end
end