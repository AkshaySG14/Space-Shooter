require 'gosu'
require_relative 'MapObject'
require_relative 'Projectile'
#A bullet class.
class Bullet < Projectile

  def initialize(x, y, angle, map, color)
    super x, y, Gosu::Image.new("Assets/bullet.png"), map, true, color
    #Sets the initial velocity based on the angle given.
    setVelocity(Math.cos(angle - Math::PI / 2) * 2, Math.sin(angle - Math::PI / 2) * 2)
  end
end
