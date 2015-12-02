require "gosu"
require_relative "space"
require_relative "piece"

class GameWindow < Gosu::Window

		DIMEN = 1000
		MARGIN = DIMEN / 10
		SPACE_DIMEN = (DIMEN - (2 * MARGIN))/8

	def initialize
    super DIMEN, DIMEN
		self.caption = "CHESS MURDER"
		@spaces = []
		@pieces = []
        
        data = File.read('pieces.txt')
		lines = data.split("\n")

        lines.each{|piece| 
        piece_data = piece.split(' ')
                @pieces.push(Piece.new(piece_data[2],0,piece_data[1],"white",1))
                @pieces.push(Piece.new(piece_data[2],7,piece_data[1],"black",1))
            if piece_data[0].to_i > 1 
                @pieces.push(Piece.new(piece_data[3],0,piece_data[1],"white",1))
                @pieces.push(Piece.new(piece_data[3],7,piece_data[1],"black",1))
            end
            }
	end

	def draw
		for i in 0..7
			for j in 0..7
				i % 2 == 0 ? h = j : h = j + 1
				h % 2 == 0 ? color = 0xffc0392b : color = 0xff2c3e50
				@spaces.push(Space.new(MARGIN + (SPACE_DIMEN * i), MARGIN + (SPACE_DIMEN * j), SPACE_DIMEN, color, 0))
			end
            @pieces.push(Piece.new(i,1,"pawn","white",1))
            @pieces.push(Piece.new(i,6,"pawn","black",1))
		end
		@spaces.each{|space| space.draw}
		@pieces.each{|piece| piece.draw}
	end
    
    def needs_cursor?
        true
    end

	private

end

window = GameWindow.new
window.show