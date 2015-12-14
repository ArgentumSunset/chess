class Piece
    
    DIMEN = 1000
    MARGIN = DIMEN / 10
    SPACE_DIMEN = (DIMEN - (2 * MARGIN))/8

    attr_accessor :xpos, :ypos, :x, :y, :image, :piece, :team, :spaces, :movenum, :in_check
    
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
        @in_check = false
	end
    
    def draw
        @image.draw(@x,@y,@zorder)
    end

    def validate_moves(will_validate)
        @spaces = []
        case @movenum
            when 0
                straight_moves(1,1)
                diagonal_moves(1,1)
                validate if will_validate
            when 1
                straight_moves(8, 8)
                validate if will_validate 
            when 2
                diagonal_moves(8,8)
                validate if will_validate
            when 3
                straight_moves(8,8)
                diagonal_moves(8,8)
                validate if will_validate
            when 4
                knight_moves(2,1)
                knight_moves(1,2)
                validate if will_validate
            when 5 
                pawn_moves(@turn)
                validate if will_validate
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

    def checking?
        king_x = 70
        king_y = 70
        checking = false

        validate_moves(false)

        @window.pieces.each{|piece|
            if piece.piece == "king" && piece.team != @team
                king_x = piece.xpos
                king_y = piece.ypos
            end
        }
        @spaces.each{|space|
            if space.xpos == king_x && space.ypos == king_y
                king_team = (@team == "white" ? "black" : "white")
                puts "The " + king_team + " king is in check"
                @window.pieces.each{|piece| piece.in_check = (piece.piece == "king" && piece.team == king_team ? true : false)}
                checking = true
            end
        }
        @spaces = []
        checking
    end

    def mated?
        if @in_check
            validate_moves(false)
            @spaces.each{|space|
                if space.is_filled
                    if space.find_piece.team != @team
                        @spaces.delete(space)
                        true
                    end
                end
            }
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

    def diagonal_moves(xlim, ylim)
        arr1 = []
        arr2 = []
        pos2 = 70
        neg2 = 0
        pos1 = 70
        neg1 = 0
        @window.spaces.each{|space| 
            diagonal_calculate(1,1,space,arr1,xlim,ylim)
            diagonal_calculate(-1,1,space,arr2,xlim,ylim)
            diagonal_calculate(1,-1,space,arr2,xlim,ylim)
            diagonal_calculate(-1,-1,space,arr1,xlim,ylim)
        }
        pos1 = find(arr1, pos1, neg1, true)[0]
        neg1 = find(arr1, pos1, neg1, true)[1]

        pos2 = find(arr2, pos2, neg2, true)[0]
        neg2 = find(arr2, pos2, neg2, true)[1]

        arr1.each{|space|
            (space.xpos > pos1 || space.xpos < neg1) || (space.is_filled && space.find_piece.team == @team) ? false : @spaces.push(space)
        }

        arr2.each{|space|
            (space.xpos > pos2 || space.xpos < neg2) || (space.is_filled && space.find_piece.team == @team) ? false : @spaces.push(space)
        }
    end

    def diagonal_calculate(int1, int2, space, arr, xlim, ylim)
        x1 = (int1 == 1 ? @xpos : @xpos - xlim)
        x2 = (int1 == 1 ? @xpos + xlim : @xpos)
        y1 = (int2 == 1 ? @ypos : @ypos - ylim)
        y2 = (int2 == 1 ? @ypos + ylim : @ypos)
        for i in 0..7
            if space.xpos == @xpos + (int1 * i) && space.ypos == @ypos + (int2 * i) && space.xpos.between?(x1,x2) && space.ypos.between?(y1,y2)
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
        take_y = (@team == 'black' ? @ypos - 1 : @ypos + 1)
        @spaces += @window.spaces.select{|space| (space.xpos == @xpos && space.ypos.between?(x, y)) && !space.is_filled}
        @spaces += @window.spaces.select{|space| (space.xpos == @xpos + 1 || space.xpos == @xpos - 1) && space.ypos == take_y && (space.is_filled && space.find_piece.team != @team)}
    end

    def knight_moves(x,y)
        @spaces += @window.spaces.select{|space| (space.xpos == @xpos + x || space.xpos == @xpos - x) && (space.ypos == @ypos + y || space.ypos == @ypos - y) && ( !space.is_filled || space.find_piece.team != @team)}
    end

end


