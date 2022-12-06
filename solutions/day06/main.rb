#!/usr/bin/ruby

DATA = File.read('data.txt').strip.chars

find_header = ->(n) { DATA.each_cons(n).find_index{ _1.uniq.size == n } + n }

PART1 = find_header[4]
PART2 = find_header[14]

puts 'Part 1: %s' % PART1
puts 'Part 2: %s' % PART2
