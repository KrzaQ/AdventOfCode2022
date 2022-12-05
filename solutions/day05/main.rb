#!/usr/bin/ruby

STACKS_DATA, MOVES_DATA = *File.read('data.txt').split("\n\n")

def parse_stacks(stacks_data)
    count = stacks_data.lines.last.scan(/\d+/).map(&:to_i).last

    data = count.times.map{ [] }
    stacks_data.lines[0..-2].reverse.map do |line|
        (0...count).each do |i|
            if line[i * 4 + 1] != ' '
                data[i] << line[i * 4 + 1]
            end
        end
    end
    data
end

def parse_moves(moves_data)
    moves_data.lines.map{ _1.scan(/\d+/).map(&:to_i) }
end

def simulate reverse:
    stacks = parse_stacks(STACKS_DATA)
    moves = parse_moves(MOVES_DATA)

    moves.each do |count, from, to|
        x = stacks[from - 1].pop(count)
        stacks[to - 1].push *(reverse ? x.reverse : x)
    end

    stacks.map{ _1.last }.join
end

PART1 = simulate reverse: false
PART2 = simulate reverse: true

puts 'Part 1: %s' % PART1
puts 'Part 2: %s' % PART2
