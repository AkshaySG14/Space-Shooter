require 'gosu'
require_relative 'MapObject'
require_relative 'Effect'
#This is the death animation shared by ALL enemies. Essentially is composed of 4 particles that split into different directions.
class EnemyDeath < Effect
  def initialize(x, y, angle, map, color)
    super x, y, Gosu::Image.new("Assets/enemydeath.png"), map, color
    #Sets the initial velocity based on the angle given.
    setVelocity(Math.cos(angle - Math::PI / 2) * 5, Math.sin(angle - Math::PI / 2) * 5)
  end
end
