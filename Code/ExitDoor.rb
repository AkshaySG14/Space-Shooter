require 'Gosu'
require_relative 'MapObject'
#The end of the level. Basically a sprite.
class ExitDoor < MapObject
  def initialize(x, y, map)
    super x, y, Gosu::Image.new("Assets/exit.png"), map
  end
end
