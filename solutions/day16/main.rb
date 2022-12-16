#!/usr/bin/ruby

require 'set'

DATA = File.read('data.txt').lines
    .map do
        rate = _1.scan(/\d+/).first.to_i
        current, *valves = _1.scan(/[A-Z]{2}/)
        [current, { rate: rate, dests: valves }]
    end.to_h

DEBUG = ENV["DEBUG"] ? ENV["DEBUG"].to_i : 0

def clone_current c
    {
        minute: c[:minute],
        open: c[:open].dup,
        path: c[:path].map(&:dup),
        current: c[:current].map(&:dup),
        score: c[:score],
    }
end

def search data, minutes: 30, players: 1
    initial = {
        minute: 0,
        open: Set.new,
        path: players.times.map{ ['AA'] },
        current: (['AA'] * players),
        score: 0,
    }
    queue = [initial]
    seen = Set.new
    best = initial
    last_minute = 0

    while queue.any?
        current = queue.shift
        dedup = [current[:current].sort, current[:score]]
        next if seen.include?(dedup)
        seen << dedup
        p [best[:score], queue.size, current[:minute]] if DEBUG >= 2
        if current[:minute] > last_minute and DEBUG > 0
            puts "Current minute: #{current[:minute]}"
            last_minute = current[:minute]
        end

        next if current[:minute] >= minutes

        operations = current[:current].map do |c|
            todo = []
            if not current[:open].include?(c) and DATA[c][:rate] > 0
                todo << "open #{c}"
            end
            todo += DATA[c][:dests]
            todo
        end.reduce(&:product).reject{ _1 == _2 }

        operations.each do |opers|
            me, el = opers
            n = clone_current current
            n[:minute] += 1
            [me, el].select(&:itself).each_with_index do |op, i|
                if op =~ /open/
                    c = current[:current][i]
                    n[:open] << c
                    n[:score] += DATA[c][:rate] * (minutes - n[:minute])
                    n[:path][i] << c
                else
                    next if n[:path][i].last == op
                    n[:path][i] << op
                    n[:current][i] = op
                end
            end
            queue << n
            best = n if n[:score] > best[:score]
        end
    end

    best
end

PART1 = search(DATA, minutes: 30, players: 1)[:score]
PART2 = search(DATA, minutes: 26, players: 2)[:score]

puts 'Part 1: %s' % PART1
puts 'Part 2: %s' % PART2
