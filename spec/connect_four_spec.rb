require 'connect_four'

describe Board do
  before do
    @b = Board.new
  end

  context "properly initializes the grid" do
    it "has a 6 cell tall grid" do
      expect(@b.grid.length).to eql(6)
    end
    it "has a 7 cell wide grid" do
      expect(@b.grid[0].length).to eql(7)
    end
    it "has all empty cells" do
      expect(@b.grid.all? {|row| row.all? {|cell| cell == 0}}).to eql(true)
    end
  end

  context "properly prints the @board" do
    it "associates 1 with red" do
      expect(@b.color(1)).to eql("\e[0;31;49mO\e[0m")
    end
    it "associates 2 with yellow" do
      expect(@b.color(2)).to eql("\e[0;33;49mO\e[0m")
    end
    it "associates 0 with empty" do
      expect(@b.color(0)).to eql(" ")
    end
  end

  context "rejects any input other than a number 1-7" do
    it "rejects strings" do
      expect(@b.is_valid?('h')).to eql(false)
    end
    it "rejects big numbers" do
      expect(@b.is_valid?(10000)).to eql(false)
    end
  end

  context "places discs properly" do
    it "puts a disc at the bottom of an empty column" do
      @b.place_disc 3
      expect([1, 2].include?(@b.grid[5][3])).to eql(true)
    end
    it "places discs on top of each other" do
      3.times {@b.place_disc(3)}
      expect([1, 2].include?(@b.grid[3][3])).to eql(true)
    end
  end

  context "detects the end of the game" do
    it "detects a horizontal win" do
      4.times {|i| @b.place_disc i}
      expect(@b.game_won?).to eql(true)
    end
    it "detects a vertical win" do
      4.times {@b.place_disc 3}
      expect(@b.game_won?).to eql(true)
    end
    it "detects a upward diagonal win" do
      4.times {|i| @b.grid[i][i] = 1}
      expect(@b.game_won?).to eql(true)
    end
    it "detects a downward diagonal win" do
      4.times {|i| @b.grid[3-i][i] = 1}
      expect(@b.game_won?).to eql(true)
    end
    it "detects a draw" do
      to_place = 0
      @b.width.times do |c|
        @b.height.times do |r|
          @b.grid[r][c] = to_place+1
          to_place = (to_place+1)%2
        end
      end
      expect(@b.draw?).to eql(true)
    end
  end

end
