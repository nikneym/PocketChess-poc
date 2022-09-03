local Piece = {
  none   = 0,
  king   = 1,
  queen  = 2,
  bishop = 3,
  knight = 4,
  rook   = 5,
  pawn   = 6,

  white  = 8,
  black  = 16
}

-- 01 110 => 14 [ WhiteQueen ]
-- 10 110 => 22 [ BlackQueen ]

return Piece