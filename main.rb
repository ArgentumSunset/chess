require "gosu"
require_relative "space"
require_relative "piece"

class GameWindow < Gosu::Window

		DIMEN = 1000
		MARGIN = DIMEN / 10
		SPACE_DIMEN = (DIMEN - (2 * MARGIN))/8

		attr_accessor :spaces, :pieces

	def initialize
    super DIMEN, DIMEN
		self.caption = "CHESS MURDER"
		@spaces = []
		@pieces = []
		@i = 0
		@time = Gosu::milliseconds
		@selected_pieces = []
        @team = "white"
        @valid = false
        
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
	end
    
    def needs_cursor?
      true
    end

    def update
        
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
            if @time < Gosu::milliseconds
                @time = Gosu::milliseconds + 500
                spaces.each{|space| 
                    space.unhighlight
        	        if space_mouse_between(space)
        		      @selected_pieces.each{|piece|
        			    piece.take(space)
        			    piece.move(space)
        		      }
        	        end
                }
                if @valid 
                    @team = (@team == "black" ? "white" : "black")
                    @valid = false
                end
            end
        end
        
    	@spaces.each{|space| 
    		space.is_filled = false
    		space.find_piece
            space.color = (space.highlighted ? 0xff2ecc71 : space.stored)
		}

        @pieces.each{|piece|
            piece.checking?
        }
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

	private
		def piece_mouse_between(piece)
			mouse_x.between?(piece.x, piece.x + piece.image.width) && mouse_y.between?(piece.y, piece.y + piece.image.height)
		end

		def space_mouse_between(space)
			mouse_x.between?(space.x, space.x + space.dimen) && mouse_y.between?(space.y, space.y + space.dimen)
		end

end

window = GameWindow.new
window.show
window.spaces.each{|space| puts space.is_filled.to_s + " x: " + space.xpos.to_s + " y: " + space.ypos.to_s}
window.pieces.each{|piece| puts piece.team + " " + piece.piece + " x: " + piece.xpos.to_s + " y: " + piece.ypos.to_s + " Movenum: " + piece.movenum.to_s}