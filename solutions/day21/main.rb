#!/usr/bin/ruby

require 'z3'

def parse_line line
    line =~ /(\w{4}): (?:(-?\d+)|((\w{4}) (.) (\w{4})))/
    [$1, $2 ? $2.to_i : [$4, $5.to_sym, $6]]
end

DATA = File.read('data.txt').lines.map{ parse_line _1 }.to_h

def get_val x
    case DATA[x]
    when Integer
        DATA[x]
    when Array
        a, op, b = DATA[x]
        get_val(a).send(op, get_val(b))
    end
end

def to_eq val
    return 'humn' if val == 'humn'
    case DATA[val]
    when Integer
        DATA[val]
    when Array
        a, op, b = DATA[val]
        '(%s %s %s)' % [to_eq(a), op, to_eq(b)]
    end
end

def part2
    a, op, b = DATA['root']
    va, vb = to_eq(a), to_eq(b)
    eq = '%s == %s' % [va, vb]
    o = Z3::Optimize.new
    humn = Z3.Int('humn')
    op = 'o.assert(%s)' % eq
    eval op
    o.check()
    o.model().to_h[humn].to_i
end

PART1 = get_val 'root'
PART2 = part2

puts 'Part 1: %s' % PART1
puts 'Part 2: %s' % PART2
