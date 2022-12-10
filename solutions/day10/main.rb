#!/usr/bin/ruby

DATA = File.read('data.txt').lines.map(&:strip)

def sim data
    ret = { 1 => 1 }
    x = 1
    i = 0
    data.each do |line|
        case line
        when 'noop'
            i += 1
            ret[i] = x
        when /addx (-?\d+)/
            i += 1
            ret[i] = x
            i += 1
            ret[i] = x
            x += $1.to_i
        end
    end
    ret
end

def part1 data
    ret = sim data
    [20, 60, 100, 140, 180, 220].map { |i| ret[i] * i }.sum
end

def part2 data
    d = sim data
    ret = []
    (d.size / 40).times.each do |line|
        line_data = ''
        40.times.each do |pixel|
            b = [*-1..1].map{ _1 + pixel }.include? d[line * 40 + pixel + 1]
            line_data += b ? '#' : ' '
        end
        ret << line_data
    end
    ret.join "\n"
end

PART1 = part1 DATA
PART2 = "\n" + part2(DATA)

puts 'Part 1: %s' % PART1
puts 'Part 2: %s' % PART2
