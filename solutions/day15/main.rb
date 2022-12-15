#!/usr/bin/ruby

require 'z3'

DATA = File.read('data.txt').lines.map(&:strip)
    .map{ _1.scan(/-?\d+/).map(&:to_i) }
    .map{ _1.each_slice(2).to_a }

def manhattan_distance a, b
    a.zip(b).map{ _1[0] - _1[1] }.map(&:abs).sum
end

def impossible_at_row point, closest, row
    dist = manhattan_distance point, closest
    row_dist = manhattan_distance(point, [point[0], row])
    if row_dist > dist
        []
    else
        x, y = point
        diff = (dist - row_dist).abs
        [*(x-diff)..(x+diff)].map{ [_1, row] }.reject{ _1 == closest }
    end
end

def part1 row = 2_000_000
    points = DATA.map{ _1[1] }.select{ _1[1] == row }.uniq
    DATA.map{ impossible_at_row _1[0], _1[1], row}.flatten(1).uniq
        .reject{ points.include? _1 }.count
end

def abs(t)
    Z3::IfThenElse(t >= 0, t, -t)
end

def part2 max = 4_000_000
    o = Z3::Optimize.new
    x = Z3.Int('x')
    y = Z3.Int('y')

    DATA.each do |point, closest|
        dist = manhattan_distance(point, closest)
        x1, y1 = point
        x2, y2 = closest
        o.assert(abs(x1-x) + abs(y1-y) > dist)
    end
    o.assert(x >= 0)
    o.assert(y >= 0)
    o.assert(x <= max)
    o.assert(y <= max)
    o.check()
    x, y = o.model().map{ [_1.to_s, _2.to_i] }.sort.map(&:last)
    [x, y, x * max + y]
end

PART1 = part1
PART2 = part2.last

puts 'Part 1: %s' % PART1
puts 'Part 2: %s' % PART2
