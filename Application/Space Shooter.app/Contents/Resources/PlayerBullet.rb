require 'gosu'
require_relative 'MapObject'
require_relative 'Projectile'
#The player's version of the bullet class.
class PlayerBullet < Projectile
  def initialize(x, y, direction, map)
    super x, y, Gosu::Image.new("Assets/playerbullet.png"), map, false, 0xff_ffffff
    #Sets the initial velocity based on the direction given. 1 is to the right, -1 is to the left.
    if direction == 1
      setVelocity(4, 0)
    else
      setVelocity(-4, 0)
    end
  end
end
