class Piece
    
    DIMEN = 1000
    MARGIN = DIMEN / 10
    SPACE_DIMEN = (DIMEN - (2 * MARGIN))/8

    attr_accessor :xpos, :ypos, :x, :y, :image, :piece, :team
    
    def initialize(x,y,piece,team,zorder,movenum,window)
        @xpos = x
        @ypos = y
        @piece = piece
        @team = team
        @movenum = movenum
        @image = Gosu::Image.new("imgs/" + piece + "-" + team + ".png")
        @x = (MARGIN * 2) + (@xpos.to_i * SPACE_DIMEN) - (SPACE_DIMEN / 2.0) - (@image.width / 2.0)
        @y = (MARGIN * 2) + (@ypos.to_i * SPACE_DIMEN) - (SPACE_DIMEN / 2.0) - (@image.height / 2.0)
        @zorder = zorder
        @window = window
        @spaces = []
	end
    
    def draw
        @image.draw(@x,@y,@zorder)
    end

    def validate_moves
        case @movenum
        when 0
            @spaces = @window.spaces.select{|space| 
            space.xpos.between(@xpos - 1, @xpos + 1) && space.ypos.between(@ypos - 1, @ypos + 1)
            }
            validate
        when 1
            puts @xpos.to_s
        when 2
            puts @xpos.to_s
        when 3
            puts @xpos.to_s
            puts @xpos.to_s
        when 4
            puts @xpos.to_s
        when 5
            puts @xpos.to_s
        end
    end



    private

    def validate
        @spaces.each{|space| space.highlight}
        puts @spaces
    end

end