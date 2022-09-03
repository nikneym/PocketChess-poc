local Object  = require "lib.classic"
local flux    = require "lib.flux"
local clear   = require "table.clear"
local Default = require "default"
local Piece   = require "piece"
local Move    = require "move"

local graphics, mouse = love.graphics, love.mouse
local insert = table.insert

local Player = Object:extend()

function Player:new(side)
  self.side = side

  self.selectedPiece = nil
  self.selectedIndex = nil
  self.moves = { } -- possible moves this turn
end

function Player:resetSelection()
  self.selectedIndex = nil
  self.selectedPiece = nil
  clear(self.moves)
end

function Player:movePiece(board, i, piece)
  for _, move in ipairs(self.moves) do
    if move == self.selectedIndex then
      board[move] = self.side + self.selectedPiece

      self:resetSelection()
      break
    end

    if move == i then
      board[self.selectedIndex] = 0
      board[move] = piece

      self:resetSelection()
      return true
    end
  end

  return false
end

function Player:pass()
  return self.side == Piece.white and Piece.black or Piece.white
end

function Player:mousePressed(x, y, key, board)
  if key == 1 then
    local posX = math.floor(x / Default.Size) + 1
    local posY = math.floor(y / Default.Size) + 1
    local i = posY * 8 - (8 - posX)

    if self.selectedPiece then
      local isMoved = self:movePiece(board, i, self.side + self.selectedPiece)

      if isMoved then
        return self:pass()
      end

      return self.side
    end

    local side, piece = board:getLocation(i)
    if side ~= self.side then
      return self.side
    end

    board[i] = 0
    self.selectedPiece = piece
    self.selectedIndex = i

    Move[self.selectedPiece](self, board, i, posX, posY)

    -- current position
    insert(self.moves, i)
  end

  return self.side
end

function Player:mouseReleased(x, y, key, board)
  if key == 1 then
    local posX = math.floor(x / Default.Size) + 1
    local posY = math.floor(y / Default.Size) + 1
    local i = posY * 8 - (8 - posX)

    if self.selectedPiece and self.selectedIndex ~= i then
      local isMoved = self:movePiece(board, i, self.side + self.selectedPiece)

      if isMoved then
        return self:pass()
      end
    end
  end

  if key == 2 then
    if not self.selectedPiece then return self.side end

    board[self.selectedIndex] = self.side + self.selectedPiece
    self:resetSelection()
  end

  return self.side
end

function Player:drawPossibleMoves(board)
  if #self.moves == 0 then return end

  for _, move in ipairs(self.moves) do
    local y = math.floor((move - 1) / 8)
    local x = (move - 1) % 8

    if board[move] ~= 0 then -- enemy piece
      graphics.setColor(1, .3, .3, .5)
    else
      graphics.setColor(1, 1, 0, .4)
    end

    graphics.rectangle(
      "fill",
      x * Default.Size,
      y * Default.Size,
      Default.Size,
      Default.Size
    )
  end
end

function Player:drawSelection(board)
  -- current location
  if self.selectedPiece then
    graphics.setColor(1, 1, 1, .7)
    board:drawPiece(
      self.selectedPiece,
      self.side,
      (self.selectedIndex - 1) % 8 * Default.Size,
      math.floor((self.selectedIndex - 1) / 8) * Default.Size
    )

    -- mouse
    graphics.setColor(1, 1, 1, 1)
    board:drawPiece(
      self.selectedPiece,
      self.side,
      mouse.getX() - Default.Size / 2,
      mouse.getY() - Default.Size / 2
    )
  end
end

return Player