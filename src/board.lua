local Default = require "default"
local Piece   = require "piece"
local fen     = require "fen"

local graphics = love.graphics
local insert = table.insert

local Board = { }
Board.__index = Board

local img = graphics.newImage("img/pieces.png", { dpiscale = 8, linear = true, mipmaps = true })

local Pieces = { }
local w = 240
local h = 80
local textureWidth = 6

for i = 0, 11 do
  local x = i % textureWidth
  local y = math.floor(i / textureWidth)

  local quad = graphics.newQuad(x * 40, y * 40, 40, 40, w, h)
  insert(Pieces, quad)
end

function Board.new(fenStr)
  local self = { }
  for i = 1, 8 ^ 2 do
    insert(self, 0)
  end

  fen.load(self, fenStr)

  return setmetatable(self, Board)
end

function Board:getLocation(i)
  assert(type(i) == "number")
  local current = self[i]
  if current == 0 then
    return nil, nil
  end

  local piece = current % 8
  local side = current - piece

  return side, piece
end

function Board:indices()
  graphics.setColor(1, 0, 0)
  for i = 0, 63 do
    local y = math.floor(i / 8)
    local x = i % 8
    graphics.print(tostring(i + 1), x * Default.Size + 10, y * Default.Size + 10)
  end
end

function Board:draw()
  graphics.setColor(1, 1, 1)
  -- 8x8
  for i = 0, 63 do
    local current = self[i + 1]
    if current == 0 then
      goto continue
    end

    local y = math.floor(i / 8)
    local x = i % 8

    local piece = current % 8
    local side = current - piece

    self:drawPiece(
      piece,
      side,
      x * Default.Size,
      y * Default.Size
    )

    ::continue::
  end
end

function Board:drawPiece(piece, side, x, y)
  graphics.draw(
    img,
    Pieces[piece + (side == Piece.black and 6 or 0)],
    x,
    y
  )
end

return setmetatable(Board, {
  __call = function(t, ...)
    return Board.new(...)
  end
})