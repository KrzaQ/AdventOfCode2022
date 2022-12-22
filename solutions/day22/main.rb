#!/usr/bin/ruby

require_relative 'part1'
require_relative 'part2'

PART1 = D22Part1.process_movement
PART2 = D22Part2.process_movement

puts 'Part 1: %s' % PART1
puts 'Part 2: %s' % PART2
