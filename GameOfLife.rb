# Game

class Game
	attr_accessor :world, :spawns

	def initialize(world=World.new, spawns=[])
	  @world = world
	  spawns.each do |spawn|
	    world.cell_grid[spawn[0]][spawn[1]].alive = true
	  end
	end

	def nextgen!
	  next_generation_respawn_cells = []
	  next_generation_kill_cells = []

	  @world.cells.each do |cell|
	  	around = self.world.living_neighborhood(cell).count
	  	# Rule 1: If a cell is alive and has fewer than 2 live neighbors, it dies
	  	 if cell.alive? and around < 2
	  	   next_generation_kill_cells << cell
	  	 end
	  	# Rule 2: If a cell is alive and has more than 3 live neighbors, it dies
	  	 if cell.alive? and around > 3
	  	   next_generation_kill_cells << cell
	  	 end
	  	# Rule 3: If a cell is alive and has 2 or 3 live neighbors, it lives to next generation
	  	 if cell.alive? and ([2,3].include? around)
	  	   next_generation_respawn_cells << cell
	  	 end
	  	# Rule 4: If a cell is dead and has exactly 3 live neighbors, it becomes a live cell
	  	 if cell.dead? and around == 3
	  	   next_generation_respawn_cells << cell
	  	 end

	  	 next_generation_respawn_cells.each do |cell|
	  	 	cell.respawn!
	  	 end

	  	 next_generation_kill_cells.each do |cell|
	  	 	cell.kill!
	  	 end
	  end
	end
end

class Cell
	attr_accessor :xcord, :ycord, :alive, :dead, :kill, :respawn

	def initialize(xcord=0, ycord=0); @xcord = xcord; @ycord = ycord; alive = false;  end
	def alive?; @alive ; end
	def respawn!; @alive = true; end
	def dead?; !alive; end
	def kill!; @alive = false; end
end

class World
	attr_accessor :rows, :cols, :cell_grid, :cells, :living, :deading

	def initialize(rows=3,cols=3)
		@rows = rows
		@cols = cols
		@cells = []

		@cell_grid = Array.new(rows) do |row|
			Array.new(cols) do |col|
				Cell.new(col, row)
			end
		end

		cell_grid.each do |row|
			row.each do |item|
				if item.is_a?(Cell)
				cells << item
				end
			end
		end
	end

	def living; cells.select { |cell| cell.alive}; end

	def instance
	  cells.each do |cell|
	  	cell.alive = [true, false, false, false, false, false, false].sample
		end
	end	

	def living_neighborhood(cell)
	  moore_neighborhood = []

	  #Detects a Neighbor to the North
	  if cell.ycord > 0
	  	detected = self.cell_grid[cell.ycord - 1][cell.xcord]
	  	moore_neighborhood << detected if detected.alive?
	  end

	  #Detects a Neighbor to the North West
	  if cell.ycord > 0 and cell.xcord > 0
	  	detected = self.cell_grid[cell.ycord - 1][cell.xcord - 1]
	  	moore_neighborhood << detected if detected.alive?
	  end

	  #Detects a Neighbor to the North East
	  if cell.ycord > 0 and cell.xcord < (cols - 1 )
	  	detected = self.cell_grid[cell.ycord - 1][cell.xcord + 1]
	  	moore_neighborhood << detected if detected.alive?
	  end

	  #Detects a Neighbor to the South
	  if cell.ycord < (rows - 1)
	  	detected = self.cell_grid[cell.ycord + 1][cell.xcord]
	  	moore_neighborhood << detected if detected.alive?
	  end

	  #Detects a Neighbor to the South West
	  if cell.ycord < (rows - 1) and cell.xcord > 0
	  	detected = self.cell_grid[cell.ycord + 1][cell.xcord - 1]
	  	moore_neighborhood << detected if detected.alive?
	  end

	  #Detects a Neighbor to the South East
	  if cell.ycord < (rows - 1) and cell.xcord < (cols - 1 )
	  	detected = self.cell_grid[cell.ycord + 1][cell.xcord + 1]
	  	moore_neighborhood << detected if detected.alive?
	  end

	  #Detects a Neighbor to the East
	  if cell.xcord < (cols - 1)
	  	detected = self.cell_grid[cell.ycord][cell.xcord + 1]
	  	moore_neighborhood << detected if detected.alive?
	  end

	  #Detects a Neighbor to the West
	  if cell.xcord > 0
	  	detected = self.cell_grid[cell.ycord][cell.xcord - 1]
	  	moore_neighborhood << detected if detected.alive?
	  end

	  moore_neighborhood
	end

end
