require 'gosu'
require_relative 'MapObject'
require_relative 'Enemy'
require_relative 'Bullet'
#A turret class. This enemy shoots at the player should he come too close.
class Turret < Enemy

  def initialize(x, y, map)
    super x, y, Gosu::Image.new("Assets/turret.png"), map, 1
    @shootTime = 0
    @color = 0xff_ff9900
    @pColor = 0xff_ff9900
  end

  #Updates the turret, and shoots at the player if he is too near. Also rotates to make the shot.
  def update
    if (@map.player.x - @x).abs < 150 and (@map.player.y - @y) < 150
      adjustAngle
      if @shootTime > 100
        shoot
        @shootTime = 0
      end
    end
    @shootTime += 1
  end

  #Creates a bullet, which is fired at the opponent.
  def shoot
    bullet = Bullet.new(@x + Math.cos(@angle), @y + Math.sin(@angle), @angle, @map, @pColor)
    @map.PobjectArray.push(bullet)
  end

  #Constantly adjusts the angle of the turret so that it is facing the player.
  def adjustAngle
    @angle = Math.atan2(@y - @map.player.y, @x - @map.player.x) - Math::PI / 2
  end
end
