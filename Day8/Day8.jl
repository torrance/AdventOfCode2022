function outlooks(grid, xy)
    x, y = Tuple(xy)
    return (
        reverse(grid[x, 1:y - 1]),
        grid[x, y + 1:end],
        reverse(grid[1:x - 1, y]),
        grid[x + 1:end, y],
    )
end

const grid::Matrix{Int} = mapreduce(x -> parse.(Int, collect(x)), hcat, eachline("input.txt"))

visible = count(CartesianIndices(grid)) do xy
    height = grid[xy]

    return any(outlooks(grid, xy)) do outlook
        all(<(height), outlook)
    end
end
println("Part 1: there are $(visible) visible trees")

highest = maximum(CartesianIndices(grid)) do xy
    height = grid[xy]

    return prod(outlooks(grid, xy)) do outlook
        # Note findfirst() returns nothing if it makes it to the edge of the map
        something(findfirst(>=(height), outlook), length(outlook))
    end
end
println("Part 2: highest scenic score is $(highest)")