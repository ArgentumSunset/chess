class Piece
    
    DIMEN = 1000
    MARGIN = DIMEN / 10
    SPACE_DIMEN = (DIMEN - (2 * MARGIN))/8

    attr_accessor :xpos, :ypos, :x, :y, :image, :piece, :team, :spaces, :movenum
    
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
                straight_moves(1, 1)
            validate
            when 1
                straight_moves(8, 8)
            validate
        end
    end

    def move(space)
        if space.is_valid 
            @xpos = space.xpos
            @ypos = space.ypos
            @x = (MARGIN * 2) + (@xpos * SPACE_DIMEN) - (SPACE_DIMEN / 2.0) - (@image.width / 2.0)
            @y = (MARGIN * 2) + (@ypos * SPACE_DIMEN) - (SPACE_DIMEN / 2.0) - (@image.height / 2.0)
        end
    end

    def take(space)
        piece = space.find_piece
        if piece
            if piece.team != @team
                doomed = piece
                @window.pieces.delete(doomed)
            end
        end
    end

    private
    
    def validate
        @spaces.each{|space| 
            space.highlight
            space.validate
        }
    end

    def straight_moves(xlim, ylim)
            y_array = @window.spaces.select{|space| space.xpos == @xpos && space.ypos.between?(@ypos - ylim, @ypos + ylim)}
            x_array = @window.spaces.select{|space| space.ypos == @ypos && space.ypos.between?(@xpos - ylim, @xpos + ylim)}
            for i in 1...(y_array.length + x_array.length) do
                @spaces[i] = y_array[i]
                @spaces[i + y_array.length] = x_array[i]
            end
    end


end