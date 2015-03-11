#MiniTests
require 'rubygems'
gem 'minitest'
require 'minitest/autorun'
require_relative 'GameOfLife.rb'

### World #################################################P
    class WorldTest < Minitest::Test
      def setup
        @world = World.new
      end
      def test_WorldResponses
        assert_respond_to @world, :rows
        assert_respond_to @world, :cols
        assert_respond_to @world, :cell_grid
        assert_respond_to @world, :cells
      end
      def test_WorldGridCreate #Create a cell grid on initialize
        assert @world.cell_grid.is_a?(Array)
          @world.cell_grid.each do |row|
            assert row.is_a?(Array)
            assert row.each do |col|
              assert col.is_a?(Cell)
            end
      end
      def test_WorldCellCount #Test World Cell Count
        assert @world.cells.count == 9
      end
      def test_WorldInstance #Randomly populate the world
        assert @world.living.count == 0
        @world.instance
        refute @world.living.count == 0 
      end
    end
### Cell #################################
    class CellTest < Minitest::Test
      def setup
        @cell = Cell.new(1,1)
      end
      def test_Cell
        #Create a new cell object
        assert @cell.is_a?(Cell)
        #Respond to methods
        assert_respond_to @cell, :alive
        assert_respond_to @cell, :xcord
        assert_respond_to @cell, :ycord
        assert_respond_to @cell, :alive?
        assert_respond_to @cell, :kill
        #Test Cell Coordinate
        refute @cell.alive
        assert @cell.xcord == 1
        assert @cell.ycord == 1
      end
    end
### Game  #################################
    class GameTest < Minitest::Test
      def setup
        @cell = Cell.new(1,1)
        @world = World.new
        @game = Game.new(@world, [[1, 1], [2,0]])
      end
      def test_Game
        #Create a New Game
        assert @game.is_a?(Game)
        #Respond to methods
        assert_respond_to @game, :world
        assert_respond_to @game, :spawns
        #Initialize
        assert @world.is_a?(World)
        assert @world.cell_grid.is_a?(Array)
        #Check Spawns
        assert @world.cell_grid[1][1].alive
        assert @world.cell_grid[2][0].alive
      end
    end
### Rules  #################################################
    class RulesTest < Minitest::Test
      def setup
        @world = World.new
      end
      def test_Rule_01 # Rule 1: If a cell is alive and has fewer than 2 live neighbors, it dies
       	#Kills a live cell with 0 live neighbors
        world = World.new
        game = Game.new(world, [[1, 1]])
        assert world.cell_grid[1][1].alive
       	game.nextgen!
        assert world.cell_grid[1][1].dead?
       	#Kills a live cell with 1 live neighbor
       	game = Game.new(world, [[1, 0], [2, 0]])
       	game.nextgen!
        assert world.cell_grid[1][0].dead?
        assert world.cell_grid[2][0].dead? 
        #Does not kill a live cell with 2 live neighbors
       	game = Game.new(world, [[2, 1], [1, 1], [2, 2]])
       	game.nextgen!
        assert world.cell_grid[1][1].alive
        assert world.cell_grid[2][1].alive
        assert world.cell_grid[2][2].alive
      end
      def test_Rule_02 # Rule 2: If a cell is alive and has more than 3 live neighbors, it dies
        world = World.new
        game = Game.new(world, [[0, 1], [1, 1], [2, 1], [2, 2], [1, 2]])
        assert_equal 4, world.living_neighborhood(world.cell_grid[1][1]).count
       	game.nextgen!
       	assert world.cell_grid[0][1].alive?
        assert world.cell_grid[1][1].dead?
        assert world.cell_grid[2][1].alive
        assert world.cell_grid[2][2].dead?
        assert world.cell_grid[1][2].dead?
      end
      def test_Rule_03 # Rule 3: If a cell is alive and has 2 or 3 live neighbors, it lives to next generation
        world = World.new
       	game = Game.new(world, [[0, 1], [1, 1], [2, 1], [2, 2]])
        assert_equal 3, world.living_neighborhood(world.cell_grid[1][1]).count
       	game.nextgen!
       	assert world.cell_grid[0][1].dead?
        assert world.cell_grid[1][1].alive
        assert world.cell_grid[2][1].alive
       	assert world.cell_grid[2][2].alive
      end
      def test_04 # Rule 4: If a cell is dead and has exactly 3 live neighbors, it becomes a live cell
        world = World.new
        game = Game.new(world, [[0, 0], [0, 1], [1, 0], [1, 1]])
       	assert_equal 3, world.living_neighborhood(world.cell_grid[1][1]).count
       	game.nextgen!
        assert world.cell_grid[0][1].alive
        assert world.cell_grid[0][0].alive
      end   		
    end
end