using StaticArrays

const V4 = SVector{4, Int}

const Ore = V4(1, 0, 0, 0)
const Clay = V4(0, 1, 0, 0)
const Obsidian = V4(0, 0, 1, 0)
const Geode = V4(0, 0, 0, 1)

const Robots = (Ore, Clay, Obsidian, Geode)

canafford(bank::V4, cost::V4) = all(>=(0), bank - cost)

function bfs(blueprint; N::Int)
    # Each edge is a tuple of (robots, bank)
    edges::Vector{Tuple{V4, V4}} = [(V4(1, 0, 0, 0), V4(0, 0, 0, 0))]
    robotconfigs = Set{V4}()

    for t in 1:N
        futures = empty(edges)
        sizehint!(futures, length(edges) * 4)

        for (robots, bank) in edges
            for i in 1:4
                robot = Robots[i]
                cost = blueprint[i]

                # Buy the robot if: we can afford it; we don't already produce more than we can spend of that resource
                if canafford(bank, cost) && (robot == Geode || robots[i] <= maximum(x -> x[i], blueprint))
                    # Deduct cost of robot
                    newbank = bank - cost

                    # Deposit new reserves
                    newbank += robots

                    # Add new robot
                    newrobots = robots + robot

                    if newrobots ∉ robotconfigs  # If we reached this state in a previous turn, we are suboptimal
                        push!(futures, (newrobots, newbank))
                    end
                end
            end

            # Case: noop (we're saving for a rainy holiday)
            # but not if we can afford every robot (that's never going to be optimal)
            if !all(x -> canafford(bank, x), blueprint)
                push!(futures, (robots, bank + robots))
            end
        end

        edges = futures

        for (robots, _) in edges
            push!(robotconfigs, robots)
        end
    end

    return maximum(x -> x[2][4], edges)
end

blueprints = map(eachline("input.txt")) do line
    words = split(line)
    return [
        V4(parse(Int, words[7]), 0, 0, 0),
        V4(parse(Int, words[13]), 0, 0, 0),
        V4(parse(Int, words[19]), parse(Int, words[22]), 0, 0),
        V4(parse(Int, words[28]), 0, parse(Int, words[31]), 0)
    ]
end

# Part 1
part1 = sum(enumerate(blueprints)) do (i, blueprint)
    i * bfs(blueprint, N=24)
end
println("Part 1: total quality level: ", part1)

# Part 2
part2 = prod(blueprints[1:3]) do blueprint
    bfs(blueprint, N=32)
end
println("Part 2: geode product: ", part2)