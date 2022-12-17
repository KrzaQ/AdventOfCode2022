#!/usr/bin/ruby

DATA = File.read('data.txt').strip.chars

BLOCKS = [
    [[1,1,1,1]],
    [[0,1,0],[1,1,1],[0,1,0]],
    [[0,0,1],[0,0,1],[1,1,1]],
    [[1],[1],[1],[1]],
    [[1,1],[1,1]],
]

def can_match well, block, level, offset
    block.reverse.each_with_index do |row, y|
        row.each_with_index do |cell, x|
            return false if cell == 1 && well[level+y][x+offset] == 1
        end
    end
    true
end

def assign_block well, block, level, offset
    block.reverse.each_with_index do |row, y|
        row.each_with_index do |cell, x|
            well[level+y][x+offset] = 1 if cell == 1
        end
    end
end

def first_free_level well
    idx = well.reverse.find_index{ _1.any?(1) }
    idx ? well.size - idx : 0
end

def simulate_one well, block, jet_offset
    level = first_free_level(well) + 3
    offset = 2
    todo = [level, offset]
    jets_used = jet_offset

    level.downto(0) do |i|
        jet = DATA[jets_used % DATA.size]
        jets_used += 1
        case jet
        when ?<
            offset -= 1 if offset > 0 and can_match(well, block, i, offset-1)
        when ?>
            offset += 1 if block[0].size + offset < 7 and can_match(well, block, i, offset+1)
        end
        if not can_match(well, block, i-1, offset)
            todo = [i, offset]
            break
        end
    end

    assign_block(well, block, todo[0], offset)

    free_levels = well.size - first_free_level(well) - 1
    if free_levels < 8
        free_levels.times { well << Array.new(7, 0) }
    end
    [well, jets_used % DATA.size]
end

def print_well well
    well.reverse.each do |level|
        puts level.map { |c| c == 1 ? '#' : '.' }.join
    end
end

def simulate n
    well = [Array.new(7, 1)] + 8.times.map { Array.new(7, 0) }
    jet_offset = 0
    memory = {}

    BLOCKS.cycle.each_with_index do |block, i|

        mem = [i % BLOCKS.size, jet_offset]

        ffl = first_free_level(well)
        well, jet_offset = simulate_one(well, block, jet_offset)
        current_ffl = first_free_level(well)

        mem << (current_ffl - ffl)
        if memory[mem]
            old_ffl, old_i = memory[mem]
            cycle = i - old_i
            level_diff = current_ffl - old_ffl
            if (n - i) % cycle == 0
                num_cycles = (n - i) / cycle
                return num_cycles * level_diff + ffl - 1
            end
        else
            memory[mem] = [current_ffl, i]
        end
    end

    first_free_level(well) - 1
end

PART1 = simulate 2022
PART2 = simulate 1_000_000_000_000

puts 'Part 1: %s' % PART1
puts 'Part 2: %s' % PART2
