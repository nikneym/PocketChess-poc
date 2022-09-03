local Piece = require "piece"

-- Orthogonal movement for rook and queen

local insert = table.insert

return function(board, player, i)
  local moves = player.moves

  -- Horizontal
  local leftwards = i
  while leftwards % 8 ~= 1 do
    leftwards = leftwards - 1
    if board[leftwards] ~= 0 then
      local side, piece = board:getLocation(leftwards)
      if side ~= player.side then
        insert(moves, leftwards)
      end

      break
    end

    insert(moves, leftwards)
  end

  local rightwards = i
  while rightwards % 8 ~= 0 do
    rightwards = rightwards + 1
    if board[rightwards] ~= 0 then
      local side, piece = board:getLocation(rightwards)
      if side ~= player.side then
        insert(moves, rightwards)
      end

      break
    end

    insert(moves, rightwards)
  end

  -- Vertical
  local upwards = i - 8
  while upwards > 0 do
    if board[upwards] ~= 0 then
      local side, piece = board:getLocation(upwards)
      if side ~= player.side then
        insert(moves, upwards)
      end

      break
    end

    insert(moves, upwards)
    upwards = upwards - 8
  end

  local downwards = i + 8
  while downwards <= 8 ^ 2 do
    if board[downwards] ~= 0 then
      local side, piece = board:getLocation(downwards)
      if side ~= player.side then
        insert(moves, downwards)
      end

      break
    end

    insert(moves, downwards)
    downwards = downwards + 8
  end
end