# Construct 9 empty stacks
stacks = [Char[] for _ in 1:9]

# Populate the stacks with the initial configuration (rows 1-8, read from bottom-up)
for row in Iterators.take(eachline("input.txt"), 8) |> collect |> reverse!
    # Each segment is 4 characters, with the integer value at the 2nd position
    for (char, stack) in zip(row[2:4:end], stacks)
        if !isspace(char)
            push!(stack, char)
        end
    end
end

# Parse the moves (rows 11 onwards) in Vector of 3-tuples
# e.g. [(N, src, dest), ...]
moves = map(Iterators.drop(eachline("input.txt"), 10)) do line
    _, N, _, src, _, dest = split(line)
    return  parse.(Int, (N, src, dest))
end

# Part 1
stacks1 = deepcopy(stacks)
for (N, src, dest) in moves
    for _ in 1:N
        push!(stacks1[dest], pop!(stacks1[src]))
    end
end
println("Part 1 top row: ", String(map(last, stacks1)))

# Part 2
stacks2 = deepcopy(stacks)
for (N, src, dest) in moves
    Is = (length(stacks2[src]) - N + 1):length(stacks2[src])
    append!(stacks2[dest], splice!(stacks2[src], Is))
end
println("Part 2 top row: ", String(map(last, stacks2)))