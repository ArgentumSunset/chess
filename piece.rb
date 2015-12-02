class Piece
    
    DIMEN = 1000
    MARGIN = DIMEN / 10
    SPACE_DIMEN = (DIMEN - (2 * MARGIN))/8
    
    def initialize(x,y,piece,team,zorder)
        @x = x.to_i
        @y = y.to_i
        @piece = piece
        @team = team
        @image = Gosu::Image.new("imgs/" + piece + "-" + team + ".png")
        @zorder = zorder
	end
    
    def draw
        x = (MARGIN * 2) + (@x * SPACE_DIMEN) - (SPACE_DIMEN / 2.0) - (@image.width / 2.0)
        y = (MARGIN * 2) + (@y * SPACE_DIMEN) - (SPACE_DIMEN / 2.0) - (@image.height / 2.0)
        @image.draw(x,y,@zorder)  
    end
end