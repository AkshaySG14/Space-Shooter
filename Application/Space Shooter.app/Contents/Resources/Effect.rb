require 'gosu'
require_relative 'MapObject'
#The effect super class. Closely resembles the player class. These are used for non-game-impacting visual effects.
class Effect < MapObject
  def initialize(x, y, image, map, color)
    super x, y, image, map
    @color = color
  end

  def move(x, y)
    @x, @y = x, y
  end

  def setVelocity(x, y)
    @velX, @velY = x, y
  end

  #Note that gravity does not affect effects, nor do effects collide with any object in the map.
  def tryMove
    @x += @velX
    @y += @velY
  end

  def update
    tryMove
  end

end
