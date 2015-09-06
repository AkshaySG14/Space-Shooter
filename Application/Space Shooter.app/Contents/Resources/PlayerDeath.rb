require 'gosu'
require_relative 'MapObject'
require_relative 'Effect'
#This is the death animation that is composed of 8 particles that split into different directions.
class PlayerDeath < Effect
  def initialize(x, y, angle, map)
    super x, y, Gosu::Image.new("Assets/enemydeath.png"), map, 0xff_00ff00
    #Sets the initial velocity based on the angle given.
    setVelocity(Math.cos(angle) * 5, Math.sin(angle) * 5)
  end
end
