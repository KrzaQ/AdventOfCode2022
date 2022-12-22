#!/usr/bin/ruby

module D22Part2
    *LINES_, MOVX  = File.read('data.txt').lines.map{ _1.gsub(/\s+$/, '').chars }
    MAX_X = LINES_.map{ _1.size }.max
    LINES = LINES_[0..-1].map{ _1 + [' '] * (MAX_X - _1.size) }
    MOV = MOVX.join

    CUBE_DIM = 50

    REGIONS = [
        [50...100, 0...50, 1],
        [100...150, 0...50, 2],
        [50...100, 50...100, 3],
        [0...50, 100...150, 4],
        [50...100, 100...150, 5],
        [0...50, 150...200, 6],
    ]

    REGION_CONN = {
        [1, 2] => [4, 0, -1],
        [1, 3] => [6, 0,  1],
        [2, 0] => [5, 2, -1],
        [2, 1] => [3, 2,  1],
        [2, 3] => [6, 3,  1],
        [3, 0] => [2, 3,  1],
        [3, 2] => [4, 1,  1],
        [4, 2] => [1, 0, -1],
        [4, 3] => [3, 0,  1],
        [5, 0] => [2, 2, -1],
        [5, 1] => [6, 2,  1],
        [6, 0] => [5, 3,  1],
        [6, 1] => [2, 1,  1],
        [6, 2] => [1, 1,  1],
    }

    def D22Part2.get_region x, y
        # p [x, y]
        REGIONS.find_index{ _1[0].include? x and _1[1].include? y } + 1
    end

    def D22Part2.get_next_region_point_and_dir pos, dir
        x, y = pos
        region = get_region x, y
        # p [:req_conn, region, dir]
        conn, new_dir, mult = REGION_CONN[[region, dir]]

        cur_reg = REGIONS[region - 1]
        new_reg = REGIONS[conn - 1]
        region_x = x - cur_reg[0].begin
        region_y = y - cur_reg[1].begin
        # p [region_x, region_y, dir, new_dir, mult]
        ret = case [dir, new_dir, mult]
        # when [0, 1, -1]
            # p [new_reg[0].end - 1 - region_y, new_reg[1].begin, new_dir]
        when [0, 2, -1]
            [new_reg[0].end - 1, new_reg[1].end - 1 - region_y, new_dir]
        when [0, 3, 1]
            [new_reg[0].begin + region_y, new_reg[1].end - 1, new_dir]
        when [1, 1, 1]
            [new_reg[0].begin + region_x, new_reg[1].begin, new_dir]
        when [1, 2, 1]
            [new_reg[0].end - 1, new_reg[1].begin + region_x, new_dir]
        # when [1, 3, -1]
            # p [new_reg[0].end - 1 - region_x, new_reg[1].end - 1, new_dir]
        when [2, 0, -1]
            [new_reg[0].begin, new_reg[1].end - 1 - region_y, new_dir]
        when [2, 1, 1]
            [new_reg[0].begin + region_y, new_reg[1].begin, new_dir]
        when [3, 0, 1]
            [new_reg[0].begin, new_reg[1].begin + region_x, new_dir]
        when [3, 3, 1]
            [new_reg[0].begin + region_x, new_reg[1].end - 1, new_dir]
        else
            raise "Unknown dir #{dir} #{new_dir} #{mult}"
        end
        ret
    end

    # DATA = LINES.join("\n")
    # p LINES[-1]
    # exit
    def D22Part2.move_right pos, steps
        x, y = pos
        steps.times do
            prev_x = x
            x += 1
            return [prev_x, y, 0] if LINES[y][x] == ?#
            if LINES[y][x] == ' ' or LINES[y][x] == nil
                nx, ny, dir = get_next_region_point_and_dir [x-1, y], 0
                return [prev_x, y, 0] if LINES[ny][nx] == ?#
                return move [nx, ny], dir, steps - _1 - 1
            end
            return [prev_x, y, 0] if LINES[y][x] == ?#
        end
        [x, y, 0]
    end

    def D22Part2.move_left pos, steps
        x, y = pos
        steps.times do
            prev_x = x
            x -= 1
            if x < 0 or LINES[y][x] == ' ' or LINES[y][x] == nil
                nx, ny, dir = get_next_region_point_and_dir [x+1, y], 2
                return [prev_x, y, 2] if LINES[ny][nx] == ?#
                return move [nx, ny], dir, steps - _1 - 1
            end
            return [prev_x, y, 2] if LINES[y][x] == ?#
        end
        [x, y, 2]
    end

    def D22Part2.move_up pos, steps
        x, y = pos
        steps.times do
            prev_y = y
            y -= 1
            if y < 0 or LINES[y][x] == ' ' or LINES[y][x] == nil
                nx, ny, dir = get_next_region_point_and_dir [x, y+1], 3
                return [x, prev_y, 3] if LINES[ny][nx] == ?#
                return move [nx, ny], dir, steps - _1 - 1
            end
            return [x, prev_y, 3] if LINES[y][x] == ?#
        end
        [x, y, 3]
    end

    def D22Part2.move_down pos, steps
        x, y = pos
        steps.times do
            prev_y = y
            y += 1
            if LINES[y][x] == ' ' or LINES[y][x] == nil
                nx, ny, dir = get_next_region_point_and_dir [x, y-1], 1
                return [x, prev_y, 1] if LINES[ny][nx] == ?#
                return move [nx, ny], dir, steps - _1 - 1
            end
            return [x, prev_y, 1] if LINES[y][x] == ?#
        end
        [x, y, 1]
    end

    def D22Part2.move(pos, dir, steps)
        # p [:move, pos, dir, steps]
        case dir
        when 0
            pos = move_right pos, steps
        when 1
            pos = move_down pos, steps
        when 2
            pos = move_left pos, steps
        when 3
            pos = move_up pos, steps
        end
        [*pos, dir]
    end

    def D22Part2.process_movement
        x, y = LINES[0].find_index{ _1 != ' ' }, 0
        dir = 0
        
        moves = MOV.scan(/(R|L|\d+)/).flatten
        moves.each do |m|
            # p [:m, m]
            case m
            in /\d+/
                x, y, dir = move [x, y], dir, m.to_i
            in 'R'
                dir = (dir + 1) % 4
            in 'L'
                dir = (dir - 1) % 4
            end
        end
        (1000 * (y + 1) + (x + 1) * 4 + dir)
    end
end
