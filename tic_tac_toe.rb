class Game
  def initialize
    @grid = [
      ["___","___","___"],
      ["___","___","___"],
      ["___","___","___"]
    ]
    @game_over = false
  end
  def play
    while true

        display_grid
        user_turn
        display_grid
        ai_turn
        puts "bot is thinking..."
        sleep(rand(1..5))


    end
  end
  def display_grid
    puts "=====================================\n\n"
    @grid.each do |i|
      i.each do |j|
        print "\t" + j
      end
      print "\n\n"
    end
    puts "====================================="
  end
  def user_turn
    print "Select a position from 1 to 9: "
    @user_choice = gets.chomp.to_i
    if @user_choice <= 3
      if @grid[0][@user_choice-1] == "___"
         @grid[0][@user_choice-1] = " x "
       else
         puts "invalid position"
         user_turn
       end
    elsif @user_choice <= 6
      if @grid[1][@user_choice-4] == "___"
         @grid[1][@user_choice-4] = " x "
       else
         puts "invalid position"
         user_turn
       end
    else
      if @grid[2][@user_choice-7] == "___"
         @grid[2][@user_choice-7] = " x "
       else
         puts "invalid position"
         user_turn
       end
    end
    check_victory
  end
  def ai_turn
    @ai_choice = rand(0..8)
    smart_up
    if @ai_choice <= 2
      if @grid[0][@ai_choice] == "___"
         @grid[0][@ai_choice] = " 0 "
       else
         ai_turn
       end
    elsif @ai_choice <= 5
      if @grid[1][@ai_choice-3] == "___"
         @grid[1][@ai_choice-3] = " 0 "
       else
         ai_turn
       end
    else
      if @grid[2][@ai_choice-6] == "___"
         @grid[2][@ai_choice-6] = " 0 "
       else
         ai_turn
       end

    end
    check_draw
    check_victory
  end

  def check_victory
    for a in 0..2 do
      @game_over = true if @grid[a][0] == ' x ' && @grid[a][1]  == ' x ' && @grid[a][2] == ' x ' || \
      @grid[a][0] == ' 0 ' && @grid[a][1] == ' 0 ' && @grid[a][2] == ' 0 ' || \
      @grid[0][a] == ' x ' && @grid[1][a] == ' x ' && @grid[2][a] == ' x ' || \
      @grid[0][a] == ' 0 ' && @grid[1][a] == ' 0 ' && @grid[2][a] == ' 0 '
    end
    @game_over = true if @grid[0][0] == ' x ' && @grid[1][1]== ' x ' && @grid[2][2] == ' x ' || \
    @grid[0][0] == ' 0 ' && @grid[1][1] == ' 0 ' && @grid[2][2] == ' 0 ' || \
    @grid[2][0] == ' x ' && @grid[1][1] == ' x ' && @grid[0][2] == ' x ' || \
    @grid[2][0] == ' 0 ' && @grid[1][1] == ' 0 ' && @grid[0][2] == ' 0 '
    if @game_over
      display_grid
      puts "GAME OVER. GOOD GAME."
      exit
    end
  end
  def smart_up
    #horizontal check
    @grid.each do |row|
      if row.count(" x ") == 2
        position = row.find_index("___") + 3*@grid.find_index(row) if row.find_index("___")
        @ai_choice = position if position
      end
    end
    #vertical check
    @grid.transpose.each do |row|
      if row.count(" x ") == 2
        position = row.find_index("___") + 3*(@grid.transpose.find_index(row)) if row.find_index("___")

        position = case position
        when 1;3
        when 3;1
        when 2;6
        when 6;2
        when 5;7
        when 7;5
        end
        @ai_choice = position if position
      end

    end
    #check diagonal
    if [@grid[0][0],@grid[1][1],@grid[2][2]].count(" x ") == 2
      temp_position = [@grid[0][0],@grid[1][1],@grid[2][2]].find_index("___")
      if temp_position
        case temp_position
        when 0
          @ai_choice = 0
        when 1
          @ai_choice = 4
        when 2
          @ai_choice = 8
        end
      end


    elsif [@grid[2][0],@grid[1][1],@grid[0][2]].count(" x ") == 2
      temp_position = [@grid[2][0],@grid[1][1],@grid[0][2]].find_index("___")
      if temp_position
        case temp_position
        when 0
          @ai_choice = 6
        when 1
          @ai_choice = 4
        when 2
          @ai_choice = 2
        end
      end
    end
  end
  def check_draw
    @game_over = true if @grid[0].count("___") == 0 && @grid[1].count("___") == 0 && @grid[2].count("___") == 0
  end
end
a = Game.new()
a.play
