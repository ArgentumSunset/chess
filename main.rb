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
        
        data = File.read('pieces.txt')
		lines = data.split("\n")

        lines.each{|piece| 
        piece_data = piece.split(' ')
                @pieces.push(Piece.new(piece_data[2],0,piece_data[1],"white",2,piece_data[3],self))
                @pieces.push(Piece.new(piece_data[2],7,piece_data[1],"black",2,piece_data[3],self))
            if piece_data[0].to_i > 1 
                @pieces.push(Piece.new(piece_data[3],0,piece_data[1],"white",2,piece_data[4],self))
                @pieces.push(Piece.new(piece_data[3],7,piece_data[1],"black",2,piece_data[4],self))
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
    		@pieces.each{|piece|
    			if mouse_x.between?(piece.x, piece.x + piece.image.width) && mouse_y.between?(piece.y, piece.y + piece.image.height)
    				piece.validate_moves
    			end
    		}
    	end
        if Gosu::button_down? Gosu::MsRight
            @spaces.each{|space| space.unhighlight}
        end
    	@spaces.each{|space| 
			if space.highlighted
				space.color = Gosu::Color.argb(0xff_2ecc71)
			end
		}
    end

	private

	def draw_all_spaces
		for i in 0..7
			for j in 0..7
				i % 2 == 0 ? h = j : h = j + 1
				h % 2 == 0 ? color = Gosu::Color.argb(0xff_c0392b) : color = Gosu::Color.argb(0xff_2c3e50)
				@spaces.push(Space.new(MARGIN + (SPACE_DIMEN * i), MARGIN + (SPACE_DIMEN * j), i, j, SPACE_DIMEN, color, 0))
			end
            @pieces.push(Piece.new(i,1,"pawn","white",2,5,self))
            @pieces.push(Piece.new(i,6,"pawn","black",2,5,self))
		end
	end

end

window = GameWindow.new
window.show