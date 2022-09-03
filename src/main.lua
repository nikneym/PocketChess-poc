local graphics, keyboard = love.graphics, love.keyboard
local Default = require "default"
local Board   = require "board"
local Piece   = require "piece"
local Move    = require "move"
local Player  = require "player"

local squares = graphics.newCanvas(320, 320)
squares:renderTo(function()
  graphics.clear()
  for i = 0, 63 do
    local y = math.floor(i / 8)
    local x = i % 8
    local isEven = (x + y) % 2 == 0

    graphics.setColor(isEven and Default.DarkColor or Default.LightColor)

    graphics.rectangle("fill",
    x * Default.Size,
    y * Default.Size,
    Default.Size,
    Default.Size
    )
  end
end)

local board, turn, sides

function love.load()
  board = Board()
  turn = Piece.white

  sides = {
    [Piece.white] = Player(Piece.white),
    [Piece.black] = Player(Piece.black)
  }
end

function love.update(dt)
  
end

function love.mousepressed(x, y, key)
  turn = sides[turn]:mousePressed(x, y, key, board)
end

function love.mousereleased(x, y, key)
  turn = sides[turn]:mouseReleased(x, y, key, board)
end

function love.keypressed(key)
  if key == "escape" or key == 'q' then
    love.event.quit()
  end

  if key == 'r' then
    love.load()
  end
end

function love.draw()
  -- checker board
  graphics.setColor(1, 1, 1)
  graphics.draw(squares, 0, 0)

  -- possible moves
  sides[turn]:drawPossibleMoves(board)

  -- pieces
  board:draw()

  --board:indices()

  -- selections of the player
  sides[turn]:drawSelection(board)
end