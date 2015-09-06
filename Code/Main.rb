require 'gosu'
require_relative 'Player'
require_relative 'Map'
require_relative 'InputController'
#Creates the window responsible for drawing the game. This is what the player sees in-game.
class GameWindow < Gosu::Window
  def initialize
    #Width and height of the window.
    super 600, 400
    #Caption of the window.
    self.caption = "Space Shooter"
    #Pixelmap responsible for the creation of all objects.
    @map = Map::Map.new(self)
    #Input controller that registers any key presses.
    @controller = InputController::InputController.new(@map, self)
  end

  def update
  end

  #If the user presses a button, responds accordingly.
  def button_down(id)
    @controller.respond(id)
  end

  #Draws the background image as well as the objects of the map.
  def draw
    @map.draw
  end
end

window = GameWindow.new
window.show
