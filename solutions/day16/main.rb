#!/usr/bin/ruby

require 'set'

DATA = File.read('data.txt').lines
    .map do
        rate = _1.scan(/\d+/).first.to_i
        current, *valves = _1.scan(/[A-Z]{2}/)
        [current, { rate: rate, dests: valves }]
    end.to_h

DEBUG = ENV["DEBUG"] ? ENV["DEBUG"].to_i : 0

BY_RATE = DATA.map{ [_1, _2[:rate]] }.sort_by{ -_2 }.map(&:first)

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
    by_open = {}
    best = initial
    last_minute = 0
    dropped = 0
    while last_minute < minutes
        last_minute += 1
        puts "Current minute: #{last_minute} (q: #{queue.size})" if DEBUG > 0
        nqueue = []
        while queue.any?
            current = queue.shift

            if players > 1
                minutes_left = minutes - current[:minute]
                max_to_score = BY_RATE
                    .yield_self{ _1 - current[:open].to_a }
                    .take(players * minutes_left / 2)
                    .each_slice(players)
                    .each_with_index
                    .map do |rates, i|
                        x = minutes_left - 2 * i
                        rates.map{ DATA[_1][:rate] * x }.sum
                    end.sum
                if max_to_score + current[:score] < best[:score]
                    dropped += 1
                    next
                end
            end

            # this is potentially unsound
            s = by_open[current[:open]]
            if s and s > current[:score]
                dropped += 1
                next
            elsif not s
                by_open[current[:open]] = current[:score]
            end
            # end of unsoundness

            dedup = [current[:current].sort, current[:open]]
            next if seen.include?(dedup)
            seen << dedup
            p [best[:score], queue.size, current[:minute], dropped] if DEBUG >= 2
            p [current[:current], current[:open], current[:score]] if DEBUG >= 3

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
                nope = false
                [me, el].select(&:itself).each_with_index do |op, i|
                    if op =~ /open/
                        c = current[:current][i]
                        n[:open] << c
                        n[:score] += DATA[c][:rate] * (minutes - n[:minute])
                        n[:path][i] << c
                    else
                        nope = true if n[:path][i][-2] == op
                        n[:path][i] << op
                        n[:current][i] = op
                    end
                end
                next if nope
                nqueue << n
                best = n if n[:score] > best[:score]
            end
        end
        queue = nqueue.sort_by{ -_1[:score] }
    end

    best
end

PART1 = search(DATA, minutes: 30, players: 1)[:score]
PART2 = search(DATA, minutes: 26, players: 2)[:score]

puts 'Part 1: %s' % PART1
puts 'Part 2: %s' % PART2
