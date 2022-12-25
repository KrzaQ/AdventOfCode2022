#!/usr/bin/ruby

DATA = File.read('data.txt').lines.map(&:strip)

def from_snafu n
    n.chars.reverse.each_with_index.map do |c, i|
        n = c == ?- ? -1 : c == ?= ? -2 : c.to_i
        n * 5**i
    end.sum
end

def to_snafu n
    carry = 0
    n.to_s(5).chars.reverse.map(&:to_i).then{ _1 + [0] }.map do |n|
        n += carry
        carry = n >= 3 ? 1 : 0
        n -= 5 if n >= 3
        n == -1 ? ?- : n == -2 ? ?= : n.to_s
    end.join.reverse.then{ _1[0] == ?0 ? _1[1..-1] : _1 }
end

PART1 = to_snafu DATA.map { |s| from_snafu s }.sum
PART2 = ":)"

puts 'Part 1: %s' % PART1
puts 'Part 2: %s' % PART2
