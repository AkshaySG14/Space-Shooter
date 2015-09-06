require 'gosu'
require_relative 'Player'
require_relative 'Map'
#Healthbar that notifies the player of his health.
class HealthBar
  def initialize(map)
    @map = map
    @player = @map.player
    @image = Gosu::Image.new("Assets/greenbar.png")
  end

  #Draws the health bar image with a scale applied. This scale makes the healthbar shrink as the player's health goes down.
  def draw
    @image.draw(0, 0, 0, Float(@player.health) / 10, 1)
  end

end
