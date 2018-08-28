$BOARD_SIZE = {width: 10, height: 10}
$BOARD = Array.new($BOARD_SIZE[:width]) {Array.new($BOARD_SIZE[:height]) {'.'}}

$SHIPS = [{
    name: "航空母艦",
    label: :A,
    size: 5}, {
    name: "戰鬥艦",
    label: :B,
    size: 4}, {
    name: "巡洋艦",
    label: :C,
    size: 3}, {
    name: "潛水艇",
    label: :S,
    size: 3}, {
    name: "驅逐艦",
    label: :D,
    size: 2}]

def get_rand_pos w=$BOARD_SIZE[:width], h=$BOARD_SIZE[:height]
  {x: rand(w), y: rand(h)}
end

def deploy ship
  pos = get_rand_pos
  row_or_column = [:r, :c].sample
  if(row_or_column==:r)
    boundary = pos[:x]+ship[:size]-1
    if boundary >= $BOARD_SIZE[:width]
      deploy ship
    else
      op = true
      (pos[:x]..(pos[:x]+ship[:size]-1)).each{|x|
        unless $BOARD[x][pos[:y]]=='.'
          op = false
          break
        end
      }
      if op
        (pos[:x]..(pos[:x]+ship[:size]-1)).each{|x|
          $BOARD[x][pos[:y]] = ship[:label]
        }
      else
        deploy ship
      end
    end
  else
    boundary = pos[:y]+ship[:size]-1
    if boundary >= $BOARD_SIZE[:height]
      deploy ship
    else
      op = true
      (pos[:y]..(pos[:y]+ship[:size]-1)).each{|y|
        unless $BOARD[pos[:x]][y]=='.'
          op = false
          break
        end
      }
      if op
        (pos[:y]..(pos[:y]+ship[:size]-1)).each{|y|
          $BOARD[pos[:x]][y] = ship[:label]
        }
      else
        deploy ship
      end
    end
  end
end

$SHIPS.each {|ship|
  deploy ship
}

sinks = []
$SINKS_BOARD = Array.new($BOARD_SIZE[:width]) {Array.new($BOARD_SIZE[:height]) {'.'}}
cnt = 0

def print_board board
  puts '  '+(0..9).to_a.join(' ')
  board.each.with_index{|row, idx|
    puts "#{idx} #{row.join(' ')}"
  }
end

def print_desc
  print_board $SINKS_BOARD
  print "Enter Position x y: "
end

loop do
  cnt += 1
  print_desc

  str = gets.chomp
  if str == 'cheat'
    print_board $BOARD
  elsif str =~ /q|exit/
    exit!
  elsif mch = str.match(/^(\d)\s?(\d)$/)
    y,x = mch.to_a.last(2).map(&:to_i)
    if [:A, :B, :C, :S, :D].include?($BOARD[x][y])
      sinks << $BOARD[x][y] unless sinks.include?($BOARD[x][y])
      $SINKS_BOARD[x][y] = $BOARD[x][y]
    else
      $SINKS_BOARD[x][y] = 'X'
    end

    sinks.size>=5 ? break : print_desc
  else
    puts "輸入格式錯誤"
  end
end

puts "YOU WIN"
print_board $BOARD
