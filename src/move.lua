local Piece      = require "piece"
local Orthogonal = require "movement.orthogonal"
local Diagonal   = require "movement.diagonal"

local insert = table.insert

local Move = { }

Move[Piece.king] = function(player, board, i, x, y)
  local offsets = { 1, -1, 7, -7, 8, -8, 9, -9 }

  for _, offset in ipairs(offsets) do
    local pos = i + offset
    if board[pos] == nil then goto continue end

    local px = x - (pos - 1) % 8 + 1
    if not (px >= 0 and px < 8) then
      goto continue
    end

    if board[pos] ~= 0 then
      local side = board:getLocation(pos)
      if side ~= player.side then
        insert(player.moves, pos)
      end
    else
      insert(player.moves, pos)
    end

    ::continue::
  end
end

Move[Piece.queen] = function(player, board, i, x, y)
  Orthogonal(board, player, i)
  Diagonal(board, player, i, x, y)
end

Move[Piece.bishop] = function(player, board, i, x, y)
  Diagonal(board, player, i, x, y)
end

Move[Piece.knight] = function(player, board, i, x, y)
  local offsets = { 6, -6, 10, -10, 15, -15, 17, -17 }

  for _, offset in ipairs(offsets) do
    local pos = i + offset
    if board[pos] == nil then goto continue end

    local px = x - (pos - 1) % 8 + 1
    local py = y - math.floor((pos - 1) / 8) + 1

    local isHorizontalOk = px >= 0 and px < 8
    local isVerticalOk = py >= 0 and py < 8

    if isHorizontalOk and isVerticalOk then
      if board[pos] ~= 0 then
        local side, piece = board:getLocation(pos)
        if side ~= player.side then
          insert(player.moves, pos)
        end
      else
        insert(player.moves, pos)
      end
    end

    ::continue::
  end
end

Move[Piece.rook] = function(player, board, i)
  Orthogonal(board, player, i)
end

Move[Piece.pawn] = function(player, board, i, x, y)
  local step = player.side == Piece.black and 8 or -8
  local offsets = player.side == Piece.black and { 7, 9 } or { -7, -9 }

  if board[i + step] == 0 then
    insert(player.moves, i + step)

    local doubleMove = i + step * 2

    if player.side == Piece.black then
      if y == 2 then
        if board[doubleMove] == 0 then
          insert(player.moves, doubleMove)
        end
      end
    elseif player.side == Piece.white then
      if y == 7 then
        if board[doubleMove] == 0 then
          insert(player.moves, doubleMove)
        end
      end
    end
  end

  for _, offset in ipairs(offsets) do
    local pos = i + offset
    if board[pos] == nil then goto continue end

    local side = board:getLocation(pos)
    if not side then goto continue end

    if side ~= player.side then
      insert(player.moves, pos)
    end

    ::continue::
  end
end

return Move