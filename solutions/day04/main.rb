#!/usr/bin/ruby

def contain a, b, c, d
    (a <= c and b >= d) or (c <= a and d >= b)
end

def overlap a, b, c, d
    ([*a..b] & [*c..d]).count > 0
end

DATA = File.read('data.txt').lines.map(&:strip)
    .map{ _1.scan(/\d+/).map(&:to_i) }

PART1 = DATA.select{ contain *_1 }.count
PART2 = DATA.select{ overlap *_1 }.count

puts 'Part 1: %s' % PART1
puts 'Part 2: %s' % PART2
