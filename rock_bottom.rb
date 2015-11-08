input_file = ARGV[0]
fin = File.open(input_file, 'r')

class Cave
  def initialize(input)
    @map = []
    while (line = input.gets)
      @map << line.chomp.chars
    end
  end

  def get_square(row, column)
    @map[row][column]
  end

  def water_square(row, column)
    @map[row][column] = '~'
  end

  def print_map
    puts "\e[H\e[2J"

    @map.each do |line|
      puts line.join
    end
  end

  def count_depths
    @map.transpose.map do |column|
      count_depth(column)
    end
  end

  private
  def count_depth(column)
    column.select {|x| x == '~' }.count
  end
end

water_units = fin.gets.chomp.to_i
fin.gets # blank line

cave = Cave.new(fin)

column_stack = []
row = 1
column = 0
(1...water_units).each do |unit|
  cave.print_map
  sleep(0.1)

  while true
    if cave.get_square(row+1, column) == ' '
      # Found an empty space below, awesome
      row += 1
      cave.water_square(row, column)
      column_stack.push(column)
      break
    elsif cave.get_square(row, column+1) == ' '
      # Found an empty space to the right, awesome
      column += 1
      cave.water_square(row, column)
      break
    else
      row -= 1
      column = column_stack.pop
    end
  end
end

# calculate water levels for output
depths = cave.count_depths
puts depths.join(' ')
