require "gosu"
require_relative "space"
require_relative "piece"

class GameWindow < Gosu::Window

		DIMEN = 1000
		MARGIN = DIMEN / 10
		SPACE_DIMEN = (DIMEN - (2 * MARGIN))/8

		attr_accessor :spaces, :pieces, :checkmated

	def initialize
    super DIMEN, DIMEN
		self.caption = "CHESS MURDER"
		@spaces = []
		@pieces = []
		@i = 0
		@time = Gosu::milliseconds
        @time2 = Gosu::milliseconds
		@selected_pieces = []
        @is_checked = ""
        @team = "white"
        @valid = false
        @turn_display = Gosu::Font.new(40)
        @check_display = Gosu::Font.new(40)
        @mated_display = Gosu::Font.new(40)
        @checked_team = ""
        @mated_team = ""
        @winning_team = ""
        @checkmated = false
        
        data = File.read('pieces.txt')
				lines = data.split("\n")

        lines.each{|piece| 
        piece_data = piece.split(' ')
        	if piece_data[0].to_i == 1
                @pieces.push(Piece.new(piece_data[2],0,piece_data[1],"white",2,piece_data[3],self,1))
                @pieces.push(Piece.new(piece_data[2],7,piece_data[1],"black",2,piece_data[3],self,1))
            else
            	@pieces.push(Piece.new(piece_data[2],0,piece_data[1],"white",2,piece_data[4],self,1))
                @pieces.push(Piece.new(piece_data[2],7,piece_data[1],"black",2,piece_data[4],self,1))
                @pieces.push(Piece.new(piece_data[3],0,piece_data[1],"white",2,piece_data[4],self,1))
                @pieces.push(Piece.new(piece_data[3],7,piece_data[1],"black",2,piece_data[4],self,1))
            end
            }
	end

	def draw
		if @i == 0
			draw_all_spaces
		end
        @spaces.each{|space| space.draw}
		@pieces.each{|piece| piece.draw}
		@i += 1
        @turn_display.draw("#{capitalize(@team)}'s turn", 405, 30, 2, 1.0, 1.0, 0xff_ecf0f1)
        @check_display.draw(@is_checked, 310, 930, 2, 1.0, 1.0, 0xff_ecf0f1)
        if @checkmated
            @mated_display.draw("#{capitalize(@winning_team)} has won!", 370, 930, 2, 1.0, 1.0, 0xff_ecf0f1)
        end
	end
    
    def needs_cursor?
      true
    end

    def update
    if !@checkmated

        @pieces.each{|piece|
                piece.is_protected = false
                is_protected(piece)
        }
        
        if Gosu::button_down? Gosu::MsLeft
            @selected_pieces = []
            @spaces.each{|space| 
            	space.unvalidate
                space.unhighlight
            }
    	    @pieces.each{|piece|
    	   	   if piece_mouse_between(piece)
                    if piece.team == @team
                        piece.validate_moves(true)
    			        @selected_pieces.push(piece)
                        @valid = true
                    end
    		   end
    		}
    	end

    	if Gosu::button_down? Gosu::MsRight 
            if @time < Gosu::milliseconds && @valid
                @time = Gosu::milliseconds + 200
                spaces.each{|space| 
                    space.unhighlight
        	        if space_mouse_between(space) && space.is_valid
        		      @selected_pieces.each{|piece|
        			    piece.take(space)
        			    piece.move(space)

                        if space.is_valid
                            @team = (@team == "black" ? "white" : "black")
                            @team_final = @team.split.map(&:capitalize).join(' ')
                            @valid = false
                        end
        		      }
        	        end
                }
            end
        end

        checking
     
    	@spaces.each{|space| 
    		space.is_filled = false
    		space.find_piece
            space.color = (space.highlighted ? 0xff2ecc71 : space.stored)
		}

        king = @pieces.find{|checked_king| checked_king.in_check}

        @pieces.each{|piece|
            checking_piece = true if piece.is_checking
            if checking_piece
                king.mated?(piece)
            end
        }

        @checkmated = true if king.mated unless king == nil
        @mated_team = (king.mated ? king.team : "") unless king == nil
        @winning_team = (@mated_team == "black" ? "white" : "black") unless @mated_team == ""

    else
        @is_checked = ""
    end
    end

	private

	def draw_all_spaces
		for i in 0..7
			for j in 0..7
				i % 2 == 0 ? h = j : h = j + 1
				h % 2 == 0 ? color = 0xffc0392b : color = 0xff2c3e50
				@spaces.push(Space.new(MARGIN + (SPACE_DIMEN * i), MARGIN + (SPACE_DIMEN * j), SPACE_DIMEN, color, 0, self))
			end
            @pieces.push(Piece.new(i,1,"pawn","white",2,5,self,2))
            @pieces.push(Piece.new(i,6,"pawn","black",2,5,self,2))
		end
	end

		def piece_mouse_between(piece)
			mouse_x.between?(piece.x, piece.x + piece.image.width) && mouse_y.between?(piece.y, piece.y + piece.image.height)
		end

		def space_mouse_between(space)
			mouse_x.between?(space.x, space.x + space.dimen) && mouse_y.between?(space.y, space.y + space.dimen)
		end

        def capitalize(str)
            str.split.map(&:capitalize).join(' ')
        end

        def is_protected(piece)
            @pieces.each{|protector| protector.protected_spaces.each{|space|
                if space.xpos == piece.xpos && space.ypos == piece.ypos && protector.team == piece.team
                    piece.is_protected = true 
                end
            }}
        end

        def checking
            @is_checked = ""
            @pieces.each{|piece|
            if piece.checking? && @mated_team == ""
                @checked_team = (piece.team == "black" ? "white" : "black")
                @is_checked = "#{capitalize(@checked_team)}'s king is in check!"
            end
            }
        end

end

window = GameWindow.new
window.show
window.pieces.each{|piece| 
    piece.validate_moves(false)
    puts piece.team + " " + piece.piece + " Checking: " + piece.is_checking.to_s + " Can Block: " + piece.can_block.to_s + " Protected: " + piece.is_protected.to_s + " X: " + piece.xpos.to_s + " Y: " + piece.ypos.to_s
}
puts window.checkmated

