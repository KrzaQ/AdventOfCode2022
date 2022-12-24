#!/usr/bin/ruby

require 'set'

PRUNE_TRIGGER = 150
PRUNE_TO = 100
INIT = File.read('data.txt').lines.map{ _1.strip.chars }.each_with_index
    .map do |l, y|
        l.each_with_index.map do |c, x|
            [x, y, c.to_sym] if '<>^v'.include? c
        end
    end.flatten(1).compact.to_set

def wrap x, min, max
    x < min ? max : x > max ? min : x
end

class Blizzard
    attr_reader :min_x, :max_x, :min_y, :max_y
    attr_reader :b, :e

    def initialize init
        @blizzards = init
        @rounds = { 0 => init }
        @min_x, @max_x = init.map{ _1[0] }.minmax
        @min_y, @max_y = init.map{ _1[1] }.minmax
        @b = [1, 0]
        @e = [@max_x, @max_y + 1]
    end

    def get_round n
        return @rounds[n] if @rounds[n]
        @rounds[n] = simulate_round get_round(n - 1)
        @rounds[n]
    end

    def simulate_round blizzards
        new_blizzards = Set.new
        blizzards.each do |b|
            nb = case b[2]
            when :< then [wrap(b[0] - 1, @min_x, @max_x), b[1], :<]
            when :> then [wrap(b[0] + 1, @min_x, @max_x), b[1], :>]
            when :^ then [b[0], wrap(b[1] - 1, @min_y, @max_y), :^]
            when :v then [b[0], wrap(b[1] + 1, @min_y, @max_y), :v]
            end
            new_blizzards << nb
        end
        new_blizzards
    end

    def print_blizzards blizzards
        margin = (?# * (@max_x - @min_x + 3))
        margin[1] = ' '
        puts margin
        (@min_y..@max_y).each do |y|
            print ?#
            (@min_x..@max_x).each do |x|
                c = blizzards.find{ _1[0] == x and _1[1] == y }
                .then{ _1[2] if _1 }
                print case c
                when nil then '.'
                else c.to_s
                end
            end
            puts ?#
        end
        puts margin.reverse
    end
end

B = Blizzard.new INIT

def dijkstra from, found:, next_nodes:, distance:, prune: nil
    queue = [from]
    distances = { from => 0 }
    while queue.any?
        cur = queue.shift
        cur_dist = distances[cur]
        return distances[cur] if found[cur]
        next_nodes[cur].each do |next_node|
            next_dist = distance[cur, next_node] + cur_dist
            next if distances[next_node] and distances[next_node] <= next_dist
            distances[next_node] = next_dist
            queue << next_node
        end
        queue = prune[queue] if prune
        queue.sort_by!{ distances[_1] }
    end
    distances
end

def add_point a, b
    a.zip(b).map(&:sum)
end

def around x
    diff = [-1, 0, 1]
    diff.product(diff)
        .reject{ [2,3].include? _1.map(&:abs).sum }
        .map{ _1.zip(x).map(&:sum) }
end

def next_nodes param
    x, y, round = param
    bs = B.get_round(round+1)
    around([x, y])
        .reject{ |pt| %i(^ v < >).any?{ bs.include?(pt + [_1]) } }
        .reject{ (_1[0] <= 0 or _1[1] <= 0) and _1 != B.b }
        .reject{ (_1[0] > B.max_x or _1[1] > B.max_y) and _1 != B.e }
        .map{ _1 + [round + 1] }
end

def compute
    howfar_f = ->(pt){ ->(x){ (x[0]-pt[0]) ** 2 + (x[1]-pt[1]) ** 2 } }
    prune_f = lambda do |hf|
        lambda do |queue|
            if queue.size > PRUNE_TRIGGER
                queue.sort_by!{ -hf[_1] }
                queue = queue[0...PRUNE_TO]
            end
            queue
        end
    end

    fb = ->(x) { x[0] == 1 and x[1] == 0 }
    fe = ->(x) { x[0] == B.max_x and x[1] == B.max_y + 1 }
    pb = prune_f[howfar_f[B.b]]
    pe = prune_f[howfar_f[B.e]]
    nn = ->(x){ next_nodes x }
    d = ->(a,b){1}

    p1_start = [*B.b, 0]
    part1 = dijkstra p1_start, found: fe, next_nodes: nn, distance: d, prune: pb

    p2_start = [*B.e, part1]
    part2 = dijkstra p2_start, found: fb, next_nodes: nn, distance: d, prune: pe

    p3_start = [*B.b, part2 + part1]
    part3 = dijkstra p3_start, found: fe, next_nodes: nn, distance: d, prune: pb

    [part1, [part1, part2, part3].sum]
end

PART1, PART2 = compute

puts 'Part 1: %s' % PART1
puts 'Part 2: %s' % PART2
