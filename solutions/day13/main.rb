#!/usr/bin/ruby

DATA = File.read('data.txt').split("\n").map(&:strip).map{ eval _1 }
    .each_slice(3).map{ |a, b, c| [a, b] }

def cmp a, b
    if a.kind_of? Array and b.kind_of? Array
        size = [a.size, b.size].max
        for i in 0...size
            ax, bx = a[i], b[i]
            return 1 if bx == nil
            return -1 if ax == nil
            ret = cmp(ax, bx)
            return ret unless ret == 0
        end
        0
    elsif a.kind_of? Array
        cmp a, [b]
    elsif b.kind_of? Array
        cmp [a], b
    else
        a <=> b
    end
end

PART1 = DATA.each_with_index.map do |input, i|
    a, b = *input
    [i + 1, cmp(a, b) < 0]
end.select{ _2 }.map{ _1.first }.sum

PART2 = DATA.flatten(1).yield_self do
    _1 << [[2]]
    _1 << [[6]]
    _1
end.sort{ cmp _1, _2 }.yield_self do |sorted|
    xx = sorted.find_index([[2]]) + 1
    yy = sorted.find_index([[6]]) + 1
    xx * yy
end

puts 'Part 1: %s' % PART1
puts 'Part 2: %s' % PART2
