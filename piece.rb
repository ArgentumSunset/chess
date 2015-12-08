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
            @spaces = @window.spaces.select{|space| 
                team = (space.find_piece ? space.find_piece.team : false)
                straight_moves(team, space, 1, 1)
            }
            validate
            when 1
                puts "Hello! Your moves are: " + @spaces.to_s
                @spaces = @window.spaces.select{|space|
                team = (space.find_piece ? space.find_piece.team : false)
                straight_moves(team, space, 8, 8)
                
            }
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

    def straight_moves(team, space, xlim, ylim)
        ((space.xpos == @xpos && space.ypos.between?(@ypos - ylim, @ypos + ylim)) ||
        (space.ypos == @ypos && space.xpos.between?(@xpos - xlim, @xpos + xlim))) && 
        (team != @team || !space.is_filled)
    end

end