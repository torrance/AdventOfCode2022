function decode!(list::Vector{Tuple{Int, Int}})
    for i in eachindex(list)
        # Find the current location of the value with original index = i
        idx = findfirst(list) do (idx, _)
            idx == i
        end

        _, val = list[idx]
        newidx = mod1(idx + val, length(list) - 1)
        deleteat!(list, idx)
        insert!(list, newidx, (i, val))
    end
end

function coordinatesum(list)
    idx = findfirst(x -> last(x) == 0, list)
    return sum([1000, 2000, 3000]) do offset
        offsetidx = mod1(idx + offset, length(list))
        last(list[offsetidx])
    end
end

list = collect(enumerate(parse.(Int, eachline("input.txt"))))

# Part 1
list1 = copy(list)
decode!(list1)
println("Part 1: coordinate sum is ", coordinatesum(list1))

# Part 2
list2 = map(list) do (idx, val)
    (idx, val * 811589153)
end
[decode!(list2) for _ in 1:10]
println("Part 2: coordinate sum is ", coordinatesum(list2))