require 'Gosu'
require 'Texplay'
require_relative 'Block'
require_relative 'Player'
require_relative 'ExitDoor'
require_relative 'HealthBar'
require_relative 'Camera'
require_relative 'Turret'
require_relative 'Wall'
require_relative 'Spike'
require_relative 'XShooter'
require_relative 'Charger'
require_relative 'MissileLauncher'

class Map
  attr_accessor :DobjectArray
  attr_accessor :PobjectArray
  attr_accessor :EobjectArray

  attr_accessor :camera
  attr_accessor :player
  attr_accessor :victory
  attr_accessor :win

  attr_accessor :checkRespawn
  attr_accessor :enemyContainsPoint
  attr_accessor :continue
  attr_accessor :reset

  attr_accessor :respawnX
  attr_accessor :respawnY

  def initialize(main)
    #Gets the main program.
    @main = main
    #Sets the level of the game.
    @level = 0
    #Creates all the objects.
    drawFromPixmap
    #Background image of the game.
    @background_image = Gosu::Image.new("Assets/space.png", :tileable => true)
    #The mask of the game, which is used for washing the screen.
    @mask = Gosu::Image.new("Assets/mask.png", :tileable => true)
    #The victory screen, for when the player successfully completes the level.
    @victoryScreen = Gosu::Image.new("Assets/victoryscreen.png", :tileable => true)
    #The win screen, for when the player successfully completes the game.
    @winScreen = Gosu::Image.new("Assets/winscreen.png", :tileable => true)
    #The fade time which is used to reduce/increase the alpha of the mask over time.
    @fadeTime = 0
  end

  # Creates all the tiles, using the information given by the pixelmap.
  def drawFromPixmap
    #Initializes the two object arrays, one for static, and one for dynamic.
    @DobjectArray = Array.new
    @SobjectArray = Array.new
    #This is the array that is used for collision.
    @KobjectArray = Array.new(400)
    @KobjectArray.map! {Array.new(25, nil)}
    #Initializes the object array for projectiles.
    @PobjectArray = Array.new
    #Initializes the object array for effects.
    @EobjectArray = Array.new
    #Initializes the array that contains all the respawn points.
    @respawnArray = Array.new
    #Sets victory and winto false.
    @victory = false
    @win = false
    #Sets the pixel map in accordance with the level.
    case @level
    when 0
      pixelMap = Gosu::Image.new("Assets/pixelmapL1.png")
    when 1
      pixelMap = Gosu::Image.new("Assets/pixelmapL2.png")
    when 2
      pixelMap = Gosu::Image.new("Assets/pixelmapL3.png")
    end
    #Iterates through all pixels in the pixelmap, creating objects depending on the color of the pixel.
    for x in 0..399
      for y in 0..24
        #Gets the color and the type of object of the pixel.
        color = pixelMap.get_pixel(x, y)
        #If the color is black, move on, as it does not represent anything significant. This speeds up initialization
        #significantly.
        if color[0] == 0 and color[1] == 0 and color[2] == 0
          next
        end
        #If the pixel is black, ignore, as it does not represent anything.
        key = getFromPixel(color)
        #Creates a block, as the pixel represents a block.
        if key == "block"
          block = Block::Block.new(x * 16, y * 16, self)
          @SobjectArray.push(block)
          #Sets that coordinate on the map to true for collision purposes.
          @KobjectArray[x][y] = true
        end
        #Creates the player, as the pixel represents the player spawn.
        if key == "player"
          @player = Player::Player.new(x * 16, y * 16, self)
          #Creates the first respawn point.
          @respawnX = x * 16
          @respawnY = y * 16
          @healthBar = HealthBar::HealthBar.new(self)
          @DobjectArray.push(@player)
        end
        #Adds a respawn point, as the pixel represents a respawn point.
        if key == "respawn"
          @respawnArray.push([x * 16, y * 16])
        end
        #Adds the exit door, as the pixel represents the exit door.
        if key == "exitdoor"
          @exitDoor = ExitDoor::ExitDoor.new(x * 16, y * 16, self)
          @DobjectArray.unshift(@exitDoor)
        end
        #Creates a turret, as the pixel represents the turret spawn.
        if key == "turret"
          turret = Turret::Turret.new(x * 16, y * 16, self)
          @DobjectArray.push(turret)
        end
        #Creates a wall enemy, as the pixel represents the wall enemy spawn.
        if key == "wall"
          wall = Wall::Wall.new(x * 16, y * 16, self)
          @DobjectArray.push(wall)
        end
        #Creates a spike enemy, as the pixel represents the spike enemy spawn.
        if key == "spike"
          spike = Spike::Spike.new(x * 16, y * 16, self)
          @DobjectArray.push(spike)
        end
        #Creates an xshooter enemy, as the pixel represents the xshooter enemy spawn.
        if key == "xshooter"
          xshooter = XShooter::XShooter.new(x * 16, y * 16, self)
          @DobjectArray.push(xshooter)
        end
        #Creates a charger enemy, as the pixel represents the charger enemy spawn.
        if key == "charger"
          charger = Charger::Charger.new(x * 16, y * 16, self)
          @DobjectArray.push(charger)
        end
        #Creates a missile launcher enemy, as the pixel represents the missile launcher enemy spawn.
        if key == "missile launcher"
          mLauncher = MissileLauncher::MissileLauncher.new(x * 16, y * 16, self)
          @DobjectArray.push(mLauncher)
        end
      end
    end
    #Creates the camera.
    @camera = Camera::Camera.new(@player.x, @player.y)
    #The x and y of the respawn point.
    @respawnX = 0
    @respawnY = 0
  end

  #This tells the game what object to generate
  def getFromPixel(color)
    key = Gosu::Image.new("Assets/key.png")
    #Red pixel, therefore it is a block.
    if key.get_pixel(0, 0) == color
      return "block"
    end
    #Green pixel, therefore it is a turret.
    if key.get_pixel(0, 1) == color
      return "turret"
    end
    #Cyan pixel, therefore it is a wall enemy.
    if key.get_pixel(0, 2) == color
      return "wall"
    end
    #Pink pixel, therefore it is a spike enemy.
    if key.get_pixel(0, 3) == color
      return "spike"
    end
    #Yellow pixel, therefore it is a xshooter enemy.
    if key.get_pixel(0, 4) == color
      return "xshooter"
    end
    #Maroon pixel, therefore it is a charger enemy.
    if key.get_pixel(1, 0) == color
      return "charger"
    end
    #Dark Green pixel, therefore it is a missile launcher enemy.
    if key.get_pixel(1, 1) == color
      return "missile launcher"
    end
    #Light gray pixel, therefore it is a respawn point.
    if key.get_pixel(4, 2) == color
      return "exitdoor"
    end
    #Gray pixel, therefore it is a respawn point.
    if key.get_pixel(4, 3) == color
      return "respawn"
    end
    #White pixel, therefore it is a player spawn.
    if key.get_pixel(4, 4) == color
      return "player"
    end

    return "none"
  end

  #If the tile is occupied by a blocker, returns true. Otherwise, returns false. This fashion of doing collision
  #greatly increases FPS.
  def returnBlocked?(x, y)
    #Gets the coordinate of the position in terms of tiles. If the key object array reveals that
    #this coordinate space is occupied, returns true. Otherwise, returns false.
    if @KobjectArray[x / 16][(y + 16) / 16] == true
      return true
    else
      return false
    end
  end

  #Iterates through all enemy objects. If one of them contains the point, it is damaged and the method returns true.
  def enemyContainsPoint?(x, y)
    @DobjectArray.each do |object|
      if object.is_a? Enemy and (object.x + object.width / 2 - x).abs <= object.width / 2 and (object.y - object.height / 2 - y).abs <= object.height / 2
        object.loseHealth
        return true
      end
    end
    return false
  end

  #Draws each individual object in the map by iterating through all tiles.
  def draw
    #Updates the map if necessary.
    update
    #If the level is completed, draws a black screen with text on it. Also returns to prevent uncessary updates.
    if @victory and !@win
      @victoryScreen.draw(0, 0, 0)
      return
    #Same but for if the player wins the game.
    elsif @victory and @win
      @winScreen.draw(0, 0, 0)
      return
    end
    #Draws background image. Note that it is drawn using the modulus operator. This is to ensure that the background "scrolls"
    #through the screen, and does not only go through once. Further, the position is negative, and is offset by 600. This is to
    #make the background move backwards while the player appears to move forwards. The division by 4 creates parallax
    #scrolling, as the background moves at a slower pace than the camera does.
    @background_image.draw(-((camera.camX + 400) / 4 % 1600) + 600, 0, 0)
    #Draws each DYNAMIC object in the map.
    @DobjectArray.each do |object|
      object.draw
    end
    #Draws each PROJECTILE object in the map.
    @PobjectArray.each do |object|
      object.draw
    end
    #Draws each Static object in the map.
    @SobjectArray.each do |object|
      object.draw
    end
    #Draws each EFFECT object in the map.
    @EobjectArray.each do |object|
      object.draw
    end
    #Draws healthbar last.
    @healthBar.draw
    #If the game is fading in/out, a mask draws on the screen to emulate washing in/out.
    if @fadingIn
      @mask.draw(0, 0, 0, 1, 1, getAlphaIn)
    elsif @fadingOut
      @mask.draw(0, 0, 0, 1, 1, getAlphaOut)
    end
  end

  #Updates the map as necessary.
  def update
    #If the map is fading, increments the fade time.
    if @fadingOut or @fadingIn
      @fadeTime += 1
      #After fade time reaches 50, stops fading in/out.
      if @fadeTime > 100
        @fadeTime = 0
        #If fading out, starts fading in immediately afterwards, and respawns the player.
        if @fadingOut
          @fadingOut = false
          @fadingIn = true
          @fadeIn
          @player.respawn
        #Otherwise just stops fading in.
        elsif @fadingIn
          @fadingIn = false
        end
      end
    end
    #Checks for whether the player has won.
    checkVictory
  end

  #Checks if the player is past any of the respawn points. If so, sets the new respawn point.
  def checkRespawn
    @respawnArray.each do |respawn|
      if @player.x > respawn[0] and respawn[0] > respawnX
        @respawnX = respawn[0]
        @respawnY = respawn[1]
      end
    end
  end

  #Checks if the player is currently inside the exit door. If so, starts the victory process.
  def checkVictory
    if @player.x > @exitDoor.x - @exitDoor.width / 2 and @player.x < @exitDoor.x + @exitDoor.width / 2 and @player.y >
      @exitDoor.y - @exitDoor.height / 2 and @player.y < @exitDoor.y + @exitDoor.height / 2
      winGame
    end
  end

  #Sets fading out to true, so that the program knows to draw the mask.
  def fadeOut
    @fadingOut = true
  end

  #Sets fading in to true, so that the program knows to draw the mask.
  def fadeIn
    @fadingIn = true
  end

  #Based on the fade time, this gradually increases the opacity of the mask to create a fading out effect.
  def getAlphaOut
    if @fadeTime < 5
      return 0x11_000000
    elsif @fadeTime < 10
      return 0x22_000000
    elsif @fadeTime < 15
      return 0x33_000000
    elsif @fadeTime < 20
      return 0x44_000000
    elsif @fadeTime < 25
      return 0x55_000000
    elsif @fadeTime < 30
      return 0x66_000000
    elsif @fadeTime < 35
      return 0x77_000000
    elsif @fadeTime < 40
      return 0x88_000000
    elsif @fadeTime < 45
      return 0x99_000000
    elsif @fadeTime < 50
      return 0xaa_000000
    elsif @fadeTime < 55
      return 0xbb_000000
    elsif @fadeTime < 60
      return 0xcc_000000
    elsif @fadeTime < 65
      return 0xdd_000000
    elsif @fadeTime < 70
      return 0xee_000000
    else
      return 0xff_000000
    end
  end
  #Based on the fade time, this gradually decreases the opacity of the mask to create a fading in effect.
  def getAlphaIn
    if @fadeTime < 5
      return 0xff_000000
    elsif @fadeTime < 10
      return 0xee_000000
    elsif @fadeTime < 15
      return 0xdd_000000
    elsif @fadeTime < 20
      return 0xcc_000000
    elsif @fadeTime < 25
      return 0xbb_000000
    elsif @fadeTime < 30
      return 0xaa_000000
    elsif @fadeTime < 35
      return 0x99_000000
    elsif @fadeTime < 40
      return 0x88_000000
    elsif @fadeTime < 45
      return 0x77_000000
    elsif @fadeTime < 50
      return 0x66_000000
    elsif @fadeTime < 55
      return 0x55_000000
    elsif @fadeTime < 60
      return 0x44_000000
    elsif @fadeTime < 65
      return 0x33_000000
    elsif @fadeTime < 70
      return 0x22_000000
    else
      return 0x11_000000
    end
  end

  #Sets victory to true. If on the final level, also sets win to true.
  def winGame
    @victory = true
    if @level == 2
      @win = true
    end
  end

  #Continues to the next level by incrementing the level and then launching the draw from pixmap.
  def continue
    @victory = false
    @level += 1
    drawFromPixmap
  end

  #Restarts the level by launching the draw from pixmap without changing the level.
  def reset
    @victory = false
    @win = false
    drawFromPixmap
  end
end
