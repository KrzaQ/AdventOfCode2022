#!/usr/bin/ruby

module D22Part1
    *LINES_, MOVX  = File.read('data.txt').lines.map{ _1.gsub(/\s+$/, '').chars }
    MAX_X = LINES_.map{ _1.size }.max
    LINES = LINES_[0..-1].map{ _1 + [' '] * (MAX_X - _1.size) }
    MOV = MOVX.join

    def D22Part1.move_right pos, steps
        x, y = pos
        steps.times do
            prev_x = x
            x += 1
            if LINES[y][x] == ' ' or LINES[y][x] == nil
                x = LINES[y].find_index{ _1 != ' ' }
            end
            return [prev_x, y] if LINES[y][x] == ?#
        end
        [x, y]
    end

    def D22Part1.move_left pos, steps
        x, y = pos
        steps.times do
            prev_x = x
            x -= 1
            x = LINES[y].size - 1 if x < 0

            if LINES[y][x] == ' ' or LINES[y][x] == nil
                x = LINES[y].rindex{ _1 != ' ' }
            end
            return [prev_x, y] if LINES[y][x] == ?#
        end
        [x, y]
    end

    def D22Part1.move_up pos, steps
        x, y = pos
        steps.times do
            prev_y = y
            y -= 1
            y = LINES.size - 1 if y < 0
            if LINES[y][x] == ' ' or LINES[y][x] == nil
                y = LINES.rindex{ _1 and _1[x] != ' ' }
            end
            return [x, prev_y] if LINES[y][x] == ?#
        end
        [x, y]
    end

    def D22Part1.move_down pos, steps
        x, y = pos
        steps.times do
            prev_y = y
            y += 1
            if LINES[y][x] == ' ' or LINES[y][x] == nil
                y = LINES.find_index{ _1[x] != ' ' }
            end
            return [x, prev_y] if LINES[y][x] == ?#
        end
        [x, y]
    end

    def D22Part1.move(pos, dir, steps)
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
        pos
    end

    def D22Part1.process_movement
        x, y = LINES[0].find_index{ _1 != ' ' }, 0
        dir = 0

        moves = MOV.scan(/(R|L|\d+)/).flatten
        moves.each do |m|
            case m
            in /\d+/
                x, y = move [x, y], dir, m.to_i
            in 'R'
                dir = (dir + 1) % 4
            in 'L'
                dir = (dir - 1) % 4
            end
        end
        (1000 * (y + 1) + (x + 1) * 4 + dir)
    end
end
