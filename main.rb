require "gosu"
require_relative "space"
require_relative "piece"

class GameWindow < Gosu::Window

		DIMEN = 1000
		MARGIN = 100
		SPACE_DIMEN = (DIMEN - (2 * MARGIN))/8

	def initialize
    super DIMEN, DIMEN
		self.caption = "CHESS MURDER"
		@spaces = []
		@pieces = []
	end

	def draw
		for i in 0..7
			for j in 0..7
				i % 2 == 0 ? h = j : h = j + 1
				h % 2 == 0 ? color = 0xffc0392b : color = 0xff2c3e50
				@spaces.push(Space.new(MARGIN + (SPACE_DIMEN * i), MARGIN + (SPACE_DIMEN * j), SPACE_DIMEN, color))
			end
		end
		@spaces.each{|space| space.draw_shape}
		@pieces.each{|piece| piece.draw_shape}
	end

	private

end

window = GameWindow.new
window.show