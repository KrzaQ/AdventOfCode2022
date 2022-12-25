#!/usr/bin/ruby

DATA = File.read('data.txt').lines.map(&:strip)

def from_snafu n
    n.chars.reverse.each_with_index.map do |c, i|
        n = case c
        when ?- then -1
        when ?= then -2
        else c.to_i
        end
        n * 5**i
    end.sum
end

def to_snafu n
    r = []
    while n > 0
        r << (n % 5)
        n /= 5
    end
    r << 0
    for i in 0...r.size
        if r[i] >= 3
            r[i] -= 5
            r[i+1] += 1
        end
    end
    r = r[0...-1] if r.last == 0
    r.map do |n|
        case n
        when -1 then ?-
        when -2 then ?=
        else n.to_s
        end
    end.join.reverse
end

PART1 = to_snafu DATA.map { |s| from_snafu s }.sum
PART2 = ":)"

puts 'Part 1: %s' % PART1
puts 'Part 2: %s' % PART2
