#This MapObject class is the superclass of every dynamic and static map object in the game. This includes the player, enemies,
#and blocks. It draws the image of all the objects, and contains the width, height, and coordinates of the object.
class MapObject
  attr_accessor :x
  attr_accessor :y
  attr_accessor :width
  attr_accessor :height

  def initialize(x, y, image, map)
    @image = image
    @map = map
    @width = image.width
    @height = image.height
    @spawnX = @x = x
    @spawnY = @y = y
    @GRAVITY = -2
    @angle = 0
    @color = 0xff_ffffff
    #The original color for the map object. Used if the map object temporarily acquires a different color.
    @pColor = 0xff_ffffff
    #The scales for the image. Used for flipping the image if neccessary.
    @scaleX = 1
    @scaleY = 1
  end
  #Draws the object's image.
  def draw
    #Checks if this map object is in view of the camera and not the player. If so, draws self. Note that there are two camera
    #in view methods being launched. This is because if the camera is travelling forwards or backwards, the front or the back
    #of the object respectively determines whether it is drawn.
    if (@map.camera.isInView?(@x + @width) or @map.camera.isInView?(@x - @width)) and !self.is_a? Player
      update
      @image.draw_rot(@map.camera.translateX(@x), @y, 0, @angle * 180 / Math::PI, 0.5, 0.5, @scaleX, @scaleY, @color)
    #Removes itself if it is a projectile and outside the camera bounds.
    elsif self.is_a? Projectile
      @map.PobjectArray.delete(self)
    elsif self.is_a? Effect
      @map.EobjectArray.delete(self)
    #If this map object is the player, draws itself no matter what.
    elsif self.is_a? Player
      update
      @image.draw_rot(@map.camera.width / 2, @y, 0, @angle * 180 / Math::PI, 0.5, 0.5, 1, 1, @color)
    end
  end
  #This method is overidden if used.
  def update

  end
end
