#!/usr/bin/ruby

DATA = File.read('data.txt').lines.map{ _1.strip.chars.map(&:to_i) }

def from_left lines, const
    max = -1
    ret = []
    lines[const].each_with_index.each do |v, i|
        ok = v > max
        max = [v, max].max
        ret.push [const, i] if ok
    end
    ret
end

def from_right lines, const
    max = -1
    ret = []
    lines[const].reverse.each_with_index.each do |v, i|
        ok = v > max
        max = [v, max].max
        ret.push [const, lines[const].size - i - 1] if ok
    end
    ret
end

def from_top lines, const
    max = -1
    ret = []
    lines.each_with_index.each do |v, i|
        ok = v[const] > max
        max = [v[const], max].max
        ret.push [i, const] if ok
    end
    ret
end

def from_bottom lines, const
    max = -1
    ret = []
    lines.reverse.each_with_index.each do |v, i|
        ok = v[const] > max
        max = [v[const], max].max
        ret.push [lines[const].size - i - 1, const] if ok
    end
    ret
end

def part1
    total = [*0...DATA.size].map{ |i| from_left DATA, i }.flatten(1)
    total += [*0...DATA.size].map{ |i| from_right DATA, i }.flatten(1)
    total += [*0...DATA.size].map{ |i| from_top DATA, i }.flatten(1)
    total += [*0...DATA.size].map{ |i| from_bottom DATA, i }.flatten(1)
    total.sort.uniq.size
end

def measure data, y, x
    up = 0
    down = 0
    left = 0
    right = 0

    cur = data[y][x]
    # up
    (y-1).downto(0) do |i|
        up += 1
        if DATA[i][x] >= cur
            break
        end
    end

    # down
    (y+1).upto(DATA.size - 1) do |i|
        down += 1
        if DATA[i][x] >= cur
            break
        end
    end

    # left
    (x-1).downto(0) do |i|
        left += 1
        if DATA[y][i] >= cur
            break
        end
    end

    # right
    (x+1).upto(DATA[0].size - 1) do |i|
        right += 1
        if DATA[y][i] >= cur
            break
        end
    end
    up * down * left * right
end

def part2
    DATA.size.times.map do |y|
        DATA[0].size.times.map{ |x| measure(DATA, y, x) }
    end.flatten.max
end

PART1 = part1
PART2 = part2

puts 'Part 1: %s' % PART1
puts 'Part 2: %s' % PART2
