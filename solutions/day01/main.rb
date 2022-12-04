#!/usr/bin/ruby

DATA = File.read('data.txt')
    .split("\n\n")
    .map{ _1.scan(/\d+/).map(&:to_i).sum }
    .sort

PART1 = DATA.last
PART2 = DATA[-3..-1].sum

puts 'Part 1: %s' % PART1
puts 'Part 2: %s' % PART2
