using BenchmarkTools

const moves = Iterators.cycle(map(c -> c == '<' ? -1 : 1, collect(Char, read("input.txt"))))

const rocks = Iterators.cycle(Matrix{Int}[
    [
        1
        1
        1
        1;;
    ],
    [
        0 1 0
        1 1 1
        0 1 0
    ],
    [
        1 0 0
        1 0 0
        1 1 1
    ],
    [
        1 1 1 1
    ],
    [
        1 1
        1 1
    ]
])

function isoverlap(grid, rock, x, y)
    for (x, y) in zip(view(grid, x:x + size(rock, 1) - 1, y:y + size(rock, 2) - 1), rock)
        if x + y == 2
            return true
        end
    end
    return false
end

function set!(grid, rock, x, y)
    grid[x:x + size(rock, 1) - 1, y:y + size(rock, 2) - 1] += rock
end

function tetris(rocks, moves, N)
    history = Int[]
    rocks = Iterators.Stateful(rocks)
    moves = Iterators.Stateful(moves)
    ground::Int = 0

    grid = zeros(Int, 7, 500_000)

    for i in 1:N
        x = 3
        y = findfirst(row -> all(==(0), row), eachcol(grid)) + 3
        rock = first(rocks)::Matrix{Int}

        while true
            # First: shift x
            shiftx = first(moves)::Int

            newx = clamp(x + shiftx, 1, 7 - size(rock, 1) + 1)

            if isoverlap(grid, rock, newx, y)
                newx = x
            end

            # Then: shift y
            newy = y - 1

            if newy == 0 || isoverlap(grid, rock, newx, newy)
                set!(grid, rock, newx, y)
                break
            end

            x = newx
            y = newy
        end

        # Record peak y position
        peak = findfirst(row -> all(==(0), row), eachcol(grid)) - 1
        push!(history, peak)
    end

    return history
end

function getsegment(history)
    offsets = history[2:end] .- history[1:end - 1]

    for i in eachindex(history)
        if offsets[end-i:end] == offsets[end - 2i:end - i] == offsets[end - 3i:end - 2i] == offsets[end - 4i:end - 3i]
            return offsets[end - i + 1:end]
        end
    end
    @assert false "Could not find repeating segment"
end

# Part 1
history = tetris(rocks, moves, 2022)
@assert last(history) == 3239 "Expected 3068, got $(part1)"
println("Part 1 sum: ", last(history))

# Part 2
history = tetris(rocks, moves, 10_000)
segment = getsegment(history)

# Extrpolate repeating segmentnt)
repeats, leftover = fldmod(1000000000000 - length(history), length(segment))
part2 = history[end] + repeats * sum(segment) + sum(segment[1:leftover])
println("Part 2 sum: ", part2)