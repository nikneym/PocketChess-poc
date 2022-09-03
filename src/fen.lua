local Piece = require "piece"

local function load(board, fen)
  assert(type(board) == "table")
  fen = fen or "rnbqkbnr/pppppppp/////PPPPPPPP/RNBQKBNR"

  local map = {
    P = Piece.white + Piece.pawn,
    R = Piece.white + Piece.rook,
    N = Piece.white + Piece.knight,
    B = Piece.white + Piece.bishop,
    Q = Piece.white + Piece.queen,
    K = Piece.white + Piece.king,

    p = Piece.black + Piece.pawn,
    r = Piece.black + Piece.rook,
    n = Piece.black + Piece.knight,
    b = Piece.black + Piece.bishop,
    q = Piece.black + Piece.queen,
    k = Piece.black + Piece.king,
  }

  local file = 1
  local rank = 0

  for i = 1, #fen do
    local c = fen:sub(i, i)

    if c == '/' then
      file = 1
      rank = rank + 1
    else
      local num = tonumber(c)
      if num then
        file = file + num
      else
        board[rank * 8 + file] = map[c]
        file = file + 1
      end
    end
  end
end

return {
  load = load
}