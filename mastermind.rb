class Game
  def initialize
    @board =
    [
      ["[ ]","[ ]","[ ]","[ ]"],
      ["[ ]","[ ]","[ ]","[ ]"],
      ["[ ]","[ ]","[ ]","[ ]"],
      ["[ ]","[ ]","[ ]","[ ]"],
      ["[ ]","[ ]","[ ]","[ ]"],
      ["[ ]","[ ]","[ ]","[ ]"],
      ["[ ]","[ ]","[ ]","[ ]"],
      ["[ ]","[ ]","[ ]","[ ]"],
      ["[ ]","[ ]","[ ]","[ ]"],
      ["[ ]","[ ]","[ ]","[ ]"],
      ["[ ]","[ ]","[ ]","[ ]"],
      ["[ ]","[ ]","[ ]","[ ]"],
    ]
    @colors = ["R","G","B","O","Y","P"]
    @tries_left = 12
    @game_over = false
    @correct_colors = 0
    @wrong_positioned_colors = 0

    puts "Welcome to Mastermind."
    puts "There are ten rows and each row consists of four pegs. There are six colors available - red, green, blue, orange, purple and yellow. \nEach of them will be denoted by their capitalized initials."
    control_flow
  end
  def display_grid
    puts "===========================================\n"
    @board.each do |row|
      row.each do |peg|
        print "\t" + peg
      end
      puts "\n"
    end
    puts "===========================================\n"
  end
  def display_feedback
    puts "You got #{@correct_colors} color pegs correct and #{@wrong_positioned_colors} color pegs in the wrong positions." if @option == 1
    puts "I got #{@correct_colors} color pegs correct and #{@wrong_positioned_colors} color pegs in the wrong positions." if @option == 2
  end


  def bot_as_maker
    @secret_code = [@colors[rand(0..5)],@colors[rand(0..5)],@colors[rand(0..5)],@colors[rand(0..5)]]
  end
  def user_as_breaker
    puts "Select four colors from R, G, B, Y, O, P. You may use lowercase. Number of tries left: #{@tries_left}."
    @input_as_array = gets.chomp.upcase.split(/\s?/)
    if @input_as_array.length != 4
      puts "Please select exactly four colors."
      user_as_breaker
      return
    end
    (@board.length-1).downto(0) do |row|
      if @board[row] != ["[ ]","[ ]","[ ]","[ ]"]
        next
      else
        @tries_left -= 1
        for i in 0..3
          @board[row][i] ="[#{@input_as_array[i]}]"
        end
        break
      end
    end

  end
  def user_as_maker
    puts "Choose four color pegs for me to guess."
    @secret_code = gets.chomp.upcase.split(/\s?/)
    if @secret_code.length != 4
      puts "Please select exactly four colors."
      user_as_maker
      return
    end
  end
  def bot_as_breaker
    @input_as_array = [@colors[rand(0..5)],@colors[rand(0..5)],@colors[rand(0..5)],@colors[rand(0..5)]]
    (@board.length-1).downto(0) do |row|
      if @board[row] != ["[ ]","[ ]","[ ]","[ ]"]
        next
      else
        @tries_left -= 1
        for i in 0..3
          @board[row][i] ="[#{@input_as_array[i]}]"
        end
        break
      end
    end
  end

  def check_matches
    @correct_colors = 0
    @wrong_positioned_colors = 0
    @temp_arr = @secret_code.dup

    for i in 0..3
      @correct_colors += 1 if @secret_code[i] == @input_as_array[i]
      @temp_arr[i] = nil if @secret_code[i] == @input_as_array[i]
      @input_as_array[i] = nil if @secret_code[i] == @input_as_array[i]

    end
    @temp_arr.delete_if {|item|item == nil}
    @input_as_array.delete_if {|item|item == nil}
    @temp_arr.each do |item_from_filtered_secret_code|
      if @input_as_array.include? item_from_filtered_secret_code
        @input_as_array.delete_at(@input_as_array.find_index(item_from_filtered_secret_code))
        @wrong_positioned_colors += 1
      end
    end
    if @input_as_array == @secret_code
      @game_over = true
      puts "Colors matched!"
    elsif @tries_left == 0
      @game_over = true
      display_grid
      display_feedback
      puts "Game over. No tries left."

    end
  end

  def control_flow
    puts "Select an option: \n\t1. You as code breaker. \n\t2. You as code maker. We will try to break the code."
    @option = gets.chomp.to_i
    if @option != 1 && @option != 2
      print "Input only 1 or 2. "
      control_flow
      return
    end 
    while @game_over == false
      case @option
      when 1
        display_grid
        display_feedback if @tries_left != 12
        bot_as_maker if @tries_left == 12
        print @secret_code
        user_as_breaker
        check_matches
      when 2
        display_grid
        display_feedback if @tries_left != 12
        user_as_maker if @tries_left == 12
        puts "The secret code: #{@secret_code} ----> Only you can see."
        puts "I have #{@tries_left} tries left. Lemme think..."
        sleep(rand(1..5))
        bot_as_breaker
        check_matches
      end
    end
  end
end
Game.new
