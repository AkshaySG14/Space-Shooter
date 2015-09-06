#This class determines whether an object will be drawn, and more importantly where it will be drawn.
class Camera
  attr_accessor :camX
  attr_accessor :camY
  attr_accessor :width
  attr_accessor :height
  #camX and camY comprise the position of the camera, which determines what is drawn on the screen and where.
  def initialize(x, y)
    @camX = x
    @camY = y
    @width = 600
    @height = 400
  end
  #This draws the given sprite at a point on the camera that it may be seen. This is to simulate the screen moving, when in
  #fact the screen stays still and the game moves around it.
  def translateX(x)
    return x - @camX
  end
  #If the object is in view of the camera, draws it. Otherwise, does not.
  def isInView?(x)
    if x + 8 > @camX and x + 8 < @camX + @width
      return true
    else
      return false
    end
  end

  def update(pX)
    @camX = pX - @width / 2
  end
end
