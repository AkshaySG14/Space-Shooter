require 'gosu'
require_relative 'MapObject'
require_relative 'Enemy'
require_relative 'Bullet'
#A spike class. This enemy hovers up and down to block the player.
class Spike < Enemy
  #Note that the spike class intiializes with a health of -1. That means it cannot be hurt.
  def initialize(x, y, map)
    super x, y, Gosu::Image.new("Assets/Spike.png"), map, -1
    @spawnX = x
    @spawnY = y
    @velX = 0
    @velY = 2
    @color = 0xff_ff0000
    @pColor = 0xff_ff0000
  end

  #The spike class overrides the original tryMove method, as it is not affected by gravity.
  def tryMove
    @x += @velX
    @y += @velY
  end

  #This method simply checks to see whether the spike has strayed to far from its initial spawn point. If so, reverses its
  #velocity. Also moves the spike and detects collision with the player.
  def update
    updateTime
    if (@y - @spawnY).abs > 90
      @velY *= -1
    end
    tryMove
    collidesWithPlayer
  end
end
