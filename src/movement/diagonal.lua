local Piece = require "piece"

-- Diagonal movement for bishop and queen

local insert = table.insert

return function(board, player, i, x, y)
  local moves = player.moves

  local topLeft = math.min(x, y) - 1

  local start = i
  for _ = 1, topLeft do
    start = start - 9
    if board[start] ~= 0 then
      local side, piece = board:getLocation(start)
      if side ~= player.side then
        insert(moves, start)
      end

      break
    end

    insert(moves, start)
  end

  local bottomRight = 8 - math.max(x, y)

  start = i
  for _ = 1, bottomRight do
    start = start + 9
    if board[start] ~= 0 then
      local side, piece = board:getLocation(start)
      if side ~= player.side then
        insert(moves, start)
      end

      break
    end

    insert(moves, start)
  end

  local topRight = math.min(9 - x, y) - 1

  start = i - 7
  for _ = 1, topRight do
    if board[start] ~= 0 then
      local side, piece = board:getLocation(start)
      if side ~= player.side then
        insert(moves, start)
      end

      break
    end

    insert(moves, start)
    start = start - 7
  end

  local bottomLeft = math.min(x, 9 - y) - 1

  start = i + 7
  for _ = 1, bottomLeft do
    if board[start] ~= 0 then
      local side, piece = board:getLocation(start)
      if side ~= player.side then
        insert(moves, start)
      end

      break
    end

    insert(moves, start)
    start = start + 7
  end
end