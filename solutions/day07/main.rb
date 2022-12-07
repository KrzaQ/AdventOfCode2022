#!/usr/bin/ruby
require 'json'
DATA = File.read('data.txt').lines.map(&:strip)

def parse_dirs data
    current_dir = []
    dirs = {}
    dir_name = nil
    data[1..-1].each do |line|
        if line =~ /^\$ cd \.\./
            current_dir.pop
        elsif line =~ /\$ cd (.*)/
            current_dir.push $1
        elsif line =~ /\$ ls (.*)/
            dir_name = $1
        elsif line =~ /dir (.*)/
            dn = $1
            if current_dir.size == 0
                dirs[dn] = {}
            else
                dirs.dig(*current_dir)[dn] = {}
            end
        elsif line =~ /(\d+) (.*)/
            size = $1.to_i
            fn = $2
            if current_dir.size == 0
                dirs[fn] = size
            else
                dirs.dig(*current_dir)[fn] = size
            end
        end
    end
    dirs
end

def compute_dir_sizes dirs, path = []
    data = {}
    val = dirs.map do |k, v|
        case v
        when Hash
            size, d = compute_dir_sizes v, path + [k]
            data.merge! d
            size
        else
            v
        end
    end.sum
    data[path] = val
    [val, data]
end

DIRS = parse_dirs DATA
DIR_SIZES = compute_dir_sizes(DIRS).last

def part2
    necessary = 30_000_000 - (70_000_000 - DIR_SIZES[[]])
    DIR_SIZES.filter_map{ _2 if _2 > necessary }.min
end

PART1 = DIR_SIZES.filter_map{ _2 if _2 <= 100_000 }.sum
PART2 = part2

puts 'Part 1: %s' % PART1
puts 'Part 2: %s' % PART2
