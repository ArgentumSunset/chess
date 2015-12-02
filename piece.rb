class Piece
    
    DIMEN = 1000
    MARGIN = DIMEN / 10
    SPACE_DIMEN = (DIMEN - (2 * MARGIN))/8
    
    def initialize(x,y,piece,team,zorder,movenum,window)
        @x = x.to_i
        @y = y.to_i
        @piece = piece
        @team = team
        @movenum = movenum
        @image = Gosu::Image.new("imgs/" + piece + "-" + team + ".png")
        @xpos = (MARGIN * 2) + (@x * SPACE_DIMEN) - (SPACE_DIMEN / 2.0) - (@image.width / 2.0)
        @ypos = (MARGIN * 2) + (@y * SPACE_DIMEN) - (SPACE_DIMEN / 2.0) - (@image.height / 2.0)
        @zorder = zorder
        @window = window
        @spaces = []
	end
    
    def draw
        @image.draw(@xpos,@ypos,@zorder)
    end

    def validate_moves
        case @movenum
        when 0
            @spaces = @window.spaces.select{|space| 
            space.xpos.between(@xpos - 1, @xpos + 1) && space.ypos.between(@ypos - 1, @ypos + 1)
            }
        when 1
            validate_move
        when 2
            validate_move
        when 3
            validate_move
            validate_move
        when 4
            validate_move
        when 5
            validate_move
        end
    end



    private

    def validate
        @spaces.each{|space| space.highlight}
    end

end