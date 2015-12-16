class Piece
    
    DIMEN = 1000
    MARGIN = DIMEN / 10
    SPACE_DIMEN = (DIMEN - (2 * MARGIN))/8

    attr_accessor :xpos, :ypos, :x, :y, :image, :piece, :team, :spaces, :protected_spaces, :movenum, :in_check, :is_checking, :is_protected, :prev_space, :can_block, :mated
    
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
        @false_spaces = []
        @protected_spaces = []
        @prev_space
        @turn = turn
        @in_check = false
        @is_checking = false
        @is_protected = false
        @can_block = false
        @mated = false
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

        @false_spaces.each{|false_space|
                @spaces.each{|space|
                    if false_space.xpos == space.xpos && false_space.ypos == space.ypos
                        @spaces.delete(space) 
                        space.unvalidate
                        space.unhighlight
                    end
                }
        }
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

    def undo_move

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

    def got_to_end?
        side_pos = (team == "white" ? 7 : 0)
        if @ypos == side_pos
            @piece = "queen"
            @movenum = 3
            @image = Gosu::Image.new("imgs/queen-" + @team + ".png")
            @x = (MARGIN * 2) + (@xpos * SPACE_DIMEN) - (SPACE_DIMEN / 2.0) - (@image.width / 2.0)
            @y = (MARGIN * 2) + (@ypos * SPACE_DIMEN) - (SPACE_DIMEN / 2.0) - (@image.height / 2.0)
        end
    end

    def checking?
        king_x = 70
        king_y = 70
        checking = false
        @is_checking = false

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
                @window.pieces.each{|piece| piece.in_check = (piece.piece == "king" && piece.team == king_team ? true : false)}
                @is_checking = true
                checking = true
            end
        }
        @spaces = []
        checking
    end

    def mated?(checking_piece)
        @false_spaces = []
        can_piece_block = false
        checking_piece.validate_moves(false)
        validate_moves(false)

        if @in_check && checking_piece

            @window.pieces.each{|piece|
                can_piece_block = true if piece.can_block?(checking_piece, self) 
            }

            @spaces.each{|space|
                checking_piece.spaces.each{|checking_space|
                    if checking_space.xpos == space.xpos && checking_space.ypos == space.ypos
                        @false_spaces.push(space)
                    end
                }
                if checking_piece.is_protected && space.xpos == checking_piece.xpos && space.ypos == checking_piece.ypos
                    @false_spaces.push(space)
                end
            }

            validate_moves(false)

            @mated = (@spaces.length == 0 && !can_piece_block ? true : false)

        end
    end

    def can_block?(checking_piece, king)  # checks to see if another piece on the checked king's side can block the check
        @can_block = false
        relevant_spaces = []
        validate_moves(false)

        if @movenum == 1 || @movenum == 3
            @spaces.each{|space| 
                casenum = (@xpos > king.xpos ? (@ypos > king.ypos ? 1 : 2) : (@ypos > king.ypos ? 3 : 4)) # gets direction of block for straight pieces
                case casenum
                    when 1
                        relevant_spaces.push(space) if space.xpos < @xpos || space.ypos < @ypos
                    when 2
                        relevant_spaces.push(space) if space.xpos < @xpos || space.ypos > @ypos
                    when 3
                        relevant_spaces.push(space) if space.xpos > @xpos || space.ypos < @ypos
                    when 4
                        relevant_spaces.push(space) if space.xpos > @xpos || space.ypos > @ypos
                end
            }
        end

        if @movenum == 2 || @movenum == 3
            @spaces.each{|space| 
                casenum = (@xpos > king.xpos ? (@ypos > king.ypos ? 1 : 2) : (@ypos > king.ypos ? 3 : 4)) # gets direction of block for diagonal pieces
                case casenum
                    when 1
                        relevant_spaces.push(space) if space.xpos > king.xpos && space.ypos > king.ypos
                    when 2
                        relevant_spaces.push(space) if space.xpos > king.xpos && space.ypos < king.ypos
                    when 3
                        relevant_spaces.push(space) if space.xpos < king.xpos && space.ypos > king.ypos
                    when 4
                        relevant_spaces.push(space) if space.xpos < king.xpos && space.ypos < king.ypos 
                end
            }
        end

        if @movenum == 5 || @movenum == 4
            relevant_spaces += @spaces
        end

        if @team != checking_piece.team && @piece != "king"
            relevant_spaces.each{|space|
                @can_block = true if space.xpos == checking_piece.xpos && space.ypos == checking_piece.ypos
                checking_piece.spaces.each{|checking_space|
                    @can_block = true if checking_space.xpos == space.xpos && checking_space.ypos == space.ypos
                }
            }
            @can_block ? true : false
        else
            false
        end
    end


    private
    
    def validate
        @spaces.each{|space| 
            space.validate
            space.highlight
        }
    end

    def straight_moves(xlim, ylim) # gets moves for rooks, straight parts of queens' paths, and kings
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
                (space.xpos > posx || space.xpos < negx) || (space.is_filled && space.team == team) ? false : @spaces.push(space)
                (space.xpos == posx || space.xpos == negx) && (space.is_filled && space.team == team) && !(space.xpos == @xpos && space.ypos == @ypos) ? @protected_spaces.push(space) : false
            }
            y_array.each{|space|
                space.ypos > posy || space.ypos < negy || (space.is_filled && space.team == team) ? false : @spaces.push(space)
                (space.ypos == posy || space.ypos == negy) && (space.is_filled && space.team == team) && !(space.xpos == @xpos && space.ypos == @ypos) ? @protected_spaces.push(space) : false
            }
    end

    def diagonal_moves(xlim, ylim) # gets moves for bishops, diagonal parts of queens' paths, and kings
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
            (space.xpos > pos1 || space.xpos < neg1) || (space.is_filled && space.team == @team) ? false : @spaces.push(space)
            (space.is_filled && space.team == team && !(space.xpos == @xpos && space.ypos == @ypos)) ? @protected_spaces.push(space) : false        
        }

        arr2.each{|space|
            (space.xpos > pos2 || space.xpos < neg2) || (space.is_filled && space.team == @team) ? false : @spaces.push(space)
            (space.is_filled && space.team == team && !(space.xpos == @xpos && space.ypos == @ypos)) ? @protected_spaces.push(space) : false
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
        @spaces += @window.spaces.select{|space| (space.xpos == @xpos + 1 || space.xpos == @xpos - 1) && space.ypos == take_y && (space.is_filled && space.team != @team)}
    end

    def knight_moves(x,y)
        @window.spaces.each{|space| 
            @spaces.push(space) if is_knight_move(space,x,y) && ( !space.is_filled || space.team != @team)
            @protected_spaces.push(space) if is_knight_move(space,x,y) && space.team == @team && !(space.xpos == @xpos && space.ypos == @ypos)
        }
    end

    def is_knight_move(space,x,y)
        (space.xpos == @xpos + x || space.xpos == @xpos - x) && (space.ypos == @ypos + y || space.ypos == @ypos - y)
    end

end


