require 'gosu'
require_relative 'Player'
require_relative 'Map'

class InputController
  def initialize(map, window)
    @map = map
    @window = window
  end

  #Passes the id of the key pressed/button clicked to the player class.
  def respond(id)
    case id
    #W causes the player to jump.
    when Gosu::KbW
      @map.player.decideJump
    #J causes the player to jump.
    when Gosu::KbJ
      @map.player.shoot
    #C when the current level is completed causes the game to continue to the next level.
    when Gosu::KbC
      if @map.victory and !@map.win
        @map.continue
      end
    #B when the current level is completed causes the game to replay the current level.
    when Gosu::KbB
      if @map.victory
        @map.reset
      end
    #E when the game is complete causes the game to exit.
    when Gosu::KbE
      if @map.win
        @window.close
      end
    end
  end

end
