#!/usr/bin/ruby

require 'set'

ELVES = File.read('data.txt').lines.map{ _1.strip.chars }.each_with_index
    .map { |l, y| l.each_with_index.map{ |c, x| [x, y] if c == '#' } }
    .flatten(1).compact.to_set

def print_elves elves
    xα, xω = elves.map{ _1[0] }.minmax.then{ [_1 - 1, _2 + 1] }
    yα, yω = elves.map{ _1[1] }.minmax.then{ [_1 - 1, _2 + 1] }
    (yα..yω).each do |y|
        (xα..xω).each{ |x| print elves.include?([x, y]) ? '#' : '.' }
        puts
    end
end

def add_point a, b
    a.zip(b).map(&:sum)
end

def around elf
    [*-1..1].product([*-1..1]).reject{ _1 == [0, 0] }.map{ add_point elf, _1 }
end

def propose_direction elves, elf, directions
    dir_points = {
        north: [[ 0, -1], [ 1, -1], [-1, -1]],
        south: [[ 0,  1], [ 1,  1], [-1,  1]],
        east:  [[ 1,  0], [ 1,  1], [ 1, -1]],
        west:  [[-1,  0], [-1,  1], [-1, -1]],
    }
    directions
        .find{ |d| dir_points[d].none?{ elves.include? add_point(elf, _1) } }
        .then{ |d| d ? add_point(elf, dir_points[d].first) : nil }
end

def one_round elves, directions
    new_elves = {}
    loners = []
    elves.each do |elf|
        new_elf = propose_direction elves, elf, directions
        if not new_elf or around(elf).count{ elves.include? _1 } == 0
            loners << elf
            next
        end
        new_elves[new_elf] ||= []
        new_elves[new_elf] << elf
    end
    new_elves.map{ _2.count == 1 ? [_1] : _2 }.flatten(1).to_set + loners
end

def calc_rectangle elves
    elves.transpose.map{ _1.minmax.inject(:-) - 1 }.inject(:*) - elves.count
end

def calculate elves
    directions = %i(north south west east)
    part1 = nil
    (1..).each do |n|
        old_elves = elves
        elves = one_round elves, directions
        directions = directions.rotate
        part1 = calc_rectangle elves.to_a if n == 10
        return part1, n if old_elves == elves
    end
end

PART1, PART2 = calculate ELVES

puts 'Part 1: %s' % PART1
puts 'Part 2: %s' % PART2
