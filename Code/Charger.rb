require 'gosu'
require_relative 'MapObject'
require_relative 'Enemy'
#A charger class. This enemy will charge at the player if at the same height.
class Charger < Enemy

  def initialize(x, y, map)
    super x, y, Gosu::Image.new("Assets/Charger.png"), map, 2
    @spawnX = x
    @spawnY = y
    @velX = 0
    @velY = 0
    @aceX = 0
    @pColor = 0xff_b03060
    @color = 0xff_b03060
    @pX = 0
    @pY = 0
    @freezeTime = 0
    @direction = -1
  end
  #Note that unlike other dynamic objects in the game, the charger does not move by setting its velocity purely. The charger
  #has an acceleration that adds to the velocity every update.
  def tryMove
    @velY -= @GRAVITY
    if @velY > 4
      @velY = 4
    end
    #Adds the x-component of the acceleration to the x-component of the velocity. This is to simulate acceleration.
    @velX += @aceX
    #Sets the max speed of the charger to 4.
    if @velX > 4
      velX = 4
    elsif @velX < -4
      velX = -4
    end
    detectCollision
  end

  #This method checks whether the charger is close enough to the player for it to charge.
  def update
    updateTime
    #Updates the position of the player.
    @pX = @map.player.x
    @pY = @map.player.y
    #If the charger is close enough, and on the same level as the player, charges him.
    if (@x - @pX).abs < 150 and (@y - @pY).abs < 30
      #Sets the freeze time to zero so that the charger does not instantly stop after losing sight of the player.
      @freezeTime = 0
      #If the player is to the right of the charger, reflects its image to the right. Otherwise, maintains its normal one.
      #Also sets the acceleration accordingly.
      if @pX > @x
        @scaleX = -1
        @aceX = 0.1
      else
        @scaleX = 1
        @aceX = -0.1
      end
    #Slows down the SPEED of the charger by setting its acceleration to 1/20th of the charger's current velocity.
    else
      @aceX = @velX * -0.05
    end
    tryMove
    collidesWithPlayer
    @freezeTime += 1
  end
end
