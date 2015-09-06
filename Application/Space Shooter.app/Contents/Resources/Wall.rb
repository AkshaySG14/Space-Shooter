require 'gosu'
require_relative 'MapObject'
require_relative 'Enemy'
require_relative 'Bullet'
#A wall class. This enemy simply walks around in an attempt to bump into the player.
class Wall < Enemy

  def initialize(x, y, map)
    super x, y, Gosu::Image.new("Assets/Wall.png"), map, 3
    @spawnX = x
    @spawnY = y
    @velX = 2.5
    @velY = 0
    @pColor = 0xff_aa00ff
    @color = 0xff_aa00ff
  end

  #This method simply checks to see whether the wall has strayed to far from its initial spawn point. If so, reverses its
  #velocity. Also moves the wall and detects any collision with the player.
  def update
    updateTime
    if (@x - @spawnX).abs > 50
      @velX *= -1
    end
    tryMove
    collidesWithPlayer
  end
end
