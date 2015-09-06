require 'gosu'
require_relative 'MapObject'
require_relative 'Projectile'
require_relative 'Explosion'
#A missile class.
class Missile < Projectile

  def initialize(x, y, map, color)
    super x, y, Gosu::Image.new("Assets/rocket.png"), map, true, color
    @velX = 0
    @velY = 0
    #Sets the angle so that it points to the player's current position (by getting the arctangent of the two positions).
    @angle = Math.atan2(@y - @map.player.y, @x - @map.player.x) - Math::PI / 2
    #Sets the INITIAL acceleration in accordance with the angle acquired.
    @aceX = Math.cos(@angle - Math::PI / 2) / 5
    @aceY = Math.sin(@angle - Math::PI / 2) / 5
    #This sets the direction of the missile. In the context of this class, direction means in which axis is the missile's
    #acceleration adjusted. For example, if the player is farther in the x-axis than the y, the missile shall only adjust its
    #y-axis acceleration. This is so that the rocket does not fly back towards the player if it misses him, emulating real
    #rockets that do not adjust acceleration mid-air.
    if (@x - @map.player.x).abs > (@y - map.player.y).abs
      @direction = 1
    else
      @direction = -1
    end
    @color = color
  end
  #This method moves the rocket/missile via acceleration.
  def tryMove
    #Resets the angle continuously to provide accurate data.
    @angle = Math.atan2(@y - @map.player.y, @x - @map.player.x) - Math::PI / 2
    #Sets axis of acceleration with relation to the direction.
    if @direction == 1
      @aceY = Math.sin(@angle - Math::PI / 2) / 4
    else
      @aceX = Math.cos(@angle - Math::PI / 2) / 4
    end
    #Adds acceleration to velocity.
    @velX += @aceX
    @velY += @aceY
    #Terminal velocity is 3.
    if @velX > 3
      velX = 3
    elsif @velX < -3
      velX = -3
    end
    #Checks for collision and moves the missile.
    collidesWithPlayer
    detectCollision
  end

  #Virtually identical to the projectile method, with the exception that the missile will explode if it collides with
  #anything. This creates a missile death animation.
  def collidesWithPlayer
    for x in @x.round..(@x + @width).round
      for y in (@y - @height).round..@y.round
        if @map.player.containsPoint?(x, y)
          @map.player.loseHealth
          death
          return
        end
      end
    end
  end

  #Same as the above.
  def detectCollision
    oldX = @x
    oldY = @y
    @x += @velX
    if isBlocked?
      @x = oldX
      @velX = 0
      death
      return
    end
    @y += @velY
    if isBlocked?
      @y = oldY
      @velY = 0
      death
      return
    end
  end
  #This method erases the missile and creates the explosion effect, which is just a cross pattern of the enemy death animation.
  def death
    death1 = Explosion.new(@x, @y, 0, @map, @color)
    death2 = Explosion.new(@x, @y, Math::PI / 2, @map, @color)
    death3 = Explosion.new(@x, @y, Math::PI, @map, @color)
    death4 = Explosion.new(@x, @y, Math::PI * 3 / 2, @map, @color)

    @map.EobjectArray.push(death1)
    @map.EobjectArray.push(death2)
    @map.EobjectArray.push(death3)
    @map.EobjectArray.push(death4)

    @map.PobjectArray.delete(self)
  end

end
