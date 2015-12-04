class Piece
    
    DIMEN = 1000
    MARGIN = DIMEN / 10
    SPACE_DIMEN = (DIMEN - (2 * MARGIN))/8

    attr_accessor :xpos, :ypos, :x, :y, :image, :piece, :team, :spaces
    
    def initialize(x,y,piece,team,zorder,movenum,window)
        @xpos = x.to_i
        @ypos = y.to_i
        @piece = piece
        @team = team
        @movenum = movenum.to_i
        @image = Gosu::Image.new("imgs/" + piece + "-" + team + ".png")
        @x = (MARGIN * 2) + (@xpos * SPACE_DIMEN) - (SPACE_DIMEN / 2.0) - (@image.width / 2.0)
        @y = (MARGIN * 2) + (@ypos * SPACE_DIMEN) - (SPACE_DIMEN / 2.0) - (@image.height / 2.0)
        @zorder = zorder
        @window = window
        @spaces = []
	end
    
    def draw
        @image.draw(@x,@y,@zorder)
    end

    def validate_moves
        @spaces = []
        case @movenum 
            when 5
            @spaces = @window.spaces.select{|space| 
                (space.xpos == @xpos && space.ypos.between?(@ypos - 1, @ypos + 1)) ||
                (space.ypos == @ypos && space.xpos.between?(@xpos - 1, @xpos + 1))
            }
            validate
        end
    end

    def move(space)
        @xpos = space.xpos
        @ypos = space.ypos
    end

    private
    
    def validate
        @spaces.each{|space| space.highlight unless space.is_filled}
    end

end