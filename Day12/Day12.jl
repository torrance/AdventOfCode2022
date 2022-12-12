function charval(c::Char)
    if c == 'S'
        return Int('a')
    elseif c == 'E'
        return Int('z')
    else
        return Int(c)
    end
end

function search(x0, y0)
    positions = [(0, x0, y0)]  # store all active positions and their step count: (N, x, y)
    visited = Set([(x0, y0)])

    # Breadth-first search:
    # shortest path is by definition the first to reach E
    while !isempty(positions)
        N, x, y = popfirst!(positions)

        if grid[x, y] == 'E'
            return N
        end

        for (i, j) in ((x, y + 1), (x, y - 1), (x + 1, y), (x - 1, y))
            if (
                i in axes(grid, 1) && j in axes(grid, 2) && !((i, j) in visited) &&
                (charval(grid[i, j]) - charval(grid[x, y])) <= 1

            )
                push!(positions, (N + 1, i, j))
                push!(visited, (i, j))
            end
        end
    end

    # There's no path from our starting point to E!
    return typemax(Int)
end

# Read input into Matrix{Char}
grid = mapreduce(collect, hcat, eachline("input.txt"))
start = Tuple(findfirst(==('S'), grid))

# Part 1
part1 = search(start...)
println("Part 1: shortest path is ", part1)

# Part 2
starts = Tuple.(findall(grid) do x
    x == 'a' || x == 'S'
end)

part2 = minimum(starts) do start
    search(start...)
end
println("Part 2: shortest path from any 'a' is ", part2)