Position = Struct.new(:row, :column)

class Cave
  def initialize(input)
    @map = []
    while (line = input.gets)
      @map << line.chomp.chars
    end
  end

  def get_square(position)
    @map[position.row][position.column]
  end

  def water_square(position)
    @map[position.row][position.column] = '~'
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
    count = column.select {|x| x == '~' }.count

    if column.join.include?(' #') && count != 0
      '~'
    else
      count
    end
  end
end

def fill_cave(iterations, cave, position)
  return 0 if iterations == 0

  square = cave.get_square(position)
  return iterations unless square == ' '
  cave.water_square(position)

  remaining = fill_cave(iterations - 1, cave, Position.new(position.row + 1, position.column))
  fill_cave(remaining, cave, Position.new(position.row, position.column + 1))
end


input_file = ARGV[0]
fin = File.open(input_file, 'r')
water_units = fin.gets.chomp.to_i
fin.gets # blank line

cave = Cave.new(fin)
fin.close

cave.print_map

# Start in the next place we have to place water
position = Position.new(1, 1) # Row, Column

fill_cave(water_units-1, cave, position)

cave.print_map

# calculate water levels for output
depths = cave.count_depths
puts depths.join(' ')
