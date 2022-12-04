#!/usr/bin/ruby

class String
    def halves
        [self[0...(self.size/2)],self[(self.size/2)..-1]]
    end
end

def val c
    if [*('A'..'Z')].include? c
        c.ord - 'A'.ord + 27
    else
        c.ord - 'a'.ord + 1
    end
end

DATA = File.read('data.txt').lines.map(&:strip)

PART1 = DATA
    .map{ val _1.halves.map(&:chars).inject(&:&).first }
    .sum

PART2 = DATA
    .each_slice(3)
    .map{ val _1.map(&:chars).inject(&:&).first }
    .sum

puts 'Part 1: %s' % PART1
puts 'Part 2: %s' % PART2
