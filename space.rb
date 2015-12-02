class Space

	attr_accessor :x, :y, :dimen, :color, :zorder

    def initialize(x,y,dimen,color,zorder)
		@x = x
		@y = y
		@dimen = dimen
		@color = color
        @zorder = zorder
	end

	def draw
		Gosu.draw_line(x, y, color, x + dimen, y, color, zorder)
		Gosu.draw_line(x + dimen, y, color, x + dimen, y + dimen, color, zorder)
		Gosu.draw_line(x + dimen, y + dimen, color, x, y + dimen, color, zorder)
		Gosu.draw_line(x, y + dimen, color, x, y, color, zorder)

		fill_shape(color)
	end

	private

	def fill_shape(color)
		for i in 0..dimen
			Gosu.draw_line(x + i, y + dimen, color, x + i, y, color, zorder)
		end
	end
end