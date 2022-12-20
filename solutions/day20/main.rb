#!/usr/bin/ruby

DATA = File.read('data.txt').scan(/-?\d+/).map(&:to_i)
KEY = 811589153

def move data, times: 1
    moved = data.each_with_index.to_a

    times.times do
        data.each_with_index do |n, idx|
            midx = moved.find_index{ _2 == idx }
            c = moved.delete_at midx
            moved.compact!
            new_idx = midx + c.first
            new_idx = new_idx % moved.size if new_idx >= moved.size
            if new_idx < 0
                new_idx -= 1
                if new_idx.abs > moved.size
                    new_idx = -(new_idx.abs % moved.size)
                end
            end
            new_idx = data.size - 1 if new_idx == 0
            moved.insert new_idx, c
        end
    end

    moved.compact.map(&:first)
end

def part1
    moved = move(DATA).cycle.take(DATA.size + 3001)
    idx = moved.find_index{ _1 == 0 }
    [1000, 2000, 3000].map{ moved[idx+_1] }.sum
end

def part2
    d = DATA.map{ _1 * KEY }
    moved = move(d, times: 10).cycle.take(DATA.size + 3001)
    idx = moved.find_index{ _1 == 0 }
    [1000, 2000, 3000].map{ moved[idx+_1] }.sum
end

PART1 = part1
PART2 = part2

puts 'Part 1: %s' % PART1
puts 'Part 2: %s' % PART2
