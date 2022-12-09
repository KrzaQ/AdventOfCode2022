#!/usr/bin/ruby

def letter_to_diff l
    {
        'L' => [-1, 0],
        'R' => [1, 0],
        'U' => [0, 1],
        'D' => [0, -1],
    }[l]
end

DATA = File.read('data.txt').lines.map do
    diff, times = *_1.split;
    [ letter_to_diff(diff), times.to_i ]
end

def sum_directions a, b
    a.zip(b).map(&:sum)
end

def dist a, b
    a.zip(b).map{ (_1.first - _1.last) ** 2 }.sum.to_f ** 0.5
end

def new_diff a, b
    a.zip(b).map{ _1.inject(:-) }.map{ _1.abs / 2 * (_1 <=> 0) }
end

def sim_step knots, diff
    new_knots = [ sum_directions(knots.last, diff) ]
    knots.reverse[1..-1].each do |k|
        if dist(k, new_knots.last) > 1.5
            d = new_diff(k, new_knots.last)
            new_knots << sum_directions(new_knots.last, d)
        else
            new_knots << k
        end
    end
    new_knots.reverse
end

def sim data, size
    knots = size.times.map{ [0, 0] }
    ts = [knots.last]
    data.each do |diff, n|
        n.times do
            knots = sim_step knots, diff
            ts << knots.first
        end
    end
    ts.sort.uniq.size
end

PART1 = sim DATA, 2
PART2 = sim DATA, 10

puts 'Part 1: %s' % PART1
puts 'Part 2: %s' % PART2
