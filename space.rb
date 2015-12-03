class Space

	DIMEN = 1000
	MARGIN = DIMEN / 10
	SPACE_DIMEN = (DIMEN - (2 * MARGIN))/8

    attr_accessor :x, :y, :xpos, :ypos, :dimen, :color, :stored, :zorder, :highlighted

    def initialize(x,y,xpos,ypos,dimen,color,zorder)
		@x = x
		@y = y
		@xpos = xpos
		@ypos = ypos
		@dimen = dimen
		@color = color
        @stored = color
        @zorder = zorder
        @highlighted = false
	end

	def draw
        Gosu.draw_line(x, y, color, x + dimen, y, color, zorder)
		Gosu.draw_line(x + dimen, y, color, x + dimen, y + dimen, color, zorder)
		Gosu.draw_line(x + dimen, y + dimen, color, x, y + dimen, color, zorder)
		Gosu.draw_line(x, y + dimen, color, x, y, color, zorder)

		fill_shape(color)
	end

	def highlight
		@highlighted = true
	end
    
    def unhighlight
        @highlighted = false
        @color = @stored
	end

	private

	def fill_shape(color)
		for i in 0..dimen
			Gosu.draw_line(x + i, y + dimen, color, x + i, y, color, zorder)
		end
	end

end