#!/usr/bin/ruby

DATA = File.read('data.txt').lines.map{ _1.strip.chars }
    .map{ [_1.first, _1.last] }

def opponent x
    case x
    when 'A'
        :rock
    when 'B'
        :paper
    when 'C'
        :scissors
    end
end

def you x
    case x
    when 'X'
        :rock
    when 'Y'
        :paper
    when 'Z'
        :scissors
    end
end

def win val, opp
    if val == 'Y'
        return opp
    elsif val == 'Z'
        return case opp
        when :rock
            :paper
        when :paper
            :scissors
        when :scissors
            :rock
        end
    elsif val == 'X'
        return case opp
        when :rock
            :scissors
        when :paper
            :rock
        when :scissors
            :paper
        end
    end
end

def score a, b, op
    x1 = opponent a
    x2 = op[b, x1]
    
    s = case x2
    when :rock
        1
    when :paper
        2
    when :scissors
        3
    end
    
    if x1 == x2
        s += 3
    elsif x1 == :rock and x2 == :paper
        s += 6
    elsif x1 == :paper and x2 == :scissors
        s += 6
    elsif x1 == :scissors and x2 == :rock
        s += 6
    else
        s
    end
    s
end

PART1 = DATA.map{ score *_1, ->(b, _){ you b } }.sum
PART2 = DATA.map{ score *_1, ->(b, x1){ win b, x1 } }.sum

puts 'Part 1: %s' % PART1
puts 'Part 2: %s' % PART2
