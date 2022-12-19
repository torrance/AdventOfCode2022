using OffsetArrays

function surfacearea(grid; outside)
    idxs = CartesianIndices(grid)
    deltas = CartesianIndex.([
        (-1, 0, 0), (+1, 0, 0), (0, -1, 0), (0, +1, 0), (0, 0, -1), (0, 0, +1)
    ])

    return sum(findall(==(1), grid)) do point
        s = 0
        for delta in deltas
            if (point + delta) ∉ idxs || grid[point + delta] == outside
                s += 1
            end
        end
        return s
    end
end

function flood(grid, origin)
    @assert grid[origin] == 0
    grid[origin] = 2

    idxs = CartesianIndices(grid)
    deltas = CartesianIndex.([
        (-1, 0, 0), (+1, 0, 0), (0, -1, 0), (0, +1, 0), (0, 0, -1), (0, 0, +1)
    ])

    function _flood(grid, point)
        for delta in deltas
            if (point + delta) ∈ idxs && grid[point + delta] == 0
                grid[point + delta] = 2
                _flood(grid, point + delta)
            end
        end
    end

    _flood(grid, origin)
end

# Load data and set up 3D grid
points = map(eachline("input.txt")) do line
    parse.(Int, split(line, ','))
end

# Create grid large enough to contain all points plus a 1px grid envelope
xaxis = (minimum(first, points) - 1):(maximum(first, points) + 1)
yaxis = (minimum(x -> x[2], points) - 1):(maximum(x -> x[2], points) + 1)
zaxis = (minimum(last, points) - 1):(maximum(last, points) + 1)

grid = OffsetArray(
    zeros(length.((xaxis, yaxis, zaxis))...),
    xaxis, yaxis, zaxis
)
for point in points
    grid[point...] = 1
end

# Part 1
println("Part 1: surface area is ", surfacearea(grid, outside=0))

# Part 2
origin = CartesianIndex(first(xaxis), first(yaxis), first(zaxis))
flood(grid, origin)
println("Part 2: surface area is ", surfacearea(grid, outside=2))