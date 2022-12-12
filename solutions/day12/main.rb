#!/usr/bin/ruby

def letter_to_elevation(letter)
  case letter
    when 'a'..'z'
        letter.ord - ?a.ord
    when ?S
        -1
    when ?E
        26
    else
        raise 'Invalid letter'
    end
end

def around(x, y)
    [[x - 1, y], [x + 1, y], [x, y - 1], [x, y + 1]].reject {
        _1[0] < 0 || _1[1] < 0 || _1[01] >= DATA.size || _1[0] >= DATA[_1[1]].size }
        .reject{ DATA.dig(*_1.reverse) != :start and DATA[y][x] != :start and
        DATA.dig(*_1.reverse) != :end and DATA[y][x] != :end and
        (DATA.dig(*_1.reverse) - DATA[y][x] > 1) }
end

DATA = File.read('data.txt').lines.map do |line|
    line.strip.chars.map { letter_to_elevation(_1) }
end

# S = DATA.find_index { _1.include?(:start) }.yield_self{ [_1, DATA[_1].find_index(:start)] }
# E = DATA.find_index { _1.include?(:end) }.yield_self{ [_1, DATA[_1].find_index(:end)] }
S = DATA.find_index { _1.include?(-1) }.yield_self{ [_1, DATA[_1].find_index(-1)] }.reverse
E = DATA.find_index { _1.include?(26) }.yield_self{ [_1, DATA[_1].find_index(26)] }.reverse
p [S, E]
def dijkstra from, to
    queue = [from]
    distances = { from => 0 }
    while queue.any?
        current = queue.shift
        current_distance = distances[current]
        return distances[current] if current == to
        if current == [2,4]
            p current
            p around(*current)
            p DATA.dig(*current)
            p DATA.dig(2, 5)
        end
        
        around(*current).each do |next_node|
            # p next_node if next_node == [2,4]
            next if distances[next_node] && distances[next_node] <= current_distance + 1
            distances[next_node] = current_distance + 1
            queue << next_node
        end
    end
    distances
end

def around2(x, y)
    [[x - 1, y], [x + 1, y], [x, y - 1], [x, y + 1]].reject {
        _1[0] < 0 || _1[1] < 0 || _1[1] >= DATA.size || _1[0] >= DATA[_1[1]].size }
        .reject{ 
            # p [DATA.dig(*_1.reverse), DATA[y][x]] 
            (DATA.dig(*_1.reverse) - DATA[y][x] < -1) }
end


def dijkstra2 from
    queue = [from]
    distances = { from => 0 }
    while queue.any?
        current = queue.shift
        current_distance = distances[current]
        # p [current, DATA.dig(*current.reverse)]
        # p around2(*current)
        return distances[current] if [0, -1].include? DATA.dig(*current.reverse)

        around2(*current).each do |next_node|
            next if distances[next_node] && distances[next_node] <= current_distance + 1
            distances[next_node] = current_distance + 1
            queue << next_node
        end
    end
    distances
end

puts 'Part 1: %s' % dijkstra(S, E)
puts 'Part 2: %s' % dijkstra2(E)

exit
PART1 = DATA.last
PART2 = DATA[-3..-1].sum

puts 'Part 1: %s' % PART1
puts 'Part 2: %s' % PART2
