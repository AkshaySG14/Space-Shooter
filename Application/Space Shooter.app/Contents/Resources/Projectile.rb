require 'gosu'
require_relative 'MapObject'
#The projectile super class. Closely resembles the player class.
class Projectile < MapObject
  def initialize(x, y, image, map, enemy, color)
    super x, y, image, map
    @enemy = enemy
    @color = color
  end

  def move(x, y)
    @x, @y = x, y
  end

  def setVelocity(x, y)
    @velX, @velY = x, y
  end

  #Note that gravity does not affect projectiles.
  def tryMove
    if @enemy
      collidesWithPlayer
    else
      collidesWithEnemy
    end
    detectCollision
  end

  def isBlocked?
    for x in @x.round..(@x + @width).round
      for y in (@y - @height).round..@y.round
        if @map.returnBlocked?(x, y)
          return true
        end
      end
    end
    return false
  end

  #If the projectile collides with the player, it will cause him to lose health and the projectile will then delete itself.
  def collidesWithPlayer
    for x in @x.round..(@x + @width).round
      for y in (@y - @height).round..@y.round
        if @map.player.containsPoint?(x, y)
          @map.PobjectArray.delete(self)
          @map.player.loseHealth
        end
      end
    end
  end

  #If the projectile collides with an enemy, it will cause it to lose health and the projectile will then delete itself.
  def collidesWithEnemy
    for x in @x.round..(@x + @width).round
      for y in (@y - @height).round..@y.round
        if @map.enemyContainsPoint?(x, y)
          @map.PobjectArray.delete(self)
          return
        end
      end
    end
  end

  #Note that if the projectile has collided with any object, it will delete itself.
  def detectCollision
    oldX = @x
    oldY = @y
    @x += @velX
    if isBlocked?
      @x = oldX
      @velX = 0
      @map.PobjectArray.delete(self)
      return
    end
    @y += @velY
    if isBlocked?
      @y = oldY
      @velY = 0
      @map.PobjectArray.delete(self)
      return
    end
  end

  def update
    tryMove
  end

end
