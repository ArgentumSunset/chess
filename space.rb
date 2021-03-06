class Space

	DIMEN = 1000
	MARGIN = DIMEN / 10
	SPACE_DIMEN = (DIMEN - (2 * MARGIN))/8

    attr_accessor :x, :y, :xpos, :ypos, :dimen, :color, :zorder, :is_filled, :is_valid, :team

    def initialize(x,y,dimen,color,zorder,window)
		@x = x
		@y = y
		@xpos = (@x - 100) / 100
		@ypos = (@y - 100) / 100
		@dimen = dimen
		@color = color
    	@zorder = zorder
    	@is_filled = false
    	@window = window
    	@is_valid = false
    	@team = ""
	end

	def draw
    Gosu.draw_line(x, y, color, x + dimen, y, color, zorder)
		Gosu.draw_line(x + dimen, y, color, x + dimen, y + dimen, color, zorder)
		Gosu.draw_line(x + dimen, y + dimen, color, x, y + dimen, color, zorder)
		Gosu.draw_line(x, y + dimen, color, x, y, color, zorder)

		fill_shape(color)
	end

	def validate
		@is_valid = true
	end

	def unvalidate
		@is_valid = false
	end

	def find_piece
		piece = @window.pieces.find{|piece| piece.xpos == @xpos && piece.ypos == @ypos}
		piece != nil ? @is_filled = true : @is_filled = false
		piece != nil ? @team = piece.team : @team = ""
		piece unless piece == nil
	end

	private

	def fill_shape(color)
		for i in 0..dimen
			Gosu.draw_line(x + i, y + dimen, color, x + i, y, color, zorder)
		end
	end

end