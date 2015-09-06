require 'gosu'
require_relative 'MapObject'
require_relative 'EnemyDeath'
#The enemy super class. Closely resembles the player class.
class Enemy < MapObject
  def initialize(x, y, image, map, health)
    super x, y, image, map
    @invulnerableTime = 0
    @health = health
  end

  def move(x, y)
    @x, @y = x, y
  end

  def setVelocity(x, y)
    @velX, @velY = x, y
  end

  def tryMove
    @velY -= @GRAVITY
    if @velY > 4
      @velY = 4
    end
    detectCollision
  end

  def isBlocked?()
    for x in @x.round..(@x + @width).round
      for y in (@y - @height).round..@y.round
        if @map.returnBlocked?(x, y)
          return true
        end
      end
    end
    return false
  end

  def detectCollision
    oldX = @x
    oldY = @y
    @x += @velX
    if isBlocked?
      @x = oldX
      @velX = 0
    end
    @y += @velY
    if isBlocked?
      @y = oldY
      @velY = 0
      @jumping = false
    end
  end

  def jump
    @velY = -25
    @jumping = true
  end

  #This method kills the enemy by first creating an enemy death animation, and then removing the enemy itself.
  def die
    #This spawns the enemy death effects in such a way that they are all travelling apart. Essentially, creates four
    #enemy death effects, setting each at a different angle. This creates an X-pattern. This angle is used to create the
    #velocity of each of the 4 enemy death animations (which are small particles).
    death1 = EnemyDeath.new(@x, @y, 45 * Math::PI / 180, @map, @pColor)
    death2 = EnemyDeath.new(@x, @y, 135 * Math::PI / 180, @map, @pColor)
    death3 = EnemyDeath.new(@x, @y, 225 * Math::PI / 180, @map, @pColor)
    death4 = EnemyDeath.new(@x, @y, 315 * Math::PI / 180, @map, @pColor)
    #Adds to the rendering list.
    @map.EobjectArray.push(death1)
    @map.EobjectArray.push(death2)
    @map.EobjectArray.push(death3)
    @map.EobjectArray.push(death4)
    #Deletes self from the program.
    @map.DobjectArray.delete(self)
  end

  #If the enemy collides with the player, it will cause him to lose health.
  def collidesWithPlayer
    for x in @x.round..(@x + @width).round
      for y in (@y - @height).round..@y.round
        if @map.player.containsPoint?(x, y)
          @map.player.loseHealth
        end
      end
    end
  end

  def loseHealth
    #If the enemy has a health of -1, that means it cannot be hurt and is an invincible enemy.
    if @invulnerable or @health == -1
      return
    end
    @health -= 1
    if @health == 0
      die
      return
    else
      @invulnerable = true
      @invulnerableTime = 0
      @color = 0xff_ffffff
    end
  end

  def checkInvulnerableEnd
    if @invulnerableTime > 50
      @invulnerable = false
      @color = @pColor
    end
  end

  #Updates all time-related variables.
  def updateTime
    #Increments invulnerable time if invulnerable. If greater than the invulnerability period, makes the enemy vulnerable.
    if @invulnerable
      @invulnerableTime += 1
      checkInvulnerableEnd
    end
  end

  def update
  end

end
