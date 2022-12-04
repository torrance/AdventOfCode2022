function priority(char::Char)
    if islowercase(char)
        return Int(char) - 96
    elseif isuppercase(char)
        return Int(char) - 65 + 27
    end
    @assert false "Invalid character"
end

rucksacks = map(collect, readlines("input.txt"))  # collect expands each row into Vector{Char}

# Part 1
prioritysum = sum(rucksacks) do rucksack
    compartment1, compartment2 = eachcol(reshape(rucksack, :, 2))
    common = only(intersect(compartment1, compartment2))
    return priority(common)
end
println("Part 1 sum: ", prioritysum)

# Part 2
rucksacks = reshape(rucksacks, 3, :)  # group sequential elves into triplets

prioritysum = sum(eachcol(rucksacks)) do triplet
    common = only(intersect(triplet...))
    return priority(common)
end
println("Part 2 sum: ", prioritysum)