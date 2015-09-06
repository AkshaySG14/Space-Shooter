require 'gosu'
require_relative 'MapObject'
require_relative 'PlayerBullet'
require_relative 'PlayerDeath'
#The main player.
class Player < MapObject
  attr_accessor :jump
  attr_accessor :shoot
  attr_accessor :containsPoint
  attr_accessor :loseHealth
  attr_accessor :freeze
  attr_accessor :unFreeze

  attr_accessor :health
  attr_accessor :color

  def initialize(x, y, map)
    super x, y, Gosu::Image.new("Assets/player.png"), map
    @velX = 0
    @velY = 0
    @health = 5
    @invulnerableTime = 0
    @direction = 1
    @jumping = false
    @dJumping = false
  end

  #Instantly moves the player to the given location.
  def move(x, y)
    @x, @y = x, y
  end

  #Sets the velocity of the player.
  def setVelocity(x, y)
    @velX, @velY = x, y
  end

  #Returns true if the player contains the point. This is useful for registering a collision with enemies.
  def containsPoint?(x, y)
    if (@x + 8 - x).abs <= 8 and (@y - 8 - y).abs <= 8
      return true
    else
      return false
    end
  end

  #Checks if the cell the player would be in is blocked. If so returns true. Otherwise, returns false.
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

  #Checks if the player is currently below the screen (falls off a cliff or fails to land on a platform). If so, kills
  #the player
  def outOfBounds
    if @y > 400
      death
    end
  end

  #This moves the player by the velocity in its individual components. Also detects collision.
  def tryMove
    #Factors in gravity's acceleration.
    @velY -= @GRAVITY
    #Terminal velocity is 4.
    if @velY > 4
      @velY = 4
    end
    #Checks for any collisions with blocks.
    detectCollision
  end

  #Tries to move the player by each velocity component. However, if the area is blocked, moves the player back and sets
  #that velocity component to zero.
  def detectCollision
    #Current x and y, soon to be old x and y.
    oldX = @x
    oldY = @y
    #Moves on the x-axis, then checks if the new position of the player is blocked. If so, returns the player to the old
    #position.
    @x += @velX
    if isBlocked?
      @x = oldX
      @velX = 0
    end
    #Same but for the y-axis. Note that this may allow the player to jump again.
    @y += @velY
    if isBlocked?
      #If the player is travelling downwards, he is allowed to jump/double jump again.
      if @velY > 0
        @jumping = false
        @dJumping = false
      end
      @y = oldY
      @velY = 0
    end
  end

  #Shoots a bullet out from the center of the player. This bullet can collide with enemies and damage them.
  def shoot
    #This count is the number of bullets currently on the map.
    bCount = 0
    #For every bullet in the projectile map, adds one to the bullet count.
    @map.PobjectArray.each do |object|
      if object.is_a? PlayerBullet
        bCount += 1
      end
    end
    #If five bullets are on the map, no more can be created until one is destroyed.
    if bCount == 5
      return
    end
    #Else creates the bullet and launches it. Also adds it to the rendering list.
    bullet = PlayerBullet.new(@x, @y, @direction, @map)
    @map.PobjectArray.push(bullet)
  end

  #Sets a high initial y-velocity to emulate the player jumping. Also tells the program that the player is currently jumping
  #and therefore cannot jump again.
  def jump
    @velY = -20
    @jumping = true
  end

  #Sets a high initial y-velocity to emulate the player double jumping. Also tells the program that the player is currently
  #double jumping and therefore cannot double jump again.
  def doubleJump
    @velY = -15
    @dJumping = true
  end

  #If the player is not currently jumping, makes the player jump.
  def decideJump
    #Player can jump if he is not falling and he hasn't jumped.
    if !@jumping and @velY <= 0
      jump
    #Player can double jump if he has not double jumped.
    elsif !@dJumping
      doubleJump
    end
  end

  #Loses one health point.
  def loseHealth
    #If the player is invulnerable, he cannot take damage until he is vulnerable once again.
    if @invulnerable
      return
    end
    #Otherwise, the player is hurt and set to invulnerable for a short period. Also colors the player red and resets the
    #invulnerable timer.
    @health -= 1
    #If the health of the player is zero, kills the player.
    if health == 0
      death
    #Otherwise makes the player invulnerable for a short time.
    else
      @invulnerable = true
      @invulnerableTime = 0
      @color = 0xff_ff0000
    end
  end

  #Makes player vulnerable if time is greater than 15 and resets the player's color.
  def checkInvulnerableEnd
    if @invulnerableTime > 75
      @invulnerable = false
      @color = 0xff_ffffff
    end
  end

  #Updates all time-related variables.
  def updateTime
    #Increments invulnerable time if invulnerable. If greater than the invulnerability period, makes the player vulnerable.
    if @invulnerable
      @invulnerableTime += 1
      checkInvulnerableEnd
    end
  end

  #This updates the player's object. Essentially, sets the velocity, depending on the player's inputs, and then moves the player
  #afterwards.
  def update
    #Updates all times
    updateTime
    #Checks whether the player has activated a new respawn point.
    @map.checkRespawn
    #Checks whether the player has gone out of bounds (below the screen).
    outOfBounds

    #A or D keys pressed. A moves backwards, D forwards.
    if Gosu::button_down? Gosu::KbA
      setVelocity(-3.5, @velY)
      @direction = -1
    elsif Gosu::button_down? Gosu::KbD
      setVelocity(3.5, @velY)
      @direction = 1
    else
      setVelocity(0, @velY)
    end
    #Updates the camera and moves the player.
    @map.camera.update(@x)
    tryMove
  end

  #Kills the player, blacks out the screen, and respawns him.
  def death
    #Halts the player.
    @velX = 0
    @velY = 0
    #Creates a player death effect in a star pattern.
    death1 = PlayerDeath.new(@x, @y, 0, @map)
    death2 = PlayerDeath.new(@x, @y, Math::PI / 4, @map)
    death3 = PlayerDeath.new(@x, @y, Math::PI / 2, @map)
    death4 = PlayerDeath.new(@x, @y, Math::PI * 3 / 4, @map)
    death5 = PlayerDeath.new(@x, @y, Math::PI, @map)
    death6 = PlayerDeath.new(@x, @y, Math::PI * 5 / 4, @map)
    death7 = PlayerDeath.new(@x, @y, Math::PI * 3 / 2, @map)
    death8 = PlayerDeath.new(@x, @y, Math::PI * 7 / 4, @map)
    #Adds to the rendering list.
    @map.EobjectArray.push(death1)
    @map.EobjectArray.push(death2)
    @map.EobjectArray.push(death3)
    @map.EobjectArray.push(death4)
    @map.EobjectArray.push(death5)
    @map.EobjectArray.push(death6)
    @map.EobjectArray.push(death7)
    @map.EobjectArray.push(death8)
    #Removes the player from the rendering list.
    @map.DobjectArray.delete(self)
    #Fades out the screen.
    @map.fadeOut
  end
  #Respawns the player.
  def respawn
    #Moves the player to the respawn point.
    move(@map.respawnX, @map.respawnY)
    #Adds the player to the rendering list.
    @map.DobjectArray.push(self)
    #Resets health.
    @health = 5
    #Resets invulnerability.
    @invulnerable = false
    @invulnerableTime = 0
    @color = 0xff_ffffff
  end
end
