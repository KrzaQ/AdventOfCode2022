#!/usr/bin/ruby

DATA = File.read('data.txt').lines.map(&:strip).map do |line|
  line.split(' -> ').map{ _1.scan(/\d+/).map(&:to_i) }
end

MAP = 1000.times.map{ Array.new(1000, ' ') }

DATA.each do |line|
    line.each_cons(2) do |from, to|
        # p [from, '->', to]
        fx, tx = [from[0], to[0]].sort
        fy, ty = [from[1], to[1]].sort
        [*fx..tx].product([*fy..ty]) do |x, y|
            MAP[y][x] = ?#
        end
    end
end

def print_map xs, ys, m = MAP
    ys.each do |y|
            xs.each do |x|
                print m[y][x]
            end
        puts ''
    end
end

def simulate_grain map
    m = map.map(&:dup)
    lowest_y = (map.size-1).downto(0).find{ map[_1].include? ?# }
    sand = [500, 0]
    loop do
        x, y = sand
        break if y == lowest_y
        if m[y+1][x] == ' '
            sand = [x, y+1]
        elsif m[y+1][x-1] == ' '
            sand = [x-1, y+1]
        elsif m[y+1][x+1] == ' '
            sand = [x+1, y+1]
        else
            m[y][x] = ?o
            break
        end
    end
    m
end

def part1 m
    count = 0
    loop do
        m2 = simulate_grain m
        # print_map 490..510, 0..10, m
        # print_map 490..510, 0..10, m2
        break if m == m2
        count += 1
        m = m2
    end
    count
end

def simulate_grain_memoized map, last = nil
    m = map
    lowest_y = (map.size-1).downto(0).find{ map[_1].include? ?# }
    sand = last || [500, 0]
    last_sand = last
    loop do
        x, y = sand
        break if y == lowest_y
        if m[y+1][x] == ' '
            last_sand = sand
            sand = [x, y+1]
        elsif m[y+1][x-1] == ' '
            last_sand = sand
            sand = [x-1, y+1]
        elsif m[y+1][x+1] == ' '
            last_sand = sand
            sand = [x+1, y+1]
        else
            m[y][x] = ?o
            last_sand = nil if last == sand
            break
        end
    end
    [m, last_sand]
end

def part2 m
    lowest_y = (m.size-1).downto(0).find{ m[_1].include? ?# }
    (0...m[lowest_y+2].size).each do |x|
        m[lowest_y+2][x] = ?#
    end
    count = 0
    last = nil
    loop do
        m2, last = simulate_grain_memoized m, nil
        if count % 1000 == 0
            # print_map 300..700, 0..180, m2
            p count
        end
        count += 1
        break if m2[0][500] != ' '
        m = m2
    end
    count
end

PART1 = part1 MAP
PART2 = part2 MAP

puts 'Part 1: %s' % PART1
puts 'Part 2: %s' % PART2
