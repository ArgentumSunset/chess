class Piece
    
    DIMEN = 1000
    MARGIN = DIMEN / 10
    SPACE_DIMEN = (DIMEN - (2 * MARGIN))/8

    attr_accessor :xpos, :ypos, :x, :y, :image, :piece, :team, :spaces, :movenum
    
    def initialize(x,y,piece,team,zorder,movenum,window,turn)
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
        @turn = turn
	end
    
    def draw
        @image.draw(@x,@y,@zorder)
    end

    def validate_moves
        @spaces = []
        case @movenum
            when 0
                straight_moves(1,1)
                validate
            when 1
                straight_moves(8, 8)
                validate 
            when 2
                diagonal_moves
                validate
            when 3
                straight_moves(8,8)
                diagonal_moves
                validate
            when 4
                knight_moves(2,1)
                knight_moves(1,2)
                validate
            when 5 
                pawn_moves(@turn)
                validate
        end
    end

    def move(space)
        if space.is_valid 
            @xpos = space.xpos
            @ypos = space.ypos
            @x = (MARGIN * 2) + (@xpos * SPACE_DIMEN) - (SPACE_DIMEN / 2.0) - (@image.width / 2.0)
            @y = (MARGIN * 2) + (@ypos * SPACE_DIMEN) - (SPACE_DIMEN / 2.0) - (@image.height / 2.0)
            @turn = 1
        end
    end

    def take(space)
        piece = space.find_piece
        if piece && space.is_valid
            if piece.team != @team
                doomed = piece
                @window.pieces.delete(doomed)
            end
        end
    end

    private
    
    def validate
        @spaces.each{|space| 
            space.validate
            space.highlight
        }
    end

    def straight_moves(xlim, ylim)
            posy = 70
            negy = 0
            posx = 70
            negx = 0
            y_array = @window.spaces.select{|space| space.xpos == @xpos && space.ypos.between?(@ypos - ylim, @ypos + ylim)}
            x_array = @window.spaces.select{|space| space.ypos == @ypos && space.xpos.between?(@xpos - xlim, @xpos + xlim)}
            # x_array.each{|space|
            #     if space.is_filled && space.xpos > @xpos
            #         posx = space.xpos unless posx < space.xpos
            #     elsif space.is_filled && space.xpos < @xpos
            #         negx = space.xpos unless negx > space.xpos
            #     end
            # }

            # y_array.each{|space|
            #     if space.is_filled && space.ypos > @ypos
            #         posy = space.ypos unless posy < space.ypos
            #     elsif space.is_filled && space.ypos < @ypos
            #         negy = space.ypos unless negy > space.ypos
            #     end
            # }

            posx = find(x_array, posx, negx, true)[0]
            negx = find(x_array, posx, negx, true)[1]

            posy = find(y_array, posy, negy, false)[0]
            negy = find(y_array, posy, negy, false)[1]

            x_array.each{|space|
                (space.xpos > posx || space.xpos < negx) || (space.is_filled && space.find_piece.team == team) ? false : @spaces.push(space)
            }
            y_array.each{|space|
                space.ypos > posy || space.ypos < negy || (space.is_filled && space.find_piece.team == team) ? false : @spaces.push(space)
            }
    end

    def diagonal_moves
        arr1 = []
        arr2 = []
        pos2 = 70
        neg2 = 0
        pos1 = 70
        neg1 = 0
        @window.spaces.each{|space| 
            diagonal_calculate(1,1,space,arr1)
            diagonal_calculate(-1,1,space,arr2)
            diagonal_calculate(1,-1,space,arr2)
            diagonal_calculate(-1,-1,space,arr1)
        }
        pos1 = find(arr1, pos1, neg1, true)[0]
        neg1 = find(arr1, pos1, neg1, true)[1]

        pos2 = find(arr2, pos2, neg2, true)[0]
        neg2 = find(arr2, pos2, neg2, true)[1]

        arr1.each{|space|
            (space.xpos > pos1 || space.xpos < neg1) || (space.is_filled && space.find_piece.team == team) ? false : @spaces.push(space)
        }

        arr2.each{|space|
            (space.xpos > pos2 || space.xpos < neg2) || (space.is_filled && space.find_piece.team == team) ? false : @spaces.push(space)
        }
    end

    def diagonal_calculate(int1, int2, space, arr)
        for i in 0..7
            if space.xpos == @xpos + (int1 * i) && space.ypos == @ypos + (int2 * i)
                arr.push(space)
            end
        end
    end

    def find(arr, pos, neg, is_x)
        arr.each{|space|
            space_pos = (is_x ? space.xpos : space.ypos)
            this_pos = (is_x ? @xpos : @ypos)
            if space.is_filled && space_pos > this_pos
                pos = space_pos unless pos < space_pos
            elsif space.is_filled && space_pos < this_pos
                neg = space_pos unless neg > space_pos
            end
        }
        return [pos,neg]
    end

    def pawn_moves(num)
        x = (@team == 'black' ? @ypos - num : @ypos)
        y = (@team == 'black' ? @ypos : @ypos + num)
        @spaces += @window.spaces.select{|space| (space.xpos == @xpos && space.ypos.between?(x, y)) && !space.is_filled}
    end

    def knight_moves(x,y)
        @spaces += @window.spaces.select{|space| (space.xpos == @xpos + x || space.xpos == @xpos - x) && (space.ypos == @ypos + y || space.ypos == @ypos - y) && ( !space.is_filled || space.find_piece.team != @team)}
    end

end


