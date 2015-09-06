require 'Gosu'
require_relative 'MapObject'
#This is a block that prevents the player from moving onto its tile. Used for platforming purposes.
class Block < MapObject
  def initialize(x, y, map)
    super x, y, Gosu::Image.new("Assets/block.png"), map
  end
end
