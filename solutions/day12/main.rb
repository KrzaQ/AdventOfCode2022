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

def dijkstra from, found:, next_nodes:, distance:
    queue = [from]
    distances = { from => 0 }
    while queue.any?
        cur = queue.shift
        cur_dist = distances[cur]
        return distances[cur] if found[cur]
        next_nodes[cur].each do |next_node|
            next_dist = distance[cur, next_node] + cur_dist
            next if distances[next_node] and distances[next_node] <= next_dist
            distances[next_node] = next_dist
            queue << next_node
        end
        queue.sort_by!{ distances[_1] }
    end
    distances
end

def around x, y, xs, ys, diff_reject_func: ->(diff){ diff > 1 }
    [[x - 1, y], [x + 1, y], [x, y - 1], [x, y + 1]]
        .select{ xs.include? _1[0] and ys.include? _1[1] }
        .reject{ diff_reject_func[DATA.dig(*_1.reverse) - DATA.dig(y, x)] }
end

DATA = File.read('data.txt').lines.map do |line|
    line.strip.chars.map { letter_to_elevation(_1) }
end
S = DATA.find_index{ _1.include?(-1) }
    .yield_self{ [_1, DATA[_1].find_index(-1)] }
    .reverse
E = DATA.find_index{ _1.include?(26) }
    .yield_self{ [_1, DATA[_1].find_index(26)] }
    .reverse
DATA[S[1]][S[0]] = 0
DATA[E[1]][E[0]] = ?z.ord - ?a.ord

def part1
    next_nodes = ->(x){ around(x[0], x[1], 0...DATA[0].size, 0...DATA.size) }
    distance = ->(_, _){ 1 }
    found = ->(x){ x == E }
    dijkstra(S, found: found, next_nodes: next_nodes, distance: distance)
end

def part2
    reject = ->(diff){ diff < -1 }
    next_nodes = ->(n) do
        xs = 0...DATA[n[1]].size
        ys = 0...DATA.size
        around(n[0], n[1], xs, ys, diff_reject_func: reject)
    end
    distance = ->(_, _){ 1 }
    found = ->(n){ DATA.dig(*n.reverse) == 0 }
    dijkstra(E, next_nodes: next_nodes, distance: distance, found: found)
end

puts 'Part 1: %s' % part1
puts 'Part 2: %s' % part2
