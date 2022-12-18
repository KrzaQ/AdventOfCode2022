#!/usr/bin/ruby

require 'set'

DATA = File.read('data.txt').lines.map{ _1.scan(/\d+/).map(&:to_i) }.to_set

def around x
    diff = [-1, 0, 1]
    diff.product(diff, diff)
        .reject{ [0,2,3].include? _1.map(&:abs).sum }
        .map{ _1.zip(x).map(&:sum) }
end

MAX = DATA.reduce([0, 0, 0]) do |acc, n|
    acc.zip(n).map(&:max)
end

MIN = DATA.reduce(Array.new(3, Float::INFINITY)) do |acc, n|
    acc.zip(n).map(&:min)
end

class RejectCache
    def initialize
        @cache_ok = Set.new
        @cache_bad = Set.new
    end

    def bfs start, max_depth = 64
        return true if @cache_ok.include? start
        return false if @cache_bad.include? start
        ret, seen = bfs_impl start, max_depth
        @cache_ok.merge seen if ret
        @cache_bad.merge seen unless ret
        ret
    end

    def bfs_impl start, max_depth = 64
        queue = [start]
        seen = Set.new queue
        max_depth.times do
            return [true, seen] if queue.empty?
            while queue.any?
                current = queue.shift
                around(current).each do |point|
                    next if seen.include? point
                    next if DATA.include? point
                    return [false, seen] if point.zip(MIN).any?{ _1 <= _2 }
                    return [false, seen] if point.zip(MAX).any?{ _1 >= _2 }
                    seen << point
                    queue << point
                end
            end
        end
        [false, seen]
    end
end

def part1
    DATA.map{ |point| around(point).reject{ DATA.include? _1 }.count }.sum
end

def part2
    cache = RejectCache.new
    DATA.map{ |point| around(point).reject{ DATA.include? _1 } }
        .flatten(1).reject{ cache.bfs _1 }.count
end

PART1 = part1
PART2 = part2

puts 'Part 1: %s' % PART1
puts 'Part 2: %s' % PART2
