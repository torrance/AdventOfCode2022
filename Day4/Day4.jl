ranges = map(eachline(joinpath(@__DIR__, "input.txt"))) do line
    Is = parse.(Int, split(line, ('-', ',')))
    return Is[1]:Is[2], Is[3]:Is[4]
end

N = count(ranges) do (first, second)
    return first ⊆ second || second ⊆ first
end
println("$(N) assignments are fully contained by another")

N = count(ranges) do (first, second)
    return !isempty(first ∩ second)
end
println("$(N) assignments overlap")