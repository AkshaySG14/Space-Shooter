require 'gosu'
require_relative 'MapObject'
require_relative 'Enemy'
require_relative 'Bullet'
#An XShooter class. This enemy shoots at the player in a cross and X pattern.
class XShooter < Enemy
  #Initializes the different angles and times used in the XShooter.
  def initialize(x, y, map)
    super x, y, Gosu::Image.new("Assets/xshooter.png"), map, 2
    @shootTime = 0
    @resetTime = 31
    @color = 0xff_00ffff
    @pColor = 0xff_00ffff
    @angle = 0
    @shootAngle = 0
    @rotateTime = 0
  end

  #Updates the XShooter in various ways.
  def update
    #Updates invulnerability timing.
    updateTime
    #If the XShooter has rotated long enough, and has nearly achieved the desired angle, shoots.
    if @shootTime > 100 and (@angle - @shootAngle).abs < 0.2
      #Sets the XShooter's angle to the shooting angle (which is 0 initially) and shoots four bullets.
      @angle = @shootAngle
      shoot
      #Increases the shoot angle so that the XShooter will change its shape the next time it shoots.
      @shootAngle += Math::PI / 4
      #Ensures the angle does not become too high.
      @shootAngle = @shootAngle % (Math::PI * 2)
      #Resets the shoot time and the reset time. This temporarily freezes the XShooter and resets the cooldown for its next
      #shot.
      @shootTime = 0
      @resetTime = 0
    end
    #If the XShooter has remained frozen for long enough, will rotate the XShooter. Note the use of rotateTime. This is to
    #ensure the XShooter does not rotate too quickly.
    if @resetTime > 30 and @rotateTime > 1
      rotate
      @rotateTime = 0
    end
    #Increments all the different timings.
    @shootTime += 1
    @resetTime += 1
    @rotateTime += 1
  end

  #Creates four bullets, fired at four angles.
  def shoot
    bullet1 = Bullet.new(@x, @y, @angle, @map, @pColor)
    bullet2 = Bullet.new(@x, @y, @angle + Math::PI / 2, @map, @pColor)
    bullet3 = Bullet.new(@x, @y, @angle + Math::PI, @map, @pColor)
    bullet4 = Bullet.new(@x, @y, @angle + Math::PI * 3 / 2, @map, @pColor)

    @map.PobjectArray.push(bullet1)
    @map.PobjectArray.push(bullet2)
    @map.PobjectArray.push(bullet3)
    @map.PobjectArray.push(bullet4)
  end

  #Rotates the Xshooter so that it is constantly spinning.
  def rotate
    @angle += Math::PI / 16
    @angle = @angle % (Math::PI * 2)
  end
end
