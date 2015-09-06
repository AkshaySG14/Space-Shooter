require 'gosu'
require_relative 'MapObject'
require_relative 'Enemy'
require_relative 'Missile'
#A missile launcher class that orbits in a circle while firing missiles at the player.
class MissileLauncher < Enemy

  def initialize(x, y, map)
    super x, y, Gosu::Image.new("Assets/missilelauncher.png"), map, 3
    @shootTime = 0
    @color = 0xff_ffff00
    @pColor = 0xff_ffff00
    @spawnX = x
    @spawnY = y
    @angle = 0
  end

  #Updates the missile launcher so that it continuously circles. Every once in a while, will also fire a missile.
  def update
    updateTime
    circle
    if @shootTime > 200
      shoot
      @shootTime = 0
    end
    @shootTime += 1
  end

  #Creates a missile, which is launched at the player. This missile follows the player and will attempt to bash into him.
  def shoot
    missile = Missile.new(@x + Math.cos(@angle), @y + Math.sin(@angle), @map, @pColor)
    @map.PobjectArray.push(missile)
  end

  #Constantly circles around its spawn point, by readjusting its angle and applying functions to it.
  def circle
    #Increments angle by a small amount.
    @angle += Math::PI / 64
    #Sets its position based upon the cosine and sine of its angle. Note the use of 50 to amplify its radius in movement.
    @x = Math.cos(@angle) * 50 + @spawnX
    @y = Math.sin(@angle) * 50 + @spawnY
    #Ensures that the angle does not become too large.
    @angle %= (Math::PI * 2)
  end
end
