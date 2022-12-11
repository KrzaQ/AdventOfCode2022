#!/usr/bin/ruby

def parse_monkey lines
    id = lines[0].scan(/\d+/).first.to_i
    starting = lines[1].scan(/\d+/).map(&:to_i)
    test = lines[3].scan(/\d+/).first.to_i
    test_true = lines[4].scan(/\d+/).first.to_i
    test_false = lines[5].scan(/\d+/).first.to_i
    operation = case lines[2].scan(/([+*]) (.+?)$/).first
        in [?*, 'old']
            ->(o){ o * o }
        in [?+, c]
            ->(o){ o + c.to_i }
        in [?*, c]
            ->(o){ o * c.to_i }
    end

    {
        id: id,
        operation: operation,
        items: starting,
        test: test,
        test_true: test_true,
        test_false: test_false,
        inspected: 0,
    }
end

DATA = File.read('data.txt').split("\n\n").map { parse_monkey _1.lines }
BIG_DIV = DATA.map{ _1[:test] }.inject(:*)

def do_round monkeys, div_by: 3
    monkeys.each do |monkey|
        monkey[:items].each do |item|
            worry = monkey[:operation][item] / div_by % BIG_DIV

            if worry % monkey[:test] == 0
                monkeys[monkey[:test_true]][:items] << worry
            else
                monkeys[monkey[:test_false]][:items] << worry
            end
            monkey[:inspected] += 1
        end
        monkey[:items] = []
    end
    monkeys
end

def sim_rounds times:, div_by:
    monkeys = DATA.dup
    times.times{ monkeys = do_round monkeys, div_by: div_by }
    monkeys.map{ _1[:inspected] }.sort[-2..-1].inject(:*)
end

PART1 = sim_rounds times: 20, div_by: 3
PART2 = sim_rounds times: 10_000, div_by: 1

puts 'Part 1: %s' % PART1
puts 'Part 2: %s' % PART2
