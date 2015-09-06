require 'gosu'
require_relative 'MapObject'
require_relative 'Effect'
#This is the death animation for missiles. This animation is essentially the splitting of four different particles in a
#cross pattern.
class Explosion < Effect
  def initialize(x, y, angle, map, color)
    super x, y, Gosu::Image.new("Assets/enemydeath.png"), map, color
    #Sets the initial velocity based on the angle given.
    setVelocity(Math.cos(angle) * 5, Math.sin(angle) * 5)
  end
end
