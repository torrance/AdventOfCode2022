function priority(char::Char)
    if islowercase(char)
        return Int(char) - Int('a') + 1
    elseif isuppercase(char)
        return Int(char) - Int('A') + 27
    end
    @assert false "Invalid character"
end

rucksacks = map(collect, eachline(joinpath(@__DIR__, "input.txt")))  # collect expands each row into Vector{Char}

# Part 1
prioritysum = sum(rucksacks) do rucksack
    compartment1, compartment2 = eachcol(reshape(rucksack, :, 2))
    common = only(compartment1 ∩ compartment2)
    return priority(common)
end
println("Part 1 sum: ", prioritysum)

# Part 2
prioritysum = sum(Iterators.partition(rucksacks, 3)) do (ruck1, ruck2, ruck3)
    common = only(ruck1 ∩ ruck2 ∩ ruck3)
    return priority(common)
end
println("Part 2 sum: ", prioritysum)