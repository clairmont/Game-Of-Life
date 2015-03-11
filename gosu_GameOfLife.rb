# Gosu
require 'gosu'
require_relative 'GameOfLife.rb'

class GameOfLife < Gosu::Window
	def needs_cursor?; true; end
	def update; @game.nextgen!; @gen += 1; puts "Game of Life Generation # #{@gen}"; end
	def initialize(height=800, width=600)
		@height = height
		@width = width
		super height, width, false
		self.caption = "Gosu Game of Life"


		@background_color = Gosu::Color.new(0xff808080)
		@alive_color = @randalive
		@dead_color = Gosu::Color.new(0xFF47CFF5)

		

		@columns = @width/10
		@column_width = @width/@columns
		@rows = @height/10
		@rows_height = @height/@rows
		
		@world = World.new(@columns, @rows)
		@game = Game.new(@world)
		@gen = 0
		@game.world.instance
	end
	def draw
		@randalive = [     Gosu::Color.argb(0xffff0000),    Gosu::Color.argb(0xffffff00),     Gosu::Color.argb(0xffff00ff),     Gosu::Color.argb(0xff00ffff),     Gosu::Color.argb(0xff00ff00)].sample
		@randadead = [         Gosu::Color.argb(0xff000000)].sample
	  	draw_quad(0, 0, @background_color,
	  			width, 0, @background_color,
	  			width, height, @background_color,
	  			0, height, @background_color)
	  	#Cell Alive / Dead
	  	@game.world.cells.each do |cell|
	      if cell.alive?
	        draw_quad(cell.xcord * @column_width, cell.ycord * @rows_height, @randalive,
	      			cell.xcord * @column_width + (@column_width - 1), cell.ycord * @rows_height, @randalive,
	      			cell.xcord * @column_width + (@column_width - 1), cell.ycord * @rows_height + (@rows_height -1), @randalive,
	      			cell.xcord * @column_width, cell.ycord * @rows_height + (@rows_height-1), @randalive)
	      else
	        draw_quad(cell.xcord * @column_width, cell.ycord * @rows_height, @randadead,
	      			cell.xcord * @column_width + (@column_width -1), cell.ycord * @rows_height, @randadead,
	      			cell.xcord * @column_width + (@column_width -1), cell.ycord * @rows_height + (@rows_height - 1), @randadead,
	      			cell.xcord * @column_width, cell.ycord * @rows_height + (@rows_height - 1), @randadead)
	    end	
	  end
	end
end

GameOfLife.new.show
