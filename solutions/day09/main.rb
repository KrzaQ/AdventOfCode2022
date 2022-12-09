#!/usr/bin/ruby

DATA = File.read('data.txt').lines.map{ d, n = *_1.split; [d, n.to_i] }

def sum_directions a, b
    a.zip(b).map(&:sum)
end

def mdist a, b
    a.zip(b).map{ (_1.first - _1.last).abs }.sum
end

def dist a, b
    a.zip(b).map{ (_1.first - _1.last) ** 2 }.sum.to_f ** 0.5
end

def l_to_d l
    case l
    when 'L'
        [-1, 0]
    when 'R'
        [1, 0]
    when 'U'
        [0, 1]
    when 'D'
        [0, -1]
    end
end

def sim_step1 h, t, diff
    h = sum_directions(h, diff)
    if dist(h, t) > 1.5
        t = sum_directions(h, diff.map{ _1 * -1 })
    end
    [h, t]
end

def sim1 data
    h = [0, 0]
    t = [0, 0]
    ts = [t]
    data.each do |d, n|
        diff = l_to_d(d)
        n.times do
            h, t = sim_step1(h, t, diff)
            ts << t
        end
    end
    ts.sort.uniq.size
end

def new_diff a, b
    dx, dy = a.zip(b).map{ _1.first - _1.last }
    case [dx, dy]
    when [0, 1]
        [0, 0]
    when [0, -1]
        [0, 0]
    when [1, 0]
        [0, 0]
    when [0, 0]
        [0, 1]
    when [-2, 0]
        [-1, 0]
    when [2, 0]
        [1, 0]
    when [0, 2]
        [0, 1]
    when [0, -2]
        [0, -1]
    when [-1, -2]
        [0, -1]
    when [1, 2]
        [0, 1]
    when [-1, 2]
        [0, 1]
    when [1, -2]
        [0, -1]
    when [-2, -1]
        [-1, 0]
    when [-2, 1]
        [-1, 0]
    when [2, -1]
        [1, 0]
    when [2, 1]
        [1, 0]
    when [-2, -2]
        [-1, -1]
    when [2, -2]
        [1, -1]
    when [-2, 2]
        [-1, 1]
    when [2, 2]
        [1, 1]
    else
        p [a, b, dx, dy]
        raise 'wtf'
    end
end

def sim_step2 knots, diff
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

def sim2 data
    knots = 10.times.map{ [0, 0] }
    ts = [knots.last]
    data.each do |d, n|
        diff = l_to_d(d)
        n.times do
            knots = sim_step2(knots, diff)
            ts << knots.first
        end
    end
    ts.sort.uniq.size
end

PART1 = sim1 DATA
PART2 = sim2 DATA

puts 'Part 1: %s' % PART1
puts 'Part 2: %s' % PART2
