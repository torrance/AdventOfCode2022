const Move::Dict{String, Vector{Int}} = Dict(
    "U" => [0, 1], "D" => [0, -1], "L" => [-1, 0], "R" => [1, 0]
)

function snake(moves, knots)
    history = [last(knots)]  # Initialize with starting position of tail

    for (direction, magnitude) in moves
        for _ in 1:magnitude
            # Move the head first
            knots[1] += Move[direction]

            # Now iterate through tail pieces and move if needed
            for (lead, follow) in zip(knots, knots[2:end])
                offset = [lead[1] - follow[1], lead[2] - follow[2]]

                if maximum(abs, offset) <= 1
                    # No need to move!
                    continue
                end

                follow .+= clamp.(offset, -1, 1)
            end

            # Track the location of the tail
            push!(history, copy(last(knots)))
        end
    end

    return history
end

const moves::Vector{Tuple{String, Int}} = map(eachline("input.txt")) do line
    direction, magnitude = split(line)
    return direction, parse(Int, magnitude)
end

# Part 1
knots = [[1, 1] for _ in 1:2]
history = snake(moves, knots)
println("Part 1: The tail visited $(length(unique!(history))) unique tiles")

# Part 2
knots = [[1, 1] for _ in 1:10]
history = snake(moves, knots)
println("Part 2: The tail visited $(length(unique!(history))) unique tiles")