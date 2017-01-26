require 'colorize'

class Board
  attr_reader :grid, :current_player, :height, :width
  def initialize
    @height = 6
    @width = 7
    @grid = @height.times.map {|i| @width.times.map {0}}
    @current_player = 0
    #mainloop
  end

  def is_valid? column
    return false unless column.ord >=48 && column.ord <= 55
    return false unless @grid[0][column.to_i-1] == 0
    true
  end

  def get_input
    column_attempt = ""
    loop do
      puts "Please enter the column you want to put a disc in."
      column_attempt = gets.chomp
      break if is_valid? column_attempt
      puts "Invalid input."
    end
    column_attempt.to_i - 1
  end

  def place_disc column
    (@height-1).downto(0) do |i|
      if @grid[i][column] == 0
        @grid[i][column] = (@current_player+1)
        break
      end
    end
  end

  def prompt_for_move
    place_disc get_input
  end

  def draw?
    draw = true
    @height.times do |r|
      @width.times do |c|
        draw = false if @grid[r][c] == 0
      end
    end
    draw
  end

  def horizontal_win?
    @height.times do |row|
      in_a_row = 1
      last = 0
      (@width-1).downto(0) do |column|
        square = @grid[row][column]
        in_a_row += 1 if square == last && last != 0
        last = square
        return true if in_a_row >= 4
      end
    end
    false
  end

  def vertical_win?
    @width.times do |column|
      in_a_row = 1
      last = 0
      (@height-1).downto(0) do |row|
        square = @grid[row][column]
        in_a_row += 1 if square == last && last != 0
        last = square
        return true if in_a_row >= 4
      end
    end
    false
  end

  def forms_diag(coords, forward)
    row = coords[0]
    col = coords[1]
    if forward
      delta_co = 1
    else
      delta_co = -1
    end
    first = @grid[row][col]
    return false if first == 0
    (1..3).each do |delta|
      return false if @grid[row+delta][col+delta*delta_co] != first
    end
    true
  end

  def up_diagonal_win?
    #take squares from upper right
    (@height-3).times do |row|
      (@width-1).downto(3) do |col|
        return true if forms_diag([row, col], false)
      end
    end
    false
  end

  def down_diagonal_win?
    #take squares in upper left 3rx4c and check down diagonal
    (@height-3).times do |row|
      (@width-4).times do |col|
        return true if forms_diag([row, col], true)
      end
    end
    false
  end

  def game_won?
    vertical_win? || horizontal_win? || up_diagonal_win? || down_diagonal_win?
  end

  def color cell
    return "O".red if cell == 1
    return "O".yellow if cell == 2
    " "
  end

  def put_line
    (@width*2+1).times {print "-"}
    puts ""
  end

  def print_board
    #print board processing cells for color
    put_line
    @grid.each do |row|
      to_print = "|"
      row.each do |cell|
        to_print += (color cell) + "|"
      end
      puts to_print + "\n"
      put_line
    end
  end

  def cycle_current_player
    @current_player = (@current_player + 1) % 2
  end

  def print_game_win
    puts "Player #{@current_player+1} has won!"
    puts "Here's the final board:"
    print_board
  end

  def print_game_draw
    puts "The game has ended in a draw."
    puts "Here's the final board:"
    print_board
  end

  def print_active_player
    puts "It is player #{@current_player+1}'s turn"
  end

  def mainloop
    loop do
      print_board
      print_active_player
      prompt_for_move
      if game_won?
        print_game_win
        return true
      end
      if draw?
        print_game_draw
        return false
      end
      cycle_current_player
    end
  end

end
