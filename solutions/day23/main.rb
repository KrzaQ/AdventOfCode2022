#!/usr/bin/ruby

require 'set'

ELVES = File.read('data.txt').lines.map{ _1.strip.chars }.each_with_index
    .map { |l, y| l.each_with_index.map{ |c, x| [x, y] if c == '#' } }
    .flatten(1).compact.to_set

def print_elves elves
    min_x, max_x = elves.map{ _1[0] }.minmax
    min_y, max_y = elves.map{ _1[1] }.minmax
    ((min_y-1)..(max_y+1)).each do |y|
        ((min_x-1)..(max_x+1)).each do |x|
            print elves.include?([x, y]) ? '#' : '.'
        end
        puts
    end
end

def add_point a, b
    [a[0] + b[0], a[1] + b[1]]
end

def around elf
    [-1, 0, 1].product([-1, 0, 1]).reject{ _1 == [0, 0] }
        .map{ add_point elf, _1 }
end

def propose_direction elves, elf, directions
    directions.each do |dir|
        case dir
        when :north
            empty = [[0, -1], [1, -1], [-1, -1]]
                .count{ elves.include? add_point(elf, _1) }
            next unless empty == 0
            return add_point(elf, [0, -1])
        when :south
            empty = [[0, 1], [1, 1], [-1, 1]]
                .count{ elves.include? add_point(elf, _1) }
            next unless empty == 0
            return add_point(elf, [0, 1])
        when :east
            empty = [[1, 0], [1, 1], [1, -1]]
                .count{ elves.include? add_point(elf, _1) }
            next unless empty == 0
            return add_point(elf, [1, 0])
        when :west
            empty = [[-1, 0], [-1, 1], [-1, -1]]
                .count{ elves.include? add_point(elf, _1) }
            next unless empty == 0
            return add_point(elf, [-1, 0])
        end
    end
    nil
end

def one_round elves, directions
    new_elves = {}
    loners = []
    elves.each do |elf|
        if around(elf).count{ elves.include? _1 } == 0
            loners << elf
            next
        end
        new_elf = propose_direction elves, elf, directions
        if not new_elf
            loners << elf
            next
        end
        new_elves[new_elf] ||= []
        new_elves[new_elf] << elf
    end
    new_elves.map{ _2.count == 1 ? [_1] : _2 }.flatten(1).to_set + loners
end

def calc_rectangle elves
    min_x, max_x = elves.map{ _1[0] }.minmax
    min_y, max_y = elves.map{ _1[1] }.minmax
    (min_y..max_y).map do |y|
        (min_x..max_x).count do |x|
            not elves.include?([x, y])
        end
    end.sum
end

def calculate elves
    directions = %i(north south west east)
    n = 0
    part1 = nil
    loop do
        n += 1
        old_elves = elves
        elves = one_round elves, directions
        directions = directions.rotate
        part1 = calc_rectangle elves if n == 10
        return part1, n if old_elves == elves
    end
end

PART1, PART2 = calculate ELVES

puts 'Part 1: %s' % PART1
puts 'Part 2: %s' % PART2
